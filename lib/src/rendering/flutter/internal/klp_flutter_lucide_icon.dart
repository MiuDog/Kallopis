import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 工作區唯一 Lucide 載入點；尺寸與顏色由已解析語意傳入。
final class KlpFlutterLucideIcon extends StatelessWidget {

	final String name;
	final double size;
	final Color color;
	const KlpFlutterLucideIcon(this.name, {required this.size, required this.color, super.key});

	@override
	Widget build(BuildContext context) => SvgPicture.asset(
		'assets/icons/lucide/$name.svg',
		package: 'kallopis',
		width: size,
		height: size,
		colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
		excludeFromSemantics: true,
	);
}
