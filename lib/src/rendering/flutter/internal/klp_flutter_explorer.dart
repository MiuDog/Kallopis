import 'dart:async';
import 'package:flutter/material.dart' show DefaultMaterialLocalizations, MaterialLocalizations;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/features/workspace/explorer/klp_explorer_model.dart';
import 'package:kallopis/src/features/workspace/explorer/klp_explorer_snapshot.dart';
import 'package:kallopis/src/features/workspace/explorer/internal/klp_explorer_controller_binding.dart';
import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'klp_flutter_commands.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_selection_surface.dart';
import 'klp_flutter_values.dart';

/// 依已驗證的可見順序呈現；不猜產品種類、不保存另一份選取樹。
final class KlpFlutterExplorer extends StatefulWidget {

	final KlpBoundExplorer content;

	const KlpFlutterExplorer({required this.content, super.key});

	@override
	State<KlpFlutterExplorer> createState() => _KlpFlutterExplorerState();
}

final class _KlpFlutterExplorerState extends State<KlpFlutterExplorer> {

	final _focus = <KlpId, FocusNode>{};
	final _rowKeys = <KlpId, GlobalKey>{};
	final _controllerOwner = Object();
	KlpExplorerDropRequest? _dropPreview;
	KlpBoundExplorer get content => widget.content;

	@override
	void initState() {
		super.initState();
		_attachController();
	}

	@override
	void didUpdateWidget(KlpFlutterExplorer oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (!identical(oldWidget.content.controller, content.controller)) {
			final oldController = oldWidget.content.controller;
			if (oldController != null) detachKlpExplorerController(oldController, _controllerOwner);
		}
		_attachController();
		if (_dropPreview != null && !content.permitsDrop(_dropPreview!)) _dropPreview = null;
		final removed = _focus.keys.where((id) => !content.tree.visibleIds.contains(id)).toList();
		for (final id in removed) {
			final node = _focus.remove(id)!;
			_rowKeys.remove(id);
			WidgetsBinding.instance.addPostFrameCallback((_) => node.dispose());
		}
	}

	@override
	void dispose() {
		final controller = content.controller;
		if (controller != null) detachKlpExplorerController(controller, _controllerOwner);
		for (final node in _focus.values) { node.dispose(); }
		super.dispose();
	}

	void _attachController() {
		final controller = content.controller;
		if (controller == null) return;

		attachKlpExplorerController(controller, _controllerOwner, focus: _focusItem, reveal: _revealItem);
	}

	Future<KlpExplorerControllerResult> _focusItem(KlpId id) async {
		if (!content.isActive()) return KlpExplorerControllerResult.unavailable;
		if (!content.snapshot.items.containsKey(id)) return KlpExplorerControllerResult.targetMissing;
		if (!content.tree.visibleIds.contains(id)) return KlpExplorerControllerResult.unavailable;
		final node = _focus[id];
		if (node == null) return KlpExplorerControllerResult.unavailable;

		node.requestFocus();
		return KlpExplorerControllerResult.completed;
	}

	Future<KlpExplorerControllerResult> _revealItem(KlpId id) async {
		if (!content.isActive()) return KlpExplorerControllerResult.unavailable;
		if (!content.snapshot.items.containsKey(id)) return KlpExplorerControllerResult.targetMissing;
		if (!content.tree.visibleIds.contains(id)) return KlpExplorerControllerResult.unavailable;
		final rowContext = _rowKeys[id]?.currentContext;
		if (rowContext == null) return KlpExplorerControllerResult.unavailable;

		await Scrollable.ensureVisible(rowContext, duration: Duration.zero);
		return KlpExplorerControllerResult.completed;
	}

	TextStyle get _text {
		final style = content.textStyle;
		final weight = (style.fontWeight.value / 100).round().clamp(1, 9) - 1;
		return TextStyle(color: klpFlutterColor(content.foreground), fontFamily: style.fontFamily.family, fontSize: style.fontSize.value, fontWeight: FontWeight.values[weight], height: style.lineHeight.value, letterSpacing: style.letterSpacing.value);
	}

