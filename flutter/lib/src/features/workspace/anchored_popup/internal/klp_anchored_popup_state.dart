part of '../klp_anchored_popup.dart';

final class _KlpAnchoredPopupState extends State<KlpAnchoredPopup> {
	final OverlayPortalController _overlay = OverlayPortalController();
	final _KlpWorkspaceCommandRouteOwner _commandRoutes = _KlpWorkspaceCommandRouteOwner();
	final FocusNode _triggerFocus = FocusNode(debugLabel: 'KlpAnchoredPopup trigger');
	final FocusScopeNode _panelFocus = FocusScopeNode(debugLabel: 'KlpAnchoredPopup panel');
	var _generation = 0;
	var _anchorUnavailableSent = false;

	@override
	void initState() {
		super.initState();
		_scheduleOverlay(widget.open, focusPanel: widget.open);
	}

	@override
	void didUpdateWidget(KlpAnchoredPopup oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.open == widget.open) return;

		_generation++;
		if (widget.open) {
			_anchorUnavailableSent = false;
		}
		else {
			_commandRoutes.dismiss();
		}
		_scheduleOverlay(widget.open, focusPanel: widget.open, restoreTrigger: !widget.open);
	}

	@override
	void dispose() {
		_generation++;
		_commandRoutes.dismiss();
		_triggerFocus.dispose();
		_panelFocus.dispose();
		super.dispose();
	}

	void _scheduleOverlay(bool open, {bool focusPanel = false, bool restoreTrigger = false}) {
		WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
			if (!mounted || widget.open != open) return;

			if (open) {
				_overlay.show();
				if (focusPanel) WidgetsBinding.instance.addPostFrameCallback((timeStamp) => _focusFirstControl());
			}
			else {
				_overlay.hide();
				if (restoreTrigger && _triggerFocus.canRequestFocus) _triggerFocus.requestFocus();
			}
		});
	}

	void _focusFirstControl() {
		if (!mounted || !widget.open) return;
		_panelFocus.requestFocus();
		if (_hasEnabledControl) _panelFocus.nextFocus();
	}

	bool get _hasEnabledControl {
		final item = widget.items?.any((item) => item.enabled && (item.onPressed != null || item.commands.any((command) => command.enabled))) ?? false;
		final action = widget.actions?.any((command) => command.enabled) ?? false;
		return item || action;
	}

	void _request(KlpAnchoredPopupChangeReason reason) {
		widget.onOpenChanged(!widget.open, reason);
	}

	void _requestClose(KlpAnchoredPopupChangeReason reason) {
		if (widget.open) widget.onOpenChanged(false, reason);
	}

	void _toggleFromTrigger() {
		if (_triggerFocus.canRequestFocus) _triggerFocus.requestFocus();
		_request(KlpAnchoredPopupChangeReason.trigger);
	}

	KeyEventResult _handleTriggerKey(FocusNode node, KeyEvent event) {
		if (!node.hasPrimaryFocus || event is! KeyDownEvent) return KeyEventResult.ignored;
		if (event.logicalKey != LogicalKeyboardKey.enter && event.logicalKey != LogicalKeyboardKey.space) return KeyEventResult.ignored;

		_toggleFromTrigger();
		return KeyEventResult.handled;
	}

	bool _isActive(int generation) {
		return mounted && generation == _generation && widget.open;
	}

	void _reportAnchorUnavailable() {
		if (_anchorUnavailableSent) return;
		_anchorUnavailableSent = true;
		_commandRoutes.dismiss();
		WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
			if (!mounted || !widget.open) return;
			widget.onOpenChanged(false, KlpAnchoredPopupChangeReason.anchorUnavailable);
		});
	}

	Future<void> _invokeItem(KlpAnchoredPopupItem item) async {
		if (!item.enabled || item.onPressed == null) return;
		try {
			await item.onPressed!();
		}
		catch (error, stackTrace) {
			FlutterError.reportError(
				FlutterErrorDetails(
					exception: error,
					stack: stackTrace,
					library: 'Kallopis anchored popup',
				),
			);
		}
	}

	void _runCommand(BuildContext context, KlpWorkspaceCommand command) {
		final generation = _generation;
		unawaited(
			_runKlpWorkspaceCommand(
				context,
				command,
				() => _isActive(generation),
				routeOwner: _commandRoutes,
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		final direction = Directionality.of(context);
		return CallbackShortcuts(
			bindings: {
				const SingleActivator(LogicalKeyboardKey.escape): () => _requestClose(KlpAnchoredPopupChangeReason.escape),
			},
			child: OverlayPortal.overlayChildLayoutBuilder(
				controller: _overlay,
				overlayChildBuilder: (context, info) => _overlayChild(context, info, direction),
				child: Focus(
					focusNode: _triggerFocus,
					onKeyEvent: _handleTriggerKey,
					child: Semantics(
						expanded: widget.open,
						child: widget.triggerBuilder(context, _toggleFromTrigger, widget.open),
					),
				),
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

		final geometry = context.klp.geometry.layout;
		final inset = geometry.overlayViewportInset;
		final width = math.max(0.0, math.min(geometry.commandMenuWidth, info.overlaySize.width - inset * 2));
		return Stack(
			children: [
				for (final rect in _barrierRects(anchor, info.overlaySize))
					Positioned.fromRect(
						rect: rect,
						child: ExcludeSemantics(
							child: GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: () => _requestClose(KlpAnchoredPopupChangeReason.outside),
							),
						),
					),
				CustomSingleChildLayout(
					delegate: _KlpAnchoredPopupLayout(anchor: anchor, direction: direction, inset: inset),
					child: SizedBox(
						width: width,
						child: _KlpAnchoredPopupPanel(
							content: widget,
							focusScopeNode: _panelFocus,
							onInvokeItem: (item) => unawaited(_invokeItem(item)),
							onRunCommand: _runCommand,
						),
					),
				),
			],
		);
	}

	bool _validAnchor(Rect anchor, Size overlaySize) {
		return !anchor.isEmpty &&
			anchor.left.isFinite &&
			anchor.top.isFinite &&
			anchor.right.isFinite &&
			anchor.bottom.isFinite &&
			anchor.overlaps(Offset.zero & overlaySize);
	}

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
}
