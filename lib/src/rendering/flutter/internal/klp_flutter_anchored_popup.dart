import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/src/features/workspace/components/klp_anchored_popup.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/foundation/platform/klp_id_scope.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_flutter_commands.dart';
import 'klp_flutter_interaction_theme.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_selection_surface.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_workspace_block.dart';

/// 只呈現已綁定資料的受控 popup；open 變更一律回送 consumer。
final class KlpFlutterAnchoredPopup extends StatefulWidget {
	final KlpBoundAnchoredPopup content;

	const KlpFlutterAnchoredPopup({required this.content, super.key});

	@override
	State<KlpFlutterAnchoredPopup> createState() => _KlpFlutterAnchoredPopupState();
}

final class _KlpFlutterAnchoredPopupState extends State<KlpFlutterAnchoredPopup> {
	final _overlay = OverlayPortalController();
	final _commandRoutes = KlpFlutterCommandRouteOwner();
	final _triggerFocus = FocusNode(debugLabel: 'KlpAnchoredPopup trigger');
	final _panelFocus = FocusScopeNode(debugLabel: 'KlpAnchoredPopup panel');
	var _generation = 0;
	var _anchorUnavailableSent = false;

	KlpBoundAnchoredPopup get _content => widget.content;
	KlpFlutterCommandStyle get _commandStyle => KlpFlutterCommandStyle(
		surface: klpFlutterColor(_content.surface),
		foreground: klpFlutterColor(_content.foreground),
		muted: klpFlutterColor(_content.mutedForeground),
		interaction: klpFlutterColor(_content.interaction),
		destructive: klpFlutterColor(_content.destructive),
		text: klpFlutterTextStyle(_content.textStyle).copyWith(textBaseline: TextBaseline.alphabetic),
		extent: _content.rowExtent.value,
		inset: _content.gap.value,
		radius: _content.radius.value,
	);

	@override
	void initState() {
		super.initState();
		_scheduleOverlay(widget.content.open, focusPanel: widget.content.open);
	}

	@override
	void didUpdateWidget(KlpFlutterAnchoredPopup oldWidget) {
		super.didUpdateWidget(oldWidget);
		_commandRoutes.dismiss();
		_generation++;
		if (oldWidget.content.open == widget.content.open) return;

		if (widget.content.open) _anchorUnavailableSent = false;
		_scheduleOverlay(widget.content.open, focusPanel: widget.content.open, restoreTrigger: !widget.content.open);
	}

	@override
	void dispose() {
		_commandRoutes.dismiss();
		_generation++;
		final reportUnavailable = widget.content.open && !_anchorUnavailableSent;
		final callback = widget.content.onOpenChanged;
		_anchorUnavailableSent = true;
		_triggerFocus.dispose();
		_panelFocus.dispose();
		super.dispose();
		if (reportUnavailable) {
			WidgetsBinding.instance.addPostFrameCallback((_) => callback(false, KlpAnchoredPopupChangeReason.anchorUnavailable));
		}
	}

