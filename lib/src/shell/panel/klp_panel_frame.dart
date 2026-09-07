import 'package:flutter/material.dart';

import '../../theme/klp_theme.dart';
import 'klp_panel_footer.dart';
import 'klp_panel_layout.dart';

/// 通用面板：header 與 content，選用 footer。圓角使用較緊湊的 card 語意，
/// 高度預設沿用 theme 的外殼密度。
/// 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）渲染。
class KlpPanelFrame extends StatelessWidget implements KlpPanelLayout {
  const KlpPanelFrame({
    super.key,
    this.header,
    required this.content,
    this.footer,
    this.headerHeight,
		this.footerHeight,
		this.background,
		this.padding,
		this.contentScrollController,
	});

  final Widget? header;
  final Widget content;
  final Widget? footer;

  /// `null` 表示沿用 theme 的外殼高度。
  final double? headerHeight;
  final double? footerHeight;
	final Color? background;

	/// 舊版 API 相容欄位；PanelFrame 不再讀取此值，內距一律由 [content]、
	/// [header] 與 [footer] 自行提供。
	@Deprecated('KlpPanelFrame no longer provides internal padding.')
	final EdgeInsetsGeometry? padding;

	/// 內容區的捲動控制器。提供時，Frame 只負責繪製 Scrollbar；內容的
	/// 內距由 [content] 自己決定。
	final ScrollController? contentScrollController;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final effectiveBackground = background ?? tokens.surface;
    final surfaceTokens = tokens.onBackground(effectiveBackground);
		final contentRegion = _buildContentRegion(context);

		return Padding(
			padding: EdgeInsets.all(context.klp.space.dockMargin),
			child: DecoratedBox(
				decoration: BoxDecoration(
					color: effectiveBackground,
					borderRadius: BorderRadius.circular(context.klp.shape.card),
				),
				child: ClipRRect(
					borderRadius: BorderRadius.circular(
						context.klp.shape.card - context.klp.shape.stroke,
					),
					child: KlpTokenOverride(
						colors: surfaceTokens,
						child: Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								if (header != null)
									SizedBox(
										height: headerHeight ?? context.klp.space.chromeHeader,
										child: header!,
									),
								Expanded(child: contentRegion),
								if (footer != null)
									SizedBox(
										height: footerHeight ?? context.klp.space.chromeStatusBar,
										child: KlpPanelFooter(child: footer!),
									),
							],
						),
					),
				),
			),
		);
  }

	@override
	Widget buildPanelLayout(BuildContext context) => build(context);

	Widget _buildContentRegion(BuildContext context) {
		final controller = contentScrollController;
		if (controller == null) return content;

		final scrollBehavior = ScrollConfiguration.of(context).copyWith(scrollbars: false);

		return ScrollbarTheme(
			data: Theme.of(context).scrollbarTheme,
			child: Scrollbar(
				controller: controller,
				child: ScrollConfiguration(
					behavior: scrollBehavior,
					child: content,
				),
			),
		);
	}
}