	KlpFlutterCommandStyle get _commandStyle => KlpFlutterCommandStyle(
		surface: klpFlutterColor(content.surface), foreground: klpFlutterColor(content.foreground), muted: klpFlutterColor(content.mutedForeground), interaction: klpFlutterColor(content.selectedBackground), destructive: klpFlutterColor(content.focusColor), text: _text, extent: content.nodeExtent.value, inset: content.inset.value, radius: content.radius.value,
	);

	void _primary(KlpExplorerItemSnapshot item) {
		switch (item.capabilities.primaryAction) {
			case KlpExplorerPrimaryAction.activate: content.onIntent?.call(KlpExplorerActivationRequested(item.id));
			case KlpExplorerPrimaryAction.toggleExpansion: _toggle(item);
			case KlpExplorerPrimaryAction.none: break;
		}
	}

	void _toggle(KlpExplorerItemSnapshot item) {
		if (!content.isActive() || !item.canToggleExpansion) return;

		final expanded = !content.tree.expandedIds.contains(item.id);
		content.onIntent?.call(KlpExplorerExpansionRequested(itemId: item.id, expanded: expanded, expandedIds: content.expandedIdsAfter(item.id, expanded)));
	}

	void _click(KlpExplorerItemSnapshot item) {
		if (!content.isActive()) { return; }

		_focus[item.id]?.requestFocus();
		final scope = content.selection;
		final multiple = scope.mode == KlpExplorerSelectionMode.multiple;
		final toggle = multiple && (HardwareKeyboard.instance.isControlPressed || HardwareKeyboard.instance.isMetaPressed);
		final extend = multiple && HardwareKeyboard.instance.isShiftPressed;
		if (item.capabilities.selectable && scope.mode != KlpExplorerSelectionMode.none) {
			final order = content.snapshot.selectableIdsForScope(scope.id);
			final anchorIndex = scope.anchorId == null ? -1 : order.indexOf(scope.anchorId!);
			final index = order.indexOf(item.id);
			Set<KlpId> next = {item.id};
			KlpId? anchor = item.id;
			if (extend && anchorIndex >= 0 && index >= 0) {
				final start = anchorIndex < index ? anchorIndex : index;
				final end = anchorIndex > index ? anchorIndex : index;
				next = order.sublist(start, end + 1).toSet();
				anchor = scope.anchorId;
			}
			else if (toggle) {
				next = Set.of(scope.selectedIds);
				if (!next.remove(item.id)) { next.add(item.id); }
			}
			content.onIntent?.call(KlpExplorerSelectionRequested(scopeId: scope.id, selectedIds: next, anchorId: anchor));
		}
		if (!toggle && !extend) { _primary(item); }
	}

	Offset _anchor(BuildContext context) {
		final box = context.findRenderObject()! as RenderBox;
		return box.localToGlobal(Offset(0, box.size.height));
	}

	void _menu(BuildContext context, KlpExplorerItemSnapshot item, Offset anchor) {
		final active = content.isActive;
		unawaited(showKlpCommandMenu(context, item.row.contextActions.map((command) => _command(context, item.id, command)).toList(), anchor, _commandStyle, active));
	}

	KlpBoundWorkspaceCommand _command(BuildContext context, KlpId itemId, KlpExplorerCommand command) {
		final material = MaterialLocalizations.of(context);
		return KlpBoundWorkspaceCommand(
			label: command.label,
			enabled: command.enabled,
			destructive: command.destructive,
			inputLabel: command.inputLabel,
			initialValue: command.initialValue,
			confirmation: command.confirmation,
			submitLabel: material.okButtonLabel,
			cancelLabel: material.cancelButtonLabel,
			shortcut: command.shortcut?.index,
			onInvoke: (input) {
				if (content.isActive()) content.onIntent?.call(KlpExplorerCommandRequested(itemId: itemId, commandId: command.id, input: input));
			},
		);
	}

