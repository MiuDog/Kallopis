part of '../klp_settings_layout.dart';

/// 設定導覽 pane 的預設表面、內距與捲動行為。
class KlpSettingsNavigationPane extends StatelessWidget {
	const KlpSettingsNavigationPane({
		super.key,
		required this.children,
		this.header,
		this.controller,
	});

	final Widget? header;
	final List<Widget> children;
	final ScrollController? controller;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final tone = klp.byBrightness(
			light: KlpSurfaceTone.base,
			dark: KlpSurfaceTone.component,
		);

		return KlpSurface(
			tone: tone,
			radius: klp.shape.panel,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					if (header != null)
						KlpBox(
							insets: KlpBoxInsets.uniform(klp.space.tight),
							child: header!,
						),
					KlpExpanded(
						child: KlpScrollViewport(
							controller: controller,
							child: KlpBox(
								insets: KlpBoxInsets.directional(
									start: klp.space.tight,
									top: header == null ? klp.space.tight : 0,
									end: klp.space.tight,
									bottom: klp.space.tight,
								),
								child: KlpColumn(
									crossAxisAlignment: CrossAxisAlignment.stretch,
									children: children,
								),
							),
						),
					),
				],
			),
		);
	}
}
