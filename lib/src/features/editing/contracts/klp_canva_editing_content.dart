import 'package:krepis_canva/krepis_canva.dart';
import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/composition/slots/klp_children.dart';
import 'package:kallopis/src/composition/slots/klp_screen_body.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 受限 Canva 節點；consumer 只能提供 Krepis session。
final class KlpCanvaEditingContent implements KlpScreenBody, KlpCompositeNode {
  static const typeId = 'kallopis.canvaEditing';

  @override
  final KlpId id;
  final KrepisCanvaSessionController controller;
  @override
  final KlpChildren children = KlpChildren(const []);

  KlpCanvaEditingContent({required this.id, required this.controller}) {
    if (controller.bridge is! KrepisCanvaBridgeChannel) {
      throw ArgumentError('Canva content requires a hosted session controller');
    }
  }

  @override
  String get definitionId => typeId;
}
