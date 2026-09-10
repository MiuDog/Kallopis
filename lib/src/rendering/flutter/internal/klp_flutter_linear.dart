import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_template.dart';
import 'klp_flutter_renderer.dart';
import 'klp_flutter_values.dart';

/// 線性內容沿主要方向保留自然尺寸，受限時由本庫提供捲動。
final class KlpFlutterLinear extends StatelessWidget {
  final KlpBoundLinear content;

  const KlpFlutterLinear({required this.content, super.key});

  @override
  Widget build(BuildContext context) {
    final axis = klpFlutterAxis(content.axis);
    final children = <Widget>[];
    for (final child in content.children) {
      if (children.isNotEmpty) {
        children.add(
          SizedBox(
            width: axis == Axis.horizontal ? content.gap.value : null,
            height: axis == Axis.vertical ? content.gap.value : null,
          ),
        );
      }
      children.add(KlpFlutterRenderer(content: child));
    }

    // 捲動器在無界方向自然收縮；字級放大也不以裁字掩蓋內容。
    final flow = Flex(
      direction: axis,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
    return SingleChildScrollView(
      scrollDirection: axis,
      primary: false,
      child: flow,
    );
  }
}
