part of '../klp_file_explorer.dart';

class _KlpFileExplorerNodeView extends StatelessWidget {
  const _KlpFileExplorerNodeView({
    required this.item,
    required this.level,
    required this.expandedItemIds,
    required this.selectedId,
    required this.onItemToggle,
    required this.onItemSelected,
    required this.spacing,
  });

  final KlpFileExplorerItem item;
  final int level;
  final Set<String> expandedItemIds;
  final String? selectedId;
  final ValueChanged<String> onItemToggle;
  final ValueChanged<String> onItemSelected;
  final KlpFileExplorerSpacing spacing;

  @override
  Widget build(BuildContext context) {
    final isExpanded = expandedItemIds.contains(item.id);
    final isSelected = selectedId == item.id;

    if (item.isFolder) {
      return KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpFileExplorerFolderView(
            item: item,
            level: level,
            isExpanded: isExpanded,
            isSelected: isSelected,
            onToggle: () => onItemToggle(item.id),
            onTap: () {
              onItemToggle(item.id);
              onItemSelected(item.id);
            },
            spacing: spacing,
          ),
          if (isExpanded)
            for (final child in item.children)
              _KlpFileExplorerNodeView(
                item: child,
                level: level + 1,
                expandedItemIds: expandedItemIds,
                selectedId: selectedId,
                onItemToggle: onItemToggle,
                onItemSelected: onItemSelected,
                spacing: spacing,
              ),
        ],
      );
    }

    return KlpFileExplorerItemView(
      item: item,
      level: level,
      isSelected: isSelected,
      onTap: () => onItemSelected(item.id),
      spacing: spacing,
    );
  }
}
