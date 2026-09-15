import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' show AlertDialog, DefaultMaterialLocalizations, Material, MaterialType, TextButton, TextField, showDialog;
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_text_style.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/kernel/identity/klp_id.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_selection_surface.dart';
import 'klp_flutter_interaction_theme.dart';
import 'klp_page_reference_drag.dart';

final class KlpFlutterExplorer extends StatefulWidget {
	final KlpBoundExplorer content;
	const KlpFlutterExplorer({required this.content, super.key});
	@override
	State<KlpFlutterExplorer> createState() => _KlpFlutterExplorerState();
}

final class _KlpFlutterExplorerState extends State<KlpFlutterExplorer> {
	KlpBoundExplorer get content => widget.content;
	OverlayEntry? _menuEntry;
	final _menuFocus = FocusNode(debugLabel: 'Explorer menu');
	KlpPlacementId? _anchor;
	void _openMenu(List<KlpBoundWorkspaceCommand> commands) {
		_menuEntry?.remove();
		late final OverlayEntry entry;
		void dismiss() { if (_menuEntry != entry) return; entry.remove(); _menuEntry = null; }
		entry = OverlayEntry(builder: (overlayContext) => Stack(children: [
			Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: dismiss)),
			PositionedDirectional(top: content.inset.value, start: content.inset.value, child: Focus(focusNode: _menuFocus, onKeyEvent: (_, event) {
				if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) { dismiss(); return KeyEventResult.handled; }
				return KeyEventResult.ignored;
			}, child: Localizations.override(context: overlayContext, delegates: const [DefaultMaterialLocalizations.delegate], child: ConstrainedBox(constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(overlayContext).height - content.inset.value * 2), child: SingleChildScrollView(child: _CommandMenu(commands: commands, content: content, onDismiss: dismiss, context: context)))))),
		]));
		_menuEntry = entry;
		Overlay.of(context).insert(entry);
		WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted && _menuEntry == entry) _menuFocus.requestFocus(); });
	}
	@override
	void dispose() {
		_menuEntry?.remove();
		_menuFocus.dispose();
		super.dispose();
	}
	void _select(KlpBoundExplorerItemData item) {
		if (item.category || !item.selectable) return;
		final selected = _selected(content.items);
		final multi = HardwareKeyboard.instance.isControlPressed || HardwareKeyboard.instance.isMetaPressed;
		final shift = HardwareKeyboard.instance.isShiftPressed;
		final selectable = _selectable(content.items);
		final anchorIndex = _anchor == null ? -1 : selectable.indexOf(_anchor!);
		final itemIndex = selectable.indexOf(item.id);
		final next = shift && anchorIndex >= 0 && itemIndex >= 0
			? selectable.sublist(anchorIndex < itemIndex ? anchorIndex : itemIndex, (anchorIndex > itemIndex ? anchorIndex : itemIndex) + 1).toSet()
			: multi ? (selected.contains(item.id) ? (Set.of(selected)..remove(item.id)) : (Set.of(selected)..add(item.id))) : {item.id};
		if (!shift) _anchor = item.id;
		content.onSelectionChanged?.call(next);
		if (!multi && !shift) content.onSelected?.call(item.id);
	}
	List<KlpPlacementId> _selectable(List<KlpBoundExplorerItemData> items) => [for (final item in items) ...[if (!item.category && item.selectable) item.id, if (!item.collapsible || item.expanded || !content.allowNesting && !item.category) ..._selectable(item.children)]];
	Set<KlpPlacementId> _selected(List<KlpBoundExplorerItemData> items) {
		final result = <KlpPlacementId>{};
		for (final item in items) {
			if (item.selected && !item.category && item.selectable) result.add(item.id);
			result.addAll(_selected(item.children));
		}
		return result;
	}
	@override
	Widget build(BuildContext context) => ColoredBox(
		color: klpFlutterColor(content.background),
		child: Padding(padding: EdgeInsets.symmetric(horizontal: content.spacing == 2 ? 0 : content.inset.value), child: Column(mainAxisSize: MainAxisSize.min, children: [
			for (final (index, item) in content.items.indexed) ...[
				if (index > 0) SizedBox(height: content.gap.value),
				_ExplorerItem(content: content, item: item, depth: 0, onSelect: _select, onMenu: _openMenu),
			],
		])),
	);
}

