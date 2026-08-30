import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/klp_theme.dart';
import '../theme/klp_spacing_theme.dart';
import '../typography/klp_text.dart';
import 'internal/klp_window_header_extras.dart';
import 'klp_window_controls.dart';

/// 視窗標題列的 App icon 固定槽位識別鍵。
const String klpWindowAppIconSlotKey = 'klp-window-app-icon-slot';

/// Header 總高度：上下各半個 compact inset 加上正方形 icon button。
double klpWindowHeaderHeight(KlpSpacingTheme spacing) =>
    spacing.compact + spacing.iconButton;

/// 桌面平台視窗控制操作（最小化、最大化／還原、關閉、拖曳、限制尺寸）。
abstract final class KlpWindowAction {
  static const MethodChannel _channel = MethodChannel('kallopis/window');

  /// 最小化目前視窗。
  static Future<void> minimize() async {
    try {
      await _channel.invokeMethod('minimize');
    } catch (_) {}
  }

  /// 切換最大化／還原目前視窗。
  static Future<void> toggleMaximize() async {
    try {
      await _channel.invokeMethod('maximize');
    } catch (_) {}
  }

  /// 確保目前視窗最大化；已最大化時不切換回視窗化。
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

/// 桌面應用程式自帶視窗標題列（Chrome Header）。
///
/// - **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。
/// - **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。
class KlpWindowHeader extends StatelessWidget implements PreferredSizeWidget {
  const KlpWindowHeader({
    super.key,
    this.title,
    this.titleText,
    this.titleRole = KlpTextRole.label,
    this.appIcon,
    this.actions,
    this.leading,
    this.trailing,
    this.platform,
    this.height,
    this.backgroundColor,
    this.onMinimize,
    this.onToggleMaximize,
    this.onClose,
    this.isMaximized = false,
    this.showWindowControls = true,
  });

  /// 自訂標題 Widget。優先於 [titleText]。
  final Widget? title;

  /// 標題純文字。
  final String? titleText;

  /// 產品標題字體角色（預設為全寬細等寬字體角色 [KlpTextRole.label]）。
  final KlpTextRole titleRole;

  /// 應用程式圖示。
  final Widget? appIcon;

  /// 頂部自訂動作按鈕清單。
  final List<Widget>? actions;

  /// 自訂最左側區域（若為 macOS 且提供則排在控制鈕後）。
  final Widget? leading;

  /// 自訂最右側區域。
  final Widget? trailing;

  /// 手動指定平台外觀風格（預設依系統環境判定）。
  final TargetPlatform? platform;

  /// 標題列高度；未指定時使用 shell geometry token。
  final double? height;

  /// 標題列背景色（預設為視窗底色 `tokens.app`）。
  final Color? backgroundColor;

  /// 最小化視窗回呼。
  final VoidCallback? onMinimize;

  /// 最大化／還原視窗回呼。
  final VoidCallback? onToggleMaximize;

  /// 關閉視窗回呼。
  final VoidCallback? onClose;

  /// 目前視窗是否為最大化狀態。
  final bool isMaximized;

  /// 是否顯示視窗控制按鈕（最小化、最大化、關閉）。
  final bool showWindowControls;

  @override
  Size get preferredSize => Size.fromHeight(
    height ?? klpWindowHeaderHeight(KlpSpacingTheme.comfortableDensity),
  );

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final layout = klp.geometry.layout;
    final effectiveHeight = height ?? klpWindowHeaderHeight(klp.space);
    final effectivePlatform = platform ?? Theme.of(context).platform;
    final isMac = effectivePlatform == TargetPlatform.macOS;

    final Widget titleWidget =
        title ??
        (titleText != null
            ? KlpText(titleText!, role: titleRole, tone: KlpTextTone.primary)
            : const SizedBox.shrink());

    final Widget identityWidget = SizedBox(
      height: klp.space.iconButton,
      child: buildKlpWindowHeaderRegion(
        alignment: AlignmentDirectional.centerStart,
        children: [
          SizedBox.square(
            key: const ValueKey(klpWindowAppIconSlotKey),
            dimension: layout.windowAppIconSize,
            child: appIcon == null ? null : Center(child: appIcon!),
          ),
          SizedBox(width: layout.windowIdentityGap),
          Center(child: titleWidget),
        ],
      ),
    );

    final Widget windowControlsWidget = showWindowControls
        ? Center(
            child: KlpWindowControls(
              onMinimize: onMinimize ?? KlpWindowAction.minimize,
              onToggleMaximize:
                  onToggleMaximize ?? KlpWindowAction.toggleMaximize,
              onClose: onClose ?? KlpWindowAction.close,
              isMaximized: isMaximized,
            ),
          )
        : const SizedBox.shrink();

    return Material(
      color: backgroundColor ?? tokens.app,
      child: SizedBox(
        height: effectiveHeight,
        child: Padding(
          padding: EdgeInsets.all(klp.space.compact / 2),
          child: isMac
              ? _buildMacLayout(
                  context,
                  identity: identityWidget,
                  controls: windowControlsWidget,
                )
              : _buildWindowsLayout(
                  context,
                  identity: identityWidget,
                  controls: windowControlsWidget,
                ),
        ),
      ),
    );
  }

  Widget _buildWindowsLayout(
    BuildContext context, {
    required Widget identity,
    required Widget controls,
  }) {
    final klp = context.klp;
    final extras = actions == null && trailing == null
        ? null
        : buildKlpWindowHeaderRegion(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              if (actions != null) ...[
                ...actions!,
                SizedBox(width: klp.space.compact),
              ],
              if (trailing != null) ...[
                trailing!,
                SizedBox(width: klp.space.compact),
              ],
            ],
          );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null) ...[leading!, SizedBox(width: klp.space.compact)],
        Expanded(
          child: buildKlpWindowHeaderContent(
            identity: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onPanStart: (_) => KlpWindowAction.drag(),
              onDoubleTap: () =>
                  (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
              child: SizedBox(
                height: double.infinity,
                child: Align(alignment: Alignment.centerLeft, child: identity),
              ),
            ),
            extras: extras,
          ),
        ),
        controls,
      ],
    );
  }

  Widget _buildMacLayout(
    BuildContext context, {
    required Widget identity,
    required Widget controls,
  }) {
    final klp = context.klp;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            controls,
            if (leading != null) ...[
              SizedBox(width: klp.space.compact),
              leading!,
            ],
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) => KlpWindowAction.drag(),
                onDoubleTap: () =>
                    (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
                child: const SizedBox(height: double.infinity),
              ),
            ),
            if (actions != null) ...?actions,
            if (trailing != null) ...[
              SizedBox(width: klp.space.compact),
              trailing!,
            ],
          ],
        ),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanStart: (_) => KlpWindowAction.drag(),
          onDoubleTap: () =>
              (onToggleMaximize ?? KlpWindowAction.toggleMaximize)(),
          child: SizedBox(
            height: double.infinity,
            child: Align(alignment: Alignment.center, child: identity),
          ),
        ),
      ],
    );
  }
}
