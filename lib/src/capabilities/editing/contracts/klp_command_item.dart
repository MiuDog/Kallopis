/// 提供者回報的命令可用性；畫面不自行推定執行權限。
enum KlpCommandAvailability { enabled, disabled }
/// 命令的語意強調用途；實際風格由本庫解析。
enum KlpCommandTone { neutral, danger }

/// 來源擁有的穩定候選資料；callback、樣式與鍵盤高亮不屬於 item。
final class KlpCommandItem {
	final String id;
	final String label;
	final String? caption;
	final KlpCommandAvailability availability;
	final String? disabledReason;
	final bool selected;
	final KlpCommandTone tone;

	KlpCommandItem({required this.id, required this.label, required this.availability, required this.selected, required this.tone, this.caption, this.disabledReason}) {
		if (id.trim().isEmpty || label.trim().isEmpty || (caption?.trim().isEmpty ?? false)) throw ArgumentError('Command identity and text must not be empty');
		if (availability == KlpCommandAvailability.enabled && disabledReason != null) throw ArgumentError('Enabled commands cannot carry a disabled reason');
		if (disabledReason?.trim().isEmpty ?? false) throw ArgumentError('Disabled reason must not be blank');
	}

	bool get enabled => availability == KlpCommandAvailability.enabled;
}
