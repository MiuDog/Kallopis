import 'package:flutter/widgets.dart';

import '../../../../foundation/layout/klp_box.dart';
import '../../../../foundation/layout/klp_center.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../internal/klp_window_header_extras.dart';
import 'klp_window_app_icon.dart';
import 'klp_window_controls.dart';
import 'klp_window_controls_style.dart';
import 'klp_window_controls_geometry.dart';
import 'klp_window_header_mac_layout.dart';
import 'klp_window_header_windows_layout.dart';

/// 將 Window Header 共用輸入轉為各平台 layout 的建構策略。
class KlpWindowHeaderStrategy {
	const KlpWindowHeaderStrategy({
		required this.title,
		required this.controlExtent,
		required this.appIconExtent,
		required this.appIconSlotKey,
		required this.onMinimize,
		required this.onToggleMaximize,
		required this.onClose,
		this.appIcon,
		this.appIconButton,
		this.actions,
		this.leading,
		this.trailing,
		this.titleTrailing,
		this.isMaximized = false,
		this.showWindowControls = true,
	});

	final Widget title;
	final double controlExtent;
	final double appIconExtent;
	final Key appIconSlotKey;
	final VoidCallback onMinimize;
	final VoidCallback onToggleMaximize;
	final VoidCallback onClose;
	final Widget? appIcon;
	final Widget? appIconButton;
	final List<Widget>? actions;
	final Widget? leading;
	final Widget? trailing;
	final Widget? titleTrailing;
	final bool isMaximized;
	final bool showWindowControls;

	Widget buildWindows(BuildContext context) {
		return KlpWindowHeaderWindowsLayout(
			identity: buildIdentity(context, appIconButton != null),
			controls: buildControls(KlpWindowControlsStyle.windows),
			controlExtent: controlExtent,
			leading: leading,
			appIconButton: appIconButton,
			trailing: trailing,
			titleTrailing: titleTrailing,
			actions: actions,
			onToggleMaximize: onToggleMaximize,
		);
	}

	Widget buildMacOS(BuildContext context) {
		return KlpWindowHeaderMacLayout(
			identity: buildIdentity(context, false),
			controls: buildControls(KlpWindowControlsStyle.macOS),
			leading: leading,
			trailing: trailing,
			titleTrailing: titleTrailing,
			actions: actions,
			onToggleMaximize: onToggleMaximize,
		);
	}

	Widget buildIdentity(BuildContext context, bool appIconUsesIndependentSlot) {
		return KlpBox(
			height: controlExtent,
			child: buildKlpWindowHeaderRegion(
				alignment: AlignmentDirectional.centerStart,
				children: [
					if (!appIconUsesIndependentSlot) ...[
						KlpBox(
							key: appIconSlotKey,
							width: controlExtent,
							height: controlExtent,
							child: appIconButton ?? (appIcon == null ? null : KlpWindowAppIcon(controlExtent: controlExtent, iconExtent: appIconExtent, child: appIcon!)),
						),
						KlpGap.width(context.klp.geometry.layout.windowIdentityGap),
					],
					KlpCenter(child: title),
				],
			),
		);
	}

	Widget buildControls(KlpWindowControlsStyle style) {
		if (!showWindowControls) return const KlpBox();

		return KlpCenter(
			child: KlpWindowControls(
				onMinimize: onMinimize,
				onToggleMaximize: onToggleMaximize,
				onClose: onClose,
				isMaximized: isMaximized,
				style: style,
				geometry: KlpWindowControlsGeometry(extent: controlExtent),
			),
		);
	}
}
