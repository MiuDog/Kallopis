import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/klp_oklch_color.dart';
import '../../l10n/klp_localizations.dart';
import '../../theme/klp_theme.dart';
import '../../typography/klp_text.dart';
import 'klp_oklch_color_editor.dart';

/// 以三個二維色彩平面與四軸控制編輯 [KlpOklchColor]。
///
/// 元件不持有產品狀態；呼叫端以 [value] 與 [onChanged] 控制目前色彩。
class KlpOklchColorPicker extends StatelessWidget {
	const KlpOklchColorPicker({
		super.key,
		required this.value,
		required this.onChanged,
		this.maxChroma = 0.4,
	}) : assert(maxChroma > 0);

	final KlpOklchColor value;
	final ValueChanged<KlpOklchColor>? onChanged;

	/// Chroma 平面與控制項的編輯上限，不限制 [KlpOklchColor] 可表達的值。
	final double maxChroma;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final labels = KlpLocalizations.of(context);

		return LayoutBuilder(
			builder: (context, constraints) {
				final planeExtent = math.min(klp.geometry.control.colorPlaneExtent, constraints.maxWidth);
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Wrap(
							spacing: klp.space.base,
							runSpacing: klp.space.base,
							children: [
								_plane(context, _OklchPlaneKind.lightness, labels.oklchLightnessPlaneLabel, planeExtent),
								_plane(context, _OklchPlaneKind.chroma, labels.oklchChromaPlaneLabel, planeExtent),
								_plane(context, _OklchPlaneKind.hue, labels.oklchHuePlaneLabel, planeExtent),
							],
						),
						SizedBox(height: klp.space.base),
						KlpOklchColorEditor(value: value, onChanged: onChanged, maxChroma: maxChroma),
						SizedBox(height: klp.space.base),
						Wrap(
							spacing: klp.space.base,
							runSpacing: klp.space.contentStackGap,
							children: [
								_preview(context, labels.oklchOriginalPreviewLabel, value.toColor(), planeExtent),
								_preview(context, labels.oklchFallbackPreviewLabel, value.toSrgbFallbackColor(), planeExtent),
							],
						),
						if (!value.isInSrgbGamut) ...[
							SizedBox(height: klp.space.contentStackGap),
							KlpText(labels.oklchFallbackWarningLabel, role: KlpTextRole.caption, tone: KlpTextTone.danger),
						],
					],
				);
			},
		);
	}

	Widget _plane(
		BuildContext context,
		_OklchPlaneKind kind,
		String label,
		double extent,
	) {
		final klp = context.klp;
		return SizedBox(
			width: extent,
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					ExcludeSemantics(child: KlpText(label, role: KlpTextRole.caption)),
					SizedBox(height: klp.space.tight),
					SizedBox.square(
						dimension: extent,
						child: _OklchPlane(
							kind: kind,
							label: label,
							value: value,
							maxChroma: maxChroma,
							onChanged: onChanged,
						),
					),
				],
			),
		);
	}

	Widget _preview(BuildContext context, String label, Color color, double width) {
		final klp = context.klp;
		return Semantics(
			label: label,
			child: SizedBox(
				width: width,
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						ExcludeSemantics(child: KlpText(label, role: KlpTextRole.caption)),
						SizedBox(height: klp.space.tight),
						ClipRRect(
							borderRadius: klp.shape.cardRadius,
							child: DecoratedBox(
								decoration: BoxDecoration(
									color: color,
									border: Border.all(color: klp.color.border, width: klp.shape.hairline),
								),
								child: SizedBox(height: klp.space.controlHeightXLarge),
							),
						),
					],
				),
			),
		);
	}
}

enum _OklchPlaneKind { lightness, chroma, hue }

class _OklchPlane extends StatefulWidget {
	const _OklchPlane({
		required this.kind,
		required this.label,
		required this.value,
		required this.maxChroma,
		required this.onChanged,
	});

