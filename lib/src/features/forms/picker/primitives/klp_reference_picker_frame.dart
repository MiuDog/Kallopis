part of '../klp_reference_picker.dart';

class _KlpReferencePickerFrame extends StatelessWidget {
	const _KlpReferencePickerFrame({required this.child});

	final Widget child;

	@override
	Widget build(BuildContext context) {
		return KlpSurface(
			tone: KlpSurfaceTone.component,
			padding: EdgeInsets.all(context.klp.space.base),
			child: child,
		);
	}
}
