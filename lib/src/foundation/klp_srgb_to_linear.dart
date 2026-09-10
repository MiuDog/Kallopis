part of 'klp_oklch_color.dart';

/// 將 sRGB 通道轉為線性色彩通道。
double _srgbToLinear(double value) {
	return value <= 0.04045
			? value / 12.92
			: math.pow((value + 0.055) / 1.055, 2.4).toDouble();
}
