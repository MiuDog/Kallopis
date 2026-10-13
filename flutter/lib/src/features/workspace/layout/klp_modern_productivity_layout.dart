import 'package:flutter/material.dart';

import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';
import 'package:kallopis/src/features/actions/button/klp_button.dart';
import 'package:kallopis/src/foundation/interaction/controls/klp_control_size.dart';
import 'package:kallopis/src/features/workspace/layout/klp_app_layout.dart';

/// 現代風生產力模板的一項受控側欄內容。
@immutable
final class KlpModernProductivityPanel {
	/* id：跨切換與重排的穩定身分；label：切換按鈕的文字及可存取名稱。
	 * content：產品提供的原生內容，資料生命週期仍由產品擁有。 */
	final String id;
	final String label;
	final Widget content;

	const KlpModernProductivityPanel({required this.id, required this.label, required this.content});
}

/// 單一全高左側欄與右側 Header／Stage 的公開可重用模板。
final class KlpModernProductivityLayout extends StatelessWidget {
	/* panels：有序功能；selectedId：產品的目前選取；onSelected：只提出切換事件。
	 * header／stage：右區兩個角色；sidebarWidth：可選的期望側欄寬度。 */
	final List<KlpModernProductivityPanel> panels;
	final String selectedId;
	final ValueChanged<String>? onSelected;
	final Widget header;
	final Widget stage;
	final double? sidebarWidth;

	KlpModernProductivityLayout({
		super.key,
		required List<KlpModernProductivityPanel> panels,
		required this.selectedId,
		required this.header,
		required this.stage,
		this.onSelected,
		this.sidebarWidth,
	}) : panels = List.unmodifiable(panels) {
		final ids = <String>{};
		if (panels.isEmpty) throw ArgumentError.value(panels, 'panels', 'panels must not be empty');
		for (final panel in panels) {
			if (panel.id.trim().isEmpty || !ids.add(panel.id)) throw ArgumentError.value(panel.id, 'id', 'panel id must be unique and nonempty');
			if (panel.label.trim().isEmpty) throw ArgumentError.value(panel.label, 'label', 'panel label must not be empty');
		}
		if (!ids.contains(selectedId)) throw ArgumentError.value(selectedId, 'selectedId', 'selectedId must identify a panel');
		if (sidebarWidth != null && (!sidebarWidth!.isFinite || sidebarWidth! <= 0)) throw ArgumentError.value(sidebarWidth, 'sidebarWidth', 'sidebarWidth must be finite and positive');
	}

	@override
	Widget build(BuildContext context) {
		final width = sidebarWidth ?? context.klp.geometry.layout.primaryPaneWidth;
		return LayoutBuilder(builder: (context, constraints) {
			if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) throw ArgumentError('Modern productivity layout requires finite width and height');
			return KlpAppLayout(child: LayoutRow(children: [
				KlpAppFrame(
					role: KlpAppFrameRole.sidebar,
					flex: 0,
					width: width,
					bounds: KlpLayoutBounds(preferred: width),
					child: _sidebar(context),
				),
				KlpLayoutPane(size: KlpLayoutPaneSize.expand, child: _stage(context)),
			]));
		});
	}

	Widget _sidebar(BuildContext context) {
		final gap = context.klp.space.actionGap;
		final inset = context.klp.space.chromePanelInset;
		final buttons = <Widget>[];
		for (final panel in panels) {
			if (buttons.isNotEmpty) buttons.add(SizedBox(width: gap));
			buttons.add(KlpButton(
				key: ValueKey('switch:${panel.id}'),
				label: panel.label,
				size: KlpControlSize.md,
				tone: KlpButtonTone.secondary,
				selected: panel.id == selectedId,
				onPressed: onSelected == null ? null : () { if (panel.id != selectedId) onSelected!(panel.id); },
			));
		}
		final switcher = Padding(padding: EdgeInsets.all(inset), child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(mainAxisSize: MainAxisSize.min, children: buttons)));
		return LayoutColumn(spacing: KlpLayoutSpacing.none, children: [
			KlpLayoutPane(flex: 0, size: KlpLayoutPaneSize.content, child: switcher),
			KlpLayoutPane(size: KlpLayoutPaneSize.expand, child: Stack(fit: StackFit.expand, children: [
				for (final panel in panels) Offstage(
					key: ValueKey(panel.id),
					offstage: panel.id != selectedId,
					child: ExcludeFocus(excluding: panel.id != selectedId, child: TickerMode(enabled: panel.id == selectedId, child: panel.content)),
				),
			])),
		]);
	}

	Widget _stage(BuildContext context) {
		final background = context.klp.color.stageSurface;
		return ColoredBox(color: background, child: KlpTokenOverride(colors: context.klp.color.onBackground(background), child: LayoutColumn(spacing: KlpLayoutSpacing.none, children: [
			KlpLayoutPane(flex: 0, size: KlpLayoutPaneSize.content, child: IntrinsicHeight(child: ConstrainedBox(constraints: BoxConstraints(minHeight: context.klp.space.chromeHeader), child: header))),
			KlpLayoutPane(size: KlpLayoutPaneSize.expand, child: stage),
		])));
	}
}
