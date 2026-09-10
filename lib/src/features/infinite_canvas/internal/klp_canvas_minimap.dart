part of '../klp_canvas_workspace.dart';

/// 大型空間文件的小地圖容器；viewport 投影由呼叫端提供。
class KlpCanvasMinimap extends StatelessWidget {
	const KlpCanvasMinimap({
		super.key,
		required this.label,
		required this.child,
		this.onPressed,
	});

	final String label;
	final Widget child;
	final VoidCallback? onPressed;

	@override
	Widget build(BuildContext context) {
		return _KlpCanvasMinimapFrame(
			label: label,
			onPressed: onPressed,
			child: child,
		);
	}
}
