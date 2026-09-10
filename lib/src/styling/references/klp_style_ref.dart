import '../primitives/klp_primitive_index.dart';
import '../primitives/klp_style_kind.dart';
import '../primitives/klp_style_value.dart';
import '../semantics/klp_semantic_key.dart';

part 'klp_primitive_ref.dart';
part 'klp_semantic_ref.dart';

/// 封閉的風格參照語言；消費端不能加入常值或任意求值函式。
sealed class KlpStyleRef<T extends KlpStyleValue> {

	const KlpStyleRef();

	KlpStyleKind<T> get kind;
}
