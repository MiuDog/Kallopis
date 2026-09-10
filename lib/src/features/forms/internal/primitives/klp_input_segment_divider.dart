import '../klp_form_dependencies.dart';

/// Form recipe 共用的輸入分段線 primitive，不屬於公開元件 API。
class KlpInputSegmentDivider extends StatelessWidget {
	const KlpInputSegmentDivider({super.key});

	@override
	Widget build(BuildContext context) {
		return SizedBox(
			width: context.klp.shape.hairline,
			child: ColoredBox(color: context.klp.color.divider),
		);
	}
}
