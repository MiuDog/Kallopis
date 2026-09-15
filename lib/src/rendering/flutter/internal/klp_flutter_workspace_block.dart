import 'package:kallopis/src/features/workspace/presentation/klp_workspace_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'klp_flutter_lucide_icon.dart';
import 'klp_flutter_values.dart';
import 'klp_flutter_selection_surface.dart';
import 'klp_flutter_interaction_theme.dart';

final class KlpFlutterWorkspaceBlock extends StatelessWidget {
	final KlpBoundWorkspaceBlock content;
	const KlpFlutterWorkspaceBlock({required this.content, super.key});

	@override
	Widget build(BuildContext context) {
		final body = content.kind == 4
			? Localizations.override(context: context, delegates: const [DefaultMaterialLocalizations.delegate], child: Material(type: MaterialType.transparency, child: _search()))
			: switch (content.kind) {
				0 => _identity(context),
				1 => _action(),
				2 => _paper(),
				3 => _sticky(),
				5 => _settings(),
				6 || 7 => _collection(),
				8 => _dialog(context),
				9 => _toolbar(),
				_ => throw StateError('Unknown workspace block kind: ${content.kind}.'),
			};
		if (content.kind == 0 || content.actions.isEmpty) return _interactionTheme(body);
		return _interactionTheme(Stack(children: [body, PositionedDirectional(top: content.compactGap.value, end: content.compactGap.value, child: _commandButton(context))]));
	}

	Widget _interactionTheme(Widget child) => KlpFlutterInteractionTheme(color: klpFlutterColor(content.selectedBackground), foreground: klpFlutterColor(content.foreground), radius: content.radius.value, child: child);

	/// 圖示工具列的外殼與命中區分離，名稱保留於提示與輔助語意。
	Widget _toolbar() => Padding(
		padding: EdgeInsets.symmetric(vertical: content.compactGap.value),
		child: DecoratedBox(
			decoration: BoxDecoration(color: klpFlutterColor(content.background), borderRadius: BorderRadius.circular(content.rowExtent.value / 2 + content.compactGap.value)),
			child: Padding(padding: EdgeInsets.all(content.compactGap.value), child: Row(mainAxisSize: MainAxisSize.min, children: [
				for (final (index, item) in content.items.indexed) ...[
					if (index > 0) SizedBox(width: content.compactGap.value),
					Tooltip(message: item.title, child: _interactive(item.title, item.onPressed, SizedBox.square(dimension: content.rowExtent.value, child: Center(child: item.icon == null ? const SizedBox.shrink() : _icon(item.icon!))), selected: item.selected)),
				],
			])),
		),
	);

	Widget _identity(BuildContext context) => SizedBox(height: content.headerExtent.value, child: Padding(padding: EdgeInsets.symmetric(horizontal: content.gap.value), child: Row(children: [
		if (content.icon != null) ...[_icon(content.icon!), SizedBox(width: content.compactGap.value)] else if (content.symbol != null) ...[Text(content.symbol!, style: _brandStyle(content.brandMarkSize.value).copyWith(color: klpFlutterColor(content.accentColor))), SizedBox(width: content.controlGap.value)],
		if (content.title.isEmpty) const Spacer() else Expanded(child: _interactive(content.title, content.onPressed, Text(content.title, style: _brandStyle(content.brandNameSize.value)))),
		if (content.secondaryActionLabel != null) _iconAction(content.secondaryActionLabel!, '⌕', content.onSecondaryAction),
		if (content.tertiaryActionLabel != null) _iconAction(content.tertiaryActionLabel!, '⚙', content.onTertiaryAction),
		if (content.actions.isNotEmpty) _commandButton(context),
	])));

