part of '../klp_artifact_workspace.dart';

class _KlpComponentDefinitionSemantics extends StatelessWidget {
	const _KlpComponentDefinitionSemantics({
		required this.button,
		required this.label,
		required this.child,
	});

	final bool button;
	final String label;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return Semantics(button: button, label: label, child: child);
	}
}
