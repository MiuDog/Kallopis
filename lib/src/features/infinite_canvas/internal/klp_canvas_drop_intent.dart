part of '../klp_canvas_workspace.dart';

/// 插入、重排、包覆、重設父層或疊放等 drop intent 指示器。
class KlpCanvasDropIntent extends StatelessWidget {
	const KlpCanvasDropIntent({
		super.key,
		required this.label,
		required this.child,
	});

	final String label;
	final Widget child;

	@override
	Widget build(BuildContext context) {
		return _KlpCanvasDropIntentFrame(label: label, child: child);
	}
}
