import 'package:flutter/widgets.dart';

import '../../../actions/button/klp_icon_button.dart';
import '../../../../foundation/klp_icons.dart';
import '../../../../foundation/layout/klp_box.dart';
import '../../../../foundation/layout/klp_center.dart';
import '../../../../foundation/layout/klp_directional_position.dart';
import '../../../../foundation/layout/klp_directional_positioned.dart';
import '../../../../foundation/layout/klp_expanded.dart';
import '../../../../foundation/layout/klp_gap.dart';
import '../../../../foundation/layout/klp_positioned.dart';
import '../../../../foundation/layout/klp_row.dart';
import '../../../../foundation/layout/klp_spacer.dart';
import '../../../../foundation/layout/klp_stack.dart';
import '../../../../foundation/layout/klp_translate.dart';
import '../../../../foundation/layout/klp_translation.dart';
import '../../../../styling/legacy_theme/klp_geometry_theme.dart';
import '../../../../styling/legacy_theme/klp_theme.dart';
import '../../../../foundation/content/klp_text.dart';
import 'klp_window_header.dart';
import 'klp_window_header_height.dart';

/// Workbench 專用的單一視窗列。
///
/// 在標準 [KlpWindowHeader] 上，依兩側 pane 的即時寬度定位收合按鈕；
/// pane 收合後，Primary 按鈕會跟在標題右方，Secondary 按鈕則留在右側動作區。
class KlpWorkbenchWindowHeader extends StatelessWidget
		implements PreferredSizeWidget {
	const KlpWorkbenchWindowHeader({
		super.key,
		required this.titleText,
		required this.primaryPaneWidth,
		required this.primaryVisible,
		required this.onTogglePrimary,
		required this.collapseLabel,
		required this.expandLabel,
		this.secondaryPaneWidth,
		this.secondaryVisible = false,
		this.onToggleSecondary,
		this.secondaryToggleEnabled = true,
		this.collapseSecondaryLabel,
		this.expandSecondaryLabel,
		this.stageTopBar,
		this.appIcon,
		this.appIconButton,
		this.actions,
		this.onMinimize,
		this.onToggleMaximize,
		this.onClose,
		this.isMaximized = false,
		this.showWindowControls = true,
	});

	final String titleText;
	final double primaryPaneWidth;
	final bool primaryVisible;
	final VoidCallback? onTogglePrimary;
	final String collapseLabel;
	final String expandLabel;
	final double? secondaryPaneWidth;
	final bool secondaryVisible;
	final VoidCallback? onToggleSecondary;
	final bool secondaryToggleEnabled;
	final String? collapseSecondaryLabel;
	final String? expandSecondaryLabel;

	/// 位於 Primary 與 Secondary pane 之間的 Stage header 內容。
	final Widget? stageTopBar;
	final Widget? appIcon;
	final Widget? appIconButton;
	final List<Widget>? actions;
	final VoidCallback? onMinimize;
	final VoidCallback? onToggleMaximize;
	final VoidCallback? onClose;
	final bool isMaximized;
	final bool showWindowControls;

	@override
	Size get preferredSize =>
			Size.fromHeight(klpWindowHeaderHeight(KlpGeometryTheme.standard));

	double _collapsedStageStart(BuildContext context, double panelMargin) {
		final klp = context.klp;
		final titleStyle = KlpTextStyles.definitionOf(
			KlpTextRole.appTitle,
			klp.type,
		).toTextStyle(klp.type);
		final titlePainter = TextPainter(
			text: TextSpan(text: titleText, style: titleStyle),
			textDirection: Directionality.of(context),
			textScaler: MediaQuery.textScalerOf(context),
			maxLines: 1,
		)..layout();
		final layout = klp.geometry.layout;

		// App icon、標題、展開按鈕都屬於 identity；Stage 從 identity 後方首幀定位。
		return panelMargin * 2 +
				layout.windowHeaderControlSize * 2 +
				layout.windowIdentityGap * 2 +
				titlePainter.width;
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final layout = klp.geometry.layout;
		final headerHeight = klpWindowHeaderHeight(
			klp.geometry,
			windowHeaderMargin: klp.space.windowHeaderMargin,
		);
		final panelMargin = klp.space.dockMargin;
		final collapsedStageStart = _collapsedStageStart(context, panelMargin);
		// 先跨過 pane gap，再覆蓋 Stage 左上圓角的完整深度。
		final stageOverlap = panelMargin + klp.shape.panel;
		final primaryToggle = KlpIconButton(
			icon: primaryVisible ? KlpIcons.panelLeft : KlpIcons.panelRight,
			label: primaryVisible ? collapseLabel : expandLabel,
			onPressed: onTogglePrimary,
			size: KlpIconButtonSize.window,
			tone: KlpIconButtonTone.inline,
		);
		final hasSecondaryToggle =
				onToggleSecondary != null &&
				collapseSecondaryLabel != null &&
				expandSecondaryLabel != null;
		final secondaryToggle = hasSecondaryToggle
				? KlpIconButton(
						icon: secondaryVisible ? KlpIcons.panelRight : KlpIcons.panelLeft,
						label: secondaryVisible
								? collapseSecondaryLabel!
								: expandSecondaryLabel!,
						onPressed: secondaryToggleEnabled ? onToggleSecondary : null,
						size: KlpIconButtonSize.window,
						tone: KlpIconButtonTone.inline,
					)
				: null;
		final windowControlsExtent = showWindowControls
				? layout.windowHeaderControlSize * 3
				: 0.0;
		final collapsedActions = actions ?? const <Widget>[];
		final hasCollapsedChrome =
				!secondaryVisible &&
				(stageTopBar != null ||
						collapsedActions.isNotEmpty ||
						secondaryToggle != null);

		return KlpBox(
			height: headerHeight,
			child: KlpStack(
				clipBehavior: Clip.none,
				children: [
					KlpPositioned.fill(
						child: KlpWindowHeader(
							titleText: titleText,
							titleTrailing: primaryVisible ? null : primaryToggle,
							appIcon: appIcon,
							appIconButton: appIconButton,
							actions: secondaryVisible ? actions : null,
							height: headerHeight,
							onMinimize: onMinimize,
							onToggleMaximize: onToggleMaximize,
							onClose: onClose,
							isMaximized: isMaximized,
							showWindowControls: showWindowControls,
						),
					),
					if (stageTopBar != null && secondaryVisible)
						KlpDirectionalPositioned(
							position: KlpDirectionalPosition(
								start: primaryVisible ? primaryPaneWidth + panelMargin : collapsedStageStart,
								end: secondaryPaneWidth != null ? secondaryPaneWidth! + panelMargin : panelMargin,
								top: 0,
								bottom: -stageOverlap,
							),
							child: stageTopBar!,
						),
					if (hasCollapsedChrome)
						KlpDirectionalPositioned(
							position: KlpDirectionalPosition(
								start: primaryVisible ? primaryPaneWidth + panelMargin : collapsedStageStart,
								end: panelMargin + windowControlsExtent,
								top: 0,
								bottom: -stageOverlap,
							),
							child: KlpRow(
								children: [
									if (stageTopBar != null)
										KlpExpanded(child: stageTopBar!)
									else
										const KlpSpacer(),
									if (collapsedActions.isNotEmpty) ...[
										KlpGap.width(klp.space.chromeToolbarGap),
										for (
											var index = 0;
											index < collapsedActions.length;
											index++
										) ...[
											if (index > 0) KlpGap.width(klp.space.tight),
											collapsedActions[index],
										],
									],
									if (secondaryToggle != null) ...[
										KlpGap.width(klp.space.chromeToolbarGap),
										KlpBox(
											height: headerHeight,
											child: KlpTranslate(
												translation: KlpTranslation(vertical: -stageOverlap / 2),
												child: KlpCenter(child: secondaryToggle),
											),
										),
									],
									KlpGap.width(klp.space.chromeToolbarGap),
								],
							),
						),
					if (primaryVisible)
						KlpDirectionalPositioned(
							position: KlpDirectionalPosition(
								start: primaryPaneWidth - panelMargin - layout.windowHeaderControlSize,
								top: 0,
								bottom: 0,
							),
							child: KlpCenter(child: primaryToggle),
						),
					if (secondaryVisible &&
							secondaryToggle != null &&
							secondaryPaneWidth != null)
						KlpDirectionalPositioned(
							position: KlpDirectionalPosition(
								end: secondaryPaneWidth! - panelMargin - layout.windowHeaderControlSize,
								top: 0,
								bottom: 0,
							),
							child: KlpCenter(child: secondaryToggle),
						),
				],
			),
		);
	}
}
