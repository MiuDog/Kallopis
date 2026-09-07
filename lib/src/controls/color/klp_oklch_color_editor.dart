import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/klp_oklch_color.dart';
import '../../l10n/klp_localizations.dart';
import '../../theme/klp_theme.dart';
import '../selection/klp_slider.dart';

/// 以 Lightness、Chroma、Hue 與 Alpha 編輯 [KlpOklchColor] 的控制項。
class KlpOklchColorEditor extends StatelessWidget {
	const KlpOklchColorEditor({
		super.key,
		required this.value,
		required this.onChanged,
		this.maxChroma = 0.4,
	}) : assert(maxChroma > 0);

	final KlpOklchColor value;
	final ValueChanged<KlpOklchColor>? onChanged;

	/// Chroma slider 的編輯上限；不限制 [KlpOklchColor] 可表達的值。
	final double maxChroma;

	@override
	Widget build(BuildContext context) {
		final klp = context.klp;
		final labels = KlpLocalizations.of(context);

		return LayoutBuilder(
			builder: (context, constraints) {
				final controlWidth = math.min(klp.geometry.control.colorPlaneExtent, constraints.maxWidth);
				return Column(
					crossAxisAlignment: CrossAxisAlignment.stretch,
					children: [
						Wrap(
							spacing: klp.space.base,
							runSpacing: klp.space.contentStackGap,
							children: [
								SizedBox(width: controlWidth, child: _lightness(labels)),
								SizedBox(width: controlWidth, child: _chroma(labels)),
								SizedBox(width: controlWidth, child: _hue(labels)),
								SizedBox(width: controlWidth, child: _alpha(labels)),
							],
						),
					],
				);
			},
		);
	}

	Widget _lightness(KlpLocalizations labels) {
		return Semantics(
			label: labels.oklchLightnessLabel,
			value: value.lightness.toStringAsFixed(3),
			child: KlpSlider(
				label: labels.oklchLightnessLabel,
				value: value.lightness,
				onChanged: onChanged == null ? null : (next) => onChanged!(value.copyWith(lightness: next)),
				divisions: 100,
				displayValue: value.lightness.toStringAsFixed(3),
			),
		);
	}

	Widget _chroma(KlpLocalizations labels) {
		return Semantics(
			label: labels.oklchChromaLabel,
			value: value.chroma.toStringAsFixed(3),
			child: KlpSlider(
				label: labels.oklchChromaLabel,
				value: value.chroma.clamp(0, maxChroma),
				onChanged: onChanged == null ? null : (next) => onChanged!(value.copyWith(chroma: next)),
				max: maxChroma,
				divisions: 100,
				displayValue: value.chroma.toStringAsFixed(3),
			),
		);
	}

	Widget _hue(KlpLocalizations labels) {
		final normalizedHue = (value.hue % 360 + 360) % 360;
		return Semantics(
			label: labels.oklchHueLabel,
			value: normalizedHue.toStringAsFixed(1),
			child: KlpSlider(
				label: labels.oklchHueLabel,
				value: normalizedHue,
				onChanged: onChanged == null ? null : (next) => onChanged!(value.copyWith(hue: next)),
				max: 360,
				divisions: 360,
				displayValue: normalizedHue.toStringAsFixed(1),
			),
		);
	}

	Widget _alpha(KlpLocalizations labels) {
		return Semantics(
			label: labels.oklchAlphaLabel,
			value: value.alpha.toStringAsFixed(3),
			child: KlpSlider(
				label: labels.oklchAlphaLabel,
				value: value.alpha,
				onChanged: onChanged == null ? null : (next) => onChanged!(value.copyWith(alpha: next)),
				divisions: 100,
				displayValue: value.alpha.toStringAsFixed(3),
			),
		);
	}
}
