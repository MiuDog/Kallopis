part of '../klp_settings_navigation.dart';

/// 固定於 Settings 導覽頂部的等寬 scope 切換器。
class KlpSettingsScopeSwitcher extends StatelessWidget {
	const KlpSettingsScopeSwitcher({
		super.key,
		required this.options,
		required this.selectedIndex,
		required this.onSelected,
	}) : assert(options.length > 1),
			 assert(selectedIndex >= 0 && selectedIndex < options.length);

	final List<KlpSettingsScopeOption> options;
	final int selectedIndex;
	final ValueChanged<int> onSelected;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return KlpSurface(
			tone: KlpSurfaceTone.inset,
			radius: klp.shape.control,
			child: KlpBox(
				insets: KlpBoxInsets.uniform(klp.space.hairline),
				child: KlpBox(
					height: klp.space.controlHeightXSmall,
					child: KlpRow(
					children: [
						for (var index = 0; index < options.length; index++)
							KlpExpanded(
								child: KlpPressable(
									key: ValueKey('klp-settings-scope-$index'),
									onPressed: () => onSelected(index),
									borderRadius: BorderRadius.circular(
										klp.shape.controlInner,
									),
									child: KlpBox.expand(
										child: KlpSurface(
											tone: index == selectedIndex
													? KlpSurfaceTone.raised
													: KlpSurfaceTone.transparent,
											radius: klp.shape.controlInner,
											child: KlpRow(
												mainAxisAlignment: MainAxisAlignment.center,
												children: [
													KlpIcon(
														options[index].icon,
														size: klp.space.iconSmall,
													),
													KlpBox(width: klp.space.tight),
													KlpText(
														options[index].label,
														role: KlpTextRole.caption,
													),
												],
											),
										),
									),
								),
							),
					],
				),
				),
			),
		);
	}
}
