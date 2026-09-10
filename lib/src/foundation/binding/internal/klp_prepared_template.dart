import '../../../styling/primitives/klp_style_value.dart';
import '../../templates/klp_axis.dart';
import 'klp_bound_template.dart';

part 'klp_prepared_value.dart';
part 'klp_prepared_linear.dart';
part 'klp_prepared_surface.dart';
part 'klp_prepared_children.dart';

/// 已完成外部資料投影的封閉準備樹，插槽不會流入 renderer。
sealed class KlpPreparedTemplate {

	const KlpPreparedTemplate();

	KlpBoundTemplate materialize(List<KlpBoundTemplate> children);
}
