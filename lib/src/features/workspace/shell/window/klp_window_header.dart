import 'package:flutter/widgets.dart';

import '../../../../foundation/platform/klp_app_platform.dart';
import '../../../../foundation/interaction/klp_gesture_region.dart';
import '../../../../foundation/layout/klp_adaptive.dart';
import '../../../../foundation/layout/klp_box.dart';
import '../../../../foundation/surface/klp_surface.dart';
import '../../../../styling/legacy_theme/klp_geometry_theme.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';
import 'klp_window_action.dart';
import 'klp_window_header_height.dart';
import 'klp_window_header_keys.dart';
import 'klp_window_header_strategy.dart';

/// 桌面應用程式自帶視窗標題列（Chrome Header）。整個 Header 表面都可拖動視窗；
/// 內部操作元件仍保留 tap 等自身事件。
///
/// - **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。
/// - **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。
class KlpWindowHeader extends StatelessWidget implements PreferredSizeWidget {
	const KlpWindowHeader({
		super.key,
		this.title,
		this.titleText,
		this.titleRole = KlpTextRole.appTitle,
		this.titleTrailing,
		this.appIcon,
		this.appIconButton,
		this.actions,
		this.leading,
		this.trailing,
		this.platform,
		this.height,
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

	/// 產品標題字體角色（預設使用 [KlpTextRole.appTitle]）。
	final KlpTextRole titleRole;

	/// 緊接在標題右方的控制項；適合在面板收合後保留展開按鈕。
	final Widget? titleTrailing;

	/// 應用程式圖示。
	final Widget? appIcon;

	/// 佔用 App icon 槽位的互動按鈕。提供時優先於 [appIcon]。
	final Widget? appIconButton;

	/// 頂部自訂動作按鈕清單。
	final List<Widget>? actions;

	/// 自訂最左側區域（若為 macOS 且提供則排在控制鈕後）。
	final Widget? leading;

	/// 自訂最右側區域。
	final Widget? trailing;

	/// 手動指定平台外觀風格（預設依系統環境判定）。
	final KlpAppPlatform? platform;

	/// 標題列版面占位高度；未指定時為內容高度加上上下 margin。
	final double? height;

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
		height ?? klpWindowHeaderHeight(KlpGeometryTheme.standard),
	);

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final layout = klp.geometry.layout;
		final headerMargin = klp.space.windowHeaderMargin;
		final effectiveHeight = height ?? layout.windowHeaderHeight;
		final availableHeight = effectiveHeight.clamp(0.0, double.infinity);
		final controlExtent = availableHeight;
		final appIconExtent =
				controlExtent *
				(layout.windowAppIconSize / layout.windowHeaderControlSize);
		final Widget titleWidget =
				title ??
				(titleText != null
						? KlpText(titleText!, role: titleRole, tone: KlpTextTone.primary)
						: const KlpBox());

		final strategy = KlpWindowHeaderStrategy(
			title: titleWidget,
			controlExtent: controlExtent,
			appIconExtent: appIconExtent,
			appIconSlotKey: const ValueKey(KlpWindowHeaderKeys.appIconSlot),
			onMinimize: onMinimize ?? KlpWindowAction.minimize,
			onToggleMaximize: onToggleMaximize ?? KlpWindowAction.toggleMaximize,
			onClose: onClose ?? KlpWindowAction.close,
			appIcon: appIcon,
			appIconButton: appIconButton,
			actions: actions,
			leading: leading,
			trailing: trailing,
			titleTrailing: titleTrailing,
			isMaximized: isMaximized,
			showWindowControls: showWindowControls,
		);

		return KlpGestureRegion(
			behavior: HitTestBehavior.translucent,
			onPanStart: (_) => KlpWindowAction.drag(),
			child: KlpBox(
				padding: EdgeInsets.symmetric(horizontal: headerMargin),
				child: KlpSurface(
					key: const ValueKey(KlpWindowHeaderKeys.surface),
					tone: KlpSurfaceTone.app,
					child: KlpBox(
						height: availableHeight,
						child: KlpAdaptive(
							windows: strategy.buildWindows,
							android: strategy.buildWindows,
							platform: platform,
							macos: strategy.buildMacOS,
							linux: strategy.buildWindows,
							ios: strategy.buildMacOS,
							other: strategy.buildWindows,
						),
					),
				),
			),
		);
	}
}
