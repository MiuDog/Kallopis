import 'klp_device_class.dart';
import 'klp_orientation.dart';

/// 自適應渲染模式定義。
abstract final class KlpAdaptiveMode {

	/// 平板橫向模式（例如 iPad 橫向雙欄/三欄生產力工作區）。
	static const String tabletLandscape = 'tablet_landscape';

	/// 平板直向模式（例如 iPad 直向單欄畫布 + 抽屜導覽）。
	static const String tabletPortrait = 'tablet_portrait';

	/// 桌面工作站模式（寬螢幕常駐側欄與面板）。
	static const String desktop = 'desktop';

	/// 手機模式（單欄流動佈局與底部控制項）。
	static const String phone = 'phone';

	/// 通用保底模式識別。
	static const String fallback = 'fallback';

	/// 依據裝置形態與螢幕朝向解析出預設模式識別。
	static String resolveDefault({required KlpDeviceClass deviceClass, required KlpOrientation orientation}) {
		return switch (deviceClass) {
			KlpDeviceClass.tablet => orientation == KlpOrientation.landscape ? tabletLandscape : tabletPortrait,
			KlpDeviceClass.phone => phone,
			KlpDeviceClass.desktop => desktop,
		};
	}
}
