import 'package:flutter/widgets.dart';

import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';

/// 元件的狀態強度。
///
/// 這個庫只承認兩種互動狀態的視覺強度，元件不得自行發明第三種——同一個狀態在不同
/// 元件長得不一樣，是這個庫先前最明顯的不一致來源。
enum KlpHighlightState {
  /// 沒有狀態，不畫任何東西。
  none,

  /// 指標懸停。暫時的，用虛線表達。
  hover,

  /// 鍵盤聚焦。實線焦點環——準則 §7 要求它必須存在且不得移除，
  /// 因為鍵盤使用者沒有別的方式知道自己在哪。
  ///
  /// 這是準則第 5 條允許 accent 出現的少數場合之一。
  focus,

  /// 受控的選取狀態。跟隨 interaction 色，強度較高。
  selected,
}

/// 元件的狀態呈現。**兩種狀態、兩種手法，刻意不同。**
///
/// 實作準則 §2.1：
///
/// - **hover → `1px dashed`**。hover 是**暫時的**，指標移開就沒了，它不是狀態。
/// - **selected → 填色**（[KlpTheme.selectedSurface]）。那是會停留的狀態。
///
/// 兩者若都用填色，使用者分不出「指標剛好經過」與「我選了這個」；若都用虛線，
/// 選取框又會和 placeholder、拖放目標、停用態的既有讀法撞在一起。
///
/// 選取的第二個訊號由呼叫端提供：文字由 secondary 升到 primary（準則第 4 條要求
/// 每個狀態都要有非顏色的訊號）。本元件只負責底色與邊框。
///
/// 填色畫在內容底下（[DecoratedBox] 的 child），而不是疊在上面——不透明的色層
/// 疊在內容之上會蓋掉文字。也不改動內容自己的底色：那會逼每個元件知道「我原本的
/// 底色是什麼、混上去之後該是什麼」，而那正是元件不該知道的事。
class KlpStateHighlight extends StatelessWidget {
  const KlpStateHighlight({
    super.key,
    required this.state,
    required this.child,
    this.borderRadius,
  });

  final KlpHighlightState state;

  /// `null` 表示沿用 theme 的控制項圓角。
  final BorderRadius? borderRadius;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (state == KlpHighlightState.none) return child;

    final klp = context.klp;
    final radius = borderRadius ?? BorderRadius.circular(klp.shape.control);

    if (state == KlpHighlightState.focus) {
      return Stack(
        fit: StackFit.passthrough,
        children: [
          child,
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                key: const ValueKey('klp-state-focus-ring'),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: klp.color.interaction,
                    width: klp.shape.stroke,
                  ),
                  borderRadius: radius,
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (state == KlpHighlightState.hover) {
      return KlpDashedBorder(
        key: const ValueKey('klp-state-hover-border'),
        color: klp.hoverBorder,
        radius: radius.topLeft.x,
        child: child,
      );
    }

    // 填色畫在內容**底下**，不是疊在上面。
    //
    // 先前用 Stack 把它疊在內容之上，因為那時的選取色是半透明的、文字透得出來。
    // 改成不透明的表面色之後，同一段程式碼會整片蓋掉文字——選取的項目變成一塊
    // 空白的色塊。半透明能容忍的錯誤，不透明會直接暴露。
    return DecoratedBox(
      key: const ValueKey('klp-state-highlight'),
      decoration: BoxDecoration(
        color: klp.selectedSurface,
        borderRadius: radius,
      ),
      child: child,
    );
  }
}