	final _OklchPlaneKind kind;
	final String label;
	final KlpOklchColor value;
	final double maxChroma;
	final ValueChanged<KlpOklchColor>? onChanged;

	@override
	State<_OklchPlane> createState() => _OklchPlaneState();
}

class _OklchPlaneState extends State<_OklchPlane> {
	final FocusNode _focusNode = FocusNode();

	@override
	void dispose() {
		_focusNode.dispose();
		super.dispose();
	}

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final radius = klp.shape.cardRadius;
		final cursorRadius = klp.geometry.control.colorPickerCursorRadius;
		return Semantics(
			label: widget.label,
			value: _semanticValue,
			enabled: widget.onChanged != null,
			focusable: true,
			child: Focus(
				focusNode: _focusNode,
				onFocusChange: (_) => setState(() {}),
				onKeyEvent: _handleKeyEvent,
				child: MouseRegion(
					cursor: widget.onChanged == null ? SystemMouseCursors.basic : SystemMouseCursors.click,
					child: ClipRRect(
						borderRadius: radius,
						child: GestureDetector(
							behavior: HitTestBehavior.opaque,
							onTapDown: widget.onChanged == null ? null : (details) => _updateFromPosition(details.localPosition, context.size!),
							onPanDown: widget.onChanged == null ? null : (details) => _updateFromPosition(details.localPosition, context.size!),
							onPanUpdate: widget.onChanged == null ? null : (details) => _updateFromPosition(details.localPosition, context.size!),
							child: CustomPaint(
								painter: _OklchPlanePainter(
									kind: widget.kind,
									value: widget.value,
									maxChroma: widget.maxChroma,
									borderColor: _focusNode.hasFocus ? klp.color.interaction : klp.color.border,
									borderWidth: _focusNode.hasFocus ? klp.shape.stroke : klp.shape.hairline,
									cursorRadius: cursorRadius,
									cursorWidth: klp.shape.stroke,
								),
							),
						),
					),
				),
			),
		);
	}

	String get _semanticValue {
		return '${widget.value.lightness.toStringAsFixed(3)}, '
			'${widget.value.chroma.toStringAsFixed(3)}, '
			'${_normalizedHue.toStringAsFixed(1)}';
	}

	double get _normalizedHue => (widget.value.hue % 360 + 360) % 360;

	KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || widget.onChanged == null) return KeyEventResult.ignored;
		const step = 0.01;
		final current = _normalizedPosition;
		final next = switch (event.logicalKey) {
			LogicalKeyboardKey.arrowLeft => Offset(current.dx - step, current.dy),
			LogicalKeyboardKey.arrowRight => Offset(current.dx + step, current.dy),
			LogicalKeyboardKey.arrowUp => Offset(current.dx, current.dy - step),
			LogicalKeyboardKey.arrowDown => Offset(current.dx, current.dy + step),
			_ => null,
		};
		if (next == null) return KeyEventResult.ignored;
		_emitNormalized(next);
		return KeyEventResult.handled;
	}

	void _updateFromPosition(Offset position, Size size) {
		_focusNode.requestFocus();
		_emitNormalized(Offset(position.dx / size.width, position.dy / size.height));
	}

	Offset get _normalizedPosition {
		return switch (widget.kind) {
			_OklchPlaneKind.lightness => Offset(widget.value.chroma / widget.maxChroma, 1 - widget.value.lightness),
			_OklchPlaneKind.chroma => Offset(_normalizedHue / 360, 1 - widget.value.chroma / widget.maxChroma),
			_OklchPlaneKind.hue => Offset(_normalizedHue / 360, 1 - widget.value.lightness),
		};
	}

	void _emitNormalized(Offset position) {
		final x = position.dx.clamp(0.0, 1.0);
		final y = position.dy.clamp(0.0, 1.0);
		final next = switch (widget.kind) {
			_OklchPlaneKind.lightness => widget.value.copyWith(lightness: 1 - y, chroma: x * widget.maxChroma),
			_OklchPlaneKind.chroma => widget.value.copyWith(chroma: (1 - y) * widget.maxChroma, hue: x * 360),
			_OklchPlaneKind.hue => widget.value.copyWith(lightness: 1 - y, hue: x * 360),
		};
		widget.onChanged!(next);
	}
}

