import 'package:flutter/material.dart';

import '../../foundation/platform/klp_environment_scope.dart';
import '../../foundation/platform/klp_platform_info.dart';
import 'klp_app_controller.dart';

/// 將應用程式控制器、平台及主題狀態注入子樹。
class KlpAppScope extends InheritedWidget {
  const KlpAppScope({
    super.key,
    required this.controller,
    required this.platform,
    required this.brightness,
    required this.themeMode,
    required super.child,
  });

  final KlpAppController controller;
  final KlpPlatformInfo platform;
  final Brightness brightness;
  final ThemeMode themeMode;

  /// 優先訂閱平台環境，並保留舊版獨立 App scope 的相容讀取。
  static KlpPlatformInfo platformOf(BuildContext context) {
    final platform = KlpEnvironmentScope.maybeOf(context);
    if (platform != null) return platform;
    final scope = context.dependOnInheritedWidgetOfExactType<KlpAppScope>();
    if (scope == null) {
      throw StateError('這個 context 之上沒有 KlpAppScope。');
    }
    return scope.platform;
  }

  @override
  bool updateShouldNotify(KlpAppScope oldWidget) =>
      !identical(controller, oldWidget.controller) ||
      platform.platform != oldWidget.platform.platform ||
      brightness != oldWidget.brightness ||
      themeMode != oldWidget.themeMode;
}
