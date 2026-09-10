import '../primitives/klp_style_kind.dart';
import '../primitives/klp_style_value.dart';
import 'internal/klp_semantic_identifier.dart';

/// 用途名稱與量值種類分離；相同名稱不能藉不同型別重複註冊。
final class KlpSemanticKey<T extends KlpStyleValue> {
  final String owner;
  final String name;
  final KlpStyleKind<T> kind;

  KlpSemanticKey(this.owner, this.name, this.kind) {
    requireSemanticIdentifier(owner, 'semantic.owner');
    requireSemanticIdentifier(name, '$owner/name');
  }

  (String, String) get identity => (owner, name);
  String get path => '$owner/$name';
}
