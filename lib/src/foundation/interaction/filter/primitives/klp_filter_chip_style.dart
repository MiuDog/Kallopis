part of '../klp_filter_bar.dart';

@immutable
final class _KlpFilterChipStyle {
	const _KlpFilterChipStyle({
		required this.label,
		required this.value,
		required this.remove,
	});

	final Color label;
	final Color value;
	final Color remove;
}
