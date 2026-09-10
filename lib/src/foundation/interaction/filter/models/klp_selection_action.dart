import 'package:flutter/foundation.dart';

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
