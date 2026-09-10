part of '../klp_oklch_color_picker.dart';

class _OklchPlaneState extends State<_OklchPlane> {
	static const _keyboardStep = 0.01;

	final FocusNode _focusNode = FocusNode();

	double get _maximumChroma => widget.chromaRange.upperBound;
	double get _normalizedHue => (widget.value.hue % 360 + 360) % 360;

	String get _semanticValue {
		return '${widget.value.lightness.toStringAsFixed(3)}, '
				'${widget.value.chroma.toStringAsFixed(3)}, '
				'${_normalizedHue.toStringAsFixed(1)}';
	}

	Offset get _normalizedPosition {
		return switch (widget.kind) {
			_OklchPlaneKind.lightness => Offset(
				widget.value.chroma / _maximumChroma,
				1 - widget.value.lightness,
			),
			_OklchPlaneKind.chroma => Offset(
				_normalizedHue / 360,
				1 - widget.value.chroma / _maximumChroma,
			),
			_OklchPlaneKind.hue => Offset(
				_normalizedHue / 360,
				1 - widget.value.lightness,
			),
		};
	}

	@override
	void dispose() {
		_focusNode.dispose();
		super.dispose();
	}

	KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
		if (event is! KeyDownEvent || widget.onChanged == null) {
			return KeyEventResult.ignored;
		}

		final current = _normalizedPosition;
		final next = switch (event.logicalKey) {
			LogicalKeyboardKey.arrowLeft => Offset(
				current.dx - _keyboardStep,
				current.dy,
			),
			LogicalKeyboardKey.arrowRight => Offset(
				current.dx + _keyboardStep,
				current.dy,
			),
			LogicalKeyboardKey.arrowUp => Offset(
				current.dx,
				current.dy - _keyboardStep,
			),
			LogicalKeyboardKey.arrowDown => Offset(
				current.dx,
				current.dy + _keyboardStep,
			),
			_ => null,
		};
		if (next == null) return KeyEventResult.ignored;

		_emitNormalized(next);
		return KeyEventResult.handled;
	}

	void _updateFromPosition(Offset position, Size size) {
		_focusNode.requestFocus();
		_emitNormalized(
			Offset(position.dx / size.width, position.dy / size.height),
		);
	}

	void _emitNormalized(Offset position) {
		final x = position.dx.clamp(0.0, 1.0);
		final y = position.dy.clamp(0.0, 1.0);
		final next = switch (widget.kind) {
			_OklchPlaneKind.lightness => widget.value.copyWith(
				lightness: 1 - y,
				chroma: x * _maximumChroma,
			),
			_OklchPlaneKind.chroma => widget.value.copyWith(
				chroma: (1 - y) * _maximumChroma,
				hue: x * 360,
			),
			_OklchPlaneKind.hue => widget.value.copyWith(
				lightness: 1 - y,
				hue: x * 360,
			),
		};

		widget.onChanged!(next);
	}

	@override
	Widget build(BuildContext context) {
		final style = _KlpOklchPlaneStyle.resolve(
			context.klp,
			focused: _focusNode.hasFocus,
		);

		return KlpSemanticRegion(
			label: widget.label,
			value: _semanticValue,
			enabled: widget.onChanged != null,
			focusable: true,
			container: false,
			child: _KlpOklchPlaneFrame(
				focusNode: _focusNode,
				enabled: widget.onChanged != null,
				style: style,
				onFocusChange: (_) => setState(() {}),
				onKeyEvent: _handleKeyEvent,
				onTapDown: widget.onChanged == null
						? null
						: (details) =>
									_updateFromPosition(details.localPosition, context.size!),
				onPanDown: widget.onChanged == null
						? null
						: (details) =>
									_updateFromPosition(details.localPosition, context.size!),
				onPanUpdate: widget.onChanged == null
						? null
						: (details) =>
									_updateFromPosition(details.localPosition, context.size!),
				painter: _OklchPlanePainter(
					kind: widget.kind,
					value: widget.value,
					chromaRange: widget.chromaRange,
					style: style,
				),
			),
		);
	}
}
