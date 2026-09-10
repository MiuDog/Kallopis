part of 'klp_advanced_models.dart';

/// 資料表欄位相對於其他欄位所占的比例。
enum KlpDataColumnSpan {
	single(1),
	double(2),
	triple(3);

	const KlpDataColumnSpan(this.flex);

	final int flex;
}
