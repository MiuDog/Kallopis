import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../controls/klp_toggle.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../interaction/klp_roving_index.dart';
import '../surface/klp_divider.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_geometry_theme.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// [KlpMenu] 系列元件共用的文字角色，目前只有一項。獨立成類別是為了讓未來
/// 若要新增更多共用樣式常數時有現成的落點，不必再改動呼叫端。
abstract final class KlpMenuStyle {
  static const KlpTextRole textRole = KlpTextRole.label;
}

abstract final class _KlpMenuMetrics {
  static double width(BuildContext context) =>
      context.klp.geometry.layout.menuWidth;
  static double headerHeight(BuildContext context) =>
      context.klp.geometry.layout.menuHeaderHeight;
  static double horizontalPadding(BuildContext context) =>
      context.klp.menuPadding;
  static double itemHeight(BuildContext context) => context.klp.menuItemHeight;
  static double iconSize(BuildContext context) => context.klp.space.iconSmall;
  static double iconGap(BuildContext context) => context.klp.space.compact;
  static double iconOpticalOffsetY(BuildContext context) =>
      context.klp.geometry.optical.menuIconOffsetY;
  // 這三項來自 theme，因此不能是編譯期常數。
  static double panelRadius(BuildContext context) => context.klp.menuRadius;
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
  @Deprecated('Use widthOf(context) so JSON geometry is applied.')
  static double get width => KlpGeometryTheme.standard.layout.menuWidth;

  static double widthOf(BuildContext context) => _KlpMenuMetrics.width(context);

