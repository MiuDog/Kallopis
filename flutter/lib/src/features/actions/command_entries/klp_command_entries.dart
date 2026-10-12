import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../foundation/content/klp_text.dart';
import '../../../foundation/interaction/klp_pressable.dart';
import '../../../foundation/klp_icon.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../command_registry/klp_command_registry.dart';

// 有效幾何只屬於本次呈現，不寫回產品或風格權威。
double _length(double value) => value.isFinite && value > 0 ? value : 0;

double _limit(double value, double available) {
	final natural = _length(value);
	if (!available.isFinite) return natural;
	return natural.clamp(0, _length(available)).toDouble();
}

EdgeInsets _rowInsets(EdgeInsets raw, double width) {
	final left = _length(raw.left);
	final right = _length(raw.right);
	final total = left + right;
	var scale = 1.0;
	if (width.isFinite && total > _length(width)) scale = _length(width) / total;
	return EdgeInsets.fromLTRB(
		left * scale,
		_length(raw.top),
		right * scale,
		_length(raw.bottom),
	);
}

enum KlpCommandKind { action, toggle }

@immutable
class KlpCommandReference {

	const KlpCommandReference({required this.commandId, this.kind = KlpCommandKind.action});
	/* commandId 引用產品清冊；kind 只指定呈現語意，不擁有命令狀態。 */
	final String commandId;
	final KlpCommandKind kind;
}

class KlpRegisteredCommandToolbar<C> extends StatelessWidget {

	const KlpRegisteredCommandToolbar({
		super.key,
		required this.registry,
		required this.getContext,
		required this.items,
		required this.label,
		required this.onResult,
	});
	/* registry 是唯一命令來源；getContext 保持產品權威；items/label 指定排列及宿主名稱。 */
	final KlpCommandRegistry<C> registry;
	final C Function() getContext;
	final List<KlpCommandReference> items;
	final String label;
	/* onResult 只交回原產品結果，入口不轉譯業務錯誤。 */
	final ValueChanged<KlpCommandExecutionResult> onResult;

	@override
	Widget build(BuildContext context) => _CommandEntryHost<C>(registry: registry, getContext: getContext, items: items, label: label, onResult: onResult, menu: false);
}

class KlpRegisteredCommandMenu<C> extends StatelessWidget {

	const KlpRegisteredCommandMenu({
		super.key,
		required this.registry,
		required this.getContext,
		required this.items,
		required this.label,
		required this.emptyLabel,
		required this.onResult,
		this.autoFocus = false,
		this.onDismiss,
	});
	/* registry/getContext 為產品權威；items/label 為入口排列及名稱。 */
	final KlpCommandRegistry<C> registry;
	final C Function() getContext;
	final List<KlpCommandReference> items;
	final String label;
	/* emptyLabel 是產品文案；onResult/onDismiss 接回產品結果及彈出生命週期。 */
	final String emptyLabel;
	final ValueChanged<KlpCommandExecutionResult> onResult;
	final bool autoFocus;
	final VoidCallback? onDismiss;

	@override
	Widget build(BuildContext context) => _CommandEntryHost<C>(registry: registry, getContext: getContext, items: items, label: label, onResult: onResult, menu: true, emptyLabel: emptyLabel, autoFocus: autoFocus, onDismiss: onDismiss);
}

class _CommandRowData {

	const _CommandRowData(this.reference, this.state);
	/* reference 保留排列語意；state 是本次清冊查詢，不作執行權威。 */
	final KlpCommandReference reference;
	final KlpCommandState state;
	bool get enabled => state.enabled && !state.running;
}

class _CommandEntryHost<C> extends StatefulWidget {

	const _CommandEntryHost({
		required this.registry,
		required this.getContext,
		required this.items,
		required this.label,
		required this.onResult,
		required this.menu,
		this.emptyLabel,
		this.autoFocus = false,
		this.onDismiss,
	});
	/* 只傳遞公開產品參數；menu 決定原生呈現及鍵盤方向。 */
	final KlpCommandRegistry<C> registry;
	final C Function() getContext;
	final List<KlpCommandReference> items;
	final String label;
	final ValueChanged<KlpCommandExecutionResult> onResult;
	final bool menu;
	final String? emptyLabel;
	final bool autoFocus;
	final VoidCallback? onDismiss;

