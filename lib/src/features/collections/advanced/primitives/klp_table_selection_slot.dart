part of '../klp_advanced_data.dart';

class _KlpTableSelectionSlot extends StatelessWidget {
  const _KlpTableSelectionSlot({
    required this.style,
    required this.rowId,
    required this.selected,
    required this.onChanged,
    required this.labels,
  });

  final _KlpAdvancedStyle style;
  final String? rowId;
  final bool selected;
  final ValueChanged<bool>? onChanged;
  final KlpLocalizations labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: style.controlHeightLarge,
      child: Center(
        child: KeyedSubtree(
          key: rowId == null
              ? const ValueKey('pln-table-select-all')
              : ValueKey('pln-table-select-$rowId'),
          child: KlpCheckbox(
            value: selected,
            label: rowId == null
                ? labels.dataTableSelectAllLabel
                : labels.dataTableSelectRowLabel,
            showLabel: false,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
