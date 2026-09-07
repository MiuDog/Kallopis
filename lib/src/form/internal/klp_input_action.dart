import 'klp_form_dependencies.dart';

/// Form recipe 共用的尾端語意操作，不屬於公開元件 API。
class KlpInputAction extends StatelessWidget {
	final KlpIconData icon;
	final String label;
	final VoidCallback? onPressed;

	const KlpInputAction({
		super.key,
		required this.icon,
		required this.label,
		this.onPressed,
	});

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final enabled = onPressed != null;

		return Semantics(
			button: true,
			enabled: enabled,
			label: label,
			child: InkWell(
				onTap: onPressed,
				overlayColor: WidgetStatePropertyAll(klp.color.clear),
				child: SizedBox(
					width: klp.fieldHeight,
					height: klp.fieldHeight,
					child: Center(
						child: KlpIcon(
							icon,
							size: klp.space.iconSmall,
							weight: KlpIconWeight.thin,
							color: enabled ? klp.color.textMuted : klp.color.textFaint,
						),
					),
				),
			),
		);
	}
}
