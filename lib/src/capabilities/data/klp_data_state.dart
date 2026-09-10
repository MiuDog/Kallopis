part 'klp_data_idle.dart';
part 'klp_data_loading.dart';
part 'klp_data_value.dart';
part 'klp_data_failure.dart';

/// 非同步資料的互斥階段；載入與失敗不保留上一份資料。
///
/// 包裝不可變，但資料本身的不可變性由提供者負責。
sealed class KlpDataState<T> {

	const KlpDataState();
}
