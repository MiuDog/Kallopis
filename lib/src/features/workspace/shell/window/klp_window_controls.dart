import 'package:flutter/widgets.dart';

import '../../../../foundation/klp_icons.dart';
import '../../../../application/localization/klp_localizations.dart';
import '../../../../foundation/layout/klp_row.dart';
import '../../../../foundation/layout/klp_adaptive.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import 'internal/klp_window_control_button.dart';
import 'klp_window_controls_geometry.dart';
import 'klp_window_controls_style.dart';

/// 依平台策略排列視窗控制按鈕。
class KlpWindowControls extends StatelessWidget {
	const KlpWindowControls({
		super.key,
		required this.onMinimize,
		required this.onToggleMaximize,
		required this.onClose,
		this.isMaximized = false,
		this.style = KlpWindowControlsStyle.adaptive,
		this.geometry,
		this.minimizeKey,
		this.maximizeKey,
		this.closeKey,
	});

	final VoidCallback? onMinimize;
	final VoidCallback? onToggleMaximize;
	final VoidCallback? onClose;
	final bool isMaximized;
	final KlpWindowControlsStyle style;
	final KlpWindowControlsGeometry? geometry;
	final Key? minimizeKey;
	final Key? maximizeKey;
	final Key? closeKey;

	@override
	Widget build(BuildContext context) {
		if (style == KlpWindowControlsStyle.adaptive) {
			return KlpAdaptive(
				windows: (context) => buildPlatformControls(context, false),
				android: (context) => buildPlatformControls(context, false),
				macos: (context) => buildPlatformControls(context, true),
				linux: (context) => buildPlatformControls(context, false),
				ios: (context) => buildPlatformControls(context, true),
				other: (context) => buildPlatformControls(context, false),
			);
		}

		return buildPlatformControls(context, style == KlpWindowControlsStyle.macOS);
	}

	Widget buildPlatformControls(BuildContext context, bool isMac) {
		final l10n = KlpLocalizations.of(context);
		final resolvedGeometry = geometry ?? KlpWindowControlsGeometry(extent: context.klp.geometry.layout.windowHeaderControlSize);
		final minimizeButton = KlpWindowControlButton(
			key: minimizeKey,
			icon: KlpIcons.minus,
			label: l10n.windowMinimizeLabel,
			onPressed: onMinimize,
			geometry: resolvedGeometry,
		);
		final maximizeButton = KlpWindowControlButton(
			key: maximizeKey,
			icon: isMaximized ? KlpIcons.restore : KlpIcons.maximize,
			label: isMaximized ? l10n.windowRestoreLabel : l10n.windowMaximizeLabel,
			onPressed: onToggleMaximize,
			geometry: resolvedGeometry,
		);
		final closeButton = KlpWindowControlButton(
			key: closeKey,
			icon: KlpIcons.x,
			label: l10n.windowCloseLabel,
			onPressed: onClose,
			geometry: resolvedGeometry,
			destructive: true,
		);

		return KlpRow(
			mainAxisSize: MainAxisSize.min,
			children: isMac
					? [closeButton, minimizeButton, maximizeButton]
					: [minimizeButton, maximizeButton, closeButton],
		);
	}
}
