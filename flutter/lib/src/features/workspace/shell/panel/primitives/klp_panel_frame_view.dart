part of '../klp_panel_frame.dart';

/// Panel 對 Flutter 裝飾、裁切、彈性排版與 scrollbar 的 primitive 邊界。
class _KlpPanelFrameView extends StatelessWidget {
	const _KlpPanelFrameView({
		required this.header,
		required this.content,
		required this.footer,
		required this.headerSize,
		required this.tone,
		required this.elevation,
		required this.contentScrollController,
	});

	/// 槽內容由 caller 擁有；即使槽縮為零也保持原節點。
	final Widget? header;
	final Widget content;
	final Widget? footer;
	/// 語意尺寸與表面選項只解析既有 theme，不建立第二份預設值。
	final KlpPanelHeaderSize headerSize;
	final KlpPanelTone tone;
	final KlpPanelElevation elevation;
	/// 正文捲動生命週期仍由產品的 controller 擁有。
	final ScrollController? contentScrollController;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tokens = context.klpColors;
		final background = switch (tone) {
			KlpPanelTone.surface => tokens.surface,
			KlpPanelTone.stage => tokens.stageSurface,
		};
		final headerHeight = switch (headerSize) {
			KlpPanelHeaderSize.standard => klp.space.chromeHeader,
			KlpPanelHeaderSize.dock => klp.space.chromeTab,
		};
		Widget contentRegion = content;
		final controller = contentScrollController;

		if (controller != null) {
			final scrollBehavior = ScrollConfiguration.of(
				context,
			).copyWith(scrollbars: false);
			contentRegion = ScrollbarTheme(
				data: Theme.of(context).scrollbarTheme,
				child: Scrollbar(
					controller: controller,
					child: ScrollConfiguration(behavior: scrollBehavior, child: content),
				),
			);
		}

		// 外距只使用可用空間，避免合法大 token 把內框移出宿主。
		return LayoutBuilder(builder: (context, constraints) {
			final horizontal = constraints.hasBoundedWidth
					? math.min(klp.space.dockMargin, constraints.maxWidth / 2)
					: klp.space.dockMargin;
			final vertical = constraints.hasBoundedHeight
					? math.min(klp.space.dockMargin, constraints.maxHeight / 2)
					: klp.space.dockMargin;
			final innerRadius = math.max(0.0, klp.shape.card - klp.shape.stroke);

			return ClipRect(child: Padding(
				padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
				child: DecoratedBox(
					decoration: BoxDecoration(
						color: background,
						boxShadow: elevation == KlpPanelElevation.raised
								? KlpFrameReliefRecipe.resolve(
									background,
									klp.surface.overlayShadowColor,
									klp.space.space1,
								)
								: null,
						borderRadius: BorderRadius.circular(klp.shape.card),
					),
					child: ClipRRect(
						borderRadius: BorderRadius.circular(innerRadius),
						child: KlpTokenOverride(
							colors: tokens.onBackground(background),
							// 共用 solver 縮配 chrome；正文即使為零仍保留原節點。
							child: LayoutColumn(
								spacing: KlpLayoutSpacing.none,
								children: [
									if (header != null) KlpLayoutPane(
										size: KlpLayoutPaneSize.content,
										flex: 0,
										bounds: KlpLayoutBounds(preferred: headerHeight, maximum: headerHeight),
										child: header!,
									),
									KlpLayoutPane(size: KlpLayoutPaneSize.expand, child: contentRegion),
									if (footer != null) KlpLayoutPane(
										size: KlpLayoutPaneSize.content,
										flex: 0,
										bounds: KlpLayoutBounds(
											preferred: klp.space.chromeStatusBar,
											maximum: klp.space.chromeStatusBar,
										),
										child: KlpPanelFooter(child: footer!),
									),
								],
							),
						),
					),
				),
			));
		});
	}
}