	KeyEventResult _key(BuildContext context, KlpExplorerItemSnapshot item, KeyEvent event) {
		if (event is! KeyDownEvent || !content.isActive()) { return KeyEventResult.ignored; }

		final key = event.logicalKey;
		final visible = content.tree.visibleIds;
		final index = visible.indexOf(item.id);
		if (key == LogicalKeyboardKey.arrowDown || key == LogicalKeyboardKey.arrowUp) {
			final next = index + (key == LogicalKeyboardKey.arrowDown ? 1 : -1);
			if (next >= 0 && next < visible.length) { _focus[visible[next]]?.requestFocus(); }
		}
		else if (key == LogicalKeyboardKey.arrowRight) {
			if (item.canToggleExpansion && !content.tree.expandedIds.contains(item.id)) { _toggle(item); }
			else if (item.hasChildren) { _focus[item.childIds.first]?.requestFocus(); }
		}
		else if (key == LogicalKeyboardKey.arrowLeft) {
			if (item.canToggleExpansion && content.tree.expandedIds.contains(item.id)) { _toggle(item); }
			else if (item.parentId != null) { _focus[item.parentId]?.requestFocus(); }
		}
		else if (key == LogicalKeyboardKey.enter) { _primary(item); }
		else if (key == LogicalKeyboardKey.space) { _click(item); }
		else if (key == LogicalKeyboardKey.contextMenu || key == LogicalKeyboardKey.f10 && HardwareKeyboard.instance.isShiftPressed) { _menu(context, item, _anchor(context)); }
		else if (key == LogicalKeyboardKey.f2 || key == LogicalKeyboardKey.delete) {
			final shortcut = key == LogicalKeyboardKey.f2 ? 0 : 1;
			final commands = [...item.row.contextActions, ...item.row.inlineActions];
			final command = commands.where((command) => command.enabled && command.shortcut?.index == shortcut).firstOrNull;
			if (command != null) unawaited(runKlpCommand(context, _command(context, item.id, command), _commandStyle, content.isActive));
		}
		else { return KeyEventResult.ignored; }

		return KeyEventResult.handled;
	}

	// 預覽只是暫態位置，不提交資料，也不快取放置許可。
	void _previewDrop(KlpExplorerDropRequest? request) {
		final next = request != null && content.permitsDrop(request) ? request : null;
		if (_dropPreview?.targetId == next?.targetId && _dropPreview?.position == next?.position) return;

		setState(() => _dropPreview = next);
	}

	int _depth(KlpExplorerItemSnapshot item) {
		var depth = 0;
		var parent = item.parentId;
		while (parent != null) {
			final ancestor = content.snapshot.items[parent]!;
			if (ancestor.role == KlpExplorerRole.node) { depth++; }
			parent = ancestor.parentId;
		}
		return depth;
	}

	(KlpId, bool, double)? _dropMarker() {
		final preview = _dropPreview;
		if (preview == null) return null;

		final target = content.snapshot.items[preview.targetId]!;
		final before = preview.position == KlpExplorerDropPlacement.before;
		var anchor = target.id;
		if (!before) {
			// 同層的 after 必須越過整個可見子樹，inside 則在子項末端。
			final visible = content.tree.visibleIds;
			for (final id in visible.skip(visible.indexOf(target.id) + 1)) {
				var parent = content.snapshot.items[id]!.parentId;
				while (parent != null && parent != target.id) { parent = content.snapshot.items[parent]!.parentId; }
				if (parent == null) break;

				anchor = id;
			}
		}
		var depth = _depth(target);
		if (preview.position == KlpExplorerDropPlacement.inside && target.role == KlpExplorerRole.node) { depth++; }

		// 指示的是待插入項目的基線；node 與圖示共用箭頭預留欄。
		final insertingNode = preview.sourceIds.any((id) => content.snapshot.items[id]!.role == KlpExplorerRole.node);
		final disclosureInset = insertingNode ? content.disclosureExtent.value : 0.0;
		return (anchor, before, content.inset.value + disclosureInset + depth * content.indent.value);
	}