	@override
	State<_CommandEntryHost<C>> createState() => _CommandEntryHostState<C>();
}

class _CommandEntryHostState<C> extends State<_CommandEntryHost<C>> {

	/* nodes/root/selectedId 只擁有原生焦點；retired 延後到元素卸載後釋放。 */
	final _root = FocusNode();
	final _nodes = <String, FocusNode>{};
	final _retired = <FocusNode>{};
	String? _selectedId;
	List<_CommandRowData> _rows = const [];
	/* unsubscribe 精確解除清冊訂閱；generation 隔離過期非同步宿主。 */
	VoidCallback? _unsubscribe;
	int _generation = 0;

	@override
	void initState() {
		super.initState();
		_subscribe();
		_scheduleAutofocus();
	}

	@override
	void didUpdateWidget(_CommandEntryHost<C> oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (!identical(oldWidget.registry, widget.registry)) {
			_unsubscribe?.call();
			_generation++;
			_selectedId = null;
			_subscribe();
			_scheduleAutofocus();
		}
		else if (!oldWidget.autoFocus && widget.autoFocus) {
			_scheduleAutofocus();
		}
	}

	@override
	void dispose() {
		_generation++;
		_unsubscribe?.call();
		_root.dispose();
		for (final node in {..._nodes.values, ..._retired}) {
			node.dispose();
		}
		_retired.clear();
		super.dispose();
	}

	void _subscribe() {
		_unsubscribe = null;
		if (!widget.registry.isDisposed) _unsubscribe = widget.registry.subscribe(_refresh);
	}

	void _refresh() {
		if (mounted) setState(() {});
	}

	void _scheduleAutofocus() {
		if (!widget.menu || !widget.autoFocus) return;

		final owner = _generation;
		void focusAfterBuild(Duration elapsed) {
			if (mounted && owner == _generation && widget.autoFocus) _focus(_activeId);
		}
		// 原生元素掛載後才取得焦點，不在 build 期間移動宿主焦點。
		WidgetsBinding.instance.addPostFrameCallback(focusAfterBuild);
	}

	String? get _activeId {
		final enabled = _rows.where((row) => row.enabled);
		if (enabled.any((row) => row.reference.commandId == _selectedId)) return _selectedId;

		return enabled.firstOrNull?.reference.commandId;
	}

	void _focus(String? id) {
		if (id == null) { _root.requestFocus(); return; }

		_selectedId = id;
		_nodes[id]?.requestFocus();
		_refresh();
	}

	void _syncNodes() {
		final ids = _rows.map((row) => row.reference.commandId).toSet();
		for (final id in ids) {
			_nodes.putIfAbsent(id, () => FocusNode(debugLabel: id));
		}
		for (final id in _nodes.keys.where((id) => !ids.contains(id)).toList()) {
			final node = _nodes.remove(id)!;
			_retired.add(node);
			void releaseAfterBuild(Duration elapsed) {
				if (_retired.remove(node)) node.dispose();
			}
			WidgetsBinding.instance.addPostFrameCallback(releaseAfterBuild);
		}
	}

	Future<void> _activate(String id) async {
		final registry = widget.registry;
		final owner = _generation;
		KlpCommandExecutionResult result;
		try {
			result = await registry.execute(id, widget.getContext());
		}
		catch (error, stack) {
			if (_isCurrent(registry, owner)) _report(error, stack);
			return;
		}
		if (!_isCurrent(registry, owner)) return;

		try { widget.onResult(result); }
		catch (error, stack) { _report(error, stack); }
	}

	bool _isCurrent(KlpCommandRegistry<C> registry, int owner) => mounted && owner == _generation && identical(registry, widget.registry);

	void _report(Object error, StackTrace stack) {
		// 宿主診斷沿 FlutterError，不把 UI callback 的錯誤偽裝成業務結果。
		FlutterError.reportError(FlutterErrorDetails(exception: error, stack: stack, library: 'Kallopis registered commands'));
	}

