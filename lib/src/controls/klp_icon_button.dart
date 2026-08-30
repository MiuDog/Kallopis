import 'package:flutter/material.dart';

import '../foundation/klp_icon.dart';
import '../overlay/klp_tooltip.dart';
import '../theme/klp_theme.dart';

/// 圖示按鈕在版面中的**角色**，不是外觀參數。
///
/// 消費端只宣告這顆按鈕是「獨立控制項」還是「嵌在既有表面上」，
/// 由 Kallopis 決定兩者各自長什麼樣。
enum KlpIconButtonTone {
  /// 獨立控制項：靜置時就有底色，讓它在空白區域中可辨識。
  standalone,

  /// 嵌在既有表面上：靜置時**透明**，只在 hover／focus／selected 時浮出底色。
  ///
  /// 用於視窗標題列、工具列這類本身已有背景的容器——在那裡給每顆按鈕
  /// 都畫一塊底色，會讓標題列看起來像一排色塊而不是一排動作。
  inline,
}

/// 圖示按鈕的語意尺寸。
enum KlpIconButtonSize {
  /// 一般控制項尺寸。
  standard,

  /// 視窗標題列尺寸，與 App icon 的正方形槽位一致。
  window,
}

/// 只有圖示的按鈕。`label` 為必填且用於無障礙標註——圖示本身沒有可讀文字，
/// 沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。
class KlpIconButton extends StatefulWidget {
  const KlpIconButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
    this.quarterTurns = 0,
    this.tone = KlpIconButtonTone.standalone,
    this.size = KlpIconButtonSize.standard,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;
  final int quarterTurns;
  final KlpIconButtonSize size;

  /// 見 [KlpIconButtonTone]。預設為 [KlpIconButtonTone.standalone]，
  /// 維持既有呼叫端的外觀不變。
  final KlpIconButtonTone tone;

  @override
  State<KlpIconButton> createState() => _KlpIconButtonState();
}

class _KlpIconButtonState extends State<KlpIconButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final dimension = switch (widget.size) {
      KlpIconButtonSize.standard => klp.space.iconButton,
      KlpIconButtonSize.window => klp.geometry.layout.windowHeaderControlSize,
    };
    final active = (_hovered || _focused) && widget.onPressed != null;

    // 靜置狀態由 tone 決定；hover／focus／selected 兩種 tone 一致，
    // 使互動回饋在整個系統裡是同一套語言。
    final resting = switch (widget.tone) {
      KlpIconButtonTone.standalone => tokens.component,
      KlpIconButtonTone.inline => klp.color.clear,
    };
    final background = widget.selected
        ? tokens.selectionBackground
        : active
        ? Color.alphaBlend(klp.selectionWash, tokens.component)
        : resting;
    final button = Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(klp.shape.control),
        child: SizedBox.square(
          dimension: dimension,
          child: Center(
            child: RotatedBox(
              quarterTurns: widget.quarterTurns,
              child: KlpIcon(
                widget.icon,
                size: widget.size == KlpIconButtonSize.window
                    ? klp.geometry.layout.windowAppIconSize
                    : null,
                color: widget.onPressed == null
                    ? tokens.textFaint
                    : tokens.text,
              ),
            ),
          ),
        ),
      ),
    );

    return KlpTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.label,
        child: button,
      ),
    );
  }
}