	Widget _commandButton(BuildContext context) => Material(type: MaterialType.transparency, child: PopupMenuButton<KlpBoundWorkspaceCommand>(
		tooltip: content.actionsLabel,
		color: klpFlutterColor(content.background),
		onSelected: (command) => _runCommand(context, command),
		itemBuilder: (_) => [for (final command in content.actions) PopupMenuItem(value: command, enabled: command.enabled, child: Text(command.label, style: _style(color: command.destructive ? content.accentColor : content.foreground)))],
		child: SizedBox.square(dimension: content.rowExtent.value, child: Center(child: KlpFlutterLucideIcon('more-horizontal', size: content.bodySize.value, color: klpFlutterColor(content.mutedForeground)))),
	));

	Future<void> _runCommand(BuildContext context, KlpBoundWorkspaceCommand command) async {
		String? value;
		if (command.inputLabel != null) {
			final controller = TextEditingController(text: command.initialValue);
			value = await showDialog<String>(context: context, builder: (dialogContext) => _interactionTheme(AlertDialog(backgroundColor: klpFlutterColor(content.background), title: Text(command.inputLabel!, style: _style()), content: TextField(controller: controller, autofocus: true, style: _style()), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(command.cancelLabel)), TextButton(onPressed: () { final text = controller.text.trim(); if (text.isNotEmpty) Navigator.pop(dialogContext, text); }, child: Text(command.submitLabel))])));
			if (value == null || value.isEmpty) return;
		}
		if (!context.mounted) return;
		if (command.confirmation != null) {
			final confirmed = await showDialog<bool>(context: context, builder: (dialogContext) => _interactionTheme(AlertDialog(backgroundColor: klpFlutterColor(content.background), title: Text(command.confirmation!, style: _style()), actions: [TextButton(onPressed: () => Navigator.pop(dialogContext, false), child: Text(command.cancelLabel)), TextButton(onPressed: () => Navigator.pop(dialogContext, true), child: Text(command.submitLabel))])));
			if (confirmed != true) return;
		}
		command.onInvoke(value);
	}

	Widget _action() => _interactive(content.title, content.onPressed, SizedBox(height: content.rowExtent.value, child: Row(children: [
			SizedBox(width: content.rowExtent.value, child: Center(child: content.icon == null ? const SizedBox.shrink() : _icon(content.icon!, color: content.mutedForeground))),
			Expanded(child: Text(content.title, style: _style(weight: FontWeight.w400))),
		])),
	selected: content.selected);

	Widget _paper() => ColoredBox(color: klpFlutterColor(content.background), child: SingleChildScrollView(padding: EdgeInsets.symmetric(horizontal: content.rowExtent.value - content.compactGap.value / 2, vertical: content.rowExtent.value - content.compactGap.value), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
		if (content.subtitle != null) Text(content.subtitle!, style: _brandStyle(content.eyebrowSize.value).copyWith(color: klpFlutterColor(content.mutedForeground))),
		SizedBox(height: content.gap.value),
		Text(content.title, style: _style(size: content.titleSize.value, weight: FontWeight.w600, height: content.textStyle.lineHeight.value)),
		SizedBox(height: content.gap.value),
		if (content.content != null) _workspaceContent(content.content!) else ...[
			for (final line in content.lines) Padding(padding: EdgeInsets.only(bottom: content.gap.value), child: Text(line, style: _style(size: content.bodySize.value, height: content.bodyLineHeight.value))),
		if (content.checklist.isNotEmpty) ...[SizedBox(height: content.gap.value), if (content.checklistTitle != null) Text(content.checklistTitle!, style: _style(size: content.sectionSize.value, weight: FontWeight.w600)), SizedBox(height: content.gap.value), for (final item in content.checklist) SizedBox(height: content.rowExtent.value, child: Row(children: [Text('☐', style: _style(color: content.mutedForeground)), SizedBox(width: content.gap.value), Expanded(child: Text(item, style: _style()))]))],
			if (content.items.isNotEmpty) ...[SizedBox(height: content.gap.value), for (final item in content.items) _item(item)],
		],
	])));

	Widget _sticky() => DecoratedBox(decoration: BoxDecoration(color: klpFlutterColor(content.materialBackground), borderRadius: BorderRadius.circular(content.stickyRadius.value), boxShadow: content.shadowed ? [BoxShadow(color: klpFlutterColor(content.shadowColor), offset: Offset(0, content.shadowOffset.value), blurRadius: content.shadowBlur.value)] : const []), child: Padding(padding: EdgeInsets.all(content.inset.value), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [
		if (content.subtitle != null) ...[Text(content.subtitle!, style: _brandStyle(content.eyebrowSize.value).copyWith(color: klpFlutterColor(content.mutedForeground))), SizedBox(height: content.gap.value)],
		Text(content.title, style: _style(weight: FontWeight.w600)),
		SizedBox(height: content.gap.value),
		if (content.content != null) _workspaceContent(content.content!) else for (final line in content.lines) Padding(padding: EdgeInsets.only(bottom: content.compactGap.value), child: Text(line, style: _style(color: content.mutedForeground, size: content.detailSize.value, height: content.detailLineHeight.value))),
		for (final item in content.items) _item(item),
	])));

	Widget _search() => Padding(padding: EdgeInsets.all(content.inset.value), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
		Text(content.title, style: _style(size: content.sectionSize.value, weight: FontWeight.w600)),
		SizedBox(height: content.gap.value),
		TextFormField(initialValue: content.query, onChanged: content.onQueryChanged, style: _style(), cursorColor: klpFlutterColor(content.foreground), decoration: InputDecoration(hintText: content.hint, hintStyle: _style(color: content.mutedForeground), filled: true, fillColor: klpFlutterColor(content.background), border: OutlineInputBorder(borderRadius: BorderRadius.circular(content.radius.value), borderSide: BorderSide.none), contentPadding: EdgeInsets.symmetric(horizontal: content.gap.value, vertical: content.compactGap.value))),
		SizedBox(height: content.gap.value),
		for (final line in content.lines) Text(line, style: _style(color: content.mutedForeground)),
		for (final item in content.items) _item(item),
	]));

	Widget _dialog(BuildContext context) => ColoredBox(
		color: klpFlutterColor(content.selectedBackground),
		child: Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: content.rowExtent.value * 11), child: DecoratedBox(
			decoration: BoxDecoration(color: klpFlutterColor(content.background), borderRadius: BorderRadius.circular(content.radius.value)),
			child: Padding(padding: EdgeInsets.all(content.inset.value), child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
				Text(content.title, style: _style(size: content.sectionSize.value, weight: FontWeight.w600)),
				if (content.subtitle != null) ...[SizedBox(height: content.compactGap.value), Text(content.subtitle!, style: _style(color: content.mutedForeground))],
				SizedBox(height: content.gap.value),
				Localizations.override(context: context, delegates: const [DefaultMaterialLocalizations.delegate], child: Material(type: MaterialType.transparency, child: TextFormField(key: ValueKey(content.query), initialValue: content.query, autofocus: true, onChanged: content.onQueryChanged, onFieldSubmitted: (_) => content.items.firstOrNull?.onPressed?.call(), style: _style(), cursorColor: klpFlutterColor(content.foreground), decoration: InputDecoration(hintText: content.hint, errorText: content.lines.firstOrNull, filled: true, fillColor: klpFlutterColor(content.selectedBackground), border: OutlineInputBorder(borderRadius: BorderRadius.circular(content.radius.value), borderSide: BorderSide.none))))),
				SizedBox(height: content.gap.value),
				Wrap(alignment: WrapAlignment.end, spacing: content.compactGap.value, children: [for (final item in content.items) _interactive(item.title, item.onPressed, Padding(padding: EdgeInsets.symmetric(horizontal: content.gap.value, vertical: content.compactGap.value), child: Text(item.title, style: _style(weight: FontWeight.w600))))]),
			])),
		))),
	);

	Widget _settings() => Padding(padding: EdgeInsets.all(content.inset.value), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
		Text(content.title, style: _style(size: content.sectionSize.value, weight: FontWeight.w600)),
		SizedBox(height: content.gap.value),
		Wrap(spacing: content.compactGap.value, runSpacing: content.compactGap.value, children: [for (final choice in content.choices) _interactive(choice.label, choice.onSelected, DecoratedBox(decoration: BoxDecoration(color: choice.selected ? klpFlutterColor(content.selectedBackground) : klpFlutterColor(content.background), borderRadius: BorderRadius.circular(content.radius.value)), child: Padding(padding: EdgeInsets.symmetric(horizontal: content.gap.value, vertical: content.compactGap.value), child: Text(choice.label, style: _style()))))]),
		if (content.toggleLabel != null && content.toggleValue != null) ...[SizedBox(height: content.gap.value), _checklistRow(content.toggleLabel!, content.toggleValue!, content.onToggleChanged)],
	]));

	Widget _collection() => Padding(padding: EdgeInsets.all(content.inset.value), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [Text(content.title, style: _style(size: content.titleSize.value, weight: FontWeight.w600)), SizedBox(height: content.gap.value), Wrap(spacing: content.gap.value, runSpacing: content.gap.value, children: [for (final item in content.items) SizedBox(width: content.rowExtent.value * 7, child: _collectionItem(item))]), if (content.secondaryActionLabel != null) ...[SizedBox(height: content.gap.value), _interactive(content.secondaryActionLabel!, content.onSecondaryAction, SizedBox(height: content.rowExtent.value, child: Center(child: Text(content.secondaryActionLabel!, style: _style(weight: FontWeight.w600)))))] ]));

	Widget _collectionItem(KlpBoundWorkspaceItem item) => _interactive(item.title, item.onPressed, DecoratedBox(
		decoration: BoxDecoration(
			color: klpFlutterColor(content.kind == 6 ? content.materialBackground : content.calloutBackground),
			borderRadius: BorderRadius.circular(content.stickyRadius.value),
			boxShadow: content.shadowed ? [BoxShadow(color: klpFlutterColor(content.shadowColor), offset: Offset(0, content.shadowOffset.value), blurRadius: content.shadowBlur.value)] : const [],
		),
		child: Padding(padding: EdgeInsets.all(content.inset.value), child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
			if (item.symbol != null) ...[Text(item.symbol!, style: _brandStyle(content.eyebrowSize.value).copyWith(color: klpFlutterColor(content.mutedForeground))), SizedBox(height: content.gap.value)],
			if (item.icon != null) ...[_icon(item.icon!), SizedBox(height: content.gap.value)],
			Text(item.title, style: _style(size: content.bodySize.value, weight: FontWeight.w600)),
			if (item.subtitle != null) ...[SizedBox(height: content.gap.value), Text(item.subtitle!, style: _style(size: content.detailSize.value, height: content.detailLineHeight.value, color: content.mutedForeground))],
		])),
	));

	Widget _item(KlpBoundWorkspaceItem item) {
		final text = Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text(item.title, style: _style(weight: FontWeight.w600)), if (item.subtitle != null) Text(item.subtitle!, style: _style(color: content.mutedForeground))]);
		if (item.checked != null) return _checklistRow(item.title, item.checked!, item.onCheckedChanged, text: text);
		return _interactive(item.title, item.onPressed, DecoratedBox(decoration: BoxDecoration(color: klpFlutterColor(content.background), borderRadius: BorderRadius.circular(content.radius.value)), child: Padding(padding: EdgeInsets.all(content.gap.value), child: Row(children: [if (item.icon != null) ...[_icon(item.icon!), SizedBox(width: content.gap.value)] else if (item.symbol != null) Text(item.symbol!, style: _style()), Expanded(child: text)]))));
	}

	Widget _iconAction(String label, String symbol, void Function()? action) => _interactive(label, action, SizedBox.square(dimension: content.rowExtent.value, child: Center(child: _icon(symbol == '⌕' ? 0 : 1, color: content.mutedForeground))));

	Widget _workspaceContent(KlpBoundTemplate template) => switch (template) {
		KlpBoundPlacement(:final content) => _workspaceContent(content),
		KlpBoundWorkspaceContent value => Flex(direction: value.axis == 0 ? Axis.horizontal : Axis.vertical, crossAxisAlignment: CrossAxisAlignment.start, children: [for (final (index, child) in value.children.indexed) ...[if (index > 0) SizedBox(width: value.axis == 0 ? content.columnGap.value : 0, height: value.axis == 0 ? 0 : content.gap.value), value.axis == 0 ? Expanded(child: _workspaceContent(child)) : _workspaceContent(child)]]),
		KlpBoundWorkspaceContentBlock value => _contentBlock(value),
		_ => const SizedBox.shrink(),
	};

	Widget _contentBlock(KlpBoundWorkspaceContentBlock block) {
		final nested = block.children.isEmpty
			? null
			: Flex(
				direction: block.axis == 0 ? Axis.horizontal : Axis.vertical,
				crossAxisAlignment: CrossAxisAlignment.start,
				children: [
					for (final (index, child) in block.children.indexed) ...[
						if (index > 0 && block.axis == 0) SizedBox(width: content.columnGap.value),
						block.axis == 0 ? Expanded(child: _workspaceContent(child)) : _workspaceContent(child),
					],
				],
			);
		return switch (block.kind) {
			0 => Padding(padding: EdgeInsets.only(bottom: content.gap.value), child: Text(block.text, style: _style(size: content.bodySize.value, height: content.bodyLineHeight.value))),
			1 => Padding(padding: EdgeInsets.only(bottom: content.gap.value), child: Text(block.text, style: _style(size: content.sectionSize.value, weight: FontWeight.w600))),
			2 => Container(margin: EdgeInsets.only(bottom: content.gap.value), padding: EdgeInsets.all(content.gap.value), decoration: BoxDecoration(color: klpFlutterColor(content.calloutBackground), borderRadius: BorderRadius.circular(content.radius.value)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [if (block.icon != null) ...[_icon(block.icon!), SizedBox(width: content.gap.value)], Expanded(child: nested ?? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(block.text, style: _style(size: content.detailSize.value, weight: FontWeight.w600)), if (block.subtitle != null) Text(block.subtitle!, style: _style(size: content.detailSize.value))]))])),
			3 => Padding(padding: EdgeInsets.symmetric(vertical: content.gap.value), child: SizedBox(width: double.infinity, height: content.dividerStroke.value, child: CustomPaint(painter: _WorkspaceDashPainter(klpFlutterColor(content.mutedForeground), content.dividerStroke.value)))),
			4 => _interactive(block.text, block.onPressed, Padding(padding: EdgeInsets.all(content.gap.value), child: Row(children: [if (block.icon != null) ...[_icon(block.icon!), SizedBox(width: content.gap.value)], Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(block.text, style: _style(weight: FontWeight.w600)), if (block.subtitle != null) Text(block.subtitle!, style: _style(color: content.mutedForeground))]))]))),
			5 => _checklistRow(block.text, block.checked ?? false, block.onCheckedChanged),
			6 => nested ?? const SizedBox.shrink(),
			7 => Padding(padding: EdgeInsets.only(bottom: content.gap.value), child: Text(block.text, style: _style(size: content.bodySize.value, height: content.detailLineHeight.value, color: content.mutedForeground))),
			_ => const SizedBox.shrink(),
		};
	}

	Widget _checklistRow(String label, bool checked, ValueChanged<bool>? onChanged, {Widget? text}) => _interactive(
		label,
		onChanged == null ? null : () => onChanged(!checked),
		ConstrainedBox(constraints: BoxConstraints(minHeight: content.rowExtent.value), child: Row(children: [
			SizedBox.square(dimension: content.controlExtent.value, child: DecoratedBox(
				decoration: BoxDecoration(color: checked ? klpFlutterColor(content.accentColor) : null, border: checked ? null : Border.all(color: klpFlutterColor(content.mutedForeground), width: content.dividerStroke.value), borderRadius: BorderRadius.circular(content.controlRadius.value)),
				child: checked ? Center(child: KlpFlutterLucideIcon('check', size: content.controlExtent.value - content.compactGap.value, color: klpFlutterColor(content.background))) : null,
			)),
			SizedBox(width: content.controlGap.value),
			Expanded(child: text ?? Text(label, style: _style(size: content.detailSize.value, color: checked ? content.mutedForeground : content.foreground).copyWith(decoration: checked ? TextDecoration.lineThrough : TextDecoration.none))),
		])),
		checked: checked,
	);

	Widget _icon(int value, {KlpColor? color}) => KlpFlutterLucideIcon(_iconData(value), size: content.iconExtent.value, color: klpFlutterColor(color ?? content.foreground));
	String _iconData(int value) => switch (value) { 0 => 'search', 1 => 'sliders-horizontal', 2 => 'inbox', 3 => 'calendar', 4 => 'clipboard-list', 5 => 'archive', 6 => 'chevron-right', 7 => 'folder', 8 => 'file-text', 9 => 'minus', 10 => 'square', 11 => 'copy', 12 => 'x', 13 => 'check', 14 => 'link', 15 => 'info', 16 => 'sparkles', 17 => 'image', 18 => 'music', 19 => 'layout-dashboard', 20 => 'lightbulb', 21 => 'calendar-check', _ => throw StateError('Unknown workspace icon: $value') };

	Widget _interactive(String label, void Function()? action, Widget child, {bool? checked, bool? selected}) {
		Color? background;
		if (child is DecoratedBox && child.decoration is BoxDecoration) {
			final decoration = child.decoration as BoxDecoration;
			background = decoration.color;
			child = DecoratedBox(decoration: decoration.copyWith(color: const Color(0x00000000)), child: child.child);
		}
		return KlpFlutterSelectionSurface(color: klpFlutterColor(content.selectedBackground), backgroundColor: background, radius: content.radius.value, selected: selected ?? false, enabled: action != null, child: Semantics(selected: selected, button: checked == null, checked: checked, label: label, enabled: action != null, excludeSemantics: true, child: FocusableActionDetector(enabled: action != null, shortcuts: const {SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(), SingleActivator(LogicalKeyboardKey.space): ActivateIntent()}, actions: {ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) { action?.call(); return null; })}, child: GestureDetector(onTap: action, behavior: HitTestBehavior.opaque, child: child))));
	}

	TextStyle _style({KlpColor? color, double? size, FontWeight? weight, double? height}) => klpFlutterTextStyle(content.textStyle).copyWith(color: klpFlutterColor(color ?? content.foreground), fontSize: size, fontWeight: weight, height: height, textBaseline: TextBaseline.alphabetic);
	TextStyle _brandStyle(double size) => _style(size: size, weight: FontWeight.w600).copyWith(fontFamily: content.brandFamily.family, fontFamilyFallback: content.brandFamily.fallback);
}

final class _WorkspaceDashPainter extends CustomPainter {
	final Color color;
	final double stroke;
	const _WorkspaceDashPainter(this.color, this.stroke);
	@override
	void paint(Canvas canvas, Size size) {
		final paint = Paint()..color = color..strokeWidth = stroke;
		final dash = stroke * 3;
		final gap = stroke * 2;
		for (var start = 0.0; start < size.width; start += dash + gap) {
			canvas.drawLine(Offset(start, stroke / 2), Offset((start + dash).clamp(0, size.width).toDouble(), stroke / 2), paint);
		}
	}
	@override
	bool shouldRepaint(_WorkspaceDashPainter oldDelegate) => oldDelegate.color != color || oldDelegate.stroke != stroke;
}
