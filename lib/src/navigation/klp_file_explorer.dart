import 'package:flutter/material.dart';

import '../interaction/klp_state_highlight.dart';
import '../interaction/klp_pressable.dart';
import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

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
    return _renderedChild ?? const SizedBox.shrink();
  }
}

/// 檔案瀏覽器中的節點資料模型（可為折疊資料夾或一般檔案項目）。
@immutable
class KlpFileExplorerItem {
  const KlpFileExplorerItem({
    required this.id,
    required this.label,
    this.icon,
    this.children = const [],
    this.folder = false,
    this.expanded = false,
    this.selected = false,
    this.badge,
    this.tone,
    this.trailing,
    this.data,
  });

  final String id;
  final String label;
  final KlpIconData? icon;
  final List<KlpFileExplorerItem> children;
  final bool folder;
  final bool expanded;
  final bool selected;
  final String? badge;
  final KlpFeedbackTone? tone;
  final Widget? trailing;
  final Object? data;

  bool get isFolder => folder || children.isNotEmpty;
}

/// 檔案瀏覽器（File Explorer）。
///
/// 支援分類分組（可折疊）、資料夾樹狀結構（可展開）與一般檔案節點選取。
/// 支援受控（傳入 `expandedSectionIds` / `expandedItemIds` / `selectedId`）
/// 與非受控（讀取各 Section 與 Item 的 `expanded` / `selected` 屬性）兩種模式。
class KlpFileExplorer extends StatefulWidget {
  const KlpFileExplorer({
    super.key,
    required this.sections,
    this.expandedSectionIds,
    this.expandedItemIds,
    this.selectedId,
    this.onSectionToggle,
    this.onItemToggle,
    this.onItemSelected,
    this.indent,
    this.emptyStateSections = const [],
  });

  final List<KlpFileExplorerSection> sections;
  final Set<String>? expandedSectionIds;
  final Set<String>? expandedItemIds;
  final String? selectedId;
  final ValueChanged<String>? onSectionToggle;
  final ValueChanged<String>? onItemToggle;
  final ValueChanged<String>? onItemSelected;
  final double? indent;

  /// [sections] 沒有資料時仍需保留的視覺分區。
  ///
  /// 這只描述 Explorer 結構，不會把 placeholder section 寫回資料模型。
  final List<KlpFileExplorerSection> emptyStateSections;

  @override
  State<KlpFileExplorer> createState() => _KlpFileExplorerState();
}

class _KlpFileExplorerState extends State<KlpFileExplorer> {
  late Set<String> _internalExpandedSections;
  late Set<String> _internalExpandedItems;
  String? _internalSelectedId;

  @override
  void initState() {
    super.initState();
    final effectiveSections = widget.sections.isEmpty
        ? widget.emptyStateSections
        : widget.sections;
    _internalExpandedSections = {
      for (final s in effectiveSections)
        if (s.expanded) s.id,
    };
    _internalExpandedItems = {};
    _collectExpandedItems(effectiveSections, _internalExpandedItems);
    _internalSelectedId = widget.selectedId;
  }

  void _collectExpandedItems(
    List<KlpFileExplorerSection> sections,
    Set<String> target,
  ) {
    void traverse(List<KlpFileExplorerItem> items) {
      for (final item in items) {
        if (item.expanded) {
          target.add(item.id);
        }
        if (item.children.isNotEmpty) {
          traverse(item.children);
        }
      }
    }

    for (final s in sections) {
      traverse(s.items);
    }
  }

  void _toggleSection(String id) {
    if (widget.onSectionToggle != null) {
      widget.onSectionToggle!(id);
    } else {
      setState(() {
        if (_internalExpandedSections.contains(id)) {
          _internalExpandedSections.remove(id);
        } else {
          _internalExpandedSections.add(id);
        }
      });
    }
  }

  void _toggleItem(String id) {
    if (widget.onItemToggle != null) {
      widget.onItemToggle!(id);
    } else {
      setState(() {
        if (_internalExpandedItems.contains(id)) {
          _internalExpandedItems.remove(id);
        } else {
          _internalExpandedItems.add(id);
        }
      });
    }
  }