	Widget _withDropLine(KlpId id, Widget row, (KlpId, bool, double)? marker) {
		final gap = content.gap.value;
		final first = id == content.tree.visibleIds.first;
		final last = id == content.tree.visibleIds.last;
		final beforeOffset = first ? 0.0 : -gap;
		final afterOffset = last ? 0.0 : -gap;

		// 覆蓋既有間隙而不推動列；首尾沒有間隙時貼內側邊界，避免被裁切。
		return Stack(clipBehavior: Clip.none, children: [row, if (marker != null && marker.$1 == id) PositionedDirectional(
			start: marker.$3,
			end: content.inset.value,
			top: marker.$2 ? beforeOffset : null,
			bottom: marker.$2 ? null : afterOffset,
			height: gap,
			child: IgnorePointer(child: DecoratedBox(key: const ValueKey('explorer.drop-indicator'), decoration: BoxDecoration(color: klpFlutterColor(content.focusColor), borderRadius: BorderRadius.circular(gap / 2)))),
		)]);
	}

	@override
	Widget build(BuildContext context) {
		final marker = _dropMarker();
		return Localizations.override(context: context, delegates: const [DefaultMaterialLocalizations.delegate], child: Column(
			mainAxisSize: MainAxisSize.min,
			children: [for (final (index, id) in content.tree.visibleIds.indexed) ...[
				if (index != 0) SizedBox(height: content.gap.value),
				KeyedSubtree(key: ValueKey(id), child: Builder(key: _rowKeys.putIfAbsent(id, GlobalKey.new), builder: (rowContext) => _withDropLine(id, _row(rowContext, content.snapshot.items[id]!), marker))),
			]],
		));
	}

	Widget _row(BuildContext context, KlpExplorerItemSnapshot item) {
		final node = _focus.putIfAbsent(item.id, () => FocusNode(debugLabel: item.row.title));
		final category = item.role == KlpExplorerRole.category;
		final extent = category ? content.categoryExtent.value : content.nodeExtent.value;
		final expandable = item.canToggleExpansion;
		final expanded = !item.capabilities.collapsible || content.tree.expandedIds.contains(item.id);
		final selected = content.selection.selectedIds.contains(item.id);
		final depth = _depth(item);

		// 兩種角色共用箭頭尺度；非收合分類只呈現指示，不冒充可操作按鈕。
		final arrow = SizedBox(width: content.disclosureExtent.value, height: extent, child: Center(child: KlpFlutterLucideIcon(expanded ? 'chevron-down' : 'chevron-right', size: content.disclosureIconExtent.value, color: klpFlutterColor(content.mutedForeground))));
		final localizations = KlpLocalizations.of(context);
		final disclosureLabel = expanded ? localizations.explorerCollapseLabel : localizations.explorerExpandLabel;
		final disclosure = expandable ? Semantics(label: '$disclosureLabel ${item.row.title}', button: true, child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: () => _toggle(item), child: arrow)) : ExcludeSemantics(child: arrow);
		final title = ExcludeSemantics(child: Text(item.row.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: category ? _text.copyWith(fontSize: content.categoryFontSize.value, color: klpFlutterColor(content.mutedForeground)) : _text));

