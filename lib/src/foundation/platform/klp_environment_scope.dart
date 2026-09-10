import 'package:flutter/widgets.dart';

import 'klp_platform_info.dart';

/// 注入執行平台；視窗尺寸、語系與互動狀態仍由各自的來源提供。
class KlpEnvironmentScope extends InheritedWidget {
  const KlpEnvironmentScope({
    super.key,
    required this.platform,
    required super.child,
  });

  final KlpPlatformInfo platform;

  /// 訂閱最近的平台環境，缺少祖先時明確拋錯。
  static KlpPlatformInfo of(BuildContext context) {
    final platform = maybeOf(context);
    if (platform == null) {
      throw StateError('這個 context 之上沒有 KlpEnvironmentScope。');
    }
    return platform;
  }

  /// 訂閱最近的平台環境；未注入時回傳 null。
  static KlpPlatformInfo? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<KlpEnvironmentScope>()
      ?.platform;

  @override
  bool updateShouldNotify(KlpEnvironmentScope oldWidget) =>
      platform.platform != oldWidget.platform.platform;
}
