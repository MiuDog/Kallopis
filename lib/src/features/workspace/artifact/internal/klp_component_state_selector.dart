part of '../klp_artifact_workspace.dart';

/// 元件的狀態切換器；狀態值與標籤皆由呼叫端定義。
class KlpComponentStateSelector extends StatelessWidget {
  const KlpComponentStateSelector({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpTabs(
      tabs: labels,
      selected: selectedIndex,
      onSelected: onSelected,
    );
  }
}
