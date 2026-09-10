import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../foundation/templates/klp_axis.dart';
import 'klp_flutter_renderer.dart';

/// 以方向起點承接父層配置，再限制子內容的指定方向尺寸。
final class KlpFlutterExtent extends StatelessWidget {
  final KlpBoundExtent content;

  const KlpFlutterExtent({required this.content, super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(builder: _layout);

  Widget _layout(BuildContext context, BoxConstraints constraints) {
    final horizontal = content.axis == KlpAxis.horizontal;
    final maximum = horizontal ? constraints.maxWidth : constraints.maxHeight;
    final extent = math.min(content.extent.value, maximum);
    final crossMaximum = horizontal
        ? constraints.maxHeight
        : constraints.maxWidth;
    final crossExtent = crossMaximum.isFinite ? crossMaximum : null;
    final child = SizedBox(
      width: horizontal ? extent : crossExtent,
      height: horizontal ? crossExtent : extent,
      child: KlpFlutterRenderer(content: content.child),
    );

    // Align 吸收外層 tight 限制，避免原語的語意尺寸被視窗寬度強迫覆蓋。
    return Align(alignment: AlignmentDirectional.topStart, child: child);
  }
}
