part of '../klp_menu.dart';

/// [KlpMenu] 裡單一項目的渲染；互動與狀態表面統一交由 [KlpActionRegion]。
class KlpMenuItem extends StatelessWidget {
  const KlpMenuItem({
    super.key,
    required this.data,
    this.keyboardHighlighted = false,
  });

  final KlpMenuItemData data;

  /// 由容器以鍵盤方向鍵移動出的高亮狀態，不影響真正的 selected 狀態。
  final bool keyboardHighlighted;

  @override
  Widget build(BuildContext context) {
    return KlpActionRegion(
      label: data.label,
      onPressed: data.enabled ? data.onPressed : null,
      tone: data.danger
          ? KlpActionRegionTone.destructive
          : KlpActionRegionTone.neutral,
      shape: KlpActionRegionShape.control,
      selected: data.selected,
      active: keyboardHighlighted,
      toggled: data.toggleValue,
      builder: (context, style) => KlpBox(
        height: _KlpMenuMetrics.itemHeight(context),
        insets: KlpBoxInsets.directional(
          start: _KlpMenuMetrics.horizontalPadding(context),
          end: _KlpMenuMetrics.horizontalPadding(context),
        ),
        child: KlpRow(
          children: [
            if (data.icon != null) ...[
              KlpTranslate(
                translation: KlpTranslation(
                  vertical: _KlpMenuMetrics.iconOpticalOffsetY(context),
                ),
                child: KlpIcon(
                  data.icon!,
                  size: _KlpMenuMetrics.iconSize(context),
                  color: style.foreground,
                ),
              ),
              KlpBox(width: _KlpMenuMetrics.iconGap(context)),
            ],
            KlpExpanded(
              child: KlpText(
                data.label,
                role: KlpMenuStyle.textRole,
                color: style.foreground,
                excludeFromSemantics: true,
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
              KlpRotate(
                key: const ValueKey('pln-menu-submenu-indicator'),
                turn: KlpQuarterTurn.counterClockwise,
                child: KlpIcon(
                  KlpIcons.chevronDown,
                  size: _KlpMenuMetrics.iconSize(context),
                  color: style.foreground,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
