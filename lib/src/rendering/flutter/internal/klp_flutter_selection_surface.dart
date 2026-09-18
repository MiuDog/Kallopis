import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart' show kPrimaryButton;

/// 所有互動狀態共用底色，不改動子元件的文字、圖示或邊框。
final class KlpFlutterSelectionSurface extends StatefulWidget {
	final Color color;
	final Color? backgroundColor;
	final double radius;
	final bool selected, enabled, focused, highlightFocus, trackFocus;
	final Widget child;
	const KlpFlutterSelectionSurface({required this.color, required this.radius, required this.selected, required this.enabled, required this.child, this.backgroundColor, this.focused = false, this.highlightFocus = true, this.trackFocus = true, super.key});
	@override
	State<KlpFlutterSelectionSurface> createState() => _SelectionSurfaceState();
}

final class _SelectionSurfaceState extends State<KlpFlutterSelectionSurface> {
	bool _hovered = false, _focused = false;
	final _pressed = <int>{};
	@override
	Widget build(BuildContext context) {
		final active = widget.selected || (widget.enabled && (_hovered || _pressed.isNotEmpty || (widget.highlightFocus && (_focused || widget.focused))));
		final body = MouseRegion(
			onEnter: (_) => setState(() => _hovered = true),
			onExit: (_) => setState(() => _hovered = false),
			child: Listener(
				onPointerDown: (event) { if (widget.enabled && event.buttons & kPrimaryButton != 0) setState(() => _pressed.add(event.pointer)); },
				onPointerUp: (event) => setState(() => _pressed.remove(event.pointer)),
				onPointerCancel: (event) => setState(() => _pressed.remove(event.pointer)),
				child: DecoratedBox(decoration: BoxDecoration(color: active ? widget.color : widget.backgroundColor, borderRadius: BorderRadius.circular(widget.radius)), child: widget.child),
			),
		);
		return widget.trackFocus ? Focus(canRequestFocus: false, skipTraversal: true, onFocusChange: (value) => setState(() => _focused = value), child: body) : body;
	}
}
