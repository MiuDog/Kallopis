part of '../klp_file_explorer.dart';

/// 折疊資料夾視圖（帶展開箭頭、資料夾圖示與縮排）。
class KlpFileExplorerFolderView extends StatefulWidget {
  const KlpFileExplorerFolderView({
    super.key,
    required this.item,
    required this.level,
    required this.isExpanded,
    required this.isSelected,
    required this.onToggle,
    required this.onTap,
    this.spacing = KlpFileExplorerSpacing.standard,
  });

  final KlpFileExplorerItem item;
  final int level;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final KlpFileExplorerSpacing spacing;

  @override
  State<KlpFileExplorerFolderView> createState() =>
      _KlpFileExplorerFolderViewState();
}
