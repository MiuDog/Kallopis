import 'package:kallopis/src/composition/nodes/klp_composite_node.dart';
import 'package:kallopis/src/capabilities/environment/klp_device_class.dart';
import 'package:kallopis/src/capabilities/environment/klp_display_mode.dart';
import 'package:kallopis/src/capabilities/environment/klp_orientation.dart';

/// 不依賴 Flutter 的平台策略輸入；由 Kallopis host 唯一建立。
final class KlpAdaptiveContext {
  final KlpAdaptivePlatform platform;
  final KlpDeviceClass deviceClass;
  final KlpOrientation orientation;
  final KlpDisplayMode displayMode;

  const KlpAdaptiveContext({
    required this.platform,
    required this.deviceClass,
    required this.orientation,
    required this.displayMode,
  });
}

/// 宣告式策略只能回傳受控節點，不能取得 Widget 或 BuildContext。
abstract interface class KlpPlatformStrategy {
  KlpCompositeNode build(KlpAdaptiveContext context);
}

/// 公開策略鍵；與 desktop／tablet 等 viewport mode 分離。
enum KlpAdaptivePlatform { android, ios, windows, macos, linux, web, other }
