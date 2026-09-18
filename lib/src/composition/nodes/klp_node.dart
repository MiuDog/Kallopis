import 'package:kallopis/src/kernel/identity/klp_id.dart';

/// 受控結構節點；只描述資料及子項，不取得渲染上下文。
abstract interface class KlpNode {
  KlpId get id;
  String get definitionId;
  Iterable<KlpNode> get children;
}
