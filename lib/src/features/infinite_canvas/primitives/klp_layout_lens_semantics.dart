part of '../klp_canvas_workspace.dart';

class _KlpLayoutLensSemantics extends StatelessWidget {
	const _KlpLayoutLensSemantics({
		required this.label,
		required this.child,
	});

	final String label;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Semantics(container: true, label: label, child: child);
	}
}
