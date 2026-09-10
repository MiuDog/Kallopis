import 'package:flutter/widgets.dart';

/// 垂直排列排版原語。取代 Column，支援自動間距設定。
class KlpColumn extends StatelessWidget {
  const KlpColumn({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.gap,
    this.children = const <Widget>[],
  });

  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final double? gap;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    List<Widget> effectiveChildren = children;
    if (gap != null && gap! > 0 && children.length > 1) {
      effectiveChildren = [];
      for (var i = 0; i < children.length; i++) {
        effectiveChildren.add(children[i]);
        if (i < children.length - 1) {
          effectiveChildren.add(SizedBox(height: gap));
        }
      }
    }

    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: effectiveChildren,
    );
  }
}
