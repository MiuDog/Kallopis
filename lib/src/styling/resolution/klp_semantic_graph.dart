import 'package:kallopis/src/styling/semantics/klp_semantic_schema.dart';
import 'klp_semantic_resolver.dart';

/// 僅驗證本庫語意相依圖；沿用解析器的所有權、型別與循環規則。
void validateKlpSemanticGraph(Iterable<KlpSemanticSchema> schemas) {
	KlpSemanticResolver(schemas);
}
