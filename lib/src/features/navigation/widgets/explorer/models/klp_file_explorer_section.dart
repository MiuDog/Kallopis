part of '../klp_file_explorer.dart';

/// 檔案瀏覽器中的分類資料模型（例如「釘選」、「筆記」）。
@immutable
class KlpFileExplorerSection extends StatelessWidget {
  const KlpFileExplorerSection({
    super.key,
    required this.id,
    required this.title,
    this.items = const [],
    this.expanded = true,
    this.collapsible = true,
    this.trailing,
  }) : _renderedChild = null;

  KlpFileExplorerSection._render({
    required KlpFileExplorerSection section,
    required Widget child,
  }) : id = section.id,
       title = section.title,
       items = section.items,
       expanded = section.expanded,
       collapsible = section.collapsible,
       trailing = section.trailing,
       _renderedChild = child,
       super(key: ValueKey(section.id));

  final String id;
  final String title;
  final List<KlpFileExplorerItem> items;
  final bool expanded;
  final bool collapsible;
  final Widget? trailing;
  final Widget? _renderedChild;

  @override
  Widget build(BuildContext context) {
    return _renderedChild ?? const KlpBox.shrink();
  }
}
