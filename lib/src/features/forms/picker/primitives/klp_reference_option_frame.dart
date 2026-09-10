part of '../klp_reference_picker.dart';

class _KlpReferenceOptionFrame extends StatelessWidget {
	const _KlpReferenceOptionFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Container(
			constraints: BoxConstraints(
				minHeight: context.klp.space.controlHeight,
			),
			padding: EdgeInsets.symmetric(
				horizontal: context.klp.space.tight,
			),
			child: child,
		);
	}
}
