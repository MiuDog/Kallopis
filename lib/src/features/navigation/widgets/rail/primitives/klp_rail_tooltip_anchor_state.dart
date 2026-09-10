part of '../klp_rail_item.dart';

class _KlpRailTooltipAnchorState extends State<_KlpRailTooltipAnchor> {
  final LayerLink _link = LayerLink();
  final OverlayPortalController _controller = OverlayPortalController();

  void _showTooltip(PointerEnterEvent event) {
    _controller.show();
  }

  void _hideTooltip(PointerExitEvent event) {
    _controller.hide();
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _controller,
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: _link,
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: Offset(context.klp.geometry.layout.tooltipOffsetX, 0),
          showWhenUnlinked: false,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: KlpTooltipSurface(
                  message: widget.message,
                  contentKey: ValueKey('rail-hover-label-${widget.message}'),
                ),
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _link,
        child: MouseRegion(
          onEnter: _showTooltip,
          onExit: _hideTooltip,
          child: widget.child,
        ),
      ),
    );
  }
}