	KeyEventResult _key(FocusNode node, KeyEvent event) {
		final key = event.logicalKey;
		final activation = key == LogicalKeyboardKey.enter || key == LogicalKeyboardKey.numpadEnter || key == LogicalKeyboardKey.space;
		if (event is KeyRepeatEvent && activation) return KeyEventResult.handled;
		if (event is! KeyDownEvent) return KeyEventResult.ignored;
		if (key == LogicalKeyboardKey.escape && widget.menu) { widget.onDismiss?.call(); return KeyEventResult.handled; }

		final enabled = _rows.where((row) => row.enabled).toList();
		if (enabled.isEmpty) return KeyEventResult.ignored;

		var index = enabled.indexWhere((row) => row.reference.commandId == _activeId);
		if (index < 0) index = 0;
		if (activation) { _activate(enabled[index].reference.commandId); return KeyEventResult.handled; }

		final forward = widget.menu ? LogicalKeyboardKey.arrowDown : LogicalKeyboardKey.arrowRight;
		final backward = widget.menu ? LogicalKeyboardKey.arrowUp : LogicalKeyboardKey.arrowLeft;
		if (key == forward) {
			index = (index + 1) % enabled.length;
		}
		else if (key == backward) {
			index = (index + enabled.length - 1) % enabled.length;
		}
		else if (key == LogicalKeyboardKey.home) {
			index = 0;
		}
		else if (key == LogicalKeyboardKey.end) {
			index = enabled.length - 1;
		}
		else {
			return KeyEventResult.ignored;
		}

		_focus(enabled[index].reference.commandId);
		return KeyEventResult.handled;
	}

	void _validate() {
		void text(String value, String name) { if (value.trim().isEmpty) throw ArgumentError.value(value, name, '須含非空白文字'); }
		text(widget.label, 'label');
		if (widget.menu) text(widget.emptyLabel!, 'emptyLabel');
		final ids = <String>{};
		for (final item in widget.items) {
			text(item.commandId, 'commandId');
			if (!ids.add(item.commandId)) throw ArgumentError.value(item.commandId, 'items', '命令 ID 不可重複');
		}
	}

	Widget _row(_CommandRowData row) {
		final id = row.reference.commandId;
		void focusChanged(bool focused) {
			if (focused) _selectedId = id;
			_refresh();
		}
		return Focus(
			key: ValueKey(id),
			focusNode: _nodes[id],
			canRequestFocus: row.enabled,
			skipTraversal: id != _activeId,
			onFocusChange: focusChanged,
			includeSemantics: false,
			child: _RegisteredCommandRow(
				row: row,
				menu: widget.menu,
				focused: _nodes[id]!.hasFocus,
				onActivate: () { if (row.enabled) { _focus(id); _activate(id); } },
			),
		);
	}

	@override
	Widget build(BuildContext context) {
		_validate();
		_rows = [];
		if (!widget.registry.isDisposed) {
			final callerContext = widget.getContext();
			for (final reference in widget.items) {
				final state = widget.registry.getState(reference.commandId, callerContext);
				if (state != null && state.visible) _rows.add(_CommandRowData(reference, state));
			}
		}
		_syncNodes();
		return Semantics(container: true, explicitChildNodes: true, label: widget.label, child: Focus(focusNode: _root, skipTraversal: true, onKeyEvent: _key, child: LayoutBuilder(builder: _content)));
	}

	Widget _content(BuildContext context, BoxConstraints constraints) {
		final klp = context.klp;
		if (widget.menu) {
			final width = constraints.constrainWidth(_limit(klp.geometry.layout.commandMenuWidth, constraints.maxWidth));
			final horizontal = _limit(klp.space.tight, width / 2);
			final vertical = _limit(klp.space.tight, constraints.maxHeight / 2);
			return SizedBox(
				width: width,
				child: DecoratedBox(
					decoration: BoxDecoration(color: klp.color.overlay, borderRadius: BorderRadius.circular(klp.menuRadius), boxShadow: klp.overlayShadow),
					child: ClipRect(child: SingleChildScrollView(
						padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
						child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final row in _rows) _row(row), if (_rows.isEmpty) KlpText(widget.emptyLabel!, role: KlpTextRole.caption, tone: KlpTextTone.muted)]),
					)),
				),
			);
		}
		return ClipRect(child: SingleChildScrollView(child: Wrap(spacing: _length(klp.space.actionGap), runSpacing: _length(klp.space.actionGap), children: _rows.map(_row).toList())));
	}
}

