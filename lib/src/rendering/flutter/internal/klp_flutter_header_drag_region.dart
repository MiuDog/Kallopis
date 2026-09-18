import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 頂部背景交由宿主移動視窗；子元件的語意互動區保留自己的指標事件。
final class KlpFlutterHeaderDragRegion extends StatelessWidget {
	final double extent;
	final void Function() onDrag;
	final Widget child;

	const KlpFlutterHeaderDragRegion({required this.extent, required this.onDrag, required this.child, super.key});

	@override
	Widget build(BuildContext context) => Builder(builder: (regionContext) => Listener(
		behavior: HitTestBehavior.translucent,
		onPointerDown: (event) {
			if (event.kind != PointerDeviceKind.mouse || event.buttons != kPrimaryMouseButton) return;
			final box = regionContext.findRenderObject()! as RenderBox;
			final position = box.globalToLocal(event.position);
			if (position.dy < 0 || position.dy >= extent) return;
			final result = BoxHitTestResult();
			box.hitTest(result, position: position);
			for (final entry in result.path) {
				final target = entry.target;
				if (target is RenderEditable) return;
				if (target is RenderSemanticsAnnotations) {
					final semantics = target.properties;
					if (semantics.enabled != false && (semantics.button == true || semantics.link == true || semantics.textField == true || semantics.onTap != null || semantics.onIncrease != null || semantics.onDecrease != null)) return;
				}
			}
			onDrag();
		},
		child: child,
	));
}
