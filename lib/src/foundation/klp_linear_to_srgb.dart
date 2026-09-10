part of 'klp_oklch_color.dart';

/// 將線性色彩通道轉為 sRGB 通道。
double _linearToSrgb(double value) {
	final magnitude = value.abs();
	final encoded = magnitude <= 0.0031308
			? 12.92 * magnitude
			: 1.055 * math.pow(magnitude, 1 / 2.4) - 0.055;
	return value < 0 ? -encoded : encoded.toDouble();
}
