part of '../klp_metrics.dart';

/// 舊版 static const 動畫時長；新元件必須改讀 context.klp.motion。
abstract final class KlpMotion {
	static const Duration themeTransition = Duration.zero;
	static const Duration styleTransition = Duration.zero;
}
