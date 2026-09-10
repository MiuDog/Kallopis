part of 'klp_view_states.dart';

class KlpLoadingState extends StatelessWidget {
	const KlpLoadingState({super.key, required this.label});

	final String label;

	@override
	Widget build(BuildContext context) {
		return KlpLiveRegion(
			message: label,
			child: KlpBox(
				paddingSize: KlpSpaceSize.loose,
				child: KlpColumn(
					mainAxisSize: MainAxisSize.min,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: [
						const KlpGeometricSpinner(),
						const KlpGap.heightSize(KlpSpaceSize.base),
						KlpText(label, role: KlpTextRole.caption),
					],
				),
			),
		);
	}
}
