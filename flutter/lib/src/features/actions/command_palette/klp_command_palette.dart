import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:kallopis/src/features/actions/command_registry/klp_command_registry.dart';
import 'package:kallopis/src/features/forms/input/klp_text_field.dart';
import 'package:kallopis/src/foundation/content/klp_text.dart';
import 'package:kallopis/src/foundation/interaction/klp_pressable.dart';
import 'package:kallopis/src/foundation/klp_icon.dart';
import 'package:kallopis/src/styling/legacy_theme/klp_theme.dart';

/// 產品受控面板的關閉意圖；不代表產品已變更 open。
enum KlpCommandDismissReason { escape, outside, executed }

/// 使用同命令清冊的原生搜尋面板；產品持有 context、open 與結果。
class KlpRegisteredCommandPalette<C> extends StatefulWidget {
	const KlpRegisteredCommandPalette({
		super.key,
		required this.registry,
		required this.getContext,
		required this.open,
		required this.label,
		required this.searchLabel,
		required this.emptyLabel,
		required this.onResult,
		required this.onDismiss,
	});

	/* 清冊及條件仍由產品擁有；open 不在浮層中建立第二份權威。 */
	final KlpCommandRegistry<C> registry;
	final C Function() getContext;
	final bool open;
	/* 三個文案由產品本地化；結果保留核心原值，dismiss 只提出意圖。 */
	final String label;
	final String searchLabel;
	final String emptyLabel;
	final ValueChanged<KlpCommandExecutionResult> onResult;
	final ValueChanged<KlpCommandDismissReason> onDismiss;

	@override
	State<KlpRegisteredCommandPalette<C>> createState() => _CommandPaletteState<C>();
}

class _Candidate {
	_Candidate(this.state, this.score);
	/* state 只供本次呈現，score 不改變命令的 checked 或產品狀態。 */
	final KlpCommandState state;
	final int score;
	bool get enabled => state.enabled && !state.running;
}

int? _fieldScore(String field, String word) {
	if (field == word) return 0;
	if (field.startsWith(word)) return 1;
	if (field.contains(word)) return 2;
	var position = 0;
	for (var index = 0; index < word.length; index++) {
		position = field.indexOf(word[index], position);
		if (position < 0) return null;
		position++;
	}
	return 3;
}

List<_Candidate> _search(List<KlpCommandState> states, String query) {
	final whitespace = RegExp(r'[\u0009-\u000D\u0020\u00A0\u1680\u2000-\u200A\u2028\u2029\u202F\u205F\u3000\uFEFF]+', unicode: true);
	final words = query.toLowerCase().split(whitespace).where((word) => word.isNotEmpty);
	final candidates = <_Candidate>[];
	for (final state in states) {
		if (!state.visible) continue;
		final fields = [state.label, state.id, state.category ?? '', state.description ?? '', ...state.keywords].map((field) => field.toLowerCase());
		var score = 0;
		var matched = true;
		for (final word in words) {
			int? best;
			for (final field in fields) {
				final value = _fieldScore(field, word);
				if (value != null && (best == null || value < best)) best = value;
			}
			if (best == null) { matched = false; break; }
			score += best;
		}
		if (matched) candidates.add(_Candidate(state, score));
	}
	int compare(_Candidate left, _Candidate right) {
		final score = left.score.compareTo(right.score);
		return score == 0 ? left.state.id.compareTo(right.state.id) : score;
	}
	candidates.sort(compare);
	return candidates;
}

double _finite(double value) => value.isFinite ? math.max(0, value) : 0;

class _CommandPaletteState<C> extends State<KlpRegisteredCommandPalette<C>> {
	/* 原生資源只在此宿主存活；generation 隔離舊 async/frame 結果。 */
	OverlayEntry? _overlay;
	CapturedThemes? _themes;
	final _query = TextEditingController();
	final _inputFocus = FocusNode(debugLabel: 'Klp command palette input');
	final _scope = FocusScopeNode(debugLabel: 'Klp command palette', traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);
	VoidCallback? _unsubscribe;
	FocusNode? _returnFocus;
	String? _activeId;
	List<_Candidate> _candidates = [];
	int _generation = 0;
	bool _scheduled = false;

