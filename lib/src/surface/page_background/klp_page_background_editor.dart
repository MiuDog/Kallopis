import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../theme/klp_theme.dart';
import 'klp_page_background.dart';
import 'klp_page_background_recipe.dart';

part 'internal/klp_background_selection_painter.dart';

/// 編輯受限 point／line 背景 recipe 的受控視覺元件。
class KlpPageBackgroundEditor extends StatefulWidget {
	const KlpPageBackgroundEditor({
		super.key,
		required this.recipe,
		required this.tool,
		required this.onChanged,
		this.viewport,
		this.onSelectionChanged,
		this.child,
	});

	final KlpCustomPageBackgroundRecipe recipe;
	final KlpPageBackgroundEditorTool tool;
	final ValueChanged<KlpCustomPageBackgroundRecipe> onChanged;
	final KlpPageBackgroundViewport? viewport;
	final ValueChanged<KlpPageBackgroundSelection?>? onSelectionChanged;
	final Widget? child;

	@override
	State<KlpPageBackgroundEditor> createState() => _KlpPageBackgroundEditorState();
}

class _KlpPageBackgroundEditorState extends State<KlpPageBackgroundEditor> {
	int? _chainPointId;
	KlpPageBackgroundSelection? _selection;

	KlpPageBackgroundViewport get _viewport => widget.viewport ?? KlpPageBackgroundViewport();

	@override
	void didUpdateWidget(covariant KlpPageBackgroundEditor oldWidget) {
		super.didUpdateWidget(oldWidget);
		if (oldWidget.tool != widget.tool) _chainPointId = null;
		if (_selection case final selection?) {
			if (!_selectionExists(selection, widget.recipe)) {
				_selection = null;
				final onSelectionChanged = widget.onSelectionChanged;
				WidgetsBinding.instance.addPostFrameCallback((_) {
					if (mounted) onSelectionChanged?.call(null);
				});
			}
		}
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;

		return Focus(
			autofocus: true,
			onKeyEvent: _handleKeyEvent,
			child: Listener(
				behavior: HitTestBehavior.opaque,
				onPointerDown: _handlePointerDown,
				child: CustomPaint(
					foregroundPainter: _KlpBackgroundSelectionPainter(
						recipe: widget.recipe,
						viewport: _viewport,
						selection: _selection,
						color: klp.color.interaction,
						guideColor: klp.color.pagePattern,
						width: klp.shape.hairline,
						snapSpacing: widget.recipe.snapSpacing ?? klp.space.loose,
					),
					child: KlpPageBackground.recipe(
						recipe: widget.recipe,
						viewport: _viewport,
						child: widget.child ?? const SizedBox.expand(),
					),
				),
			),
		);
	}

	KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
		if (event is KeyDownEvent && event.logicalKey == LogicalKeyboardKey.escape) {
			setState(() => _chainPointId = null);
			return KeyEventResult.handled;
		}
		return KeyEventResult.ignored;
	}

	void _handlePointerDown(PointerDownEvent event) {
		if (event.buttons != kPrimaryButton) return;

		final pagePosition = _viewport.viewportToPage(event.localPosition);
		final hit = _hitTest(pagePosition);
		switch (widget.tool) {
			case KlpPageBackgroundEditorTool.connect:
				_connect(pagePosition, hit);
			case KlpPageBackgroundEditorTool.select:
				_setSelection(hit);
			case KlpPageBackgroundEditorTool.delete:
				_delete(hit);
		}
	}

	void _connect(Offset pagePosition, KlpPageBackgroundSelection? hit) {
		final existingPointId = hit?.kind == KlpPageBackgroundElementKind.point ? hit!.id : null;
		var recipe = widget.recipe;
		final targetId = existingPointId ?? recipe.nextPointId;

		if (existingPointId == null) {
			final position = HardwareKeyboard.instance.isShiftPressed ? pagePosition : _snap(pagePosition);
			recipe = recipe.copyWith(
				points: [...recipe.points, KlpPageBackgroundPoint(id: targetId, position: position)],
			);
		}

		final startId = _chainPointId;
		if (startId != null && startId != targetId) {
			recipe = recipe.copyWith(
				lines: [
					...recipe.lines,
					KlpPageBackgroundLine(id: recipe.nextLineId, startPointId: startId, endPointId: targetId),
				],
			);
		}

		setState(() => _chainPointId = targetId);
		if (recipe != widget.recipe) widget.onChanged(recipe);
	}

	Offset _snap(Offset position) {
		final spacing = widget.recipe.snapSpacing ?? context.klp.space.loose;
		return Offset((position.dx / spacing).round() * spacing, (position.dy / spacing).round() * spacing);
	}

	void _delete(KlpPageBackgroundSelection? hit) {
		if (hit == null) return;
		final recipe = switch (hit.kind) {
			KlpPageBackgroundElementKind.point => widget.recipe.removePoint(hit.id),
			KlpPageBackgroundElementKind.line => widget.recipe.removeLine(hit.id),
		};
		_setSelection(null);
		widget.onChanged(recipe);
	}

	KlpPageBackgroundSelection? _hitTest(Offset position) {
		final threshold =
				context.klp.geometry.control.pageBackgroundHitRadius / _viewport.scale;
		for (final point in widget.recipe.points.reversed) {
			if ((point.position - position).distance <= threshold) return KlpPageBackgroundSelection.point(point.id);
		}

		final points = <int, KlpPageBackgroundPoint>{for (final point in widget.recipe.points) point.id: point};
		for (final line in widget.recipe.lines.reversed) {
			final start = points[line.startPointId];
			final end = points[line.endPointId];
			if (start == null || end == null) continue;
			if (_distanceToSegment(position, start.position, end.position) <= threshold) {
				return KlpPageBackgroundSelection.line(line.id);
			}
		}
		return null;
	}

	void _setSelection(KlpPageBackgroundSelection? selection) {
		if (_selection == selection) return;
		setState(() => _selection = selection);
		widget.onSelectionChanged?.call(selection);
	}
}
