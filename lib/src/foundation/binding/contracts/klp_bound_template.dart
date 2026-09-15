import 'dart:async';
import 'package:kallopis/src/styling/primitives/klp_style_value.dart';
import 'package:kallopis/src/kernel/identity/klp_placement_id.dart';
import 'package:kallopis/src/capabilities/state/klp_state.dart';
import 'package:kallopis/src/foundation/templates/klp_axis.dart';
import 'klp_bound_text_style.dart';
import 'klp_bound_choice_style.dart';

part 'klp_bound_text.dart';
part 'klp_bound_linear.dart';
part 'klp_bound_surface.dart';
part 'klp_bound_surface_shadow.dart';
part 'klp_bound_choice.dart';
part 'klp_bound_regions.dart';
part 'klp_bound_extent.dart';
part 'klp_bound_placement.dart';
part 'klp_bound_retained_stack.dart';
part 'klp_bound_screen.dart';
part 'klp_bound_accessibility.dart';

/// 本庫通用的唯讀呈現協定；功能紀錄由所屬模組實作，使用端不可達。
abstract class KlpBoundTemplate {
	const KlpBoundTemplate();
}
