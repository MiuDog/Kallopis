import 'package:flutter/widgets.dart';

import '../theme/klp_theme.dart';

/// 元件的狀態強度。
///
/// 這個庫只承認兩種互動狀態的視覺強度，元件不得自行發明第三種——同一個狀態在不同
/// 元件長得不一樣，是這個庫先前最明顯的不一致來源。
enum KlpHighlightState {
  /// 沒有狀態，不畫任何東西。
  none,

  /// 指標懸停或鍵盤聚焦。中性的低強度高亮。
  hover,

  /// 受控的選取狀態。跟隨 interaction 色，強度較高。
  selected,
}

/// 疊在內容上的狀態高亮。
///
/// **hover 與 selected 一律以高亮色表達，不畫邊框。** 先前這兩個狀態在庫裡有兩套
/// 語彙——`KlpPressable` 用高亮、表單與 explorer 用虛線框——同一件事兩種畫法，
/// 消費者無從預期。
///
/// 高亮以 [Stack] 疊在內容之上而不是換掉內容的底色：後者會逼每個元件自己知道
/// 「我原本的底色是什麼、混上去之後該是什麼」，而那正是元件不該知道的事。
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

    return Stack(
      fit: StackFit.passthrough,
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            child: DecoratedBox(
              key: const ValueKey('klp-state-highlight'),
              decoration: BoxDecoration(
                color: state == KlpHighlightState.selected
                    ? klp.selectedWash
                    : klp.selectionWash,
                borderRadius: radius,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
