part of '../klp_canvas_workspace.dart';

class _KlpCanvasViewportFrame extends StatelessWidget {
	const _KlpCanvasViewportFrame({
		required this.transformationController,
		required this.panEnabled,
		required this.scaleEnabled,
		required this.child,
	});

	final TransformationController? transformationController;
	final bool panEnabled;
	final bool scaleEnabled;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return ColoredBox(
			color: context.klp.color.stageSurface,
			child: ClipRect(
				child: InteractiveViewer(
					transformationController: transformationController,
					panEnabled: panEnabled,
					scaleEnabled: scaleEnabled,
					boundaryMargin: EdgeInsets.all(context.klp.space.pageLarge),
					child: child,
				),
			),
		);
	}
}
