import '../../../features/navigation/rail/internal/klp_rail_adapter.dart';
import '../../../runtime/compilation/internal/klp_component_adapter.dart';
import '../../../runtime/compilation/internal/klp_node_adapter.dart';
import '../../../runtime/compilation/internal/klp_scope_boundary_adapter.dart';
import '../../structure/klp_application.dart';
import 'klp_screen_adapter.dart';
import 'klp_retained_screens_adapter.dart';

/// 功能註冊集中在組合根，執行核心不反向認識個別功能。
List<KlpNodeAdapter> klpApplicationAdapters(KlpApplication application) {
  return [
    KlpScopeBoundaryAdapter(),
    KlpRetainedScreensAdapter(),
    KlpScreenAdapter(),
    KlpRailAdapter(),
    for (final component in application.components)
      KlpComponentAdapter(component),
  ];
}
