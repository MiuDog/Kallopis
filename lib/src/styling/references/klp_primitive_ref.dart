part of 'klp_style_ref.dart';

/// 定義期選擇固定原料欄位，不保存元件實例的外觀值。
final class KlpPrimitiveRef<T extends KlpStyleValue> extends KlpStyleRef<T> {

	@override
	final KlpStyleKind<T> kind;
	final KlpPrimitiveIndex index;

	const KlpPrimitiveRef(this.kind, this.index);
}
