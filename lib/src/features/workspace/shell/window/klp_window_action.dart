import 'package:flutter/services.dart';

/// 桌面平台視窗控制操作。
abstract final class KlpWindowAction {
  static const MethodChannel _channel = MethodChannel('kallopis/window');

  /// 最小化目前視窗。
  static Future<void> minimize() async {
    try {
      await _channel.invokeMethod('minimize');
    } catch (_) {}
  }

  /// 切換最大化或還原目前視窗。
  static Future<void> toggleMaximize() async {
    try {
      await _channel.invokeMethod('maximize');
    } catch (_) {}
  }

  /// 確保目前視窗最大化。
  static Future<void> maximize() async {
    if (await checkIsMaximized()) return;

    try {
      await _channel.invokeMethod('maximize');
    } catch (_) {}
  }

  /// 關閉目前視窗。
  static Future<void> close() async {
    try {
      await _channel.invokeMethod('close');
    } catch (_) {}
  }

  /// 開始拖曳目前視窗。
  static Future<void> drag() async {
    try {
      await _channel.invokeMethod('drag');
    } catch (_) {}
  }

  /// 設定視窗最小寬高限制。
  static Future<void> setMinSize({double? minWidth, double? minHeight}) async {
    try {
      await _channel.invokeMethod('setMinSize', {
        'width': ?minWidth,
        'height': ?minHeight,
      });
    } catch (_) {}
  }

  /// 查詢目前視窗是否處於最大化狀態。
  static Future<bool> checkIsMaximized() async {
    try {
      return await _channel.invokeMethod<bool>('isMaximized') ?? false;
    } catch (_) {
      return false;
    }
  }
}