  static double estimatedHeight({
    required BuildContext context,
    required int itemCount,
    int separatorCount = 0,
  }) {
    return context.klp.space.tight * 2 +
        _KlpMenuMetrics.headerHeight(context) +
        context.klp.space.tight +
        itemCount * _KlpMenuMetrics.itemHeight(context) +
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
          viewport.width -
              _KlpMenuMetrics.width(context) -
              context.klp.space.compact,
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
///
/// **鍵盤**：`↓`／`↑` 在項目間移動高亮（跳過 [KlpMenuItemData.enabled] 為
/// `false` 的項目，並在頭尾之間循環），`Home`／`End` 跳到首／尾一個可用項目，
/// `Enter`／`Space` 觸發目前高亮的項目，`Escape` 呼叫 [onEscape]（通常用來關閉
/// 選單，由呼叫端決定要不要提供）。索引移動的規則沿用 [KlpRovingIndex]，與
/// [KlpCombobox] 共用同一套實作，不是第二份重寫。
///
/// 高亮的視覺沿用既有的 hover／focus 語言（[KlpMenuItem] 的 `active` 底色），
/// 不是新增的第三種視覺；只有 [KlpMenuItemData.selected]（真正的選取狀態）才會
/// 用高對比的選取底色。
///
/// 選單預設會在第一次 build 時自動取得鍵盤焦點（[autofocus]），因為選單通常是
/// 剛彈出的 overlay，此時畫面上不會有其他東西持有焦點；若呼叫端要自行控制焦點
/// 時機（例如選單嵌在一般版面裡而非彈出層），可以把 [autofocus] 設為 `false`。
class KlpMenu extends StatefulWidget {
  const KlpMenu({
    super.key,
    required this.label,
    required this.items,
    this.autofocus = true,
    this.onEscape,
  });

  final String label;
  final List<KlpMenuItemData> items;

  /// 是否在選單出現時自動取得鍵盤焦點，才能立刻用方向鍵操作。預設 `true`。
  final bool autofocus;

  /// 按下 `Escape` 時呼叫。庫不擅自決定「按 Escape 要做什麼」——通常是呼叫端
  /// 用來關閉選單，未提供時 `Escape` 不會有任何效果。
  final VoidCallback? onEscape;

  @override
  State<KlpMenu> createState() => _KlpMenuState();
}

class _KlpMenuState extends State<KlpMenu> {
  int _highlightedIndex = -1;

  bool _isEnabled(int index) => widget.items[index].enabled;

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final count = widget.items.length;
    if (count == 0) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: count,
          forward: true,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.move(
          current: _highlightedIndex,
          count: count,
          forward: false,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.home) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.first(
          count: count,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.end) {
      setState(
        () => _highlightedIndex = KlpRovingIndex.last(
          count: count,
          isEnabled: _isEnabled,
        ),
      );
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.space) {
      if (_highlightedIndex >= 0 && _highlightedIndex < count) {
        final item = widget.items[_highlightedIndex];
        if (item.enabled) item.onPressed();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      widget.onEscape?.call();
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final items = widget.items;

    return Focus(
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: DecoratedBox(
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
          width: _KlpMenuMetrics.width(context),
          child: KlpSurface(
            tone: KlpSurfaceTone.overlay,
            radius: _KlpMenuMetrics.panelRadius(context),
            padding: EdgeInsets.all(context.klp.space.tight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: _KlpMenuMetrics.headerHeight(context),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: _KlpMenuMetrics.horizontalPadding(context),
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: KlpText(
                        widget.label,
                        role: KlpMenuStyle.textRole,
                        tone: KlpTextTone.muted,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: context.klp.space.tight),
                for (var index = 0; index < items.length; index++) ...[
                  if (items[index].separatedBefore)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: context.klp.space.tight,
                      ),
                      child: KlpDivider(),
                    ),
                  KlpMenuItem(
                    key: items[index].key,
                    data: items[index],
                    keyboardHighlighted: index == _highlightedIndex,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// [KlpMenu] 裡單一項目的渲染，自行追蹤 hover／focus 以決定背景與前景色。
///
/// 選取狀態（[KlpMenuItemData.selected]）與 hover／focus 共用同一套「active」
/// 視覺，但前景色只有選取或停用時才會變——hover 只加背景高亮，
/// 與一般控制項的互動語言一致。一般透過 [KlpMenu] 間接使用，
/// 只有要在選單容器之外單獨畫一個選單項目時才需要直接用它。
class KlpMenuItem extends StatefulWidget {
  const KlpMenuItem({
    super.key,
    required this.data,
    this.keyboardHighlighted = false,
  });

  final KlpMenuItemData data;

  /// 由容器（例如 [KlpMenu]）以鍵盤方向鍵移動出的高亮狀態。視覺上等同
  /// hover／focus，不影響前景色——與 [KlpMenuItemData.selected] 是兩件事：
  /// 後者是「真的被選取」，會提亮前景色與底色。
  final bool keyboardHighlighted;

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
    final active =
        data.selected || _hovered || _focused || widget.keyboardHighlighted;
    final background = data.selected
        ? tokens.selectionBackground
        : active
        ? context.klp.selectionWash
        : tokens.clear;
    final foreground = !data.enabled
        ? tokens.textFaint
        : data.danger
        ? tokens.danger
        : data.selected
        ? tokens.text
        : tokens.textMuted;

    final item = SizedBox(
      height: _KlpMenuMetrics.itemHeight(context),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: InkWell(
          onTap: data.enabled ? data.onPressed : null,
          onHover: data.enabled
              ? (value) => setState(() => _hovered = value)
              : null,
          onFocusChange: (value) => setState(() => _focused = value),
          overlayColor: WidgetStatePropertyAll(tokens.clear),
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: _KlpMenuMetrics.horizontalPadding(context),
            ),
            child: Row(
              children: [
                if (data.icon != null) ...[
                  Transform.translate(
                    offset: Offset(
                      0,
                      _KlpMenuMetrics.iconOpticalOffsetY(context),
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
    );

    return Semantics(
      button: true,
      enabled: data.enabled,
      selected: data.selected,
      toggled: data.toggleValue,
      child: item,
    );
  }
}