class _RegisteredCommandRow extends StatefulWidget {

	const _RegisteredCommandRow({required this.row, required this.menu, required this.focused, required this.onActivate});
	/* row 是最新清冊呈現；menu/focused 只控制視覺；onActivate 永遠 dispatch ID。 */
	final _CommandRowData row;
	final bool menu;
	final bool focused;
	final VoidCallback onActivate;

	@override
	State<_RegisteredCommandRow> createState() => _RegisteredCommandRowState();
}

class _RegisteredCommandRowState extends State<_RegisteredCommandRow> {

	/* hovered 僅控制入口視覺，checked/pending 仍由清冊擁有。 */
	bool _hovered = false;

	@override
	Widget build(BuildContext context) => LayoutBuilder(builder: _content);

	Widget _content(BuildContext context, BoxConstraints constraints) {
		final klp = context.klp;
		final state = widget.row.state;
		final toggle = widget.row.reference.kind == KlpCommandKind.toggle;
		final highlighted = (toggle && state.checked) || widget.focused || (_hovered && widget.row.enabled);
		final radius = widget.menu ? klp.shape.control : klp.buttonRadius;
		final rawInsets = widget.menu ? EdgeInsets.symmetric(horizontal: klp.menuPadding) : klp.buttonInsets;
		final insets = _rowInsets(rawInsets, constraints.maxWidth);
		final remaining = constraints.maxWidth - insets.horizontal;
		final icon = _limit(klp.space.iconSmall, remaining / 2);
		final rawGap = widget.menu ? klp.space.overlayItemGap : klp.space.controlContentGap;
		final gap = _limit(rawGap, remaining - icon);
		final tone = widget.row.enabled ? KlpTextTone.automatic : KlpTextTone.faint;
		final content = Container(
			constraints: BoxConstraints(minHeight: _length(widget.menu ? klp.menuItemHeight : klp.buttonHeight)),
			padding: insets,
			decoration: BoxDecoration(color: highlighted ? klp.selectionWash : klp.color.clear, borderRadius: BorderRadius.circular(radius)),
			child: Row(
				mainAxisSize: MainAxisSize.min,
				children: [
					if (state.icon != null) ...[KlpIcon(state.icon!, size: icon), SizedBox(width: gap)],
					Flexible(
						child: Column(
							mainAxisSize: MainAxisSize.min,
							crossAxisAlignment: CrossAxisAlignment.start,
							children: [
								KlpText(state.label, role: KlpTextRole.label, tone: tone, maxLines: 1, overflow: TextOverflow.ellipsis),
								if (widget.menu && state.description != null) KlpText(state.description!, role: KlpTextRole.caption, tone: widget.row.enabled ? KlpTextTone.muted : KlpTextTone.faint, maxLines: 1, overflow: TextOverflow.ellipsis),
							],
						),
					),
				],
			),
		);
		return Semantics(
			container: true,
			excludeSemantics: true,
			label: state.label,
			button: true,
			enabled: widget.row.enabled,
			checked: toggle ? state.checked : null,
			focusable: widget.row.enabled,
			focused: widget.focused,
			onTap: widget.row.enabled ? widget.onActivate : null,
			child: ExcludeFocus(
				child: Material(
					color: klp.color.clear,
					child: KlpPressable(
						onPressed: widget.row.enabled ? widget.onActivate : null,
						onHover: (hovered) => setState(() => _hovered = hovered),
						hoverHighlight: false,
						borderRadius: BorderRadius.circular(radius),
						child: ClipRect(child: content),
					),
				),
			),
		);
	}
}
