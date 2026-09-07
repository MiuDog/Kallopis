import 'package:flutter/foundation.dart';

/// 篩選列選項資料。
@immutable
class KlpFilterOption {
	const KlpFilterOption({
		required this.id,
		required this.label,
		this.value,
		this.removable = false,
	});

	final String id;
	final String label;
	final String? value;
	final bool removable;
}

/// 批次選取工具列的操作資料。
@immutable
class KlpSelectionAction {
	const KlpSelectionAction({
		required this.id,
		required this.label,
		required this.onPressed,
		this.danger = false,
	});

	final String id;
	final String label;
	final VoidCallback? onPressed;
	final bool danger;
}
