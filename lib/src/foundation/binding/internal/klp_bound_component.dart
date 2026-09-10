import 'klp_bound_template.dart';

/// 元件放置的內容快照；識別與風格結果分離，換風格不改放置 id。
final class KlpBoundComponent {
  final String id;
  final String definitionId;
  final KlpBoundTemplate content;
  final String? accessibilityLabel;

  const KlpBoundComponent(
    this.id,
    this.definitionId,
    this.content, [
    this.accessibilityLabel,
  ]);
}