  void _selectItem(String id) {
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(id);
    } else {
      setState(() {
        _internalSelectedId = id;
      });
    }
  }

  String? _firstSelectedItemId(List<KlpFileExplorerSection> sections) {
    String? selectedId;

    void traverse(List<KlpFileExplorerItem> items) {
      for (final item in items) {
        if (selectedId != null) return;
        if (item.selected) {
          selectedId = item.id;
          return;
        }
        traverse(item.children);
      }
    }

    for (final section in sections) {
      traverse(section.items);
      if (selectedId != null) break;
    }
    return selectedId;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveExpandedSections =
        widget.expandedSectionIds ?? _internalExpandedSections;
    final effectiveExpandedItems =
        widget.expandedItemIds ?? _internalExpandedItems;
    final effectiveIndent = widget.indent ?? context.klp.space.tight;
    final effectiveSections = widget.sections.isEmpty
        ? widget.emptyStateSections
        : widget.sections;
    final effectiveSelectedId =
        widget.selectedId ??
        _internalSelectedId ??
        _firstSelectedItemId(effectiveSections);

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (final section in effectiveSections)
          KlpFileExplorerSection._render(
            section: section,
            child: KlpFileExplorerSectionView(
              section: section,
              isExpanded: effectiveExpandedSections.contains(section.id),
              expandedItemIds: effectiveExpandedItems,
              selectedId: effectiveSelectedId,
              onToggle: () => _toggleSection(section.id),
              onItemToggle: _toggleItem,
              onItemSelected: _selectItem,
              indent: effectiveIndent,
            ),
          ),
      ],
    );
  }
}

/// 分類區塊視圖（含分類標題、折疊動畫與項目清單）。
class KlpFileExplorerSectionView extends StatelessWidget {
  const KlpFileExplorerSectionView({
    super.key,
    required this.section,
    required this.isExpanded,
    required this.expandedItemIds,
    required this.selectedId,
    required this.onToggle,
    required this.onItemToggle,
    required this.onItemSelected,
    required this.indent,
  });

  final KlpFileExplorerSection section;
  final bool isExpanded;
  final Set<String> expandedItemIds;
  final String? selectedId;
  final VoidCallback onToggle;
  final ValueChanged<String> onItemToggle;
  final ValueChanged<String> onItemSelected;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: double.infinity,
          height: klp.space.icon,
          child: KlpPressable(
            onPressed: section.collapsible ? onToggle : null,
            hoverHighlight: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
              child: Row(
                children: [
                  if (section.collapsible) ...[
                    AnimatedRotation(
                      turns: isExpanded ? 0 : -0.25,
                      duration: klp.motion.stateTransition,
                      curve: Curves.easeOutCubic,
                      child: KlpIcon(
                        KlpIcons.chevronDown,
                        size: klp.space.compact,
                        color: tokens.textMuted,
                      ),
                    ),
                    SizedBox(width: klp.space.tight + klp.space.hairline),
                  ],
                  Expanded(
                    child: KlpText(
                      section.title,
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                  if (section.trailing != null) section.trailing!,
                ],
              ),
            ),
          ),
        ),
        if (isExpanded)
          for (final item in section.items)
            _KlpFileExplorerNodeView(
              item: item,
              level: 0,
              expandedItemIds: expandedItemIds,
              selectedId: selectedId,
              onItemToggle: onItemToggle,
              onItemSelected: onItemSelected,
              indent: indent,
            ),
        SizedBox(height: klp.space.compact - klp.space.hairline),
      ],
    );
  }
}

class _KlpFileExplorerNodeView extends StatelessWidget {
  const _KlpFileExplorerNodeView({
    required this.item,
    required this.level,
    required this.expandedItemIds,
    required this.selectedId,
    required this.onItemToggle,
    required this.onItemSelected,
    required this.indent,
  });

  final KlpFileExplorerItem item;
  final int level;
  final Set<String> expandedItemIds;
  final String? selectedId;
  final ValueChanged<String> onItemToggle;
  final ValueChanged<String> onItemSelected;
  final double indent;

  @override
  Widget build(BuildContext context) {
    final isExpanded = expandedItemIds.contains(item.id);
    final isSelected = selectedId == item.id;

    if (item.isFolder) {
      return Column(
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
            indent: indent,
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
                indent: indent,
              ),
        ],
      );
    }

    return KlpFileExplorerItemView(
      item: item,
      level: level,
      isSelected: isSelected,
      onTap: () => onItemSelected(item.id),
      indent: indent,
    );
  }
}

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
    required this.indent,
  });

  final KlpFileExplorerItem item;
  final int level;
  final bool isExpanded;
  final bool isSelected;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final double indent;

  @override
  State<KlpFileExplorerFolderView> createState() =>
      _KlpFileExplorerFolderViewState();
}

