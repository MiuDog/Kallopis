import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_control_style.dart';
import 'package:kallopis/src/foundation/klp_icon_fonts.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_selection_surface.dart';

enum KlpFlutterBlockStateKind { task, disclosure }

/// 行內區塊狀態控制；命中、圖示與焦點幾何全部由編輯 semantic 推導。
final class KlpFlutterBlockStateControl extends StatefulWidget {
	final KlpBoundControlStyle style;
	final KlpFlutterBlockStateKind kind;
	final String label;
	final bool active, enabled;
	final VoidCallback action;

	const KlpFlutterBlockStateControl({required this.style, required this.kind, required this.label, required this.active, required this.enabled, required this.action, super.key});

	@override
	State<KlpFlutterBlockStateControl> createState() => _KlpFlutterBlockStateControlState();
}

final class _KlpFlutterBlockStateControlState extends State<KlpFlutterBlockStateControl> {
	bool _focused = false;

	@override
	Widget build(BuildContext context) {
		final density = widget.style.density;
		return Semantics(
			button: true,
			label: widget.label,
			toggled: widget.kind == KlpFlutterBlockStateKind.task ? widget.active : null,
			enabled: widget.enabled,
			onTap: widget.enabled ? widget.action : null,
			excludeSemantics: true,
			child: FocusableActionDetector(
				enabled: widget.enabled,
				mouseCursor: widget.enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
				onShowFocusHighlight: (value) => setState(() => _focused = value),
				shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent()},
				actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { if (widget.enabled) widget.action(); return null; })},
				child: GestureDetector(
					behavior: HitTestBehavior.opaque,
					onTap: widget.enabled ? widget.action : null,
					child: SizedBox.square(
						dimension: density.height,
						child: KlpFlutterSelectionSurface(
							color: klpFlutterColor(widget.style.background), radius: widget.style.radius.value,
							selected: false, focused: _focused, trackFocus: false, enabled: widget.enabled,
							child: Center(child: widget.kind == KlpFlutterBlockStateKind.task ? _task() : _disclosure()),
						),
					),
				),
			),
		);
	}

	Widget _task() {
		final density = widget.style.density;
		final color = widget.active ? widget.style.focus : widget.style.text.color;
		return Container(
			width: density.icon,
			height: density.icon,
			decoration: BoxDecoration(
				color: widget.active ? klpFlutterColor(color) : null,
				border: Border.all(color: klpFlutterColor(color), width: density.focusStroke),
				borderRadius: BorderRadius.circular(widget.style.radius.value.clamp(0, density.icon / 3)),
			),
			child: widget.active ? Center(child: Text(
				String.fromCharCode(KlpIcons.check.regularCodePoint),
				textScaler: TextScaler.noScaling,
				style: TextStyle(fontFamily: KlpIconFonts.regular, package: KlpIconFonts.package, fontSize: density.icon - density.focusStroke * 2, height: 1, color: klpFlutterColor(widget.style.background)),
			)) : null,
		);
	}

	Widget _disclosure() => SizedBox.square(
		dimension: widget.style.density.icon,
		child: RotatedBox(
			quarterTurns: widget.active ? 0 : 1,
			child: Center(child: Text(
				String.fromCharCode(KlpIcons.disclosureTriangle.regularCodePoint),
				textScaler: TextScaler.noScaling,
				style: TextStyle(fontFamily: KlpIconFonts.regular, package: KlpIconFonts.package, fontSize: widget.style.density.icon, height: 1, color: klpFlutterColor(widget.style.text.color)),
			)),
		),
	);
}
