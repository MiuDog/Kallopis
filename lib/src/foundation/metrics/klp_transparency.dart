part of '../klp_metrics.dart';

/// 舊版 static const 面板透明度；新元件必須改讀 context.klp.surface。
abstract final class KlpTransparency {
	static const double lightPaneOpacity = 0.88;
	static const double darkPaneOpacity = 0.72;
}
