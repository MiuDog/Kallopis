part of 'klp_prepared_template.dart';

/// 葉內容已完成求值，安裝後不再讀取外部資料。
final class KlpPreparedValue extends KlpPreparedTemplate {

	final KlpBoundTemplate value;

	const KlpPreparedValue(this.value);

	@override
	KlpBoundTemplate materialize(List<KlpBoundTemplate> children) => value;
}