/// 分類、展開槽、圖示、標題及徽章共用一條列布局，階層資料只讀取 bound tree。
final class _ExplorerItem extends StatelessWidget {
	final KlpBoundExplorer content;
	final KlpBoundExplorerItemData item;
	final int depth;
	final void Function(KlpBoundExplorerItemData) onSelect;
	final void Function(List<KlpBoundWorkspaceCommand>) onMenu;
	const _ExplorerItem({required this.content, required this.item, required this.depth, required this.onSelect, required this.onMenu});
	@override
	Widget build(BuildContext context) {
		final expandable = item.collapsible && (item.category || ((item.folder || item.branch) && content.allowNesting));
		final expanded = !item.collapsible || (!content.allowNesting && !item.category) || item.expanded;
		final toggle = !expandable || content.onExpandedChanged == null ? null : () => content.onExpandedChanged!(item.id, !item.expanded);
		final activate = item.category || !item.selectable ? toggle : content.onSelected == null && content.onSelectionChanged == null ? null : () => onSelect(item);
		final icon = item.icon ?? (item.category ? null : item.folder ? 'folder' : 'file-text');
		final indent = content.spacing == 1 ? content.indent.value : content.inset.value;
		KlpBoundWorkspaceCommand? deleteCommand;
		KlpBoundWorkspaceCommand? renameCommand;
		for (final command in item.actions) {
			if (command.shortcut == 1 && command.enabled) deleteCommand = command;
			if (command.shortcut == 0 && command.enabled) renameCommand = command;
		}
		final rowExtent = item.category ? content.categoryExtent : content.rowExtent.value;
		final label = Row(children: [
			if (icon != null) ...[
				KlpFlutterLucideIcon(icon, size: content.itemIconExtent, color: klpFlutterColor(content.mutedForeground)),
				SizedBox(width: content.inset.value),
			],
			Expanded(child: Text(item.label, maxLines: 1, overflow: TextOverflow.ellipsis, style: _textStyle(content, item.category ? content.mutedForeground : content.foreground).copyWith(fontSize: item.category ? content.categoryFontSize : content.textStyle.fontSize.value))),
			if (item.badge != null) ...[SizedBox(width: content.inset.value), Text(item.badge!, style: _textStyle(content, content.foreground))],
			SizedBox(width: content.gap.value),
		]);
		final row = KlpFlutterSelectionSurface(
			color: klpFlutterColor(content.selectedBackground), radius: content.radius.value, selected: !item.category && item.selectable && item.selected, highlightFocus: !item.category, enabled: activate != null || toggle != null,
			child: Padding(padding: EdgeInsetsDirectional.only(start: depth * indent), child: SizedBox(height: rowExtent, child: Row(children: [
				if (expandable) _ActionSurface(decorate: false, label: '${expanded ? content.collapseLabel : content.expandLabel} ${item.label}', onActivate: toggle, interactionColor: content.selectedBackground, radius: content.radius.value, child: SizedBox(width: content.indent.value, height: rowExtent, child: KlpFlutterLucideIcon(expanded ? 'chevron-down' : 'chevron-right', size: content.textStyle.fontSize.value, color: klpFlutterColor(content.mutedForeground))))
				else SizedBox(width: content.indent.value),
				Expanded(child: _ActionSurface(decorate: false, label: item.label, selected: !item.category && item.selected, onActivate: activate, onContextMenu: item.actions.isEmpty ? null : (_) => onMenu(item.actions), onRename: renameCommand == null ? null : () => _runCommand(context, renameCommand!, content), onDelete: deleteCommand == null ? null : () => _runCommand(context, deleteCommand!, content), interactionColor: content.selectedBackground, radius: content.radius.value, child: SizedBox(height: rowExtent, child: label))),
				if (item.actions.isNotEmpty && content.showCommandButtons) SizedBox(height: rowExtent, child: _CommandButton(commands: item.actions, content: content, onMenu: onMenu)),
			]))),
		);
		return Column(mainAxisSize: MainAxisSize.min, children: [
			_dragSurface(row),
			if (expanded) for (final child in item.children) ...[
				SizedBox(height: content.gap.value),
				_ExplorerItem(content: content, item: child, depth: item.category || !content.allowNesting ? depth : depth + 1, onSelect: onSelect, onMenu: onMenu),
			],
		]);
	}

