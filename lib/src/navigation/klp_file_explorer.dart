import 'package:flutter/material.dart';

import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 檔案瀏覽器中的分類資料模型（例如「釘選」、「筆記」）。
@immutable
class KlpFileExplorerSection {
  const KlpFileExplorerSection({
    required this.id,
    required this.title,
    this.items = const [],
    this.expanded = true,
    this.collapsible = true,
    this.trailing,
  });

  final String id;
  final String title;
  final List<KlpFileExplorerItem> items;
  final bool expanded;
  final bool collapsible;
  final Widget? trailing;
}

/// 檔案瀏覽器中的節點資料模型（可為折疊資料夾或一般檔案項目）。
@immutable
class KlpFileExplorerItem {
  const KlpFileExplorerItem({
    required this.id,
    required this.label,
    this.icon,
    this.children = const [],
    this.expanded = false,
    this.selected = false,
    this.badge,
    this.tone,
    this.trailing,
    this.data,
  });

  final String id;
  final String label;
  final String? icon;
  final List<KlpFileExplorerItem> children;
  final bool expanded;
  final bool selected;
  final String? badge;
  final KlpFeedbackTone? tone;
  final Widget? trailing;
  final Object? data;

  bool get isFolder => children.isNotEmpty;
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
  });

  final List<KlpFileExplorerSection> sections;
  final Set<String>? expandedSectionIds;
  final Set<String>? expandedItemIds;
  final String? selectedId;
  final ValueChanged<String>? onSectionToggle;
  final ValueChanged<String>? onItemToggle;
  final ValueChanged<String>? onItemSelected;
  final double? indent;

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
    _internalExpandedSections = {
      for (final s in widget.sections)
        if (s.expanded) s.id,
    };
    _internalExpandedItems = {};
    _collectExpandedItems(widget.sections, _internalExpandedItems);
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

  @override
  Widget build(BuildContext context) {
    final effectiveExpandedSections =
        widget.expandedSectionIds ?? _internalExpandedSections;
    final effectiveExpandedItems =
        widget.expandedItemIds ?? _internalExpandedItems;
    final effectiveSelectedId = widget.selectedId ?? _internalSelectedId;
    final effectiveIndent = widget.indent ?? context.klp.space.base;

    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        for (final section in widget.sections)
          KlpFileExplorerSectionView(
            section: section,
            isExpanded: effectiveExpandedSections.contains(section.id),
            expandedItemIds: effectiveExpandedItems,
            selectedId: effectiveSelectedId,
            onToggle: () => _toggleSection(section.id),
            onItemToggle: _toggleItem,
            onItemSelected: _selectItem,
            indent: effectiveIndent,
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
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: section.collapsible ? onToggle : null,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: klp.space.compact,
              vertical: klp.space.tight,
            ),
            child: Row(
              children: [
                if (section.collapsible) ...[
                  AnimatedRotation(
                    turns: isExpanded ? 0 : -0.25,
                    duration: klp.motion.stateTransition,
                    curve: Curves.easeOutCubic,
                    child: KlpIcon(
                      KlpIcons.chevronDown,
                      size: klp.space.iconSmall,
                      color: tokens.textMuted,
                    ),
                  ),
                  SizedBox(width: klp.space.compact),
                ],
                Expanded(
                  child: KlpText(
                    section.title,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                  ),
                ),
                if (section.trailing != null) section.trailing!,
              ],
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
        SizedBox(height: klp.space.tight),
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
    final isSelected = selectedId == item.id || item.selected;

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

class _KlpFileExplorerFolderViewState extends State<KlpFileExplorerFolderView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    final bg = widget.isSelected
        ? tokens.selectionBackground
        : (_isHovered
              ? tokens.surfaceRaised.withValues(
                  alpha: klp.surface.statusFillOpacity,
                )
              : tokens.clear);

    final fg = widget.isSelected ? tokens.text : tokens.textMuted;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          height: klp.space.controlHeightSmall,
          margin: EdgeInsets.symmetric(
            horizontal: klp.space.compact,
            vertical: klp.space.hairline,
          ),
          padding: EdgeInsets.only(
            left: widget.level * widget.indent + klp.space.tight,
            right: klp.space.tight,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(klp.shape.control),
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onToggle,
                child: AnimatedRotation(
                  turns: widget.isExpanded ? 0 : -0.25,
                  duration: klp.motion.stateTransition,
                  curve: Curves.easeOutCubic,
                  child: KlpIcon(
                    KlpIcons.chevronDown,
                    size: klp.space.iconSmall,
                    color: tokens.textMuted,
                  ),
                ),
              ),
              SizedBox(width: klp.space.compact),
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
                  color: fg,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.trailing != null) widget.item.trailing!,
            ],
          ),
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

    final bg = widget.isSelected
        ? tokens.selectionBackground
        : (_isHovered
              ? tokens.surfaceRaised.withValues(
                  alpha: klp.surface.statusFillOpacity,
                )
              : tokens.clear);

    final fg = widget.isSelected
        ? tokens.text
        : (widget.item.tone == KlpFeedbackTone.danger
              ? tokens.danger
              : tokens.text);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Container(
          height:
              klp.space.controlHeightSmall +
              klp.geometry.control.fileExplorerRowHeightAdjustment,
          margin: EdgeInsets.symmetric(
            horizontal: klp.space.compact,
            vertical: klp.space.hairline,
          ),
          padding: EdgeInsets.only(
            left:
                widget.level * widget.indent +
                klp.space.iconSmall +
                klp.space.compact +
                klp.space.tight,
            right: klp.space.tight,
          ),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(klp.shape.control),
          ),
          child: Row(
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
                  color: fg,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (widget.item.badge != null) ...[
                SizedBox(width: klp.space.compact),
                KlpText(
                  widget.item.badge!,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (widget.item.trailing != null) widget.item.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
