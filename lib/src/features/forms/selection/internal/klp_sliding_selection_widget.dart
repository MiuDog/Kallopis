part of '../klp_sliding_selection.dart';

class KlpSlidingSelection extends StatelessWidget {
  const KlpSlidingSelection({
    super.key,
    required this.label,
    required this.selectedIndex,
    required this.options,
    required this.onSelected,
  }) : assert(options.length > 1),
       assert(selectedIndex >= 0 && selectedIndex < options.length);

  final String label;
  final int selectedIndex;
  final List<KlpSelectionOption> options;
  final ValueChanged<int>? onSelected;

  @override
  Widget build(BuildContext context) {
    return _KlpSlidingSelectionFrame(
      label: label,
      selectedIndex: selectedIndex,
      options: options,
      onSelected: onSelected,
      style: _KlpSlidingSelectionStyle.resolve(context.klp),
    );
  }
}
