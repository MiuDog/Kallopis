import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../kernel/lifecycle/internal/klp_frame_lease.dart';
import '../../../kernel/identity/klp_placement_id.dart';

/// 只保存封閉呈現資料與操作期限，不保留消費端結構樹或 selector。
final class KlpRuntimeFrame {
  final KlpPlacementId rootId;
  final KlpBoundTemplate content;
  final KlpFrameLease lease;

  const KlpRuntimeFrame(this.rootId, this.content, this.lease);
}
