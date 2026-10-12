import 'package:flutter/widgets.dart';

/// 水平排列排版原語。取代 Row，支援自動間距設定。
class KlpRow extends StatelessWidget {
  const KlpRow({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.textBaseline,
    this.gap,
    this.children = const <Widget>[],
  });

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final TextBaseline? textBaseline;
  final double? gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> effectiveChildren = children;
    if (gap != null && gap! > 0 && children.length > 1) {
      effectiveChildren = [];
      for (var index = 0; index < children.length; index++) {
        effectiveChildren.add(children[index]);
        if (index < children.length - 1) {
          effectiveChildren.add(SizedBox(width: gap));
        }
      }
    }

    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      textBaseline: textBaseline,
      children: effectiveChildren,
    );
  }
}