	Widget _dragSurface(Widget row) {
		final selected = _selectedBound(content.items);
		final source = item.selected && selected.isNotEmpty ? selected : {item.sourceId};
		final carrier = KlpPageReferenceDrag(sourceIds: source, pageReferences: content.pageReferences);
		if (content.onMove == null && carrier.page == null) return row;

		final target = Builder(builder: (rowContext) {
			if (content.onMove == null) return row;

			int position(Offset offset) {
				if (item.category) return 1;
				final box = rowContext.findRenderObject()! as RenderBox;
				final y = box.globalToLocal(offset).dy;
				if (y < box.size.height / 3) return 0;
				if (y > box.size.height * 2 / 3) return 2;
				return item.folder || item.branch ? 1 : y < box.size.height / 2 ? 0 : 2;
			}
			bool accepts(DragTargetDetails<KlpPageReferenceDrag> details) => !details.data.sourceIds.contains(item.sourceId) && (content.canMove?.call(details.data.sourceIds, item.id, position(details.offset)) ?? true);
			return DragTarget<KlpPageReferenceDrag>(
				onWillAcceptWithDetails: (details) => !details.data.sourceIds.contains(item.sourceId) && [0, 1, 2].any((value) => content.canMove?.call(details.data.sourceIds, item.id, value) ?? true),
				onAcceptWithDetails: (details) { if (accepts(details)) content.onMove!(details.data.sourceIds, item.id, position(details.offset)); },
				builder: (_, candidates, _) => DecoratedBox(decoration: BoxDecoration(border: candidates.isEmpty ? null : Border.all(color: klpFlutterColor(content.focusColor), width: content.focusWidth.value), borderRadius: BorderRadius.circular(content.radius.value)), child: row),
			);
		});
		if (item.category) return target;
		return Draggable<KlpPageReferenceDrag>(
			dragAnchorStrategy: pointerDragAnchorStrategy,
			data: carrier,
			onDragStarted: () { klpActivePageReferenceDrag.value = carrier; },
			onDragEnd: (_) {
				// 只清除自己開始的拖放，避免舊手勢結束時取消新的 carrier。
				if (identical(klpActivePageReferenceDrag.value, carrier)) klpActivePageReferenceDrag.value = null;
			},
			feedback: Material(type: MaterialType.transparency, child: DecoratedBox(decoration: BoxDecoration(color: klpFlutterColor(content.selectedBackground), borderRadius: BorderRadius.circular(content.radius.value)), child: Padding(padding: EdgeInsets.all(content.inset.value), child: Text(item.label, style: _textStyle(content, content.foreground))))),
			childWhenDragging: Opacity(opacity: 0.5, child: target),
			child: target,
		);
	}
}

Set<KlpId> _selectedBound(List<KlpBoundExplorerItemData> items) {
	final result = <KlpId>{};
	for (final item in items) {
		if (item.selected && !item.category && item.selectable) result.add(item.sourceId);
		result.addAll(_selectedBound(item.children));
	}
	return result;
}

final class _CommandButton extends StatelessWidget {
	final List<KlpBoundWorkspaceCommand> commands;
	final KlpBoundExplorer content;
	final void Function(List<KlpBoundWorkspaceCommand>) onMenu;
	const _CommandButton({required this.commands, required this.content, required this.onMenu});
	@override
	Widget build(BuildContext context) => _ActionSurface(label: content.actionsLabel, onActivate: () => onMenu(commands), interactionColor: content.selectedBackground, radius: content.radius.value, child: SizedBox.square(dimension: content.rowExtent.value, child: Center(child: KlpFlutterLucideIcon('more-horizontal', size: content.textStyle.fontSize.value, color: klpFlutterColor(content.mutedForeground)))));
}

final class _CommandMenu extends StatelessWidget {
	final List<KlpBoundWorkspaceCommand> commands;
	final KlpBoundExplorer content;
	final VoidCallback onDismiss;
	final BuildContext context;
	const _CommandMenu({required this.commands, required this.content, required this.onDismiss, required this.context});
	@override
	Widget build(BuildContext _) => SizedBox(width: content.rowExtent.value * 6, child: Material(color: klpFlutterColor(content.background), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [for (final command in commands) _ActionSurface(
		label: command.label, interactionColor: content.selectedBackground, radius: content.radius.value,
		onActivate: !command.enabled ? null : () { onDismiss(); unawaited(_runCommand(context, command, content)); },
		child: Padding(padding: EdgeInsets.symmetric(horizontal: content.inset.value * 2, vertical: content.inset.value), child: Text(command.label, style: _textStyle(content, command.enabled ? (command.destructive ? content.focusColor : content.foreground) : content.mutedForeground))),
	)])));
}

