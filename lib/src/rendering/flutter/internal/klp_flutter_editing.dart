import 'package:kallopis/src/features/editing/presentation/klp_editing_presentation.dart';
import 'package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart';
import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_drawing.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_interaction.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_intent.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_layout.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_point_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_reply.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_viewport.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_item.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editor_mode_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_item.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_drop_preview.dart';
import 'package:kallopis/src/capabilities/editing/klp_block_drop_target.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_block_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_projection.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_editing_save_request.dart';
import 'package:kallopis/src/capabilities/editing/contracts/klp_text_offsets.dart';
import 'package:kallopis/src/capabilities/state/klp_subscription.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/foundation/klp_icon_data.dart';
import 'package:kallopis/src/foundation/klp_icons.dart';
import 'klp_flutter_control.dart';
import 'klp_flutter_block_state_control.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_editing_painter.dart';
import 'klp_flutter_text_input_batch.dart';
import 'klp_flutter_text_input_session.dart';
import 'klp_editing_command_sequence.dart';
import 'klp_flutter_block_control_session.dart';
import 'klp_anchored_command_session.dart';
import 'klp_editor_mode_session.dart';
import '../klp_viewport_capabilities.dart';

/// 監看權威繪圖；可編輯來源才在庫內取得焦點、平台輸入與 viewport 排版。
final class KlpFlutterEditing extends StatefulWidget {
	final KlpBoundEditing content;

	const KlpFlutterEditing({required this.content, super.key});

	@override
	State<KlpFlutterEditing> createState() => _KlpFlutterEditingState();
}

final class _KlpFlutterEditingState extends State<KlpFlutterEditing> with DeltaTextInputClient, WidgetsBindingObserver implements KlpEditingInteraction {
	final FocusNode _focus = FocusNode(debugLabel: 'Kallopis editing');
	final GlobalKey _surface = GlobalKey(debugLabel: 'Kallopis editing surface');
	late KlpEditingDrawing _drawing;
	late KlpSubscription _subscription;
	KlpEditingInteractionBinding? _interactionBinding;
	KlpFlutterTextInputSession? _input;
	KlpFlutterTextInputBatch? _batch;
	KlpFlutterBlockControlSession? _blockControls;
	KlpAnchoredCommandSession? _anchoredCommands;
	KlpEditorModeSession? _modeToolbar;
	KlpSubscription? _saveSubscription;
	KlpEditingSaveProjection? _saveProjection;
	TextInputConnection? _connection;
	TextEditingValue _value = TextEditingValue.empty;
	KlpEditingLayout? _requestedLayout;
	KlpEditingLayout? _pendingLayout;
	Future<void>? _interruption;
	Future<void>? _detachment;
	late KlpEditingHostFailureSink _onEditingHostFailure;
	bool _layoutScheduled = false;
	bool _inputBusy = false;
	bool _controlBusy = false;
	bool _moreOpen = false;
	bool _blockToolsOpen = false;
	bool _blockKindsOpen = false;
	String? _hoverBlockId;
	String? _dragBlockId;
	Offset? _dragPointer;
	double _dragGrabOffsetY = 0;
	bool _keyboardDrop = false;
	Timer? _dragAutoScrollTimer;
	double _dragAutoScrollDelta = 0;
	bool _dragAutoScrollBusy = false;
	List<_KlpControlAction> _overflowActions = const [];
	FocusNode? _moreReturnFocus;
	Completer<void>? _operationSettled;
	bool _disposed = false;
	bool _active = true;
	int _generation = 0;

	@override
	void initState() {
		super.initState();
		WidgetsBinding.instance.addObserver(this);
		_focus.addListener(_handleFocus);
		_subscribe();
		_bindInteraction();
		_bindBlockControls();
		_bindAnchoredCommands();
		_bindModeToolbar();
		_bindSave();
	}

	@override
	void didChangeDependencies() {
		super.didChangeDependencies();

		// 掛載時擷取唯一宿主通道，非同步釋放不得再查詢 context。
		final capabilities = KlpViewportCapabilities.of(context);
		if (capabilities == null) throw StateError('Editing requires application viewport capabilities');

		_onEditingHostFailure = capabilities.onEditingHostFailure;
	}

	@override
	void activate() {
		super.activate();
		_active = true;
	}

	@override
	void deactivate() {
		// 圖層移除可能同步觸發回呼，先阻止對 inactive Element 查詢幾何。
		_active = false;
		super.deactivate();
	}

	@override
	void didUpdateWidget(KlpFlutterEditing oldWidget) {
		super.didUpdateWidget(oldWidget);
		final actionsChanged = !identical(oldWidget.content.actions, widget.content.actions);
		if (!identical(oldWidget.content.drawing, widget.content.drawing)) {
			_subscription.cancel();
			_subscribe();
		}
		else {
			_drawing = widget.content.drawing.value;
		}
		if (actionsChanged) {
			_discardMore();
			_discardBlockDrag();
			_blockControls?.close();
			_blockControls = null;
			_anchoredCommands?.dispose();
			_anchoredCommands = null;
			_modeToolbar?.close();
			_modeToolbar = null;
			final generation = ++_generation;
			unawaited(_replaceInteraction(generation));
		}
		if (!actionsChanged && !identical(oldWidget.content.blockControls, widget.content.blockControls)) {
			_discardBlockDrag();
			_blockControls?.close();
			_bindBlockControls();
		}
		if (!actionsChanged && !identical(oldWidget.content.anchoredCommands, widget.content.anchoredCommands)) {
			_discardMore();
			_anchoredCommands?.dispose();
			_bindAnchoredCommands();
		}
		if (!actionsChanged && !identical(oldWidget.content.modeToolbar, widget.content.modeToolbar)) {
			_modeToolbar?.close();
			_bindModeToolbar();
		}
		if (!identical(oldWidget.content.saveActions, widget.content.saveActions)) {
			_saveSubscription?.cancel();
			_bindSave();
		}
	}

	Future<void> _replaceInteraction(int generation) async {
		await _detachInteraction();
		if (_disposed || generation != _generation) return;

		// 只讓最新來源取得新局部綁定，不恢復失敗的舊輸入工作階段。
		_detachment = null;
		try {
			_bindInteraction();
			_bindBlockControls();
			_bindAnchoredCommands();
			_bindModeToolbar();
		}
		catch (error, stack) {
			_reportTextFailure(KlpEditingHostPhase.bind, error, stack);
			return;
		}
		if (_focus.hasFocus) await _resumeAndAttach();
	}

	Future<void> _detachInteraction() => _detachment ??= _detachCaptured(_input, _interactionBinding);

