part of '../klp_file_explorer.dart';

class _KlpFileExplorerFolderViewState extends State<KlpFileExplorerFolderView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    Widget row = KlpBox(
      height: klp.space.controlHeightXSmall,
      insets: KlpBoxInsets.directional(end: klp.space.tight),
      child: _KlpFileExplorerRowAreas(
        level: widget.level,
        spacing: widget.spacing,
        leading: KlpGestureRegion(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onToggle,
          child: _KlpFileExplorerDisclosure(
            expanded: widget.isExpanded,
            size: _KlpFileExplorerDisclosureSize.item,
            selected: widget.isSelected,
          ),
        ),
        content: KlpRow(
          children: [
            KlpIcon(
              widget.item.icon ?? KlpIcons.folder,
              size: klp.space.iconSmall,
              color: widget.isSelected ? tokens.text : tokens.textMuted,
            ),
            KlpBox(width: klp.space.contentInlineGap),
            KlpExpanded(
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
      child: row,
    );

    return _KlpFileExplorerInteractiveRow(
      spacing: widget.spacing,
      onHoverChanged: (value) => setState(() => _isHovered = value),
      onTap: widget.onTap,
      child: row,
    );
  }
}