Future<void> _runCommand(BuildContext context, KlpBoundWorkspaceCommand command, KlpBoundExplorer content) async {
	Widget theme(Widget child) => KlpFlutterInteractionTheme(color: klpFlutterColor(content.selectedBackground), foreground: klpFlutterColor(content.foreground), radius: content.radius.value, child: child);
	String? value;
	if (command.inputLabel != null) {
		final controller = TextEditingController(text: command.initialValue);
		value = await showDialog<String>(context: context, builder: (dialogContext) => theme(AlertDialog(
			backgroundColor: klpFlutterColor(content.background),
			title: Text(command.inputLabel!, style: _textStyle(content, content.foreground)),
			content: TextField(controller: controller, autofocus: true, style: _textStyle(content, content.foreground)),
			actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(command.cancelLabel)), TextButton(onPressed: () { final text = controller.text.trim(); if (text.isNotEmpty) Navigator.pop(dialogContext, text); }, child: Text(command.submitLabel))],
		)));
		if (value == null || value.isEmpty) return;
	}
	if (!context.mounted) return;
	if (command.confirmation != null) {
		final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => theme(AlertDialog(backgroundColor: klpFlutterColor(content.background), title: Text(command.confirmation!, style: _textStyle(content, content.foreground)), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(command.cancelLabel)), TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(command.submitLabel))])));
		if (confirmed != true) return;
	}
	command.onInvoke(value);
}

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
	final bool decorate;
	final void Function()? onActivate;
	final void Function(Offset)? onContextMenu;
	final void Function()? onDelete;
	final void Function()? onRename;
	final KlpColor interactionColor;
	final double radius;
	final Widget child;
	const _ActionSurface({required this.label, required this.onActivate, required this.interactionColor, required this.radius, required this.child, this.onContextMenu, this.onDelete, this.onRename, this.selected = false, this.decorate = true});
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
				shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent(), SingleActivator(LogicalKeyboardKey.contextMenu): _MenuIntent(), SingleActivator(LogicalKeyboardKey.f10, shift: true): _MenuIntent(), SingleActivator(LogicalKeyboardKey.delete): _DeleteIntent(), SingleActivator(LogicalKeyboardKey.f2): _RenameIntent(), SingleActivator(LogicalKeyboardKey.arrowDown): NextFocusIntent(), SingleActivator(LogicalKeyboardKey.arrowUp): PreviousFocusIntent()},
				actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { _activate(); return null; }), _MenuIntent: CallbackAction<_MenuIntent>(onInvoke: (_) { widget.onContextMenu?.call(Offset.zero); return null; }), _RenameIntent: CallbackAction<_RenameIntent>(onInvoke: (_) { widget.onRename?.call(); return null; }), _DeleteIntent: CallbackAction<_DeleteIntent>(onInvoke: (_) { widget.onDelete?.call(); return null; })},
				child: GestureDetector(behavior: HitTestBehavior.opaque, excludeFromSemantics: true, onTap: widget.onActivate == null ? null : _activate, onSecondaryTapDown: widget.onContextMenu == null ? null : (details) => widget.onContextMenu!(details.globalPosition), onLongPressStart: widget.onContextMenu == null ? null : (details) => widget.onContextMenu!(details.globalPosition), child: widget.child),
			),
		);
		return widget.decorate ? KlpFlutterSelectionSurface(color: klpFlutterColor(widget.interactionColor), radius: widget.radius, selected: widget.selected, enabled: widget.onActivate != null, child: interaction) : interaction;
	}
}

final class _MenuIntent extends Intent { const _MenuIntent(); }
final class _DeleteIntent extends Intent { const _DeleteIntent(); }
final class _RenameIntent extends Intent { const _RenameIntent(); }

TextStyle _textStyle(KlpBoundExplorer content, KlpColor color) => _resolvedTextStyle(content.textStyle, color);
TextStyle _tabsTextStyle(KlpBoundDocumentTabs content, KlpColor color) => _resolvedTextStyle(content.textStyle, color);
TextStyle _resolvedTextStyle(KlpBoundTextStyle style, KlpColor color) {
	final weightIndex = (style.fontWeight.value / 100).round().clamp(1, 9) - 1;
	return TextStyle(color: klpFlutterColor(color), fontFamily: style.fontFamily.family, fontSize: style.fontSize.value, fontWeight: FontWeight.values[weightIndex], height: style.lineHeight.value, letterSpacing: style.letterSpacing.value);
}