/// 將樹狀控制區與內容區分開，讓同層節點以內容圖示左緣對齊。
class _KlpFileExplorerRowAreas extends StatelessWidget {
  const _KlpFileExplorerRowAreas({
    required this.level,
    required this.indent,
    required this.content,
    this.leading,
  });

  final int level;
  final double indent;
  final Widget? leading;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Row(
      children: [
        Padding(
          key: const ValueKey('klp-file-explorer-leading-area'),
          padding: EdgeInsets.only(left: level * indent),
          child: SizedBox(
            width: klp.space.iconSmall + klp.space.compact,
            child: leading == null
                ? null
                : Align(alignment: Alignment.centerLeft, child: leading),
          ),
        ),
        Expanded(
          child: KeyedSubtree(
            key: const ValueKey('klp-file-explorer-content-area'),
            child: content,
          ),
        ),
      ],
    );
  }
}

class _KlpFileExplorerFolderViewState extends State<KlpFileExplorerFolderView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    Widget row = Container(
      height: klp.space.controlHeightXSmall,
      padding: EdgeInsets.only(right: klp.space.tight),
      decoration: BoxDecoration(
        color: tokens.clear,
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      child: _KlpFileExplorerRowAreas(
        level: widget.level,
        indent: widget.indent,
        leading: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onToggle,
          child: AnimatedRotation(
            turns: widget.isExpanded ? 0 : -0.25,
            duration: klp.motion.stateTransition,
            curve: Curves.easeOutCubic,
            child: KlpIcon(
              KlpIcons.chevronDown,
              size: klp.space.iconSmall,
              color: widget.isSelected ? tokens.text : tokens.textMuted,
            ),
          ),
        ),
        content: Row(
          children: [
            KlpIcon(
              widget.item.icon ?? KlpIcons.folder,
              size: klp.space.iconSmall,
              color: widget.isSelected ? tokens.text : tokens.textMuted,
            ),
            SizedBox(width: klp.space.compact),
            Expanded(
              child: KlpText(
                widget.item.label,
                role: KlpTextRole.code,
                color: tokens.text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.item.trailing != null) widget.item.trailing!,
          ],
        ),
      ),
    );

    row = KlpStateHighlight(
      state: widget.isSelected || _isHovered
          ? KlpHighlightState.hover
          : KlpHighlightState.none,
      borderRadius: BorderRadius.circular(klp.shape.control),
      child: row,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: klp.space.compact,
            vertical: klp.space.hairline,
          ),
          child: row,
        ),
      ),
    );
  }
}

/// 一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。
class KlpFileExplorerItemView extends StatefulWidget {
  const KlpFileExplorerItemView({
    super.key,
    required this.item,
    required this.level,
    required this.isSelected,
    required this.onTap,
    required this.indent,
  });

  final KlpFileExplorerItem item;
  final int level;
  final bool isSelected;
  final VoidCallback onTap;
  final double indent;

  @override
  State<KlpFileExplorerItemView> createState() =>
      _KlpFileExplorerItemViewState();
}

class _KlpFileExplorerItemViewState extends State<KlpFileExplorerItemView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    Widget row = Container(
      height:
          klp.space.controlHeightXSmall +
          klp.geometry.control.fileExplorerRowHeightAdjustment,
      padding: EdgeInsets.only(right: klp.space.tight),
      decoration: BoxDecoration(
        color: tokens.clear,
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      child: _KlpFileExplorerRowAreas(
        level: widget.level,
        indent: widget.indent,
        content: Row(
          children: [
            KlpIcon(
              widget.item.icon ?? KlpIcons.clipboard,
              size: klp.space.iconSmall,
              color: widget.isSelected ? tokens.text : tokens.textMuted,
            ),
            SizedBox(width: klp.space.compact),
            Expanded(
              child: KlpText(
                widget.item.label,
                role: KlpTextRole.code,
                color: tokens.text,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (widget.item.badge != null) ...[
              SizedBox(width: klp.space.compact),
              KlpText(
                widget.item.badge!,
                role: KlpTextRole.code,
                color: tokens.text,
              ),
            ],
            if (widget.item.trailing != null) widget.item.trailing!,
          ],
        ),
      ),
    );

    row = KlpStateHighlight(
      state: widget.isSelected || _isHovered
          ? KlpHighlightState.hover
          : KlpHighlightState.none,
      borderRadius: BorderRadius.circular(klp.shape.control),
      child: row,
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: klp.space.compact,
            vertical: klp.space.hairline,
          ),
          child: row,
        ),
      ),
    );
  }
}
