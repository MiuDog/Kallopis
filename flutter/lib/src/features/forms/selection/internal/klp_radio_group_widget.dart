part of '../klp_radio_group.dart';

class KlpRadioGroup<T> extends StatelessWidget {
  const KlpRadioGroup({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.descriptions,
    this.vertical = false,
  });

  final Map<T, String> items;
  final T value;
  final ValueChanged<T> onChanged;
  final Map<T, String>? descriptions;
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final children = [
      for (final entry in items.entries)
        _KlpRadioItem(
          label: entry.value,
          description: descriptions?[entry.key],
          selected: entry.key == value,
          onPressed: () => onChanged(entry.key),
        ),
    ];
    if (!vertical) {
      return KlpWrap(
        spacingSize: KlpSpaceSize.comfortable,
        runSpacingSize: KlpSpaceSize.contentStack,
        children: children,
      );
    }

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final child in children) ...[
          child,
          const KlpGap.heightSize(KlpSpaceSize.tight),
        ],
      ],
    );
  }
}