	@override
	void initState() {
		super.initState();
		_query.addListener(_refresh);
		_subscribe();
	}

	@override
	void didUpdateWidget(KlpRegisteredCommandPalette<C> oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.registry != widget.registry || oldWidget.open != widget.open) {
			_generation++;
			_unsubscribe?.call();
			_subscribe();
		}
		if (oldWidget.open && !widget.open) _closeSession();
	}

	void _subscribe() {
		_unsubscribe = null;
		if (widget.open && !widget.registry.isDisposed) _unsubscribe = widget.registry.subscribe(_refresh);
	}

	void _refresh() { if (mounted) setState(() {}); }

	void _scheduleOverlay() {
		if (_scheduled) return;
		_scheduled = true;
		void synchronize(Duration timestamp) {
			_scheduled = false;
			if (!mounted) return;
			if (widget.open && _overlay == null) {
				_generation++;
				_returnFocus = FocusManager.instance.primaryFocus;
				_activeId = null;
				_query.clear();
				_overlay = OverlayEntry(builder: _projectOverlay);
				Overlay.of(context).insert(_overlay!);
				final generation = _generation;
				void focusInput(Duration timestamp) {
					if (mounted && widget.open && generation == _generation) _inputFocus.requestFocus();
				}
				WidgetsBinding.instance.addPostFrameCallback(focusInput);
			}
			else if (!widget.open) { _removeOverlay(); }
			else { _overlay?.markNeedsBuild(); }
		}
		WidgetsBinding.instance.addPostFrameCallback(synchronize);
	}

	void _removeOverlay() {
		_overlay?.remove();
		_overlay?.dispose();
		_overlay = null;
	}

	Widget _projectOverlay(BuildContext overlayContext) {
		if (!mounted || !widget.open || _themes == null) return const SizedBox.shrink();
		final child = Directionality(textDirection: Directionality.of(context), child: Builder(builder: _overlayChild));
		// locale 投影會建立語意容器；背景阻擋必須在其外層才涵蓋同 Overlay。
		return BlockSemantics(child: _themes!.wrap(Localizations.override(context: context, child: child)));
	}

	bool _ownsFocus(FocusNode? focus) => focus == null || focus == FocusManager.instance.rootScope || focus == _scope || focus == _inputFocus || _scope.descendants.contains(focus);

	void _closeSession() {
		final target = _returnFocus;
		final restore = _ownsFocus(FocusManager.instance.primaryFocus);
		final generation = _generation;
		_returnFocus = null;
		if (!restore || target == null) return;
		void restoreFocus(Duration timestamp) {
			if (generation != _generation) return;
			final current = FocusManager.instance.primaryFocus;
			if (_ownsFocus(current) && target.context != null && target.canRequestFocus) target.requestFocus();
		}
		WidgetsBinding.instance.addPostFrameCallback(restoreFocus);
	}

	@override
	void dispose() {
		_generation++;
		_unsubscribe?.call();
		_closeSession();
		_removeOverlay();
		_query.removeListener(_refresh);
		_query.dispose();
		_inputFocus.dispose();
		_scope.dispose();
		super.dispose();
	}

	bool _isCurrent(int generation, KlpCommandRegistry<C> registry) => mounted && widget.open && generation == _generation && widget.registry == registry;

	void _report(Object error, StackTrace stack) {
		FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack, library: 'Kallopis command palette'));
	}

	Future<void> _activate(String id) async {
		if (!widget.open || widget.registry.isDisposed) return;
		final registry = widget.registry;
		final generation = _generation;
		try {
			final context = widget.getContext();
			final state = registry.getState(id, context);
			if (state == null || !state.visible || !state.enabled || state.running) return;
			_inputFocus.requestFocus();
			final result = await registry.execute(id, context);
			if (!_isCurrent(generation, registry)) return;
			widget.onResult(result);
			if (result.status == KlpCommandExecutionStatus.executed && _isCurrent(generation, registry)) widget.onDismiss(KlpCommandDismissReason.executed);
		} catch (error, stack) { _report(error, stack); }
	}

	KeyEventResult _key(FocusNode node, KeyEvent event) {
		// 本面板唯一可遍歷輸入；避免 TextField 內部裝飾 Focus 成為 Tab 停靠點。
		if (event.logicalKey == LogicalKeyboardKey.tab && event is KeyDownEvent) { _inputFocus.requestFocus(); return KeyEventResult.handled; }
		if (_query.value.composing.isValid && !_query.value.composing.isCollapsed) return KeyEventResult.ignored;
		final key = event.logicalKey;
		if (key == LogicalKeyboardKey.enter && event is KeyRepeatEvent) return KeyEventResult.handled;
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		if (key == LogicalKeyboardKey.escape) { widget.onDismiss(KlpCommandDismissReason.escape); return KeyEventResult.handled; }
		if (key == LogicalKeyboardKey.enter) {
			if (_activeId != null) _activate(_activeId!);
			return KeyEventResult.handled;
		}
		if (key != LogicalKeyboardKey.arrowDown && key != LogicalKeyboardKey.arrowUp) return KeyEventResult.ignored;
		final available = _candidates.where((candidate) => candidate.enabled).toList();
		if (available.isNotEmpty) {
			final index = available.indexWhere((candidate) => candidate.state.id == _activeId);
			final step = key == LogicalKeyboardKey.arrowDown ? 1 : -1;
			setState(() { _activeId = available[(index + step) % available.length].state.id; });
		}
		return KeyEventResult.handled;
	}

	Widget _overlayChild(BuildContext context) {
		_candidates = widget.registry.isDisposed ? [] : _search(widget.registry.list(widget.getContext()), _query.text);
		final available = _candidates.where((candidate) => candidate.enabled).toList();
		if (!available.any((candidate) => candidate.state.id == _activeId)) _activeId = available.isEmpty ? null : available.first.state.id;
		return Stack(children: [
			Positioned.fill(child: _barrier(context)),
			Positioned.fill(child: LayoutBuilder(builder: _panel)),
		]);
	}

	Widget _barrier(BuildContext context) {
		// Windows 的 ModalBarrier 不提供 dismiss 語意；原生名稱仍讀同 caller locale。
		final label = Localizations.of<MaterialLocalizations>(context, MaterialLocalizations)?.modalBarrierDismissLabel ?? widget.label;
		final barrier = ModalBarrier(color: context.klp.color.modalScrim.withValues(alpha: context.klp.surface.scrimOpacity), onDismiss: _outside);
		return Semantics(container: true, label: label, button: true, onTap: _outside, onDismiss: _outside, child: ExcludeSemantics(child: barrier));
	}

	void _outside() { if (widget.open) widget.onDismiss(KlpCommandDismissReason.outside); }

	Object? _nativeDismiss(DismissIntent intent) {
		// EditableText 的原生 Escape fallback 需要 Actions；composition 不提出關閉。
		if (!_query.value.composing.isValid || _query.value.composing.isCollapsed) {
			if (widget.open) widget.onDismiss(KlpCommandDismissReason.escape);
		}
		return null;
	}

	Widget _panel(BuildContext context, BoxConstraints constraints) {
		final klp = context.klp;
		final width = _finite(constraints.maxWidth), height = _finite(constraints.maxHeight);
		final inset = math.min(_finite(klp.geometry.layout.overlayViewportInset), math.min(width / 2, height / 2));
		final panelWidth = math.min(_finite(klp.geometry.layout.dialogMaximumWidth), width - 2 * inset);
		final panelHeight = math.max(0.0, height - 2 * inset);
		final padding = math.min(_finite(klp.space.tight), math.min(panelWidth / 2, panelHeight / 2));
		final contentWidth = math.max(0.0, panelWidth - 2 * padding);
		final children = <Widget>[
			KlpTextField(label: widget.searchLabel, controller: _query, focusNode: _inputFocus),
			if (_candidates.isEmpty) KlpText(widget.emptyLabel, role: KlpTextRole.caption, tone: KlpTextTone.muted),
			for (final candidate in _candidates) _PaletteRow(candidate: candidate, active: candidate.state.id == _activeId, width: contentWidth, onActivate: () => _activate(candidate.state.id)),
		];
		final content = Padding(padding: EdgeInsets.all(padding), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: children));
		final panel = Container(
			width: panelWidth,
			constraints: BoxConstraints(maxHeight: panelHeight),
			decoration: BoxDecoration(color: klp.color.overlay, borderRadius: BorderRadius.circular(klp.menuRadius), boxShadow: klp.overlayShadow),
			child: Material(type: MaterialType.transparency, child: ClipRect(child: SingleChildScrollView(child: content))),
		);
		final semantics = Semantics(container: true, scopesRoute: true, namesRoute: true, label: widget.label, explicitChildNodes: true, child: panel);
		final focus = FocusScope(node: _scope, onKeyEvent: _key, child: semantics);
		final actions = Actions(actions: <Type, Action<Intent>>{DismissIntent: CallbackAction<DismissIntent>(onInvoke: _nativeDismiss)}, child: focus);
		return Padding(padding: EdgeInsets.all(inset), child: Align(alignment: Alignment.topCenter, child: actions));
	}

	@override
	Widget build(BuildContext context) {
		for (final text in [widget.label, widget.searchLabel, widget.emptyLabel]) {
			if (text.trim().isEmpty) throw ArgumentError.value(text, 'label', 'Command palette label must not be blank');
		}
		_scheduleOverlay();
		// 每次從同呼叫點刷新既有主題；modal 語意在獨立 entry 附著原生 Overlay。
		_themes = widget.open ? InheritedTheme.capture(from: context, to: Overlay.of(context).context) : null;
		return const SizedBox.shrink();
	}
}

