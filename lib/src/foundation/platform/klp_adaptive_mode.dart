import 'klp_device_class.dart';
import 'klp_orientation.dart';

/// 自適應渲染模式定義。
abstract final class KlpAdaptiveMode {
	static const String tabletLandscape = 'tablet_landscape';
	static const String tabletPortrait = 'tablet_portrait';
	static const String desktop = 'desktop';
	static const String phone = 'phone';
	static const String fallback = 'fallback';

	static String resolveDefault({
		required KlpDeviceClass deviceClass,
		required KlpOrientation orientation,
	}) {
		return switch (deviceClass) {
			KlpDeviceClass.tablet => orientation == KlpOrientation.landscape
				? tabletLandscape
				: tabletPortrait,
			KlpDeviceClass.phone => phone,
			KlpDeviceClass.desktop => desktop,
		};
	}
}
