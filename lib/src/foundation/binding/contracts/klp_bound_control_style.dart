import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/styling/semantics/klp_control_density.dart';
import 'klp_bound_text_style.dart';

/// 控制項與容器分離的已解析風格，不接受產品端局部注入。
final class KlpBoundControlStyle {
	final KlpControlDensity density;
	final KlpRadius radius;
	final KlpColor background, focus;
	final KlpBoundTextStyle text;
	const KlpBoundControlStyle({required this.density, required this.radius, required this.background, required this.focus, required this.text});
}
