part of '../klp_settings_navigation.dart';

/// 設定 section 導覽列；只有選取項目會建立其 field deep links。
class KlpSettingsNavigationItem extends StatelessWidget {
	const KlpSettingsNavigationItem({
		super.key,
		required this.title,
		required this.onPressed,
		this.icon,
		this.trailing,
		this.selected = false,
		this.children = const [],
	});

	final String title;
	final KlpIconData? icon;
	final Widget? trailing;
	final bool selected;
	final VoidCallback? onPressed;
	final List<Widget> children;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpColumn(
			crossAxisAlignment: CrossAxisAlignment.stretch,
			children: [
				KlpListTile(
					title: title,
					icon: icon,
					trailing: trailing,
					selected: selected,
					compact: true,
					onPressed: onPressed,
				),
				if (selected && children.isNotEmpty)
					KlpSurface(
						key: const ValueKey('klp-settings-field-guide'),
						tone: KlpSurfaceTone.transparent,
						radius: klp.shape.none,
						border: Border(
							left: BorderSide(
								color: klp.color.divider,
								width: klp.shape.hairline,
							),
						),
						child: KlpBox(
							insets: KlpBoxInsets.directional(start: klp.space.contentInset),
							child: KlpColumn(
								crossAxisAlignment: CrossAxisAlignment.stretch,
								children: children,
							),
						),
					),
			],
		);
	}
}
