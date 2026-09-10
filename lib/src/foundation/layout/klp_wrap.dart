import 'package:flutter/widgets.dart';

import 'klp_gap.dart';
import 'klp_space_size.dart';

/// 可換行排版原語。間距僅接受 Kallopis 語意尺寸。
class KlpWrap extends StatelessWidget {
  const KlpWrap({
    super.key,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacingSize,
    this.runAlignment = WrapAlignment.start,
    this.runSpacingSize,
    this.crossAxisAlignment = WrapCrossAlignment.start,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.clipBehavior = Clip.none,
    this.children = const <Widget>[],
  });

  final Axis direction;
  final WrapAlignment alignment;
  final KlpSpaceSize? spacingSize;
  final WrapAlignment runAlignment;
  final KlpSpaceSize? runSpacingSize;
  final WrapCrossAlignment crossAxisAlignment;
  final TextDirection? textDirection;
  final VerticalDirection verticalDirection;
  final Clip clipBehavior;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final spacing = spacingSize == null
        ? 0.0
        : KlpGap.resolveSpace(context, spacingSize!);
    final runSpacing = runSpacingSize == null
        ? 0.0
        : KlpGap.resolveSpace(context, runSpacingSize!);

    return Wrap(
      direction: direction,
      alignment: alignment,
      spacing: spacing,
      runAlignment: runAlignment,
      runSpacing: runSpacing,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      clipBehavior: clipBehavior,
      children: children,
    );
  }
}
