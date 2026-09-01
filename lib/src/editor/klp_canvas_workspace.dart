import 'package:flutter/material.dart';

import '../data/klp_badge.dart';
import '../feedback/klp_feedback_tone.dart';
import '../feedback/klp_inline_notice.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 編輯器畫布視窗；背景直接繼承 Stage surface，不建立另一塊畫布色。
class KlpCanvasViewport extends StatelessWidget {
	const KlpCanvasViewport({
		super.key,
		required this.child,
		this.transformationController,
		this.panEnabled = true,
		this.scaleEnabled = true,
	});

	final Widget child;
	final TransformationController? transformationController;
	final bool panEnabled;
	final bool scaleEnabled;

	@override
	Widget build(BuildContext context) => ColoredBox(
		color: context.klpColors.stageSurface,
		child: ClipRect(
			child: InteractiveViewer(
				transformationController: transformationController,
				panEnabled: panEnabled,
				scaleEnabled: scaleEnabled,
				boundaryMargin: EdgeInsets.all(context.klp.space.pageLarge),
				child: child,
			),
		),
	);
}

/// 畫布上的有限動作工具列；動作能力由呼叫端決定。
class KlpCanvasToolbar extends StatelessWidget {
	const KlpCanvasToolbar({super.key, required this.actions});

	final List<Widget> actions;

	@override
	Widget build(BuildContext context) => KlpSurface(
		tone: KlpSurfaceTone.raised,
		padding: EdgeInsets.all(context.klp.space.tight),
		child: Wrap(spacing: context.klp.space.tight, runSpacing: context.klp.space.tight, children: actions),
	);
}

/// 選取範圍與可選 resize handles 的通用覆層。
class KlpCanvasSelectionOverlay extends StatelessWidget {
	const KlpCanvasSelectionOverlay({super.key, required this.child, this.selected = true, this.showHandles = false});

	final Widget child;
	final bool selected;
	final bool showHandles;

	@override
	Widget build(BuildContext context) => Stack(
		clipBehavior: Clip.none,
		children: [
			DecoratedBox(
				decoration: BoxDecoration(border: selected ? Border.all(color: context.klpColors.selection, width: context.klp.shape.hairline) : null),
				child: child,
			),
			if (selected && showHandles)
				for (final alignment in const [Alignment.topLeft, Alignment.topRight, Alignment.bottomLeft, Alignment.bottomRight])
					Align(
						alignment: alignment,
						child: Container(
							width: context.klp.space.indicatorDot,
							height: context.klp.space.indicatorDot,
							decoration: BoxDecoration(color: context.klpColors.stageSurface, border: Border.all(color: context.klpColors.selection, width: context.klp.shape.hairline)),
						),
					),
		],
	);
}

/// 插入、重排、包覆、重設父層或疊放等 drop intent 指示器。
class KlpCanvasDropIntent extends StatelessWidget {
	const KlpCanvasDropIntent({super.key, required this.label, required this.child});

	final String label;
	final Widget child;

	@override
	Widget build(BuildContext context) => Semantics(
		liveRegion: true,
		label: label,
		child: DecoratedBox(
			decoration: BoxDecoration(border: Border.all(color: context.klpColors.interaction, width: context.klp.shape.hairline)),
			child: child,
		),
	);
}

/// Layout Lens 的單一診斷項目。
@immutable
class KlpLayoutDiagnosticData {
	const KlpLayoutDiagnosticData({required this.label, required this.value, this.tone = KlpFeedbackTone.neutral});

	final String label;
	final String value;
	final KlpFeedbackTone tone;
}

/// 顯示 layout、size、padding、gap 與 parent 關係，不推導文件狀態。
class KlpLayoutLens extends StatelessWidget {
	const KlpLayoutLens({super.key, required this.label, required this.diagnostics});

	final String label;
	final List<KlpLayoutDiagnosticData> diagnostics;

	@override
	Widget build(BuildContext context) => Semantics(
		container: true,
		label: label,
		child: KlpSurface(
			tone: KlpSurfaceTone.raised,
			padding: EdgeInsets.all(context.klp.space.compact),
			child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final item in diagnostics) Padding(padding: EdgeInsets.only(bottom: context.klp.space.tight), child: Row(children: [Expanded(child: KlpText(item.label, role: KlpTextRole.code, tone: KlpTextTone.muted)), KlpBadge(label: item.value, tone: item.tone)]))]),
		),
	);
}

/// Flow 節點卡；節點種類與風險文字由呼叫端提供。
class KlpFlowNodeCard extends StatelessWidget {
	const KlpFlowNodeCard({super.key, required this.title, required this.typeLabel, required this.child, this.selected = false, this.onPressed});

	final String title;
	final String typeLabel;
	final Widget child;
	final bool selected;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) => Semantics(
		button: onPressed != null,
		selected: selected,
		child: GestureDetector(
			onTap: onPressed,
			child: KlpSurface(
				tone: selected ? KlpSurfaceTone.raised : KlpSurfaceTone.component,
				border: Border.all(color: selected ? context.klpColors.selection : context.klpColors.divider, width: context.klp.shape.hairline),
				padding: EdgeInsets.all(context.klp.space.compact),
				child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Row(children: [Expanded(child: KlpText(title, role: KlpTextRole.bodyStrong)), KlpBadge(label: typeLabel)]), SizedBox(height: context.klp.space.compact), child]),
			),
		),
	);
}

/// Flow 風險或驗證訊息清單；風險計算與修復動作由領域層提供。
class KlpFlowValidationPanel extends StatelessWidget {
	const KlpFlowValidationPanel({super.key, required this.title, required this.issues, this.recoveryActions = const []});

	final String title;
	final List<(String, KlpFeedbackTone)> issues;
	final List<Widget> recoveryActions;

	@override
	Widget build(BuildContext context) => Column(
		crossAxisAlignment: CrossAxisAlignment.stretch,
		children: [
			KlpText(title, role: KlpTextRole.bodyStrong),
			for (final issue in issues) ...[SizedBox(height: context.klp.space.tight), KlpInlineNotice(title: title, message: issue.$1, tone: issue.$2)],
			if (recoveryActions.isNotEmpty) ...[SizedBox(height: context.klp.space.compact), Wrap(spacing: context.klp.space.tight, children: recoveryActions)],
		],
	);
}

/// 大型空間文件的小地圖容器；viewport 投影由呼叫端提供。
class KlpCanvasMinimap extends StatelessWidget {
	const KlpCanvasMinimap({super.key, required this.label, required this.child, this.onPressed});

	final String label;
	final Widget child;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) => Semantics(
		label: label,
		button: onPressed != null,
		child: GestureDetector(
			onTap: onPressed,
			child: KlpSurface(tone: KlpSurfaceTone.inset, padding: EdgeInsets.all(context.klp.space.tight), child: child),
		),
	);
}
