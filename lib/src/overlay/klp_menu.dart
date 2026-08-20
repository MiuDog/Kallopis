import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../foundation/klp_palette.dart';
import '../controls/klp_toggle.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_dashed_border.dart';
import '../surface/klp_divider.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// [KlpMenu] 系列元件共用的文字角色，目前只有一項。獨立成類別是為了讓未來
/// 若要新增更多共用樣式常數時有現成的落點，不必再改動呼叫端。
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

/// [KlpMenu] 裡的一個項目。
///
/// [toggleValue] 非 null 時項目會額外畫出一個開關指示，用於「這個選項本身是
/// 一個可切換設定」的情境（例如選單裡的「顯示隱藏檔案」）；[hasSubmenu] 只是
/// 畫出展開箭頭的視覺提示，實際的子選單彈出邏輯不歸這個資料類別管，由呼叫端
/// 自行處理 [onPressed]。[separatedBefore] 在這個項目之前插入一條分隔線，
/// 用來把選單切成語意上的幾組。
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

/// 計算 [KlpMenu] 彈出時的尺寸與位置，供呼叫端在插入 overlay 之前先算好座標。
///
/// [KlpMenu] 本身不負責定位——它假設自己已經被放在正確的座標上。這裡的計算
/// 之所以要在 build 之前完成，是因為 overlay 通常要在 `showMenu` 一類的 API
/// 呼叫時就給出目標位置，那時還沒有已渲染的 widget 可以量測，因此改用
/// [estimatedHeight] 這種按項目數推算高度的方式，而不是實際排版量測。
/// [resolvePosition]／[resolveSubmenuPosition] 都會把結果夾在 viewport 內，
/// 避免選單超出螢幕邊界。
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
        .clamp(
          context.klp.space.compact,
          viewport.height - height - context.klp.space.compact,
        )
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
    final left =
        preferredLeft + width + context.klp.space.compact <= viewport.width
        ? preferredLeft
        : parentPosition.dx - width - context.klp.space.tight;
    final top = parentPosition.dy
        .clamp(
          context.klp.space.compact,
          viewport.height - height - context.klp.space.compact,
        )
        .toDouble();

    return Offset(
      left.clamp(context.klp.space.compact, viewport.width - width).toDouble(),
      top,
    );
  }
}

/// 彈出式選單面板：標題列加上一組 [KlpMenuItemData]。
///
/// 只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用
/// [KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端（通常是
/// `showMenu` 或自訂 overlay）控制。
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
        borderRadius: BorderRadius.circular(
          _KlpMenuMetrics.panelRadius(context),
        ),
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
                    padding: EdgeInsets.symmetric(
                      vertical: context.klp.space.tight,
                    ),
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

/// [KlpMenu] 裡單一項目的渲染，自行追蹤 hover／focus 以決定外框與前景色。
///
/// 選取狀態（[KlpMenuItemData.selected]）與 hover／focus 共用同一套「active」
/// 視覺，但前景色只有選取或停用時才會變——hover 不改文字色，只加外框，
/// 與本產品其他控制項的 hover 表達語言一致。一般透過 [KlpMenu] 間接使用，
/// 只有要在選單容器之外單獨畫一個選單項目時才需要直接用它。
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
    // hover 不改前景色——選取才提亮，hover 只加外框。
    final foreground = !data.enabled
        ? tokens.textFaint
        : data.danger
        ? tokens.danger
        : data.selected
        ? tokens.text
        : tokens.textMuted;

    Widget item = SizedBox(
      height: _KlpMenuMetrics.itemHeight,
      child: Material(
        color: data.selected
            ? tokens.selectionBackground
            : KlpPalette.transparent,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: InkWell(
          onTap: data.enabled ? data.onPressed : null,
          onHover: data.enabled
              ? (value) => setState(() => _hovered = value)
              : null,
          onFocusChange: (value) => setState(() => _focused = value),
          overlayColor: const WidgetStatePropertyAll(KlpPalette.transparent),
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _KlpMenuMetrics.horizontalPadding(context),
            ),
            child: Row(
              children: [
                if (data.icon != null) ...[
                  Transform.translate(
                    offset: const Offset(0, _KlpMenuMetrics.iconOpticalOffsetY),
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
    );

    if (active) {
      item = KlpDashedBorder(
        color: data.selected ? tokens.textMuted : context.klp.hoverBorder,
        radius: context.klp.shape.control,
        child: item,
      );
    }

    return Semantics(
      button: true,
      enabled: data.enabled,
      toggled: data.toggleValue,
      child: item,
    );
  }
}
