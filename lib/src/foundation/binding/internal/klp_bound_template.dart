import 'dart:async';

import '../../../styling/primitives/klp_style_value.dart';
import '../../../kernel/identity/klp_placement_id.dart';
import '../../../capabilities/state/klp_state.dart';
import '../../templates/klp_axis.dart';
import 'klp_bound_text_style.dart';
import 'klp_bound_choice_style.dart';

part 'klp_bound_text.dart';
part 'klp_bound_linear.dart';
part 'klp_bound_surface.dart';
part 'klp_bound_choice.dart';
part 'klp_bound_regions.dart';
part 'klp_bound_extent.dart';
part 'klp_bound_placement.dart';
part 'klp_bound_retained_stack.dart';
part 'klp_bound_screen.dart';
part 'klp_bound_accessibility.dart';

/// 本庫完成資料投影與風格求值後的封閉呈現輸入。
sealed class KlpBoundTemplate {

	const KlpBoundTemplate();
}