class _OklchPlanePainter extends CustomPainter {
	const _OklchPlanePainter({
		required this.kind,
		required this.value,
		required this.maxChroma,
		required this.borderColor,
		required this.borderWidth,
		required this.cursorRadius,
		required this.cursorWidth,
	});

	static const int _samples = 32;
	static const double _opaqueAlpha = 1;

	final _OklchPlaneKind kind;
	final KlpOklchColor value;
	final double maxChroma;
	final Color borderColor;
	final double borderWidth;
	final double cursorRadius;
	final double cursorWidth;

	@override
	void paint(Canvas canvas, Size size) {
		final cellWidth = size.width / _samples;
		final cellHeight = size.height / _samples;
		final paint = Paint();

		for (var row = 0; row < _samples; row++) {
			for (var column = 0; column < _samples; column++) {
				final x = (column + 0.5) / _samples;
				final y = (row + 0.5) / _samples;
				paint.color = _colorAt(x, y);
				canvas.drawRect(Rect.fromLTWH(column * cellWidth, row * cellHeight, cellWidth + 1, cellHeight + 1), paint);
			}
		}

		paint
			..style = PaintingStyle.stroke
			..strokeWidth = borderWidth
			..color = borderColor;
		canvas.drawRect(Offset.zero & size, paint);

		final cursor = _cursorOffset(size);
		paint
			..style = PaintingStyle.fill
			..color = KlpThemeContrast.foregroundFor(value.toColor());
		canvas.drawCircle(cursor, cursorRadius, paint);
		paint
			..style = PaintingStyle.stroke
			..strokeWidth = cursorWidth
			..color = value.toColor();
		canvas.drawCircle(cursor, cursorRadius, paint);
	}

	Color _colorAt(double x, double y) {
		final normalizedHue = (value.hue % 360 + 360) % 360;
		final sample = switch (kind) {
			_OklchPlaneKind.lightness => value.copyWith(lightness: 1 - y, chroma: x * maxChroma, alpha: _opaqueAlpha),
			_OklchPlaneKind.chroma => value.copyWith(chroma: (1 - y) * maxChroma, hue: x * 360, alpha: _opaqueAlpha),
			_OklchPlaneKind.hue => value.copyWith(lightness: 1 - y, hue: x * 360, alpha: _opaqueAlpha),
		};
		if (kind == _OklchPlaneKind.lightness) return sample.copyWith(hue: normalizedHue).toColor();
		return sample.toColor();
	}

	Offset _cursorOffset(Size size) {
		final normalizedHue = (value.hue % 360 + 360) % 360;
		final normalized = switch (kind) {
			_OklchPlaneKind.lightness => Offset(value.chroma / maxChroma, 1 - value.lightness),
			_OklchPlaneKind.chroma => Offset(normalizedHue / 360, 1 - value.chroma / maxChroma),
			_OklchPlaneKind.hue => Offset(normalizedHue / 360, 1 - value.lightness),
		};
		return Offset(normalized.dx.clamp(0, 1) * size.width, normalized.dy.clamp(0, 1) * size.height);
	}

	@override
	bool shouldRepaint(covariant _OklchPlanePainter oldDelegate) {
		return kind != oldDelegate.kind ||
			value != oldDelegate.value ||
			maxChroma != oldDelegate.maxChroma ||
			borderColor != oldDelegate.borderColor ||
			borderWidth != oldDelegate.borderWidth ||
			cursorRadius != oldDelegate.cursorRadius ||
			cursorWidth != oldDelegate.cursorWidth;
	}
}
