import 'dart:math' as math;
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';

/// 已確認的緊湊控制比例；以解析後的尺度推導，不增加 primitive 欄位。
final class KlpControlDensity {
	final KlpDistance extent;
	KlpControlDensity(this.extent) {
		if (!extent.value.isFinite || extent.value <= 0) throw ArgumentError('Control extent must be finite and positive.');
	}
	double get height => extent.value;
	double get icon => height / 2;
	double get padding => height / 4;
	double get gap => height * 3 / 16;
	double get row => height * 9 / 8;
	double get lineHeight => height * 9 / 16;
	// 完整原料替換縮小時，仍保留已確認的最小命中範圍。
	double get touchTarget => math.max(48, height * 3 / 2);
	double get focusStroke => height / 32;
	// 舊 Catalog 視窗控制為 24，與一般控制 32 分離並隨完整尺度變化。
	double get windowControl => height * 3 / 4;
}