class _PaletteRow extends StatefulWidget {
	const _PaletteRow({required this.candidate, required this.active, required this.width, required this.onActivate});
	/* 候選及寬度為本次有限投影；active/hover只控制呈現，權限仍由清冊擁有。 */
	final _Candidate candidate;
	final bool active;
	final double width;
	final VoidCallback onActivate;
	@override
	State<_PaletteRow> createState() => _PaletteRowState();
}

class _PaletteRowState extends State<_PaletteRow> {
	/* hover 不改命令 checked，也不建立第二份命令選取狀態。 */
	bool _hovered = false;
	void _hover(bool value) { if (_hovered != value) setState(() { _hovered = value; }); }

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final state = widget.candidate.state;
		final enabled = widget.candidate.enabled;
		final padding = math.min(_finite(klp.menuPadding), widget.width / 2);
		final remaining = math.max(0.0, widget.width - 2 * padding);
		final icon = math.min(_finite(klp.space.iconSmall), remaining / 2);
		final gap = math.min(_finite(klp.space.overlayItemGap), math.max(0.0, remaining - icon));
		final tone = enabled ? KlpTextTone.automatic : KlpTextTone.faint;
		final copy = Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
			KlpText(state.label, role: KlpTextRole.label, tone: tone, maxLines: 1, overflow: TextOverflow.ellipsis),
			if (state.description != null) KlpText(state.description!, role: KlpTextRole.caption, tone: tone, maxLines: 1, overflow: TextOverflow.ellipsis),
			if (state.category != null) KlpText(state.category!, role: KlpTextRole.caption, tone: tone, maxLines: 1, overflow: TextOverflow.ellipsis),
		]);
		final row = Row(children: [
			if (state.icon != null) ...[KlpIcon(state.icon!, size: icon), SizedBox(width: gap)],
			Expanded(child: copy),
		]);
		final content = Container(
			constraints: BoxConstraints(minHeight: _finite(klp.menuItemHeight)),
			padding: EdgeInsets.symmetric(horizontal: padding),
			decoration: BoxDecoration(color: widget.active || (_hovered && enabled) ? klp.selectionWash : klp.color.clear, borderRadius: BorderRadius.circular(klp.shape.control)),
			child: row,
		);
		final pressable = KlpPressable(onPressed: enabled ? widget.onActivate : null, onHover: _hover, hoverHighlight: false, child: content);
		return Semantics(
			container: true,
			excludeSemantics: true,
			label: state.label,
			button: true,
			enabled: enabled,
			selected: widget.active,
			onTap: enabled ? widget.onActivate : null,
			child: ExcludeFocus(child: ExcludeSemantics(child: pressable)),
		);
	}
}
