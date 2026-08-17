import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controls/pln_toggle.dart';
import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_divider.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

abstract final class PlnMenuStyle {
  static const PlnTextRole textRole = PlnTextRole.label;
}

abstract final class _PlnMenuMetrics {
  static const double width = PlnSize.menu;
  static const double headerHeight = PlnSize.menuHeader;
  static const double itemHeight = PlnSize.menuItem;
  static const double horizontalPadding = PlnSpace.sm;
  static const double iconSize = PlnSize.iconSmall;
  static const double iconGap = PlnSpace.sm;
  static const double iconOpticalOffsetY = 1;
  static const double panelRadius = PlnRadius.card;
  static const double menuBlurRadius = PlnElevation.menuBlurRadius;
  static const double menuOffsetY = PlnElevation.menuOffsetY;
}

class PlnMenuItemData {
  const PlnMenuItemData({
    required this.label,
    required this.onPressed,
    this.key,
    this.icon,
    this.shortcut,
    this.toggleValue,
    this.hasSubmenu = false,
    this.danger = false,
    this.separatedBefore = false,
    this.selected = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onPressed;
  final Key? key;
  final String? icon;
  final String? shortcut;
  final bool? toggleValue;
  final bool hasSubmenu;
  final bool danger;
  final bool separatedBefore;
  final bool selected;
  final bool enabled;
}

abstract final class PlnMenuLayout {
  static double get width => _PlnMenuMetrics.width;

  static double estimatedHeight({
    required int itemCount,
    int separatorCount = 0,
  }) {
    return PlnSpace.xs * 2 +
        _PlnMenuMetrics.headerHeight +
        PlnSpace.xs +
        itemCount * _PlnMenuMetrics.itemHeight +
        separatorCount * (PlnLine.width + PlnSpace.sm);
  }

  static Offset resolvePosition({
    required Offset anchor,
    required Size viewport,
    required int itemCount,
    int separatorCount = 0,
  }) {
    final height = estimatedHeight(
      itemCount: itemCount,
      separatorCount: separatorCount,
    );
    final left = anchor.dx
        .clamp(
          PlnSpace.sm,
          viewport.width - _PlnMenuMetrics.width - PlnSpace.sm,
        )
        .toDouble();
    final top = anchor.dy
        .clamp(PlnSpace.sm, viewport.height - height - PlnSpace.sm)
        .toDouble();

    return Offset(left, top);
  }

  static Offset resolveSubmenuPosition({
    required Offset parentPosition,
    required Size viewport,
    required int itemCount,
    int separatorCount = 0,
  }) {
    final height = estimatedHeight(
      itemCount: itemCount,
      separatorCount: separatorCount,
    );
    final preferredLeft = parentPosition.dx + width + PlnSpace.xs;
    final left = preferredLeft + width + PlnSpace.sm <= viewport.width
        ? preferredLeft
        : parentPosition.dx - width - PlnSpace.xs;
    final top = parentPosition.dy
        .clamp(PlnSpace.sm, viewport.height - height - PlnSpace.sm)
        .toDouble();

    return Offset(
      left.clamp(PlnSpace.sm, viewport.width - width).toDouble(),
      top,
    );
  }
}

class PlnMenu extends StatelessWidget {
  const PlnMenu({super.key, required this.label, required this.items});

  final String label;
  final List<PlnMenuItemData> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;

    return DecoratedBox(
      key: const ValueKey('pln-menu-elevation'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_PlnMenuMetrics.panelRadius),
        boxShadow: [
          BoxShadow(
            color: tokens.modalScrim.withValues(
              alpha: PlnElevation.menuShadowOpacity,
            ),
            blurRadius: _PlnMenuMetrics.menuBlurRadius,
            spreadRadius: PlnElevation.menuSpreadRadius,
            offset: Offset(0, _PlnMenuMetrics.menuOffsetY),
          ),
        ],
      ),
      child: SizedBox(
        width: _PlnMenuMetrics.width,
        child: PlnSurface(
          tone: PlnSurfaceTone.overlay,
          radius: _PlnMenuMetrics.panelRadius,
          padding: const EdgeInsets.all(PlnSpace.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _PlnMenuMetrics.headerHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _PlnMenuMetrics.horizontalPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: PlnText(
                      label,
                      role: PlnMenuStyle.textRole,
                      tone: PlnTextTone.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: PlnSpace.xs),
              for (final item in items) ...[
                if (item.separatedBefore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: PlnSpace.xs),
                    child: PlnDivider(),
                  ),
                PlnMenuItem(key: item.key, data: item),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PlnMenuItem extends StatefulWidget {
  const PlnMenuItem({super.key, required this.data});

  final PlnMenuItemData data;

  @override
  State<PlnMenuItem> createState() => _PlnMenuItemState();
}

class _PlnMenuItemState extends State<PlnMenuItem> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final data = widget.data;
    final active = data.selected || _hovered || _focused;
    final foreground = !data.enabled
        ? tokens.textFaint
        : data.danger
        ? tokens.danger
        : active
        ? tokens.text
        : tokens.textMuted;

    return Semantics(
      button: true,
      enabled: data.enabled,
      toggled: data.toggleValue,
      child: Material(
        color: active ? tokens.hoverSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: InkWell(
          onTap: data.enabled ? data.onPressed : null,
          onHover: data.enabled
              ? (value) => setState(() => _hovered = value)
              : null,
          onFocusChange: (value) => setState(() => _focused = value),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: SizedBox(
            height: _PlnMenuMetrics.itemHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _PlnMenuMetrics.horizontalPadding,
              ),
              child: Row(
                children: [
                  if (data.icon != null) ...[
                    Transform.translate(
                      offset: const Offset(
                        0,
                        _PlnMenuMetrics.iconOpticalOffsetY,
                      ),
                      child: PlnIcon(
                        data.icon!,
                        size: _PlnMenuMetrics.iconSize,
                        color: foreground,
                      ),
                    ),
                    SizedBox(width: _PlnMenuMetrics.iconGap),
                  ],
                  Expanded(
                    child: PlnText(
                      data.label,
                      role: PlnMenuStyle.textRole,
                      color: foreground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (data.shortcut != null)
                    PlnText(
                      data.shortcut!,
                      role: PlnTextRole.caption,
                      tone: PlnTextTone.faint,
                    ),
                  if (data.toggleValue != null)
                    PlnToggleIndicator(
                      value: data.toggleValue!,
                      enabled: data.enabled,
                    ),
                  if (data.hasSubmenu)
                    Transform.rotate(
                      key: const ValueKey('pln-menu-submenu-indicator'),
                      angle: -math.pi / 2,
                      child: PlnIcon(
                        PlnIcons.chevronDown,
                        size: _PlnMenuMetrics.iconSize,
                        color: foreground,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