	Future<void> _detachCaptured(KlpFlutterTextInputSession? input, KlpEditingInteractionBinding? binding) async {
		final pending = interrupt();
		try {
			await _observeInterruption(pending);
		}
		finally {
			// 先清除符合身分的舊欄位；兩種局部資源各自只釋放一次。
			if (identical(input, _input)) {
				_input = null;
				_batch = null;
			}
			if (identical(binding, _interactionBinding)) _interactionBinding = null;
			if (identical(pending, _interruption)) _interruption = null;

			try {
				try { input?.close(); }
				catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.dispose, error, stack); }
			}
			finally {
				try { binding?.close(); }
				catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.dispose, error, stack); }
			}
		}
	}

	Future<void> _observeInterruption(Future<void> pending) async {
		// 中斷擁有者已回報；生命週期觀察者只接收失敗，不重複回報。
		try { await pending; }
		catch (_) { return; }
	}

	void _reportTextFailure(KlpEditingHostPhase phase, Object error, StackTrace stack) {
		_onEditingHostFailure(KlpEditingHostFailure(origin: KlpEditingHostOrigin.textInput, phase: phase, error: error, stackTrace: stack));
	}

	void _subscribe() {
		_drawing = widget.content.drawing.value;
		_subscription = widget.content.drawing.subscribe((drawing) {
			if (_disposed || identical(_drawing, drawing)) return;
			if (_blockControls?.dropViewportPending != true) _discardBlockDrag();
			setState(() => _drawing = drawing);
			_syncInput(drawing.projection, published: true);
		});
	}

	void _bindInteraction() {
		final actions = widget.content.actions;
		if (actions != null) _interactionBinding = actions.bindInteraction(this);
	}

	void _bindBlockControls() {
		final controls = widget.content.blockControls;
		_blockControls = controls == null ? null : KlpFlutterBlockControlSession(controls, KlpEditingCommandSequence(controls.actions.issueCommandSequence), () => _drawing, interrupt);
	}

	void _bindAnchoredCommands() {
		final commands = widget.content.anchoredCommands;
		_anchoredCommands = commands == null ? null : KlpAnchoredCommandSession(commands, () => _drawing, interrupt);
	}

	void _bindModeToolbar() {
		final toolbar = widget.content.modeToolbar;
		_modeToolbar = toolbar == null ? null : KlpEditorModeSession(toolbar, () => _drawing, interrupt, () {
			if (_disposed) return;
			if (_acceptsTextInput && _focus.hasFocus) unawaited(_resumeAndAttach());
		});
	}

	void _bindSave() {
		final actions = widget.content.saveActions;
		_saveProjection = actions?.saveState.value;
		_saveSubscription = actions?.saveState.subscribe((value) {
			if (_disposed) return;
			setState(() => _saveProjection = value);
		});
	}

	bool get _acceptsTextInput {
		final projection = _drawing.editorModes;
		if (projection == null || projection.transition != KlpEditorModeTransition.ready || _modeToolbar?.pending == true) return widget.content.modeToolbar == null;
		final tool = projection.tools.singleWhere((candidate) => candidate.id == projection.activeToolId);
		return projection.activePurpose == KlpEditorInputPurpose.text && tool.acceptsTextInput;
	}

	@override
	Widget build(BuildContext context) => LayoutBuilder(builder: (context, constraints) {
		final hasControls = widget.content.modeToolbar != null || widget.content.blockControls != null || widget.content.anchoredCommands != null || widget.content.saveActions != null;
		final toolbarHeight = hasControls ? widget.content.style.control.density.height : 0.0;
		final availableHeight = constraints.hasBoundedHeight ? constraints.maxHeight - toolbarHeight : _drawing.height;
		final viewport = KlpEditingViewport(
			width: constraints.hasBoundedWidth && constraints.maxWidth > 0 ? constraints.maxWidth : _drawing.width,
			height: availableHeight > 0 ? availableHeight : _drawing.height,
		);
		final layout = widget.content.layout;
		if (layout != null) _scheduleLayout(KlpEditingLayout(viewport: viewport, style: widget.content.style.core));
		final current = _drawing.width == viewport.width && _drawing.height == viewport.height;
		final routesViewport = klpCanRouteEditorViewport(_drawing, viewport, pending: _modeToolbar?.pending == true);
		final canvas = current ? CustomPaint(painter: KlpFlutterEditingPainter(_drawing, widget.content.style), size: Size(viewport.width, viewport.height)) : const SizedBox.shrink();
		final surface = widget.content.actions == null && widget.content.modeToolbar == null ? canvas : _KlpEditingGeometryReporter(
			key: _surface,
			onComposite: _updateGeometry,
			child: MouseRegion(
				onHover: widget.content.blockControls == null ? null : _updateHoveredBlock,
				child: Listener(
					onPointerSignal: routesViewport ? (event) => _handlePointerSignal(event, viewport) : null,
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTapDown: current && _acceptsTextInput ? _selectPoint : null,
						child: Focus(focusNode: _focus, onKeyEvent: _handleTextKey, child: SizedBox(width: viewport.width, height: viewport.height, child: canvas)),
					),
				),
			),
		);
		if (!hasControls) return surface;
		final height = toolbarHeight + viewport.height;
		final blockControls = _buildBlockControls(context, viewport);
		return MouseRegion(
			onExit: (_) => _clearHoveredBlock(),
			child: SizedBox(
				width: viewport.width,
				height: height,
				child: Stack(clipBehavior: Clip.hardEdge, children: [
				Positioned(left: 0, top: 0, right: 0, height: toolbarHeight, child: _buildToolbar(context, viewport.width)),
				Positioned(left: 0, top: toolbarHeight, width: viewport.width, height: viewport.height, child: Stack(clipBehavior: Clip.hardEdge, children: [
					Positioned.fill(child: surface),
					?blockControls,
				])),
				if (_moreOpen) Positioned.fill(
					top: toolbarHeight,
					child: CustomSingleChildLayout(
						delegate: _KlpAnchoredMenuLayout(_moreAnchor(viewport), widget.content.style.control.density.gap),
						child: _buildMoreMenu(context, viewport.width),
					),
				),
				]),
			),
		);
	});

	Widget _buildToolbar(BuildContext context, double width) {
		final style = widget.content.style.control;
		final labels = KlpLocalizations.of(context);
		final actions = <_KlpControlAction>[];
		final modes = _drawing.editorModes;
		if (modes != null) {
			for (final mode in modes.modes.where((item) => item.enabled && item.purpose != KlpEditorInputPurpose.handwriting)) {
				final tool = modes.tools.where((item) => item.modeId == mode.id && item.enabled).firstOrNull;
				if (tool == null) continue;
				actions.add(_KlpControlAction(
					label: mode.label,
					icon: mode.purpose == KlpEditorInputPurpose.text ? KlpIcons.keyboard : KlpIcons.switchVertical,
					selected: modes.activeModeId == mode.id && modes.activeToolId == tool.id,
					enabled: modes.transition == KlpEditorModeTransition.ready && !_controlBusy,
					action: () => _runControl(() => _modeToolbar!.switchTo(mode.id, tool.id)),
				));
			}
		}
		final blocks = _drawing.blocks;
		if (blocks != null && _blockControls != null) {
			actions.add(_KlpControlAction(label: labels.editorUndoLabel, icon: KlpIcons.refresh, enabled: blocks.canUndo && !_controlBusy, action: () => _runControl(_blockControls!.undo)));
			actions.add(_KlpControlAction(label: labels.editorRedoLabel, icon: KlpIcons.refresh, quarterTurns: 2, enabled: blocks.canRedo && !_controlBusy, action: () => _runControl(_blockControls!.redo)));
		}
		final reserved = 2;
		final visibleCount = ((width / style.density.height).floor() - reserved).clamp(0, actions.length);
		final visible = actions.take(visibleCount);
		_overflowActions = actions.skip(visibleCount).toList(growable: false);
		final save = _saveProjection;
		final canSave = widget.content.saveActions != null && save != null && save.phase != KlpEditingSavePhase.saving && !(save.phase == KlpEditingSavePhase.failed && (!save.outcomeKnown || !save.retryAllowed)) && _drawing.projection.window?.composingStartUtf8 == null && !_controlBusy;
		return Row(children: [
			for (final action in visible) _control(action),
			KlpFlutterControl(style: style, icon: KlpIcons.more, label: labels.editorMoreLabel, selected: _moreOpen, touch: false, enabled: !_controlBusy, action: _toggleMore),
			if (widget.content.saveActions != null) KlpFlutterControl(style: style, icon: KlpIcons.checkSquare, label: labels.editorSaveLabel, selected: save?.phase == KlpEditingSavePhase.saved, touch: false, enabled: canSave, action: _save),
			Expanded(child: ExcludeSemantics(child: Text(_saveStatus(labels), maxLines: 1, overflow: TextOverflow.ellipsis, style: klpFlutterTextStyle(style.text)))),
		]);
	}

	Widget _control(_KlpControlAction action) => KlpFlutterControl(
		style: widget.content.style.control,
		icon: action.icon,
		label: action.label,
		selected: action.selected,
		touch: false,
		enabled: action.enabled,
		action: action.action,
		quarterTurns: action.quarterTurns,
	);

	String _saveStatus(KlpLocalizations labels) {
		final value = _saveProjection;
		if (value == null) return '';
		return switch (value.phase) {
			KlpEditingSavePhase.idle => value.confirmedSavedContentRevision == _drawing.projection.stamp.contentRevision ? labels.editorSavedLabel : labels.editorUnsavedLabel,
			KlpEditingSavePhase.saving => labels.editorSavingLabel,
			KlpEditingSavePhase.saved => labels.editorSavedLabel,
			KlpEditingSavePhase.failed => value.outcomeKnown ? labels.editorSaveFailedLabel : labels.editorSaveUnknownLabel,
		};
	}

	Future<void> _save() async {
		final actions = widget.content.saveActions;
		final state = _saveProjection;
		if (actions == null || state == null) return;
		final retry = state.phase == KlpEditingSavePhase.failed && state.retryAllowed;
		await _runControl(() => actions.submitSave(KlpEditingSaveRequest(
			sequence: actions.issueCommandSequence(),
			expected: _drawing.projection.stamp,
			intent: retry ? KlpEditingSaveIntent.retry : KlpEditingSaveIntent.save,
			expectedStateRevision: retry ? state.stateRevision : null,
			failedJobId: retry ? state.jobId : null,
		)));
	}

	Future<void> _runControl(FutureOr<Object?> Function() operation) async {
		if (_controlBusy || _disposed) return;
		setState(() => _controlBusy = true);
		try { await Future.sync(operation); }
		catch (error) { debugPrint('Kallopis editor control failed: $error'); }
		finally {
			if (!_disposed) setState(() => _controlBusy = false);
		}
	}

	Widget? _buildBlockControls(BuildContext context, KlpEditingViewport viewport) {
		final projection = _drawing.blocks;
		final session = _blockControls;
		if (projection == null || session == null) return null;
		final labels = KlpLocalizations.of(context);
		final controls = <Widget>[];
		final preview = session.dropPreview;
		if (preview != null) controls.add(_buildDropIndicator(projection.blocks, preview, viewport));
		final ghost = _buildDropGhost(projection.blocks, viewport);
		if (ghost != null) controls.add(ghost);
		controls.addAll([
			for (final item in projection.blocks)
				if ((item.taskChecked != null || item.toggleCollapsed != null) && _blockStateVisible(item, viewport)) _buildBlockStateControl(item, session, labels, viewport),
		]);
		final hovered = projection.blocks.where((block) => block.id == _hoverBlockId).firstOrNull;
		final activeId = hovered?.id ?? projection.selectionFocus?.id ?? _drawing.projection.window?.blockId;
		final block = projection.blocks.where((item) => item.id == activeId).firstOrNull;
		if (block != null) controls.add(_buildBlockTools(block, session, labels, viewport));
		return controls.isEmpty ? null : Positioned.fill(child: Focus(
			canRequestFocus: false,
			onKeyEvent: (node, event) => _handleBlockControlKey(event, session),
			child: Stack(clipBehavior: Clip.hardEdge, children: controls),
		));
	}

	Widget _buildBlockStateControl(KlpBlockItem block, KlpFlutterBlockControlSession session, KlpLocalizations labels, KlpEditingViewport viewport) {
		final density = widget.content.style.control.density;
		final left = (block.visualRect.x - density.height).clamp(0.0, math.max(0.0, viewport.width - density.height)).toDouble();
		final top = (block.visualRect.y + (block.visualRect.height - density.height) / 2).clamp(0.0, math.max(0.0, viewport.height - density.height)).toDouble();
		final task = block.taskChecked;
		final collapsed = block.toggleCollapsed;
		return Positioned(
			left: left,
			top: top,
			child: KlpFlutterBlockStateControl(
				style: widget.content.style.control,
				kind: task != null ? KlpFlutterBlockStateKind.task : KlpFlutterBlockStateKind.disclosure,
				label: task != null
					? (task ? labels.editorTaskReopenLabel : labels.editorTaskCompleteLabel)
					: (collapsed! ? labels.editorToggleExpandLabel : labels.editorToggleCollapseLabel),
				active: task ?? collapsed!,
				enabled: !_controlBusy,
				action: () => _runControl(() => task != null ? session.toggleTaskChecked(block.id) : session.toggleCollapsed(block.id)),
			),
		);
	}

	bool _blockStateVisible(KlpBlockItem block, KlpEditingViewport viewport) => block.visualRect.width > 0 && block.visualRect.height > 0 && block.visualRect.x < viewport.width && block.visualRect.x + block.visualRect.width > 0 && block.visualRect.y < viewport.height && block.visualRect.y + block.visualRect.height > 0;

	Widget _buildBlockTools(KlpBlockItem block, KlpFlutterBlockControlSession session, KlpLocalizations labels, KlpEditingViewport viewport) {
		final left = block.visualRect.x.clamp(0.0, viewport.width).toDouble();
		final top = block.visualRect.y.clamp(0.0, math.max(0.0, viewport.height - widget.content.style.control.density.height)).toDouble();
		final openAbove = _blockKindsOpen && top > viewport.height - top - widget.content.style.control.density.height;
		final bottom = viewport.height - top - widget.content.style.control.density.height;
		return Positioned(left: left, top: openAbove ? null : top, bottom: openAbove ? math.max(0.0, bottom) : null, width: viewport.width - left, child: ConstrainedBox(
			constraints: BoxConstraints(maxHeight: openAbove ? viewport.height - math.max(0.0, bottom) : viewport.height - top),
			child: TapRegion(
			onTapOutside: (_) {
				if (!_blockToolsOpen && !_blockKindsOpen) return;
				setState(() { _blockToolsOpen = false; _blockKindsOpen = false; });
			},
			child: Column(mainAxisSize: MainAxisSize.min, verticalDirection: openAbove ? VerticalDirection.up : VerticalDirection.down, crossAxisAlignment: CrossAxisAlignment.start, children: [
				Row(mainAxisSize: MainAxisSize.min, children: [
					GestureDetector(
						onPanStart: block.selected && (block.canMoveBefore || block.canMoveAfter) && !_controlBusy ? (details) => _beginBlockDrag(block, session, details) : null,
						onPanUpdate: block.selected && (block.canMoveBefore || block.canMoveAfter) && !_controlBusy ? (details) => _updateBlockDrag(block, session, viewport, details) : null,
						onPanEnd: block.selected && (block.canMoveBefore || block.canMoveAfter) && !_controlBusy ? (_) => _finishBlockDrag(session) : null,
						onPanCancel: block.selected && (block.canMoveBefore || block.canMoveAfter) && !_controlBusy ? () => _cancelBlockDrag(session) : null,
						child: KlpFlutterControl(
							style: widget.content.style.control,
							icon: KlpIcons.gripVertical,
							label: labels.editorBlockActionsLabel,
							hint: labels.editorBlockMoveHint,
							selected: block.selected,
							touch: false,
							enabled: !_controlBusy,
							action: () => _activateBlock(block),
							onKeyEvent: block.selected ? (node, event) => _handleBlockGripKey(event, block, session) : null,
						),
					),
					if (block.selected && _blockToolsOpen) ...[
						KlpFlutterControl(style: widget.content.style.control, icon: KlpIcons.chevronUp, label: labels.editorMovePreviousLabel, selected: false, touch: false, enabled: block.canMoveBefore && !_controlBusy, action: () => _runControl(() => session.moveBefore(block.id))),
						KlpFlutterControl(style: widget.content.style.control, icon: KlpIcons.chevronDown, label: labels.editorMoveNextLabel, selected: false, touch: false, enabled: block.canMoveAfter && !_controlBusy, action: () => _runControl(() => session.moveAfter(block.id))),
						if (block.textKind != null || _isListBlock(block)) KlpFlutterControl(style: widget.content.style.control, icon: null, caption: labels.editorBlockTypeLabel, label: labels.editorBlockTypeLabel, selected: _blockKindsOpen, touch: false, enabled: !_controlBusy, action: () => setState(() => _blockKindsOpen = !_blockKindsOpen)),
					],
				]),
				if (block.selected && _blockKindsOpen) Flexible(child: SingleChildScrollView(child: _buildBlockKindMenu(labels, block))),
			]),
		)));
	}

	void _beginBlockDrag(KlpBlockItem block, KlpFlutterBlockControlSession session, DragStartDetails details) {
		try {
			session.beginDrop(block.id);
			final pointer = _editorLocal(details.globalPosition);
			final selectedTop = _drawing.blocks!.selectedBlocks.map((item) => item.visualRect.y).reduce(math.min);
			setState(() {
				_dragBlockId = block.id;
				_dragPointer = pointer;
				_dragGrabOffsetY = pointer.dy - selectedTop;
				_keyboardDrop = false;
				_blockToolsOpen = false;
				_blockKindsOpen = false;
			});
		}
		catch (error) { debugPrint('Kallopis block drag failed to begin: $error'); }
	}

	void _updateBlockDrag(KlpBlockItem source, KlpFlutterBlockControlSession session, KlpEditingViewport viewport, DragUpdateDetails details) {
		if (_dragBlockId != source.id || _keyboardDrop) return;
		final pointer = _editorLocal(details.globalPosition);
		try {
			_previewPointerDrop(source.id, session, pointer, viewport);
			_updateDragAutoScroll(pointer, viewport, session);
		}
		catch (error) {
			debugPrint('Kallopis block drag preview failed: $error');
			_cancelBlockDrag(session);
		}
	}

	void _previewPointerDrop(String sourceId, KlpFlutterBlockControlSession session, Offset pointer, KlpEditingViewport viewport) {
		final projection = _drawing.blocks!;
		final candidate = klpResolveBlockDropTarget(blocks: projection.blocks, sourceId: projection.selectionFirst?.id ?? sourceId, sourceEndId: projection.selectionLast?.id, pointerY: pointer.dy, viewportHeight: viewport.height);
		if (candidate == null) {
			session.clearDropPreview();
		}
		else {
			session.previewDrop(candidate.targetId, candidate.placement);
		}
		setState(() => _dragPointer = pointer);
	}

	void _updateDragAutoScroll(Offset pointer, KlpEditingViewport viewport, KlpFlutterBlockControlSession session) {
		final style = widget.content.style;
		final direction = pointer.dy < style.dragAutoScrollEdge.value
			? -1
			: pointer.dy > viewport.height - style.dragAutoScrollEdge.value ? 1 : 0;
		_dragAutoScrollDelta = direction * style.dragAutoScrollStep.value;
		if (_dragAutoScrollDelta == 0) {
			_stopDragAutoScroll();
			return;
		}
		_dragAutoScrollTimer ??= Timer.periodic(Duration(milliseconds: style.dragAutoScrollInterval.milliseconds), (_) => unawaited(_tickDragAutoScroll(session)));
	}

	Future<void> _tickDragAutoScroll(KlpFlutterBlockControlSession session) async {
		final blockId = _dragBlockId;
		final pointer = _dragPointer;
		if (_disposed || _keyboardDrop || _dragAutoScrollBusy || blockId == null || pointer == null || _dragAutoScrollDelta == 0) return;
		_dragAutoScrollBusy = true;
		try {
			final moved = await session.scrollDropViewport(_dragAutoScrollDelta);
			if (!moved) {
				_stopDragAutoScroll();
				return;
			}
			if (_disposed || _dragBlockId != blockId) return;
			_previewPointerDrop(blockId, session, pointer, KlpEditingViewport(width: _drawing.width, height: _drawing.height));
		}
		catch (error) {
			debugPrint('Kallopis block drag auto-scroll failed: $error');
			if (!_disposed && _dragBlockId != null) _cancelBlockDrag(session);
		}
		finally { _dragAutoScrollBusy = false; }
	}

	void _stopDragAutoScroll() {
		_dragAutoScrollTimer?.cancel();
		_dragAutoScrollTimer = null;
		_dragAutoScrollDelta = 0;
	}

	void _finishBlockDrag(KlpFlutterBlockControlSession session) {
		if (_dragBlockId == null) return;
		_stopDragAutoScroll();
		final hasPreview = session.dropPreview != null;
		_clearBlockDragState();
		if (hasPreview) {
			_runControl(session.commitDrop);
		}
		else {
			session.cancelDrop();
		}
	}

	void _cancelBlockDrag(KlpFlutterBlockControlSession session) {
		_stopDragAutoScroll();
		session.cancelDrop();
		_clearBlockDragState();
	}

	KeyEventResult _handleBlockGripKey(KeyEvent event, KlpBlockItem block, KlpFlutterBlockControlSession session) {
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		final keyboard = HardwareKeyboard.instance;
		if (_dragBlockId == null && block.selected && event.logicalKey == LogicalKeyboardKey.tab && !keyboard.isControlPressed && !keyboard.isMetaPressed && !keyboard.isAltPressed) {
			final projection = _drawing.blocks!;
			final outdent = keyboard.isShiftPressed;
			final available = outdent ? projection.selectedBlocks.every((item) => item.canOutdent) : projection.selectionFirst?.canIndent == true;
			if (!available) return KeyEventResult.ignored;
			if (!_controlBusy) _runControl(outdent ? session.outdentSelection : session.indentSelection);
			return KeyEventResult.handled;
		}
		if (_dragBlockId == null && block.selected && HardwareKeyboard.instance.isShiftPressed && (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown)) {
			_extendBlockSelection(session, event.logicalKey == LogicalKeyboardKey.arrowDown ? 1 : -1);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.escape && _dragBlockId == block.id) {
			_cancelBlockDrag(session);
			return KeyEventResult.handled;
		}
		if (event.logicalKey == LogicalKeyboardKey.space || _keyboardDrop && event.logicalKey == LogicalKeyboardKey.enter) {
			if (_dragBlockId == block.id && _keyboardDrop) {
				_finishBlockDrag(session);
			}
			else if (_dragBlockId == null) {
				_beginKeyboardBlockDrag(block, session);
			}
			return KeyEventResult.handled;
		}
		if (_dragBlockId == block.id && _keyboardDrop && (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.arrowDown)) {
			_stepKeyboardBlockDrag(block, session, event.logicalKey == LogicalKeyboardKey.arrowDown ? 1 : -1);
			return KeyEventResult.handled;
		}
		return KeyEventResult.ignored;
	}

	void _beginKeyboardBlockDrag(KlpBlockItem block, KlpFlutterBlockControlSession session) {
		try {
			session.beginDrop(block.id);
			final projection = _drawing.blocks!;
			if (klpBlockDropTargets(projection.blocks, projection.selectionFirst!.id, sourceEndId: projection.selectionLast!.id).isEmpty) {
				session.cancelDrop();
				return;
			}
			setState(() {
				_dragBlockId = block.id;
				final selectedTop = projection.selectedBlocks.map((item) => item.visualRect.y).reduce(math.min);
				final selectedBottom = projection.selectedBlocks.map((item) => item.visualRect.y + item.visualRect.height).reduce(math.max);
				_dragGrabOffsetY = (selectedBottom - selectedTop) / 2;
				_dragPointer = Offset(block.visualRect.x, block.visualRect.y + _dragGrabOffsetY);
				_keyboardDrop = true;
				_blockToolsOpen = false;
				_blockKindsOpen = false;
			});
		}
		catch (error) { debugPrint('Kallopis keyboard block drag failed to begin: $error'); }
	}

	void _stepKeyboardBlockDrag(KlpBlockItem source, KlpFlutterBlockControlSession session, int direction) {
		try {
			final blocks = _drawing.blocks!.blocks;
			final projection = _drawing.blocks!;
			final first = projection.selectionFirst!;
			final targets = klpBlockDropTargets(blocks, first.id, sourceEndId: projection.selectionLast!.id);
			final preview = session.dropPreview;
			final sourceIndex = blocks.indexOf(first);
			KlpBlockDropTarget? target;
			if (preview == null) {
				final candidates = targets.where((item) => direction > 0 ? item.destinationIndex > sourceIndex : item.destinationIndex < sourceIndex);
				target = direction > 0 ? candidates.firstOrNull : candidates.lastOrNull;
			}
			else {
				final current = targets.indexWhere((item) => item.targetId == preview.targetId && item.placement == preview.placement);
				final next = current + direction;
				if (current >= 0 && next >= 0 && next < targets.length) target = targets[next];
			}
			if (target == null) return;
			session.previewDrop(target.targetId, target.placement);
			final targetBlock = blocks.firstWhere((block) => block.id == target!.targetId);
			final edge = target.placement == KlpBlockDropPlacement.before ? targetBlock.hitRect.y : targetBlock.hitRect.y + targetBlock.hitRect.height;
			setState(() => _dragPointer = Offset(source.visualRect.x, edge + _dragGrabOffsetY));
		}
		catch (error) {
			debugPrint('Kallopis keyboard block drag failed to move: $error');
			_cancelBlockDrag(session);
		}
	}

	void _extendBlockSelection(KlpFlutterBlockControlSession session, int direction) {
		final projection = _drawing.blocks!;
		final anchor = projection.selectionAnchor;
		final focus = projection.selectionFocus;
		if (anchor == null || focus == null) return;
		final next = projection.blocks.indexOf(focus) + direction;
		if (next < 0 || next >= projection.blocks.length) return;
		_runControl(() => session.selectRange(anchor.id, projection.blocks[next].id));
	}

	KeyEventResult _handleBlockControlKey(KeyEvent event, KlpFlutterBlockControlSession session) {
		if (event is! KeyDownEvent || event.logicalKey != LogicalKeyboardKey.escape || _dragBlockId == null) return KeyEventResult.ignored;
		_cancelBlockDrag(session);
		return KeyEventResult.handled;
	}

	void _discardBlockDrag() {
		_stopDragAutoScroll();
		_blockControls?.cancelDrop();
		_dragBlockId = null;
		_dragPointer = null;
		_dragGrabOffsetY = 0;
		_keyboardDrop = false;
	}

	void _clearBlockDragState() {
		if (_dragBlockId == null && _dragPointer == null) return;
		setState(() {
			_dragBlockId = null;
			_dragPointer = null;
			_dragGrabOffsetY = 0;
			_keyboardDrop = false;
		});
	}

	Offset _editorLocal(Offset global) {
		final render = _surface.currentContext?.findRenderObject();
		if (render is! RenderBox || !render.attached) throw StateError('Editing surface geometry is unavailable');
		return render.globalToLocal(global);
	}

	Widget _buildDropIndicator(List<KlpBlockItem> blocks, KlpBlockDropPreview preview, KlpEditingViewport viewport) {
		final target = blocks.firstWhere((block) => block.id == preview.targetId);
		final stroke = widget.content.style.control.density.focusStroke;
		final left = target.visualRect.x.clamp(0.0, viewport.width).toDouble();
		final right = (target.visualRect.x + target.visualRect.width).clamp(left, viewport.width).toDouble();
		final edge = preview.placement == KlpBlockDropPlacement.before ? target.hitRect.y : target.hitRect.y + target.hitRect.height;
		final top = (edge - stroke / 2).clamp(0.0, math.max(0.0, viewport.height - stroke)).toDouble();
		return Positioned(left: left, top: top, width: right - left, height: stroke, child: IgnorePointer(child: ColoredBox(color: klpFlutterColor(widget.content.style.control.focus))));
	}

	Widget? _buildDropGhost(List<KlpBlockItem> blocks, KlpEditingViewport viewport) {
		final blockId = _dragBlockId;
		final pointer = _dragPointer;
		if (blockId == null || pointer == null) return null;
		final source = blocks.where((block) => block.id == blockId).firstOrNull;
		final selected = blocks.where((block) => block.selected && block.visualRect.width > 0 && block.visualRect.height > 0).toList(growable: false);
		if (source == null || selected.isEmpty) return null;
		final sourceLeft = selected.map((block) => block.visualRect.x).reduce(math.min);
		final sourceRight = selected.map((block) => block.visualRect.x + block.visualRect.width).reduce(math.max);
		final sourceTop = selected.map((block) => block.visualRect.y).reduce(math.min);
		final sourceBottom = selected.map((block) => block.visualRect.y + block.visualRect.height).reduce(math.max);
		final left = sourceLeft.clamp(0.0, viewport.width).toDouble();
		final width = (sourceRight - sourceLeft).clamp(0.0, math.max(0.0, viewport.width - left)).toDouble();
		final height = (sourceBottom - sourceTop).clamp(0.0, viewport.height).toDouble();
		final top = (pointer.dy - _dragGrabOffsetY).clamp(0.0, math.max(0.0, viewport.height - height)).toDouble();
		final style = widget.content.style.control;
		return Positioned(
			left: left,
			top: top,
			width: width,
			height: height,
			child: IgnorePointer(child: ExcludeSemantics(child: DecoratedBox(decoration: BoxDecoration(
				color: klpFlutterColor(style.background),
				borderRadius: BorderRadius.circular(style.radius.value),
				border: Border.all(color: klpFlutterColor(style.focus), width: style.density.focusStroke),
			)))),
		);
	}

	void _activateBlock(KlpBlockItem block) {
		final projection = _drawing.blocks;
		final anchor = projection?.selectionAnchor;
		if (HardwareKeyboard.instance.isShiftPressed && anchor != null) {
			_runControl(() async {
				final reply = await _blockControls!.selectRange(anchor.id, block.id);
				if (reply.decision == KlpEditingDecision.accepted && !_disposed) setState(() => _blockToolsOpen = true);
				return reply;
			});
			return;
		}
		if (block.selected) {
			setState(() { _blockToolsOpen = !_blockToolsOpen; _blockKindsOpen = false; });
			return;
		}
		_runControl(() async {
			final reply = await _blockControls!.select(block.id);
			if (reply.decision == KlpEditingDecision.accepted && !_disposed) setState(() => _blockToolsOpen = true);
			return reply;
		});
	}

	void _updateHoveredBlock(PointerHoverEvent event) {
		if (_dragBlockId != null) return;
		final blocks = _drawing.blocks?.blocks;
		if (blocks == null) return;
		final position = event.localPosition;
		final hovered = blocks.where((block) => position.dx >= block.hitRect.x && position.dx <= block.hitRect.x + block.hitRect.width && position.dy >= block.hitRect.y && position.dy <= block.hitRect.y + block.hitRect.height).firstOrNull?.id;
		if (hovered == _hoverBlockId) return;
		setState(() {
			_hoverBlockId = hovered;
			_blockToolsOpen = false;
			_blockKindsOpen = false;
		});
	}

	void _clearHoveredBlock() {
		if (_hoverBlockId == null || _dragBlockId != null) return;
		setState(() => _hoverBlockId = null);
	}

	Widget _buildBlockKindMenu(KlpLocalizations labels, KlpBlockItem block) => _menuSurface([
		for (final kind in KlpBlockTextKind.values) KlpFlutterControl(
			style: widget.content.style.control, icon: null, caption: _blockKindLabel(labels, kind), label: _blockKindLabel(labels, kind),
			selected: block.textKind == kind, touch: false, enabled: !_controlBusy && (kind == KlpBlockTextKind.paragraph && _listSelectionSupported || block.textKind != null && _drawing.blocks!.selectedBlocks.length == 1),
			action: () {
				setState(() => _blockKindsOpen = false);
				_runControl(() => kind == KlpBlockTextKind.paragraph && _listSelectionSupported ? _blockControls!.convertSelectionToParagraph() : _blockControls!.convert(block.id, kind));
			},
		),
		_listMenuAction(labels.editorUnorderedListLabel, _blockControls!.convertSelectionToUnorderedList, enabled: _listSelectionSupported),
		_listMenuAction(labels.editorOrderedListLabel, _blockControls!.convertSelectionToOrderedList, enabled: _listSelectionSupported),
		_listMenuAction(labels.editorIndentLabel, _blockControls!.indentSelection, enabled: _drawing.blocks!.selectionFirst?.canIndent == true),
		_listMenuAction(labels.editorOutdentLabel, _blockControls!.outdentSelection, enabled: _drawing.blocks!.selectedBlocks.every((item) => item.canOutdent)),
	]);

	bool _isListBlock(KlpBlockItem block) => block.kind == KlpBlockKind.unorderedListItem || block.kind == KlpBlockKind.orderedListItem;
	bool get _listSelectionSupported => _drawing.blocks!.selectedBlocks.isNotEmpty && _drawing.blocks!.selectedBlocks.every((block) => block.kind == KlpBlockKind.paragraph || _isListBlock(block));

	Widget _listMenuAction(String label, Future<KlpEditingReply> Function() action, {bool enabled = true}) => KlpFlutterControl(
		style: widget.content.style.control, icon: null, caption: label, label: label,
		selected: false, touch: false, enabled: enabled && !_controlBusy,
		action: () {
			setState(() => _blockKindsOpen = false);
			_runControl(action);
		},
	);

	String _blockKindLabel(KlpLocalizations labels, KlpBlockTextKind kind) => switch (kind) {
		KlpBlockTextKind.paragraph => labels.editorParagraphLabel,
		KlpBlockTextKind.heading1 => labels.editorHeading1Label,
		KlpBlockTextKind.heading2 => labels.editorHeading2Label,
		KlpBlockTextKind.heading3 => labels.editorHeading3Label,
	};

	void _toggleMore() {
		if (_moreOpen) {
			_closeMore();
			return;
		}
		unawaited(_openMore());
	}

	Future<void> _openMore() async {
		try {
			_moreReturnFocus = FocusManager.instance.primaryFocus;
			final commands = _anchoredCommands;
			if (commands != null && !commands.opened) await commands.open();
			if (!_disposed) setState(() => _moreOpen = true);
		}
		catch (error) {
			_moreReturnFocus = null;
			debugPrint('Kallopis command menu failed to open: $error');
		}
	}

	void _closeMore() {
		_anchoredCommands?.close();
		if (_moreOpen) setState(() => _moreOpen = false);
		final target = _moreReturnFocus;
		_moreReturnFocus = null;
		if (target?.canRequestFocus == true) {
			target!.requestFocus();
		}
		else if (_focus.canRequestFocus) {
			_focus.requestFocus();
		}
	}

	void _discardMore() {
		_moreOpen = false;
		_moreReturnFocus = null;
	}

	Rect _moreAnchor(KlpEditingViewport viewport) {
		final anchor = _anchoredCommands?.projection?.anchor.rect;
		if (anchor != null) return Rect.fromLTWH(anchor.x, anchor.y, anchor.width, anchor.height);
		final extent = widget.content.style.control.density.height;
		return Rect.fromLTWH(viewport.width - extent, -extent, extent, extent);
	}

	Widget _buildMoreMenu(BuildContext context, double maximumWidth) {
		final commands = _anchoredCommands;
		final items = commands?.projection?.items ?? const [];
		return TapRegion(
			onTapOutside: (_) => _closeMore(),
			child: Focus(
				autofocus: true,
				onKeyEvent: (_, event) => _handleMoreKey(event),
				child: ConstrainedBox(constraints: BoxConstraints(maxWidth: maximumWidth), child: _menuSurface([
					for (final action in _overflowActions) _control(action),
					for (final item in items) KlpFlutterControl(
						style: widget.content.style.control, icon: null, caption: item.caption ?? item.label, label: item.label,
						selected: commands?.highlightedId == item.id, touch: false, enabled: item.enabled && !_controlBusy,
						action: () => _confirmCommand(item.id),
					),
				])),
			),
		);
	}

	Widget _menuSurface(List<Widget> children) => Container(
		decoration: BoxDecoration(color: klpFlutterColor(widget.content.style.control.background), borderRadius: BorderRadius.circular(widget.content.style.control.radius.value)),
		child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: children),
	);

	KeyEventResult _handleMoreKey(KeyEvent event) {
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		final commands = _anchoredCommands;
		try {
			if (event.logicalKey == LogicalKeyboardKey.escape) { _closeMore(); return KeyEventResult.handled; }
			if (commands == null) return KeyEventResult.ignored;
			if (event.logicalKey == LogicalKeyboardKey.arrowDown) { commands.next(); }
			else if (event.logicalKey == LogicalKeyboardKey.arrowUp) { commands.previous(); }
			else if (event.logicalKey == LogicalKeyboardKey.home) { commands.home(); }
			else if (event.logicalKey == LogicalKeyboardKey.end) { commands.end(); }
			else if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.space) { unawaited(_confirmHighlighted()); return KeyEventResult.handled; }
			else { return KeyEventResult.ignored; }
			setState(() {});
			return KeyEventResult.handled;
		}
		catch (error) {
			debugPrint('Kallopis command menu navigation failed: $error');
			return KeyEventResult.handled;
		}
	}

	Future<void> _confirmCommand(String id) async {
		final commands = _anchoredCommands;
		if (commands == null) return;
		commands.select(id);
		await _confirmHighlighted();
	}

	Future<void> _confirmHighlighted() async {
		final commands = _anchoredCommands;
		if (commands == null) return;
		await _runControl(commands.confirm);
		if (!_disposed) _closeMore();
	}

	void _handlePointerSignal(PointerSignalEvent event, KlpEditingViewport viewport) {
		if (event is! PointerScrollEvent || event.scrollDelta.dy == 0) return;
		final toolbar = _modeToolbar;
		if (toolbar == null || !klpCanRouteEditorViewport(_drawing, viewport, pending: toolbar.pending)) return;
		unawaited(_navigateViewport(toolbar, event.scrollDelta.dy));
	}

	Future<void> _navigateViewport(KlpEditorModeSession toolbar, double deltaY) async {
		try { await toolbar.navigateBy(deltaY); }
		catch (error) { debugPrint('Kallopis viewport navigation failed: $error'); }
	}

	void _scheduleLayout(KlpEditingLayout requested) {
		if (_requestedLayout?.viewport == requested.viewport && _requestedLayout?.style == requested.style) return;
		_pendingLayout = requested;
		if (_layoutScheduled) return;

		_layoutScheduled = true;
		WidgetsBinding.instance.addPostFrameCallback((_) {
			_layoutScheduled = false;
			if (_disposed) return;
			final next = _pendingLayout;
			if (next == null) return;

			_pendingLayout = null;
			try {
				widget.content.layout!.layout(next);
				_requestedLayout = next;
			}
			catch (error) {
				debugPrint('Kallopis editing layout failed: $error');
			}
			if (_pendingLayout != null) _scheduleLayout(_pendingLayout!);
		});
	}

	Future<void> _selectPoint(TapDownDetails details) async {
		if (_inputBusy || _disposed || _detachment != null || !_acceptsTextInput) return;

		final actions = widget.content.actions;
		if (actions == null) return;

		final generation = _generation;
		final input = _input;
		final prior = _interruption;
		if (prior != null) {
			try { await prior; }
			catch (_) { return; }

			if (!_isCurrentInput(generation, input) || !identical(prior, _interruption)) return;
		}
		try {
			if (prior != null) {
				input?.resume();
				input?.resynchronize(_drawing.projection);
				_interruption = null;
			}
		}
		catch (error, stack) {
			_reportTextFailure(KlpEditingHostPhase.input, error, stack);
			return;
		}

		_inputBusy = true;
		final settled = Completer<void>();
		_operationSettled = settled;
		try {
			// 平台選取等待權威回覆，來源失效後不得使用回覆接續輸入。
			final reply = await actions.selectPoint(KlpEditingPointRequest(expected: _drawing.projection.stamp, x: details.localPosition.dx, y: details.localPosition.dy));
			if (!_isCurrentInput(generation, input) || _interruption != null || reply.decision != KlpEditingDecision.accepted) return;

			_resynchronize(reply.projection);
		}
		catch (error, stack) {
			_reportTextFailure(KlpEditingHostPhase.input, error, stack);
			return;
		}
		finally {
			_finishInputOperation(settled, generation);
		}
		if (!_isCurrentInput(generation, input) || _interruption != null) return;

		// 操作已結束才要求焦點，避免與等待這個操作的中斷互相等待。
		_focus.requestFocus();
		await _resumeAndAttach();
	}

	void _handleFocus() {
		if (_disposed) return;

		if (_focus.hasFocus) {
			unawaited(_resumeAndAttach());
		}
		else {
			unawaited(_observeInterruption(interrupt()));
		}
	}

	Future<void> _resumeAndAttach() async {
		if (_disposed || _detachment != null || !_focus.hasFocus || !_acceptsTextInput) return;

		final generation = _generation;
		final input = _input;
		final actions = widget.content.actions;
		final prior = _interruption;
		if (prior != null) {
			try { await prior; }
			catch (_) { return; }

			if (!_isCurrentInput(generation, input) || !_focus.hasFocus || !identical(prior, _interruption) || !_acceptsTextInput) return;
		}
		try {
			if (prior != null) {
				input?.resume();
				input?.resynchronize(_drawing.projection);
				_interruption = null;
			}
			if (actions == null || _drawing.projection.window == null || _inputBusy) return;

			_input ??= KlpFlutterTextInputSession(_drawing.projection, (request) => actions.submit(request, committedAtMs: DateTime.now().millisecondsSinceEpoch), sequence: KlpEditingCommandSequence(actions.issueCommandSequence));
			_batch ??= KlpFlutterTextInputBatch(_input!);
			_value = _editingValue(_input!.projection);
			if (!mounted) return;

			// 唯有仍存活的來源可建立平台文字連線。
			final configuration = TextInputConfiguration(
				viewId: View.of(context).viewId,
				inputType: TextInputType.multiline,
				inputAction: TextInputAction.newline,
				enableSuggestions: true,
				autocorrect: true,
				enableDeltaModel: true,
			);
			_connection ??= TextInput.attach(this, configuration);
			_connection!..setEditingState(_value)..show();
			setState(() {});
		}
		catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.input, error, stack); }
	}

	@override
	Future<void> interrupt() => _interruption ??= _interrupt();

	Future<void> _interrupt() async {
		final connection = _connection;
		final input = _input;
		final generation = _generation;
		final pending = _operationSettled?.future;
		try {
			// 立即停止工作階段後續選取；工作階段自身等待在途命令才取消組字。
			final interrupted = input?.interrupt();
			await pending;
			if (interrupted != null) {
				final result = await interrupted;
				if (!result.synchronized) Error.throwWithStackTrace(result.error ?? StateError('Editing interruption was not synchronized'), result.stackTrace ?? StackTrace.current);

				if (_isCurrentInput(generation, input)) _value = _editingValue(result.projection);
			}
		}
		catch (error, stack) {
			_reportTextFailure(KlpEditingHostPhase.interrupt, error, stack);
			rethrow;
		}
		finally {
			if (identical(connection, _connection)) _connection = null;

			// 平台連線與本地 binding 分開釋放，關閉失敗不遮蔽原始中斷失敗。
			try { connection?.close(); }
			catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.dispose, error, stack); }
		}
	}

	bool _isCurrentInput(int generation, KlpFlutterTextInputSession? input) => !_disposed && generation == _generation && _detachment == null && identical(input, _input);

	void _finishInputOperation(Completer<void> settled, int generation) {
		if (!settled.isCompleted) settled.complete();
		if (!identical(settled, _operationSettled)) return;

		_inputBusy = false;
		_operationSettled = null;
		if (_disposed || generation != _generation || _detachment != null) return;

		// 命令回覆可能先於繪圖發布；收尾不可把快取的舊投影重播至較新權威。
		final projection = _drawing.projection;
		final current = _input?.projection.stamp;
		if (current != null && current.sameSession(projection.stamp) && projection.stamp.projectionRevision < current.projectionRevision) return;

		_syncInput(projection);
	}

	@override
	void updateEditingValueWithDeltas(List<TextEditingDelta> deltas) {
		if (_inputBusy || _interruption != null || _disposed || _detachment != null || !_acceptsTextInput) {
			_connection?.setEditingState(_value);
			return;
		}
		_inputBusy = true;
		final settled = Completer<void>();
		_operationSettled = settled;
		final generation = _generation;
		unawaited(_applyDeltas(deltas, generation).whenComplete(() => _finishInputOperation(settled, generation)));
	}

	Future<void> _applyDeltas(List<TextEditingDelta> deltas, int generation) async {
		final batch = _batch;
		if (batch == null) return;

		final input = _input;
		final connection = _connection;
		try {
			final result = await batch.submit(deltas, interrupted: () => !_isCurrentInput(generation, input) || _interruption != null, onStep: (result) {
				if (!_isCurrentInput(generation, input) || _interruption != null) return;

				_value = _editingValue(result.projection);
				if (identical(connection, _connection)) connection?.setEditingState(_value);
			});
			final error = result?.error;
			if (error != null) _reportTextFailure(KlpEditingHostPhase.input, error, result!.stackTrace ?? StackTrace.current);
		}
		catch (error, stack) {
			_reportTextFailure(KlpEditingHostPhase.input, error, stack);
		}
	}

	void _syncInput(KlpEditingProjection projection, {bool published = false}) {
		final input = _input;
		if (_disposed || _detachment != null || input == null || _inputBusy || _interruption != null) return;

		// 明確發布即使版本相同仍須驗證並重新同步；快取不得用來解除未知結果。
		if (!published && input.projection.stamp == projection.stamp) return;

		try { _resynchronize(projection); }
		catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.input, error, stack); }
	}

	void _resynchronize(KlpEditingProjection projection) {
		_input?.resynchronize(projection);
		_value = _editingValue(projection);
		_connection?.setEditingState(_value);
	}

	KeyEventResult _handleTextKey(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || _disposed || _inputBusy || _interruption != null || !_acceptsTextInput) return KeyEventResult.ignored;
		final keyboard = HardwareKeyboard.instance;
		if (keyboard.isControlPressed || keyboard.isAltPressed || keyboard.isMetaPressed) return KeyEventResult.ignored;
		final projection = _drawing.projection;
		final window = projection.window;
		if (window == null || window.composingStartUtf8 != null || window.anchorUtf8 != window.focusUtf8) return KeyEventResult.ignored;
		if (event.logicalKey == LogicalKeyboardKey.backspace && window.anchorUtf8 == 0) {
			unawaited(_submitEditingCommand(KlpEditingCommand.backspace));
			return KeyEventResult.handled;
		}
		if (event.logicalKey != LogicalKeyboardKey.tab) return KeyEventResult.ignored;
		final block = _drawing.blocks?.blocks.where((item) => item.id == window.blockId).firstOrNull;
		if (block == null || !_isListBlock(block)) return KeyEventResult.ignored;

		unawaited(_submitEditingCommand(keyboard.isShiftPressed ? KlpEditingCommand.outdentList : KlpEditingCommand.indentList));
		return KeyEventResult.handled;
	}

	Future<void> _submitEditingCommand(KlpEditingCommand command) async {
		final actions = widget.content.actions;
		final window = _drawing.projection.window;
		if (actions == null || window == null || _inputBusy || _interruption != null || _disposed || _detachment != null || !_acceptsTextInput) return;
		if (window.composingStartUtf8 != null || window.anchorUtf8 != window.focusUtf8) return;

		final generation = _generation;
		final input = _input;
		_inputBusy = true;
		final settled = Completer<void>();
		_operationSettled = settled;
		try {
			final reply = await actions.submit(KlpEditingRequest(
				sequence: actions.issueCommandSequence(),
				expected: _drawing.projection.stamp,
				blockId: window.blockId,
				intent: KlpEditingCommandIntent(command),
			), committedAtMs: DateTime.now().millisecondsSinceEpoch);
			if (_isCurrentInput(generation, input) && _interruption == null) _resynchronize(reply.projection);
		}
		catch (error, stack) { _reportTextFailure(KlpEditingHostPhase.input, error, stack); }
		finally {
			_finishInputOperation(settled, generation);
		}
	}

	TextEditingValue _editingValue(KlpEditingProjection projection) {
		final window = projection.window;
		if (window == null) return TextEditingValue.empty;
		final offsets = KlpTextOffsets(window.text);
		final composingStart = window.composingStartUtf8;
		final composingEnd = window.composingEndUtf8;
		final anchor = window.anchorUtf8;
		final focus = window.focusUtf8;
		return TextEditingValue(
			text: window.text,
			selection: anchor == null ? const TextSelection.collapsed(offset: -1) : TextSelection(baseOffset: offsets.toUtf16(anchor), extentOffset: offsets.toUtf16(focus!)),
			composing: composingStart == null ? TextRange.empty : TextRange(start: offsets.toUtf16(composingStart), end: offsets.toUtf16(composingEnd!)),
		);
	}

	void _updateGeometry(Layer layer) {
		if (_disposed || !_active || !mounted || _detachment != null) return;

		final connection = _connection;
		if (connection == null) return;
		final drawing = _drawing;
		final stamp = drawing.projection.stamp;
		final render = _surface.currentContext?.findRenderObject();
		if (_disposed || !identical(connection, _connection) || render is! RenderBox || !render.attached) return;
		final current = _drawing.projection.stamp;
		if (!current.sameSession(stamp) || current.layoutRevision != stamp.layoutRevision || current.environmentId != stamp.environmentId) return;
		if (render.size.width != drawing.width || render.size.height != drawing.height) return;

		connection.setEditableSizeAndTransform(render.size, render.getTransformTo(null));
		final caret = drawing.caretRect;
		if (caret != null) connection.setCaretRect(Rect.fromLTWH(caret.x, caret.y, caret.width, caret.height));
		final composing = drawing.composingRect;
		if (composing != null) connection.setComposingRect(Rect.fromLTWH(composing.x, composing.y, composing.width, composing.height));
	}

	@override
	TextEditingValue get currentTextEditingValue => _value;
	@override
	AutofillScope? get currentAutofillScope => null;
	@override
	void updateEditingValue(TextEditingValue value) => _connection?.setEditingState(_value);
	@override
	void performAction(TextInputAction action) {
		if (action == TextInputAction.newline) unawaited(_submitEditingCommand(KlpEditingCommand.paragraphBreak));
	}
	@override
	void performPrivateCommand(String action, Map<String, dynamic> data) {}
	@override
	void showAutocorrectionPromptRect(int start, int end) {}
	@override
	void updateFloatingCursor(RawFloatingCursorPoint point) {}
	@override
	void didChangeInputControl(TextInputControl? oldControl, TextInputControl? newControl) {}
	@override
	void insertContent(KeyboardInsertedContent content) {}
	@override
	void insertTextPlaceholder(Size size) {}
	@override
	bool onFocusReceived() => false;
	@override
	void performSelector(String selectorName) {}
	@override
	void removeTextPlaceholder() {}
	@override
	void showToolbar() {}

	@override
	void connectionClosed() {
		final connection = _connection;
		connection?.connectionClosedReceived();
		_connection = null;
		unawaited(_observeInterruption(interrupt()));
		_focus.unfocus();
	}

	@override
	void didChangeAppLifecycleState(AppLifecycleState state) {
		if (state == AppLifecycleState.resumed) {
			if (_focus.hasFocus) unawaited(_resumeAndAttach());
			return;
		}
		if (_dragBlockId != null && mounted) _cancelBlockDrag(_blockControls!);
		unawaited(_observeInterruption(interrupt()));
	}

	@override
	void dispose() {
		_disposed = true;
		_stopDragAutoScroll();
		_generation++;
		WidgetsBinding.instance.removeObserver(this);
		_focus.removeListener(_handleFocus);
		_blockControls?.close();
		_anchoredCommands?.dispose();
		_modeToolbar?.close();
		unawaited(_detachInteraction());
		_subscription.cancel();
		_saveSubscription?.cancel();
		_focus.dispose();
		super.dispose();
	}
}

