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
