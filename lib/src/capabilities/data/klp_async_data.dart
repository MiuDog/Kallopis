import '../state/klp_mutable_state.dart';
import '../state/klp_state.dart';
import 'klp_data_notification_exception.dart';
import 'klp_data_state.dart';

/// 非同步資料擁有者，沿用共用狀態的唯讀借用與通知機制。
final class KlpAsyncData<T> {

	final KlpMutableState<KlpDataState<T>> _state = KlpMutableState(KlpDataIdle<T>());
	int _generation = 0;
	bool _publishing = false;

	KlpState<KlpDataState<T>> get state => _state.readOnly;
	bool get isDisposed => _state.isDisposed;

	/// 等待本次操作結束並採納或捨棄結果後完成；取消不提早完成。
	///
	/// 操作的同步或非同步錯誤成為資料狀態，不拒絕回傳的 Future。
	/// 已釋放使用與訂閱者錯誤仍拒絕 Future，不偽裝成資料失敗。
	/// 若載入通知中被取消、取代或釋放，操作不會啟動。
	/// 通知內重入的載入先保留請求識別，延至通知結束才發布與啟動。
	Future<void> load(Future<T> Function() operation) async {
		_requireActive();
		final generation = ++_generation;
		if (_publishing) {
			// 避免重入通知仍排隊時，工作已先啟動或錯誤歸到舊請求。
			await Future<void>.value();
			if (!_accepts(generation)) return;
		}
		_startLoading(generation);
		if (!_accepts(generation)) return;

		// 僅捕捉資料操作錯誤，通知錯誤由共用狀態機制傳回呼叫端。
		KlpDataState<T> result;
		try {
			result = KlpDataValue<T>(await operation());
		}
		catch (error, stackTrace) {
			result = KlpDataFailure<T>(error, stackTrace);
		}

		// 每次載入、取消或釋放都使舊請求失效，晚到結果不再寫入。
		if (!_accepts(generation)) return;

		_publish(result);
	}

	/// 停止採納目前載入結果並回到待命，不取消底層 I/O。
	/// 非載入階段不改變資料；釋放後呼叫會失敗。
	void cancel() {
		_requireActive();
		if (_state.value is! KlpDataLoading<T>) return;

		_generation++;
		_publish(KlpDataIdle<T>());
	}

	/// 釋放訂閱並使所有未完成請求失效，可重複呼叫。
	void dispose() {
		if (isDisposed) return;

		_generation++;
		_state.dispose();
	}

	bool _accepts(int generation) => !isDisposed && generation == _generation;

	void _startLoading(int generation) {
		try {
			_publish(KlpDataLoading<T>());
		}
		catch (error, stackTrace) {
			// 通知失敗時工作尚未開始，只復原仍由本次請求擁有的狀態。
			if (_accepts(generation)) {
				_generation++;
				try {
					_publish(KlpDataIdle<T>());
				}
				catch (recoveryError, recoveryStack) {
					throw KlpDataNotificationException([
						(error: error, stackTrace: stackTrace),
						(error: recoveryError, stackTrace: recoveryStack),
					]);
				}
			}
			Error.throwWithStackTrace(error, stackTrace);
		}
	}

	void _publish(KlpDataState<T> value) {
		final wasPublishing = _publishing;
		_publishing = true;
		try {
			_state.value = value;
		}
		finally {
			// cancel 可在通知中再次發布，必須保留外層尚未結束的狀態。
			_publishing = wasPublishing;
		}
	}

	void _requireActive() {
		if (isDisposed) {
			throw StateError('Async data has been disposed.');
		}
	}
}
