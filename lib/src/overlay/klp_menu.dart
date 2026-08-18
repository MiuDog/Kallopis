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
  static double horizontalPadding(BuildContext context) =>
      context.klp.space.compact;
  static double iconSize(BuildContext context) => context.klp.space.iconSmall;
  static double iconGap(BuildContext context) => context.klp.space.compact;
  static const double iconOpticalOffsetY = 1;
  // 這三項來自 theme，因此不能是編譯期常數。
  static double panelRadius(BuildContext context) => context.klp.shape.card;
  static double menuBlurRadius(BuildContext context) =>
      context.klp.surface.overlayBlur;
  static double menuOffsetY(BuildContext context) =>
      context.klp.surface.overlayOffsetY;
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
    required BuildContext context,
    required int itemCount,
    int separatorCount = 0,
  }) {
    return context.klp.space.tight * 2 +
        _KlpMenuMetrics.headerHeight +
        context.klp.space.tight +
        itemCount * _KlpMenuMetrics.itemHeight +
        separatorCount * (context.klp.shape.stroke + context.klp.space.compact);
  }

  static Offset resolvePosition({
    required Offset anchor,
    required Size viewport,
    required BuildContext context,
    required int itemCount,
    int separatorCount = 0,
  }) {
    final height = estimatedHeight(
      context: context,
      itemCount: itemCount,
      separatorCount: separatorCount,
    );
    final left = anchor.dx
        .clamp(
          context.klp.space.compact,
          viewport.width - _KlpMenuMetrics.width - context.klp.space.compact,
        )
        .toDouble();
    final top = anchor.dy
        .clamp(context.klp.space.compact, viewport.height - height - context.klp.space.compact)
        .toDouble();

    return Offset(left, top);
  }

  static Offset resolveSubmenuPosition({
    required Offset parentPosition,
    required Size viewport,
    required BuildContext context,
    required int itemCount,
    int separatorCount = 0,
  }) {
    final height = estimatedHeight(
      context: context,
      itemCount: itemCount,
      separatorCount: separatorCount,
    );
    final preferredLeft = parentPosition.dx + width + context.klp.space.tight;
    final left = preferredLeft + width + context.klp.space.compact <= viewport.width
        ? preferredLeft
        : parentPosition.dx - width - context.klp.space.tight;
    final top = parentPosition.dy
        .clamp(context.klp.space.compact, viewport.height - height - context.klp.space.compact)
        .toDouble();

    return Offset(
      left.clamp(context.klp.space.compact, viewport.width - width).toDouble(),
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
        borderRadius: BorderRadius.circular(_KlpMenuMetrics.panelRadius(context)),
        boxShadow: [
          BoxShadow(
            color: tokens.modalScrim.withValues(
              alpha: context.klp.surface.overlayShadowOpacity,
            ),
            blurRadius: _KlpMenuMetrics.menuBlurRadius(context),
            spreadRadius: context.klp.surface.overlaySpread,
            offset: Offset(0, _KlpMenuMetrics.menuOffsetY(context)),
          ),
        ],
      ),
      child: SizedBox(
        width: _KlpMenuMetrics.width,
        child: KlpSurface(
          tone: KlpSurfaceTone.overlay,
          radius: _KlpMenuMetrics.panelRadius(context),
          padding: EdgeInsets.all(context.klp.space.tight),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: _KlpMenuMetrics.headerHeight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: _KlpMenuMetrics.horizontalPadding(context),
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
              SizedBox(height: context.klp.space.tight),
              for (final item in items) ...[
                if (item.separatedBefore)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: context.klp.space.tight),
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
        color: active ? context.klp.hoverSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: InkWell(
          onTap: data.enabled ? data.onPressed : null,
          onHover: data.enabled
              ? (value) => setState(() => _hovered = value)
              : null,
          onFocusChange: (value) => setState(() => _focused = value),
          overlayColor: const WidgetStatePropertyAll(Colors.transparent),
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: SizedBox(
            height: _KlpMenuMetrics.itemHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _KlpMenuMetrics.horizontalPadding(context),
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
                        size: _KlpMenuMetrics.iconSize(context),
                        color: foreground,
                      ),
                    ),
                    SizedBox(width: _KlpMenuMetrics.iconGap(context)),
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
                        size: _KlpMenuMetrics.iconSize(context),
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
