import 'package:kallopis/src/composition/validation/klp_validated_node.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/kernel/lifecycle/klp_frame_lease.dart';
import 'package:kallopis/src/runtime/contracts/klp_prepared_node.dart';
import 'package:kallopis/src/runtime/installation/klp_default_placement.dart';
import 'package:kallopis/src/runtime/contracts/klp_placement_resource.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// 準備階段已取得風格值，提交後只組合本庫封閉輸出。
final class KlpPreparedScreen implements KlpPreparedNode {
  final KlpColor background;
  final KlpRadius radius;
  final KlpDistance inset;
  final String accessibilityLabel;

  const KlpPreparedScreen(
    this.background,
    this.radius,
    this.inset,
    this.accessibilityLabel,
  );

  @override
  KlpPlacementResource createResource(KlpValidatedNode node) =>
      KlpDefaultPlacement(node);

  @override
  KlpBoundTemplate materialize(
    KlpPlacementResource resource,
    List<KlpBoundTemplate> children,
    KlpFrameLease lease,
  ) {
    return KlpBoundScreen(
      accessibilityLabel: accessibilityLabel,
      child: KlpBoundSurface(
        background: background,
        radius: radius,
        inset: inset,
        child: children.single,
      ),
    );
  }
}
