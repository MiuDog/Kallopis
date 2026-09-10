part of '../klp_file_explorer.dart';

class _KlpFileExplorerItemViewState extends State<KlpFileExplorerItemView> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    Widget row = KlpBox(
      height:
          klp.space.controlHeightXSmall +
          klp.geometry.control.fileExplorerRowHeightAdjustment,
      insets: KlpBoxInsets.directional(end: klp.space.tight),
      child: _KlpFileExplorerRowAreas(
        level: widget.level,
        spacing: widget.spacing,
        content: KlpRow(
          children: [
            KlpIcon(
              widget.item.icon ?? KlpIcons.clipboard,
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
            if (widget.item.badge != null) ...[
              KlpBox(width: klp.space.contentInlineGap),
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
