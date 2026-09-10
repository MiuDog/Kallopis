part of '../klp_canvas_workspace.dart';

/// 編輯器畫布視窗；背景直接繼承 Stage surface，不建立另一塊畫布色。
class KlpCanvasViewport extends StatelessWidget {
	const KlpCanvasViewport({
		super.key,
		required this.child,
		this.transformationController,
		this.panEnabled = true,
		this.scaleEnabled = true,
	});

	final Widget child;
	final TransformationController? transformationController;
	final bool panEnabled;
	final bool scaleEnabled;

	@override
	Widget build(BuildContext context) {
		return _KlpCanvasViewportFrame(
			transformationController: transformationController,
			panEnabled: panEnabled,
			scaleEnabled: scaleEnabled,
			child: child,
		);
	}
}
