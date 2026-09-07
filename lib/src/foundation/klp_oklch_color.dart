import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// 以 OKLCH 表示的裝置無關色彩。
///
/// [lightness] 與 [alpha] 使用 0 到 1；[chroma] 不限制上界；[hue] 以角度表示。
/// 轉成 Flutter [Color] 時會逐通道限制在 sRGB 色域內，原值是否超出色域可先由
/// [isInSrgbGamut] 判斷。
@immutable
class KlpOklchColor {
	const KlpOklchColor({
		required this.lightness,
		required this.chroma,
		required this.hue,
		this.alpha = 1,
	}) : assert(lightness >= 0 && lightness <= 1),
		 assert(chroma >= 0),
		 assert(alpha >= 0 && alpha <= 1);

	/// 從 Flutter sRGB 色彩建立 OKLCH 值。
	factory KlpOklchColor.fromColor(Color color) {
		final argb = color.toARGB32();
		final red = _srgbToLinear(((argb >> 16) & 0xff) / 255);
		final green = _srgbToLinear(((argb >> 8) & 0xff) / 255);
		final blue = _srgbToLinear((argb & 0xff) / 255);

		final l = math.pow(0.4122214708 * red + 0.5363325363 * green + 0.0514459929 * blue, 1 / 3).toDouble();
		final m = math.pow(0.2119034982 * red + 0.6806995451 * green + 0.1073969566 * blue, 1 / 3).toDouble();
		final s = math.pow(0.0883024619 * red + 0.2817188376 * green + 0.6299787005 * blue, 1 / 3).toDouble();
		final lightness = 0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s;
		final a = 1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s;
		final b = 0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s;
		final chroma = math.sqrt(a * a + b * b);
		final hue = chroma < 0.00000001 ? 0.0 : (math.atan2(b, a) * 180 / math.pi + 360) % 360;

		return KlpOklchColor(
			lightness: lightness.clamp(0, 1),
			chroma: chroma,
			hue: hue,
			alpha: ((argb >> 24) & 0xff) / 255,
		);
	}

	final double lightness;
	final double chroma;
	final double hue;
	final double alpha;

	/// 未限制通道前的轉換結果是否完整落在 sRGB 色域。
	bool get isInSrgbGamut {
		final rgb = _toSrgb();
		return rgb.every((channel) => channel >= 0 && channel <= 1);
	}

	/// 固定 Lightness 與 Hue，找出 sRGB 色域內的最大 Chroma。
	KlpOklchColor get closestSrgbFallback {
		if (isInSrgbGamut) return this;

		var lowerChroma = 0.0;
		var upperChroma = chroma;

		for (var iteration = 0; iteration < 24; iteration++) {
			final candidateChroma = (lowerChroma + upperChroma) / 2;
			final candidate = copyWith(chroma: candidateChroma);

			if (candidate.isInSrgbGamut) {
				lowerChroma = candidateChroma;
			} else {
				upperChroma = candidateChroma;
			}
		}

		return copyWith(chroma: lowerChroma);
	}

	/// 取得以 Chroma fallback 映射後的 sRGB 色彩。
	Color toSrgbFallbackColor() => closestSrgbFallback.toColor();

	/// 轉成 Flutter sRGB 色彩；超出色域的通道會限制在 0 到 1。
	Color toColor() {
		final rgb = _toSrgb();
		int channel(double value) => (value.clamp(0, 1) * 255).round();
		return Color.fromARGB(
			(alpha * 255).round(),
			channel(rgb[0]),
			channel(rgb[1]),
			channel(rgb[2]),
		);
	}

	/// 建立只替換指定座標的新值。
	KlpOklchColor copyWith({double? lightness, double? chroma, double? hue, double? alpha}) {
		return KlpOklchColor(
			lightness: lightness ?? this.lightness,
			chroma: chroma ?? this.chroma,
			hue: hue ?? this.hue,
			alpha: alpha ?? this.alpha,
		);
	}

	List<double> _toSrgb() {
		final radians = hue * math.pi / 180;
		final a = chroma * math.cos(radians);
		final b = chroma * math.sin(radians);
		final lRoot = lightness + 0.3963377774 * a + 0.2158037573 * b;
		final mRoot = lightness - 0.1055613458 * a - 0.0638541728 * b;
		final sRoot = lightness - 0.0894841775 * a - 1.2914855480 * b;
		final l = lRoot * lRoot * lRoot;
		final m = mRoot * mRoot * mRoot;
		final s = sRoot * sRoot * sRoot;

		return [
			_linearToSrgb(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s),
			_linearToSrgb(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s),
			_linearToSrgb(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s),
		];
	}

	@override
	bool operator ==(Object other) {
		return identical(this, other) ||
			other is KlpOklchColor &&
			lightness == other.lightness &&
			chroma == other.chroma &&
			hue == other.hue &&
			alpha == other.alpha;
	}

	@override
	int get hashCode => Object.hash(lightness, chroma, hue, alpha);
}

double _srgbToLinear(double value) {
	return value <= 0.04045 ? value / 12.92 : math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}

double _linearToSrgb(double value) {
	final magnitude = value.abs();
	final encoded = magnitude <= 0.0031308 ? 12.92 * magnitude : 1.055 * math.pow(magnitude, 1 / 2.4) - 0.055;
	return value < 0 ? -encoded : encoded.toDouble();
}