final class _KlpControlAction {
	final String label;
	final KlpIconData? icon;
	final bool selected;
	final bool enabled;
	final int quarterTurns;
	final VoidCallback action;

	const _KlpControlAction({required this.label, required this.icon, required this.enabled, required this.action, this.selected = false, this.quarterTurns = 0});
}

final class _KlpAnchoredMenuLayout extends SingleChildLayoutDelegate {
	final Rect anchor;
	final double gap;

	const _KlpAnchoredMenuLayout(this.anchor, this.gap);

	@override
	BoxConstraints getConstraintsForChild(BoxConstraints constraints) => BoxConstraints.loose(constraints.biggest);

	@override
	Offset getPositionForChild(Size size, Size childSize) {
		final maximumX = size.width > childSize.width ? size.width - childSize.width : 0.0;
		final maximumY = size.height > childSize.height ? size.height - childSize.height : 0.0;
		final x = anchor.left.clamp(0.0, maximumX).toDouble();
		final below = anchor.bottom + gap;
		final above = anchor.top - gap - childSize.height;
		final y = (below <= maximumY ? below : above).clamp(0.0, maximumY).toDouble();
		return Offset(x, y);
	}

	@override
	bool shouldRelayout(covariant _KlpAnchoredMenuLayout oldDelegate) =>
		oldDelegate.anchor != anchor || oldDelegate.gap != gap;
}

final class _KlpEditingGeometryReporter extends SingleChildRenderObjectWidget {
	final CompositionCallback onComposite;

	const _KlpEditingGeometryReporter({required this.onComposite, required super.child, super.key});

	@override
	RenderObject createRenderObject(BuildContext context) => _KlpEditingGeometryRender(onComposite);

	@override
	void updateRenderObject(BuildContext context, covariant _KlpEditingGeometryRender renderObject) {
		renderObject.onComposite = onComposite;
	}
}

final class _KlpEditingGeometryRender extends RenderProxyBox {
	CompositionCallback _onComposite;
	VoidCallback? _cancelCallback;

	_KlpEditingGeometryRender(this._onComposite);

	set onComposite(CompositionCallback value) {
		if (identical(value, _onComposite)) return;
		_cancelCallback?.call();
		_cancelCallback = null;
		_onComposite = value;
		markNeedsPaint();
	}

	@override
	void paint(PaintingContext context, Offset offset) {
		_cancelCallback ??= context.addCompositionCallback(_onComposite);
		super.paint(context, offset);
	}

	@override
	void dispose() {
		_cancelCallback?.call();
		_cancelCallback = null;
		super.dispose();
	}
}
