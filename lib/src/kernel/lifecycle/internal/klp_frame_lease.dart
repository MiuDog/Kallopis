/// 更新提交後撤銷舊畫面的操作資格，避免尚未卸載的按鈕執行過期回呼。
final class KlpFrameLease {

	bool _active = true;
	final KlpFrameLease? _parent;
	final bool _enabled;

	KlpFrameLease() : _parent = null, _enabled = true;
	KlpFrameLease._(this._parent, this._enabled);

	bool get isActive => _active && _enabled && (_parent?.isActive ?? true);
	KlpFrameLease derive({required bool enabled}) => KlpFrameLease._(this, enabled);
	void revoke() => _active = false;
	void run(void Function() callback) {
		if (isActive) callback();
	}

	/// 非同步操作也必須在啟動當下檢查 lease；完成後由資源自行決定提交結果。
	Future<void> runAsync(Future<void> Function() callback) async {
		if (isActive) await callback();
	}
}
