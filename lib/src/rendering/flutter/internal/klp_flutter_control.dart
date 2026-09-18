import 'dart:math' as math;
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/foundation/klp_icon_data.dart';
import 'package:kallopis/src/foundation/klp_icon_fonts.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_selection_surface.dart';

/// 庫內共用控制呈現：可見外框與命中槽分離，產品不接觸此 Widget。
final class KlpFlutterControl extends StatefulWidget {
	final KlpBoundControlStyle style;
	final KlpIconData? icon;
	final String label;
	final String? hint;
	final String? caption;
	final int quarterTurns;
	final bool selected, touch, enabled;
	final VoidCallback action;
	final FocusOnKeyEventCallback? onKeyEvent;
	const KlpFlutterControl({required this.style, required this.icon, required this.label, required this.selected, required this.touch, required this.action, this.caption, this.hint, this.quarterTurns = 0, this.enabled = true, this.onKeyEvent, super.key}) : assert(icon != null || caption != null);
	@override
	State<KlpFlutterControl> createState() => _ControlState();
}

class _ControlState extends State<KlpFlutterControl> {
	bool _focus = false;
	late final FocusNode _keyFocus = FocusNode(debugLabel: 'Kallopis control key');

	@override
	void dispose() {
		_keyFocus.dispose();
		super.dispose();
	}

	void _activate() {
		if (!widget.enabled) return;
		_keyFocus.requestFocus();
		widget.action();
	}

	KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
		if (!widget.enabled) return KeyEventResult.ignored;
		final custom = widget.onKeyEvent?.call(node, event) ?? KeyEventResult.ignored;
		if (custom != KeyEventResult.ignored) return custom;
		if (!widget.enabled || event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.enter && event.logicalKey != LogicalKeyboardKey.space) return custom;
		_activate();
		return KeyEventResult.handled;
	}

	@override
	Widget build(BuildContext context) {
		final style = widget.style;
		final density = style.density;
		final textHeight = MediaQuery.textScalerOf(context).scale(style.text.fontSize.value) * style.text.lineHeight.value;
		final visibleHeight = widget.caption == null ? density.height : math.max(density.height, textHeight + density.gap * 2);
		final targetHeight = widget.touch ? math.max(visibleHeight, density.touchTarget) : visibleHeight;
		final glyph = widget.icon == null ? null : ExcludeSemantics(child: SizedBox.square(
			dimension: density.icon,
			child: RotatedBox(quarterTurns: widget.quarterTurns, child: Center(child: Text(
				String.fromCharCode(widget.icon!.regularCodePoint),
				textScaler: TextScaler.noScaling,
				style: TextStyle(fontFamily: KlpIconFonts.regular, package: KlpIconFonts.package, fontSize: density.icon, height: 1, color: klpFlutterColor(style.text.color)),
			))),
		));
		return Semantics(
			button: true, label: widget.label, hint: widget.hint, toggled: widget.selected, enabled: widget.enabled,
			onTap: widget.enabled ? _activate : null,
			excludeSemantics: true,
			child: Focus(
				focusNode: _keyFocus,
				canRequestFocus: widget.enabled,
				onFocusChange: (value) => setState(() => _focus = value),
				onKeyEvent: _handleKeyEvent,
				child: MouseRegion(
				cursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
				child: GestureDetector(
					behavior: HitTestBehavior.opaque,
					onTap: widget.enabled ? _activate : null,
					child: ConstrainedBox(
						constraints: BoxConstraints(minWidth: targetHeight, minHeight: targetHeight),
						child: Center(widthFactor: 1, heightFactor: 1, child: KlpFlutterSelectionSurface(color: klpFlutterColor(style.background), radius: style.radius.value, selected: widget.selected, focused: _focus, trackFocus: false, enabled: widget.enabled, child: Container(
							height: visibleHeight,
							width: widget.caption == null ? density.height : null,
							padding: widget.caption == null ? null : EdgeInsets.symmetric(horizontal: density.padding),
							alignment: Alignment.center,
							child: widget.caption == null ? glyph : Row(mainAxisSize: MainAxisSize.min, children: [
								...glyph == null ? const <Widget>[] : <Widget>[glyph, SizedBox(width: density.gap)],
								Text(widget.caption!, style: klpFlutterTextStyle(style.text)),
							]),
						))),
					),
				)),
			));
	}
}
