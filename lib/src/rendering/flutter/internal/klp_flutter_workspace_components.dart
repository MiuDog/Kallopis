import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_selection_surface.dart';

final class KlpFlutterDocumentTabs extends StatelessWidget {
	final KlpBoundDocumentTabs content;
	const KlpFlutterDocumentTabs({required this.content, super.key});
	@override
	Widget build(BuildContext context) => ColoredBox(
		color: klpFlutterColor(content.background),
		child: SizedBox(height: content.extent.value, child: ListView.separated(scrollDirection: Axis.horizontal, padding: EdgeInsets.symmetric(horizontal: content.inset.value), itemCount: content.tabs.length, separatorBuilder: (_, _) => SizedBox(width: content.gap.value), itemBuilder: (_, index) => _DocumentTab(content: content, tab: content.tabs[index]))),
	);
}

final class _DocumentTab extends StatelessWidget {
	final KlpBoundDocumentTabs content;
	final KlpBoundDocumentTabData tab;
	const _DocumentTab({required this.content, required this.tab});
	@override
	Widget build(BuildContext context) {
		final label = tab.dirty ? '${tab.label}, Modified' : tab.label;
		return DecoratedBox(
			decoration: BoxDecoration(color: klpFlutterColor(tab.selected ? content.selectedBackground : content.background), borderRadius: BorderRadius.circular(content.radius.value)),
			child: Row(mainAxisSize: MainAxisSize.min, children: [
				_ActionSurface(label: label, selected: tab.selected, onActivate: content.onSelected == null ? null : () => content.onSelected!(tab.id), interactionColor: content.selectedBackground, radius: content.radius.value, child: Padding(padding: EdgeInsets.symmetric(horizontal: content.inset.value), child: Row(mainAxisSize: MainAxisSize.min, children: [Text(tab.label, style: _tabsTextStyle(content, content.foreground)), if (tab.dirty) Text(' •', style: _tabsTextStyle(content, content.mutedForeground))]))),
				_ActionSurface(label: '${tab.pinned ? 'Unpin' : 'Pin'} ${tab.label}', selected: tab.pinned, onActivate: content.onPinnedChanged == null ? null : () => content.onPinnedChanged!(tab.id, !tab.pinned), interactionColor: content.selectedBackground, radius: content.radius.value, child: Padding(padding: EdgeInsets.all(content.inset.value), child: KlpFlutterLucideIcon(tab.pinned ? 'pin-off' : 'pin', size: content.textStyle.fontSize.value, color: klpFlutterColor(content.mutedForeground)))),
				if (tab.closable) _ActionSurface(label: 'Close ${tab.label}', onActivate: content.onClose == null ? null : () => content.onClose!(tab.id), interactionColor: content.selectedBackground, radius: content.radius.value, child: Padding(padding: EdgeInsets.all(content.inset.value), child: Text('×', style: _tabsTextStyle(content, content.mutedForeground)))),
			]),
		);
	}
}

final class KlpFlutterWindowControls extends StatelessWidget {
	final KlpBoundWindowControls content;
	const KlpFlutterWindowControls({required this.content, super.key});
	@override
	Widget build(BuildContext context) => SizedBox(
		height: content.extent.value,
		child: Align(alignment: AlignmentDirectional.centerEnd, child: Row(mainAxisSize: MainAxisSize.min, children: [
			_control('Minimize window', 'minus', content.onMinimize),
			SizedBox(width: content.gap.value),
			_control(content.isMaximized ? 'Restore window' : 'Maximize window', content.isMaximized ? 'copy' : 'square', content.onToggleMaximize),
			SizedBox(width: content.gap.value),
			_control('Close window', 'x', content.onClose),
		])),
	);
	Widget _control(String label, String icon, void Function()? callback) => _ActionSurface(label: label, onActivate: callback, interactionColor: content.closeHover, radius: content.radius.value, child: SizedBox.square(dimension: content.buttonExtent.value, child: Center(child: KlpFlutterLucideIcon(icon, size: content.buttonExtent.value / 2 - (icon == 'square' || icon == 'copy' ? content.gap.value / 2 : 0), color: klpFlutterColor(content.foreground)))));
}

final class _ActionSurface extends StatefulWidget {
	final String label;
	final bool selected;
	final void Function()? onActivate;
	final KlpColor interactionColor;
	final double radius;
	final Widget child;
	const _ActionSurface({required this.label, required this.onActivate, required this.interactionColor, required this.radius, required this.child, this.selected = false});
	@override
	State<_ActionSurface> createState() => _ActionSurfaceState();
}

final class _ActionSurfaceState extends State<_ActionSurface> {
	final _focusNode = FocusNode();
	void _activate() {
		_focusNode.requestFocus();
		final callback = widget.onActivate;
		if (callback != null) unawaited(Future.sync(callback));
	}
	@override
	void dispose() {
		_focusNode.dispose();
		super.dispose();
	}
	@override
	Widget build(BuildContext context) {
		final interaction = Semantics(
			container: true, button: true, label: widget.label, selected: widget.selected, enabled: widget.onActivate != null, excludeSemantics: true, onTap: widget.onActivate == null ? null : _activate,
			child: FocusableActionDetector(
				enabled: widget.onActivate != null, focusNode: _focusNode, includeFocusSemantics: false,
				shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent(), SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(), SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent()},
				actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { _activate(); return null; })},
				child: GestureDetector(behavior: HitTestBehavior.opaque, excludeFromSemantics: true, onTap: widget.onActivate == null ? null : _activate, child: widget.child),
			),
		);
		return KlpFlutterSelectionSurface(color: klpFlutterColor(widget.interactionColor), radius: widget.radius, selected: widget.selected, enabled: widget.onActivate != null, child: interaction);
	}
}


TextStyle _tabsTextStyle(KlpBoundDocumentTabs content, KlpColor color) => _resolvedTextStyle(content.textStyle, color);
TextStyle _resolvedTextStyle(KlpBoundTextStyle style, KlpColor color) {
	final weightIndex = (style.fontWeight.value / 100).round().clamp(1, 9) - 1;
	return TextStyle(color: klpFlutterColor(color), fontFamily: style.fontFamily.family, fontSize: style.fontSize.value, fontWeight: FontWeight.values[weightIndex], height: style.lineHeight.value, letterSpacing: style.letterSpacing.value);
}
