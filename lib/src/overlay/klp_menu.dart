import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../controls/klp_toggle.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_divider.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

abstract final class KlpMenuStyle {
  static const KlpTextRole textRole = KlpTextRole.label;
}

abstract final class _KlpMenuMetrics {
  static const double width = KlpSize.menu;
  static const double headerHeight = KlpSize.menuHeader;
  static const double itemHeight = KlpSize.menuItem;
  static const double horizontalPadding = KlpSpace.sm;
  static const double iconSize = KlpSize.iconSmall;
  static const double iconGap = KlpSpace.sm;
  static const double iconOpticalOffsetY = 1;
  static const double panelRadius = KlpRadius.card;
  static const double menuBlurRadius = KlpElevation.menuBlurRadius;
  static const double menuOffsetY = KlpElevation.menuOffsetY;
}

class KlpMenuItemData {
  const KlpMenuItemData({
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

abstract final class KlpMenuLayout {
  static double get width => _KlpMenuMetrics.width;

  static double estimatedHeight({
    required int itemCount,
    int separatorCount = 0,
  }) {
    return KlpSpace.xs * 2 +
        _KlpMenuMetrics.headerHeight +
        KlpSpace.xs +
        itemCount * _KlpMenuMetrics.itemHeight +
        separatorCount * (KlpLine.width + KlpSpace.sm);
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
          KlpSpace.sm,
          viewport.width - _KlpMenuMetrics.width - KlpSpace.sm,
        )
        .toDouble();
    final top = anchor.dy
        .clamp(KlpSpace.sm, viewport.height - height - KlpSpace.sm)
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
    final preferredLeft = parentPosition.dx + width + KlpSpace.xs;
    final left = preferredLeft + width + KlpSpace.sm <= viewport.width
        ? preferredLeft
        : parentPosition.dx - width - KlpSpace.xs;
    final top = parentPosition.dy
        .clamp(KlpSpace.sm, viewport.height - height - KlpSpace.sm)
        .toDouble();

    return Offset(
      left.clamp(KlpSpace.sm, viewport.width - width).toDouble(),
      top,
    );
  }
}

class KlpMenu extends StatelessWidget {
  const KlpMenu({super.key, required this.label, required this.items});

  final String label;
  final List<KlpMenuItemData> items;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      key: const ValueKey('pln-menu-elevation'),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_KlpMenuMetrics.panelRadius),
        boxShadow: [
          BoxShadow(
            color: tokens.modalScrim.withValues(
              alpha: KlpElevation.menuShadowOpacity,
            ),
            blurRadius: _KlpMenuMetrics.menuBlurRadius,
            spreadRadius: KlpElevation.menuSpreadRadius,
            offset: Offset(0, _KlpMenuMetrics.menuOffsetY),
          ),
        ],
      ),
      child: SizedBox(
        width: _KlpMenuMetrics.width,
        child: KlpSurface(
          tone: KlpSurfaceTone.overlay,
          radius: _KlpMenuMetrics.panelRadius,
          padding: const EdgeInsets.all(KlpSpace.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _KlpMenuMetrics.headerHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _KlpMenuMetrics.horizontalPadding,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: KlpText(
                      label,
                      role: KlpMenuStyle.textRole,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: KlpSpace.xs),
              for (final item in items) ...[
                if (item.separatedBefore)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: KlpSpace.xs),
                    child: KlpDivider(),
                  ),
                KlpMenuItem(key: item.key, data: item),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class KlpMenuItem extends StatefulWidget {
  const KlpMenuItem({super.key, required this.data});

  final KlpMenuItemData data;

  @override
  State<KlpMenuItem> createState() => _KlpMenuItemState();
}

class _KlpMenuItemState extends State<KlpMenuItem> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
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
        borderRadius: BorderRadius.circular(KlpRadius.control),
        child: InkWell(
          onTap: data.enabled ? data.onPressed : null,
          onHover: data.enabled
              ? (value) => setState(() => _hovered = value)
              : null,
          onFocusChange: (value) => setState(() => _focused = value),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: BorderRadius.circular(KlpRadius.control),
          child: SizedBox(
            height: _KlpMenuMetrics.itemHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _KlpMenuMetrics.horizontalPadding,
              ),
              child: Row(
                children: [
                  if (data.icon != null) ...[
                    Transform.translate(
                      offset: const Offset(
                        0,
                        _KlpMenuMetrics.iconOpticalOffsetY,
                      ),
                      child: KlpIcon(
                        data.icon!,
                        size: _KlpMenuMetrics.iconSize,
                        color: foreground,
                      ),
                    ),
                    SizedBox(width: _KlpMenuMetrics.iconGap),
                  ],
                  Expanded(
                    child: KlpText(
                      data.label,
                      role: KlpMenuStyle.textRole,
                      color: foreground,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (data.shortcut != null)
                    KlpText(
                      data.shortcut!,
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.faint,
                    ),
                  if (data.toggleValue != null)
                    KlpToggleIndicator(
                      value: data.toggleValue!,
                      enabled: data.enabled,
                    ),
                  if (data.hasSubmenu)
                    Transform.rotate(
                      key: const ValueKey('pln-menu-submenu-indicator'),
                      angle: -math.pi / 2,
                      child: KlpIcon(
                        KlpIcons.chevronDown,
                        size: _KlpMenuMetrics.iconSize,
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
