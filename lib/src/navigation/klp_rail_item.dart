import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

class KlpRailItem extends StatefulWidget {
  const KlpRailItem({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.badge,
  });

  final String icon;
  final String label;
  final VoidCallback onPressed;
  final bool selected;
  final String? badge;

  @override
  State<KlpRailItem> createState() => _KlpRailItemState();
}

class _KlpRailItemState extends State<KlpRailItem> {
  final LayerLink _tooltipLink = LayerLink();
  final OverlayPortalController _tooltipController = OverlayPortalController();
  bool _hovered = false;
  bool _focused = false;

  void _setHovered(bool value) {
    setState(() => _hovered = value);
    _syncTooltip(hovered: value);
  }

  void _setFocused(bool value) {
    setState(() => _focused = value);
  }

  void _syncTooltip({required bool hovered}) {
    if (hovered) {
      _tooltipController.show();
    } else {
      _tooltipController.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final background = widget.selected
        ? tokens.selectionBackground
        : _hovered || _focused
        ? context.klp.selectionWash
        : tokens.clear;
    final item = Material(
      color: background,
      borderRadius: BorderRadius.circular(context.klp.shape.card),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: _setHovered,
        onFocusChange: _setFocused,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
        child: SizedBox.square(
          dimension: context.klp.space.railItem,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Center(
                child: KlpIcon(
                  widget.icon,
                  color: widget.selected
                      ? tokens.selectionForeground
                      : tokens.textMuted,
                ),
              ),
              if (widget.badge != null)
                Positioned(
                  top: context.klp.geometry.optical.railBadgeInset,
                  right: context.klp.geometry.optical.railBadgeInset,
                  child: Container(
                    width: context.klp.space.indicatorDotLarge,
                    height: context.klp.space.indicatorDotLarge,
                    decoration: BoxDecoration(
                      color: tokens.info,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    return OverlayPortal(
      controller: _tooltipController,
      overlayChildBuilder: (context) {
        return CompositedTransformFollower(
          link: _tooltipLink,
          targetAnchor: Alignment.centerRight,
          followerAnchor: Alignment.centerLeft,
          offset: Offset(context.klp.space.compact, 0),
          showWhenUnlinked: false,
          child: IgnorePointer(
            child: ExcludeSemantics(
              child: UnconstrainedBox(
                alignment: Alignment.centerLeft,
                child: KlpTooltipSurface(
                  message: widget.label,
                  contentKey: ValueKey('rail-hover-label-${widget.label}'),
                ),
              ),
            ),
          ),
        );
      },
      child: CompositedTransformTarget(
        link: _tooltipLink,
        child: Semantics(
          button: true,
          selected: widget.selected,
          label: widget.label,
          child: item,
        ),
      ),
    );
  }
}