	void _scheduleOverlay(bool open, {bool focusPanel = false, bool restoreTrigger = false}) {
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (!mounted || widget.content.open != open) return;

			if (open) {
				_overlay.show();
				if (focusPanel) WidgetsBinding.instance.addPostFrameCallback((_) => _focusFirstControl());
			}
			else {
				_overlay.hide();
				if (restoreTrigger && _triggerFocus.canRequestFocus) _triggerFocus.requestFocus();
			}
		});
	}

	void _focusFirstControl() {
		if (!mounted || !widget.content.open) return;
		_panelFocus.requestFocus();
		if (_hasEnabledControl) _panelFocus.nextFocus();
	}

	bool get _hasEnabledControl {
		final item = _content.items?.any((item) => item.enabled && item.onPressed != null) ?? false;
		final action = _content.actions?.any((command) => command.enabled) ?? false;
		return item || action;
	}

	void _request(KlpAnchoredPopupChangeReason reason) => _content.onOpenChanged(!_content.open, reason);
	void _requestClose(KlpAnchoredPopupChangeReason reason) {
		if (_content.open) _content.onOpenChanged(false, reason);
	}

	bool _isActive(int generation) => mounted && generation == _generation && widget.content.open;

	void _reportAnchorUnavailable() {
		if (_anchorUnavailableSent) return;
		_anchorUnavailableSent = true;
		_commandRoutes.dismiss();
		WidgetsBinding.instance.addPostFrameCallback((_) {
			if (!mounted || !widget.content.open) return;
			widget.content.onOpenChanged(false, KlpAnchoredPopupChangeReason.anchorUnavailable);
		});
	}

	@override
	Widget build(BuildContext context) {
		final direction = Directionality.of(context);
		return Localizations.override(
			context: context,
			delegates: const [DefaultMaterialLocalizations.delegate],
			child: Material(
				type: MaterialType.transparency,
				child: CallbackShortcuts(
					bindings: {const SingleActivator(LogicalKeyboardKey.escape): () => _requestClose(KlpAnchoredPopupChangeReason.escape)},
					child: OverlayPortal.overlayChildLayoutBuilder(
						controller: _overlay,
						overlayChildBuilder: (context, info) => _overlayChild(context, info, direction),
						child: _trigger(),
					),
				),
			),
		);
	}

	Widget _trigger() {
		final trigger = _content.trigger;
		if (trigger is! KlpBoundPlacement || trigger.content is! KlpBoundWorkspaceBlock) throw StateError('Anchored popup trigger must materialize as a workspace block placement.');
		return KlpIdScope(
			id: _scopeId(trigger.id),
			child: KlpFlutterWorkspaceBlock(
				key: ValueKey(trigger.id),
				content: trigger.content as KlpBoundWorkspaceBlock,
				activation: () => _request(KlpAnchoredPopupChangeReason.trigger),
				focusNode: _triggerFocus,
				expanded: _content.open,
				selectedOverride: false,
			),
		);
	}

	Widget _overlayChild(BuildContext context, OverlayChildLayoutInfo info, TextDirection direction) {
		final anchor = MatrixUtils.transformRect(info.childPaintTransform, Offset.zero & info.childSize);
		if (!_validAnchor(anchor, info.overlaySize)) {
			_reportAnchorUnavailable();
			return const SizedBox.shrink();
		}
		_anchorUnavailableSent = false;

		final inset = _content.viewportInset.value;
		final width = math.max(0.0, math.min(_content.panelWidth.value, info.overlaySize.width - inset * 2));
		return Stack(children: [
			for (final rect in _barrierRects(anchor, info.overlaySize)) Positioned.fromRect(rect: rect, child: ExcludeSemantics(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _requestClose(KlpAnchoredPopupChangeReason.outside)))),
			CustomSingleChildLayout(
				delegate: _AnchoredPopupLayout(anchor: anchor, direction: direction, inset: inset),
				child: SizedBox(width: width, child: _panel()),
			),
		]);
	}

	bool _validAnchor(Rect anchor, Size overlaySize) => !anchor.isEmpty && anchor.left.isFinite && anchor.top.isFinite && anchor.right.isFinite && anchor.bottom.isFinite && anchor.overlaps(Offset.zero & overlaySize);
	List<Rect> _barrierRects(Rect anchor, Size size) {
		final left = anchor.left.clamp(0.0, size.width);
		final top = anchor.top.clamp(0.0, size.height);
		final right = anchor.right.clamp(0.0, size.width);
		final bottom = anchor.bottom.clamp(0.0, size.height);
		return [
			Rect.fromLTRB(0, 0, size.width, top),
			Rect.fromLTRB(0, top, left, bottom),
			Rect.fromLTRB(right, top, size.width, bottom),
			Rect.fromLTRB(0, bottom, size.width, size.height),
		].where((rect) => !rect.isEmpty).toList(growable: false);
	}

	Widget _panel() => KlpFlutterInteractionTheme(
		color: klpFlutterColor(_content.interaction),
		foreground: klpFlutterColor(_content.foreground),
		radius: _content.radius.value,
		child: Semantics(
			container: true,
			label: _content.accessibilityLabel,
			child: GestureDetector(
				behavior: HitTestBehavior.opaque,
				onTap: () {},
				child: DecoratedBox(
					decoration: BoxDecoration(
						color: klpFlutterColor(_content.surface),
						borderRadius: BorderRadius.circular(_content.radius.value),
						boxShadow: [BoxShadow(color: klpFlutterColor(_content.shadow), offset: Offset(0, _content.shadowOffset.value), blurRadius: _content.shadowBlur.value)],
					),
					child: FocusTraversalGroup(
						policy: WidgetOrderTraversalPolicy(),
						child: FocusScope(
							node: _panelFocus,
							child: SingleChildScrollView(
								padding: EdgeInsets.all(_content.inset.value),
								child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: _panelChildren()),
							),
						),
					),
				),
			),
		),
	);

	List<Widget> _panelChildren() {
		final children = <Widget>[];
		void separate() {
			if (children.isNotEmpty) children.add(SizedBox(height: _content.gap.value));
		}

		if (_content.title != null) children.add(Text(_content.title!, style: _textStyle()));
		if (_content.items != null) {
			separate();
			children.addAll(_content.items!.map(_item));
		}
		if (_content.actions != null) {
			separate();
			children.addAll(_content.actions!.map(_action));
		}
		if (_content.state != 1) {
			separate();
			children.add(_feedback());
		}
		return children;
	}

	Widget _item(KlpBoundAnchoredPopupItem item) {
		final primaryEnabled = item.enabled && item.onPressed != null;
		final commandsEnabled = item.enabled && item.commands.isNotEmpty;
		return Builder(builder: (itemContext) => KlpFlutterSelectionSurface(
			key: ValueKey(item.id),
			color: klpFlutterColor(_content.interaction),
			backgroundColor: klpFlutterColor(_content.surface),
			radius: _content.radius.value,
			selected: item.current,
			enabled: primaryEnabled || commandsEnabled,
			child: Semantics(
				button: primaryEnabled,
				selected: item.current,
				enabled: item.enabled,
				label: item.label,
				excludeSemantics: true,
				child: FocusableActionDetector(
					enabled: primaryEnabled,
					shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent()},
					actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { unawaited(_invokeItem(item)); return null; })},
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTap: primaryEnabled ? () => unawaited(_invokeItem(item)) : null,
						onSecondaryTapDown: commandsEnabled ? (details) => unawaited(_showItemCommands(itemContext, item, details.globalPosition)) : null,
						child: ConstrainedBox(
							constraints: BoxConstraints(minHeight: _content.rowExtent.value),
							child: Padding(
								padding: EdgeInsets.symmetric(horizontal: _content.gap.value),
								child: Row(children: [
									if (item.icon != null) ...[_icon(item.icon!), SizedBox(width: _content.gap.value)],
									Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(item.label, style: _textStyle()), if (item.subtitle != null) Text(item.subtitle!, style: _textStyle(color: _content.mutedForeground))])),
								]),
							),
						),
					),
				),
			),
		));
	}

	Widget _action(KlpBoundWorkspaceCommand command) {
		final color = command.enabled ? command.destructive ? _content.destructive : _content.foreground : _content.mutedForeground;
		return KlpFlutterSelectionSurface(
			color: klpFlutterColor(_content.interaction),
			backgroundColor: klpFlutterColor(_content.surface),
			radius: _content.radius.value,
			selected: false,
			enabled: command.enabled,
			child: Semantics(
				button: true,
				enabled: command.enabled,
				label: command.label,
				excludeSemantics: true,
				child: FocusableActionDetector(
					enabled: command.enabled,
					shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent()},
					actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { _runAction(context, command); return null; })},
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTap: command.enabled ? () => _runAction(context, command) : null,
						child: SizedBox(height: _content.rowExtent.value, child: Padding(padding: EdgeInsets.symmetric(horizontal: _content.gap.value), child: Align(alignment: AlignmentDirectional.centerStart, child: Text(command.label, style: _textStyle(color: color))))),
					),
				),
			),
		);
	}

	Widget _feedback() {
		if (_content.state == 0) {
			return Semantics(
				liveRegion: true,
				label: _content.message,
				child: SizedBox(
					height: _content.rowExtent.value,
					child: Row(children: [
						SizedBox.square(dimension: _content.gap.value * 2, child: Center(child: KlpFlutterLucideIcon('loader-circle', size: _content.gap.value * 2, color: klpFlutterColor(_content.foreground)))),
						if (_content.message != null) ...[SizedBox(width: _content.gap.value), Expanded(child: Text(_content.message!, style: _textStyle(color: _content.mutedForeground)))],
					]),
				),
			);
		}
		return Semantics(liveRegion: true, label: _content.message, child: Text(_content.message!, style: _textStyle(color: _content.state == 2 ? _content.destructive : _content.foreground)));
	}

	Future<void> _invokeItem(KlpBoundAnchoredPopupItem item) async {
		if (!item.enabled || item.onPressed == null) return;
		try {
			await item.onPressed!();
		}
		catch (error, stackTrace) {
			FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stackTrace, library: 'Kallopis anchored popup'));
		}
	}

	Future<void> _showItemCommands(BuildContext context, KlpBoundAnchoredPopupItem item, Offset anchor) async {
		final generation = _generation;
		await showKlpCommandMenu(context, item.commands, anchor, _commandStyle, () => _isActive(generation) && item.enabled, routeOwner: _commandRoutes);
	}

	void _runAction(BuildContext context, KlpBoundWorkspaceCommand command) {
		final generation = _generation;
		unawaited(runKlpCommand(context, command, _commandStyle, () => _isActive(generation), routeOwner: _commandRoutes));
	}

	Widget _icon(int value) => KlpFlutterLucideIcon(_iconData(value), size: _content.gap.value * 2, color: klpFlutterColor(_content.foreground));
	String _iconData(int value) => switch (value) { 0 => 'search', 1 => 'sliders-horizontal', 2 => 'inbox', 3 => 'calendar', 4 => 'clipboard-list', 5 => 'archive', 6 => 'chevron-right', 7 => 'folder', 8 => 'file-text', 9 => 'minus', 10 => 'square', 11 => 'copy', 12 => 'x', 13 => 'check', 14 => 'link', 15 => 'info', 16 => 'sparkles', 17 => 'image', 18 => 'music', 19 => 'layout-dashboard', 20 => 'lightbulb', 21 => 'calendar-check', _ => throw StateError('Unknown workspace icon: $value') };
	TextStyle _textStyle({KlpColor? color}) => klpFlutterTextStyle(_content.textStyle).copyWith(color: klpFlutterColor(color ?? _content.foreground));

	KlpId _scopeId(KlpPlacementId placement) {
		final segments = <String>[for (final value in placement.scope) ...value.split('.'), ...placement.localId.split('.')];
		return KlpId.from(segments);
	}
}

final class _AnchoredPopupLayout extends SingleChildLayoutDelegate {
	final Rect anchor;
	final TextDirection direction;
	final double inset;

	const _AnchoredPopupLayout({required this.anchor, required this.direction, required this.inset});

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints(maxWidth: math.max(0, constraints.maxWidth - inset * 2), maxHeight: math.max(0, constraints.maxHeight - inset * 2));

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final start = direction == TextDirection.ltr ? anchor.left : anchor.right - childSize.width;
		final below = size.height - inset - anchor.bottom;
		final top = childSize.height > below ? anchor.top - childSize.height : anchor.bottom;
		final maxX = math.max(inset, size.width - inset - childSize.width);
		final maxY = math.max(inset, size.height - inset - childSize.height);
		return Offset(start.clamp(inset, maxX), top.clamp(inset, maxY));
	}

	@override
	bool shouldRelayout(_AnchoredPopupLayout oldDelegate) => oldDelegate.anchor != anchor || oldDelegate.direction != direction || oldDelegate.inset != inset;
}
