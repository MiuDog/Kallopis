part of 'klp_style_ref.dart';

/// 引用另一個同型用途；解析時仍核對真正註冊的目標型別與權限。
final class KlpSemanticRef<T extends KlpStyleValue> extends KlpStyleRef<T> {

	final KlpSemanticKey<T> key;

	const KlpSemanticRef(this.key);

	@override
	KlpStyleKind<T> get kind => key.kind;
}
