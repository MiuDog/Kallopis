/// 編輯模式的輸入通道用途；不實作文字、導覽或筆跡引擎。
enum KlpEditorInputPurpose { text, navigation, handwriting }
/// 來源回報的模式可用性；不由畫面重新判定模式能力。
enum KlpEditorModeAvailability { enabled, disabled }

/// 來源註冊的模式；availability 必須反映完整 handler 與核心能力。
final class KlpEditorModeItem {
	final String id;
	final String label;
	final KlpEditorInputPurpose purpose;
	final KlpEditorModeAvailability availability;
	final String? disabledReason;

	KlpEditorModeItem({required this.id, required this.label, required this.purpose, required this.availability, this.disabledReason}) {
		if (id.trim().isEmpty || label.trim().isEmpty) throw ArgumentError('Mode identity and label must not be blank');
		if (availability == KlpEditorModeAvailability.enabled && disabledReason != null) throw ArgumentError('Enabled modes cannot carry a disabled reason');
		if (availability == KlpEditorModeAvailability.disabled && (disabledReason?.trim().isEmpty ?? true)) throw ArgumentError('Disabled modes require a reason');
	}

	bool get enabled => availability == KlpEditorModeAvailability.enabled;
}
