import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_screen_body.dart';
import 'package:kallopis/src/composition/slots/klp_slot.dart';
import 'klp_composite_node.dart';
import 'klp_platform_strategy.dart';

/// 宣告式平台分流節點；由 Kallopis 選定平台後才建立命中策略子樹。
final class KlpAdaptive implements KlpCompositeNode, KlpScreenBody {
  static const String typeId = 'kallopis.adaptive';

  /// 保底通用內容插槽（必填 1 個）。
  static final fallbackSlot = KlpSlot<KlpCompositeNode>(
    owner: typeId,
    name: 'fallback',
    min: 1,
    max: 1,
  );

  @override
  final KlpId id;

  /// 沒有命中平台策略時使用的通用內容。
  final KlpCompositeNode fallback;

  /// 依平台延後建立的策略；未命中的策略絕不會被呼叫。
  final Map<KlpAdaptivePlatform, KlpPlatformStrategy> strategies;

  @override
  final KlpChildren children;

  @override
  String get definitionId => typeId;

  KlpAdaptive({
    required this.id,
    required this.fallback,
    Map<KlpAdaptivePlatform, KlpPlatformStrategy> strategies = const {},
  }) : strategies = Map.unmodifiable(strategies),
        children = KlpChildren([
          fallbackSlot.assign([fallback]),
        ]);

  KlpChildren childrenFor(KlpAdaptiveContext? context) {
    final strategy = context == null ? null : strategies[context.platform];
    if (strategy == null) return children;
    return KlpChildren([fallbackSlot.assign([strategy.build(context!)])]);
  }
}
