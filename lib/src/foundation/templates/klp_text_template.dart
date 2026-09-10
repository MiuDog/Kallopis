part of 'klp_template.dart';

/// 文字內容由純資料選取器提供；風格只在定義期指定語意參照。
final class KlpTextTemplate<T extends KlpNode> extends KlpTemplate<T> {

	final String Function(T) _text;
	final KlpTextSemantics semantics;

	const KlpTextTemplate({required String Function(T) text, required KlpTextSemantics semantics}) : this._(text, semantics);

	const KlpTextTemplate._(this._text, this.semantics);

	/// 經方法派送保留 T 的參數檢查，不將窄型別函式上轉成廣型別函式。
	String selectText(T node) => _text(node);
}
