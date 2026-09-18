import 'package:kallopis/src/features/workspace/explorer/internal/klp_explorer_adapter.dart';
import 'package:kallopis/src/features/overlays/declarative/klp_menu_adapter.dart';
import 'package:kallopis/src/runtime/compilation/klp_adaptive_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_editing_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_block_note_editing_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_canva_editing_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_block_controls_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_anchored_commands_adapter.dart';
import 'package:kallopis/src/features/editing/adapters/klp_mode_toolbar_adapter.dart';
import 'package:kallopis/src/features/navigation/rail/adapters/klp_rail_adapter.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_app_layout_adapter.dart';
import 'package:kallopis/src/features/workspace/layout/adapters/klp_frame_groups_adapter.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_components_adapter.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_workspace_block_adapter.dart';
import 'package:kallopis/src/features/workspace/components/adapters/klp_anchored_popup_adapter.dart';
import 'package:kallopis/src/runtime/contracts/klp_node_adapter.dart';
import 'package:kallopis/src/runtime/compilation/klp_scope_boundary_adapter.dart';
import 'klp_screen_adapter.dart';
import 'klp_retained_screens_adapter.dart';

/// 功能註冊集中在組合根，執行核心不反向認識個別功能。
List<KlpNodeAdapter> klpApplicationAdapters() {
	return [
		...KlpMenuAdapter.createAll(),
		KlpScopeBoundaryAdapter(),
		KlpRetainedScreensAdapter(),
		KlpScreenAdapter(),
		KlpAdaptiveAdapter(),
		KlpEditingAdapter(),
		KlpBlockNoteEditingAdapter(),
		KlpCanvaEditingAdapter(),
		KlpBlockControlsAdapter(),
		KlpAnchoredCommandsAdapter(),
		KlpModeToolbarAdapter(),
		KlpRailAdapter(),
		...KlpExplorerAdapter.createAll(),
		...KlpWorkspaceComponentsAdapter.createAll(),
		...KlpWorkspaceBlockAdapter.createAll(),
		KlpAnchoredPopupAdapter(),
		...KlpAppLayoutAdapter.createAll(),
		...KlpFrameGroupsAdapter.createAll(),
	];
}
