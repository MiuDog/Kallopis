part of '../klp_phase_toggle.dart';

/// 階段／多態切換按鈕組。
///
/// 邊框軌道、正方形分段，寬度隨選項數量延展。支援二態、三態與多選項目。
class KlpPhaseToggle<T> extends StatelessWidget {
	const KlpPhaseToggle({
		super.key,
		required this.options,
		required this.selected,
		this.onSelected,
		this.enabled = true,
	});

	final List<KlpPhaseOption<T>> options;
	final T? selected;
	final ValueChanged<T>? onSelected;
	final bool enabled;

	@override
	Widget build(BuildContext context) {
		final selectedIndex = options.indexWhere((option) => option.value == selected);
		final selectedTone = selectedIndex < 0 ? null : options[selectedIndex].activeTone;
		final style = _KlpPhaseToggleStyle.resolve(
			context.klp,
			optionCount: options.length,
			enabled: enabled,
			selectedTone: selectedTone,
		);
		return _KlpPhaseToggleFrame(
			selectedIndex: selectedIndex,
			style: style,
			children: [
				for (var index = 0; index < options.length; index++)
					_KlpPhaseSegment<T>(
						option: options[index],
						selected: selected == options[index].value,
						enabled: enabled,
						style: style,
						onTap: enabled && onSelected != null ? () => onSelected!(options[index].value) : null,
					),
			],
		);
	}
}