		// 列內表面與命中使用同一 extent；節點固定箭頭欄以保持同層圖示對齊。
		final row = KlpFlutterSelectionSurface(
			color: klpFlutterColor(content.selectedBackground), radius: content.radius.value, selected: selected, enabled: true,
			child: Focus(
				focusNode: node,
				onKeyEvent: (_, event) => _key(context, item, event),
				child: Semantics(
					container: true, label: item.row.title, selected: selected,
					child: GestureDetector(
						behavior: HitTestBehavior.opaque,
						onTap: () => _click(item),
						onSecondaryTapDown: item.row.contextActions.isEmpty ? null : (details) => _menu(context, item, details.globalPosition),
						child: Padding(padding: EdgeInsetsDirectional.only(start: depth * content.indent.value), child: SizedBox(height: extent, child: Row(children: [
							SizedBox(width: content.inset.value),
							if (!category) SizedBox(width: content.disclosureExtent.value, child: expandable ? disclosure : null),
							if (item.row.icon != null) ...[_icon(item), SizedBox(width: content.inset.value)],
							Expanded(child: category ? Row(children: [Flexible(child: title), disclosure]) : title),
							if (item.row.badge != null) ...[SizedBox(width: content.inset.value), Text(item.row.badge!, style: _text)],
							for (final command in item.row.inlineActions) Semantics(label: command.label, button: true, enabled: command.enabled, child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: !command.enabled ? null : () => unawaited(runKlpCommand(context, _command(context, item.id, command), _commandStyle, content.isActive)), child: ConstrainedBox(constraints: BoxConstraints(minWidth: content.actionExtent.value), child: Padding(padding: EdgeInsets.symmetric(horizontal: content.inset.value), child: Text(command.label, style: _text.copyWith(color: klpFlutterColor(command.enabled ? content.foreground : content.mutedForeground))))))),
							SizedBox(width: content.inset.value),
						]))),
					),
				),
			),
		);
		return _drag(context, item, row);
	}

	Widget _icon(KlpExplorerItemSnapshot item) => KlpFlutterLucideIcon(const ['file-text', 'folder', 'image', 'music', 'layout-dashboard'][item.row.icon!.index], size: content.iconExtent.value, color: klpFlutterColor(content.mutedForeground));

	Widget _drag(BuildContext context, KlpExplorerItemSnapshot item, Widget row) {
		if (content.snapshot.acceptedDrops.isEmpty) return row;

		KlpExplorerDropRequest request(Set<KlpId> ids, Offset offset) {
			final box = context.findRenderObject()! as RenderBox;
			final y = box.globalToLocal(offset).dy;
			var position = KlpExplorerDropPlacement.inside;
			if (y < box.size.height / 3) { position = KlpExplorerDropPlacement.before; }
			else if (y > box.size.height * 2 / 3) { position = KlpExplorerDropPlacement.after; }
			else if (!item.canHaveChildren) { position = y < box.size.height / 2 ? KlpExplorerDropPlacement.before : KlpExplorerDropPlacement.after; }
			return KlpExplorerDropRequest(sourceIds: ids, targetId: item.id, position: position);
		}

		// 持續觀察列內位置；候選追蹤不是許可，preview／commit 分別驗證。
		final target = DragTarget<Set<KlpId>>(
			onWillAcceptWithDetails: (details) { _previewDrop(request(details.data, details.offset)); return true; },
			onMove: (details) => _previewDrop(request(details.data, details.offset)),
			onLeave: (_) { if (_dropPreview?.targetId == item.id) { _previewDrop(null); } },
			onAcceptWithDetails: (details) {
				final accepted = request(details.data, details.offset);
				_previewDrop(null);
				if (content.permitsDrop(accepted)) content.onIntent?.call(KlpExplorerDropRequested(sourceIds: accepted.sourceIds, targetId: accepted.targetId, position: accepted.position));
			},
			builder: (_, candidates, _) => row,
		);
		if (!item.capabilities.draggable) { return target; }

		final selected = content.selection.selectedIds;
		final source = selected.contains(item.id) ? selected : {item.id};
		return Draggable<Set<KlpId>>(
			data: source,
			dragAnchorStrategy: pointerDragAnchorStrategy,
			feedback: Directionality(key: const ValueKey('explorer.drag-feedback'), textDirection: Directionality.of(context), child: DecoratedBox(decoration: BoxDecoration(color: klpFlutterColor(content.selectedBackground), borderRadius: BorderRadius.circular(content.radius.value)), child: Padding(padding: EdgeInsets.all(content.inset.value), child: Row(mainAxisSize: MainAxisSize.min, children: [
				if (item.row.icon != null) ...[_icon(item), SizedBox(width: content.inset.value)],
				Text(item.row.title, style: _text),
			])))),
			child: target,
		);
	}
}
