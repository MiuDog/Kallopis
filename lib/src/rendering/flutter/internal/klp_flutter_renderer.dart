import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_template.dart';
import 'klp_flutter_choice.dart';
import 'klp_flutter_extent.dart';
import 'klp_flutter_linear.dart';
import 'klp_flutter_regions.dart';
import 'klp_flutter_retained_stack.dart';
import 'klp_flutter_values.dart';

/// 唯一封閉的 Flutter 呈現分派；不接受消費端 Widget 或 builder。
final class KlpFlutterRenderer extends StatelessWidget {
  final KlpBoundTemplate content;

  KlpFlutterRenderer({required this.content, Key? key})
    : super(key: key ?? _placementKey(content));

  static Key? _placementKey(KlpBoundTemplate content) => switch (content) {
    KlpBoundPlacement(:final id) => ValueKey(id),
    KlpBoundChoice(:final id) => ValueKey(id),
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    // 只消費已解析快照，不在畫面建構階段執行外部資料投影。
    return switch (content) {
      KlpBoundPlacement value => KlpFlutterRenderer(content: value.content),
      KlpBoundText value => Text(
        value.text,
        style: klpFlutterTextStyle(value.style),
      ),
      KlpBoundLinear value => KlpFlutterLinear(content: value),
      KlpBoundSurface value => _surface(value),
      KlpBoundChoice value => KlpFlutterChoice(content: value),
      KlpBoundRegions value => KlpFlutterRegions(content: value),
      KlpBoundExtent value => KlpFlutterExtent(content: value),
      KlpBoundRetainedStack value => KlpFlutterRetainedStack(content: value),
      KlpBoundScreen value => Semantics(
        namesRoute: true,
        label: value.accessibilityLabel,
        child: KlpFlutterRenderer(content: value.child),
      ),
      KlpBoundAccessibility value => Semantics(
        container: true,
        label: value.label,
        child: KlpFlutterRenderer(content: value.child),
      ),
    };
  }

  Widget _surface(KlpBoundSurface value) {
    final radius = BorderRadius.circular(value.radius.value);
    final decoration = BoxDecoration(
      color: klpFlutterColor(value.background),
      borderRadius: radius,
    );
    final child = Padding(
      padding: EdgeInsets.all(value.inset.value),
      child: KlpFlutterRenderer(content: value.child),
    );
    return ClipRRect(
      borderRadius: radius,
      child: DecoratedBox(decoration: decoration, child: child),
    );
  }
}
