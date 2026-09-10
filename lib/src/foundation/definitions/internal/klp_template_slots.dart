import '../../../composition/nodes/klp_node.dart';
import '../../../composition/slots/klp_slot.dart';
import '../../templates/klp_template.dart';

/// 由模板順序取得契約，避免作者另外維護一份插槽清單。
Iterable<KlpSlot<KlpNode>> klpTemplateSlots(
  KlpTemplate<KlpNode> template,
) sync* {
  switch (template) {
    case KlpTextTemplate():
      break;
    case KlpChildrenTemplate(:final slot):
      yield slot;
    case KlpLinearTemplate(:final children):
      for (final child in children) {
        yield* klpTemplateSlots(child);
      }
    case KlpSurfaceTemplate(:final child):
      yield* klpTemplateSlots(child);
  }
}
