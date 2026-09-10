part of '../structure/klp_application.dart';

/// 本庫從執行環境取得的不可覆寫偏好快照。
///
/// 消費端不建立或注入此值；應用宿主是唯一來源。功能可依此新增
/// 受控的語意策略，不能改以平台分支或任意 Flutter 設定取代它。
final class KlpApplicationEnvironment {

	const KlpApplicationEnvironment._({
		required this.platform,
		required this.accessibility,
		required this.motion,
	});

	final KlpApplicationPlatform platform;
	final KlpAccessibilityPreferences accessibility;
	final KlpMotionPolicy motion;
}

/// 應用可依賴的平台分類；不洩漏 Flutter 平台型別。
enum KlpApplicationPlatform { android, ios, windows, macos, linux, web, other }

/// 系統輔助功能偏好。基本語意與鍵盤支援不受此值關閉。
final class KlpAccessibilityPreferences {

	const KlpAccessibilityPreferences._({
		required this.accessibleNavigation,
		required this.boldText,
		required this.highContrast,
	});

	final bool accessibleNavigation;
	final bool boldText;
	final bool highContrast;
}

/// 動態強度只由系統偏好決定，元件不得各自改寫。
enum KlpMotionPolicy { standard, reduced, immediate }
