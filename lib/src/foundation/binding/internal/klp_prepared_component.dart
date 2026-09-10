import '../../../kernel/diagnostics/klp_contract_error.dart';
import 'klp_bound_component.dart';
import 'klp_bound_template.dart';
import 'klp_prepared_template.dart';

/// 子放置數量在準備期固定，公開 renderer 永遠只收到完成的呈現樹。
final class KlpPreparedComponent {
  final String id;
  final String definitionId;
  final int childCount;
  final KlpPreparedTemplate content;
  final String? accessibilityLabel;

  const KlpPreparedComponent({
    required this.id,
    required this.definitionId,
    required this.childCount,
    required this.content,
    this.accessibilityLabel,
  });

  KlpBoundComponent materialize(List<KlpBoundTemplate> children) {
    if (children.length != childCount) {
      throw KlpContractError('component_child_count_mismatch', id);
    }

    return KlpBoundComponent(
      id,
      definitionId,
      content.materialize(children),
      accessibilityLabel,
    );
  }
}
