import '../../../kernel/diagnostics/klp_contract_error.dart';
import '../../primitives/klp_style_value.dart';
import '../../semantics/klp_semantic_key.dart';

/// 本庫持有的單次求值快照，不向消費端暴露可寫入風格表。
final class KlpSemanticResolution {
  final Map<(String, String), KlpStyleValue> _values;

  KlpSemanticResolution(Map<(String, String), KlpStyleValue> values)
    : _values = Map.unmodifiable(values);

  T read<T extends KlpStyleValue>(KlpSemanticKey<T> key) {
    final value = _values[key.identity];
    if (value == null) throw KlpContractError('unknown_semantic', key.path);
    if (!key.kind.accepts(value)) {
      throw KlpContractError('semantic_kind_mismatch', key.path);
    }

    return value as T;
  }
}
