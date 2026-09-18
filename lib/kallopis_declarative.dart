/// 宣告式框架遷移入口；目前為實驗實作，尚未作 Stable 承諾。
library;

export 'src/features/overlays/declarative/klp_menu.dart';
export 'src/features/overlays/declarative/klp_menu_item.dart';

// L0 — 核心識別與契約錯誤。
export 'src/kernel/diagnostics/klp_contract_error.dart';
export 'src/kernel/identity/klp_id.dart';
export 'src/kernel/identity/klp_placement_id.dart';

// L1 — 狀態、資料、受限動作與導覽。
export 'src/capabilities/controllers/klp_state_controller.dart';
export 'src/capabilities/actions/klp_action.dart' show KlpAction;
export 'src/capabilities/actions/klp_pick_file_action.dart' show KlpPickFileAction;
export 'src/capabilities/navigation/klp_destination.dart';
export 'src/capabilities/navigation/klp_location.dart';
export 'src/capabilities/navigation/klp_navigation_cancellation.dart';
export 'src/capabilities/navigation/klp_navigation_decision.dart';
export 'src/capabilities/navigation/klp_navigation_entry.dart';
export 'src/capabilities/navigation/klp_navigation_restoration.dart';
export 'src/capabilities/navigation/klp_navigation_outcome.dart';
export 'src/capabilities/navigation/klp_navigation_snapshot.dart';
export 'src/capabilities/navigation/klp_navigation_ticket.dart';
export 'src/capabilities/navigation/klp_navigation_transition.dart';
export 'src/capabilities/navigation/klp_route_policy.dart';
export 'src/capabilities/navigation/klp_route_address.dart';
export 'src/capabilities/navigation/klp_route_codec.dart';
export 'src/capabilities/navigation/klp_route_uri.dart';
export 'src/capabilities/data/klp_async_data.dart';
export 'src/capabilities/data/klp_data_notification_exception.dart';
export 'src/capabilities/data/klp_data_state.dart';
export 'src/capabilities/state/klp_mutable_state.dart';
export 'src/capabilities/state/klp_state.dart';
export 'src/capabilities/state/klp_subscription.dart';

// L2 — 庫擁有節點的組裝資格與受限插槽。
export 'src/composition/nodes/klp_node.dart';
export 'src/composition/nodes/klp_composite_node.dart';
export 'src/composition/nodes/klp_adaptive.dart';
export 'src/composition/nodes/klp_platform_strategy.dart';
export 'src/composition/slots/klp_slot.dart';
export 'src/composition/slots/klp_children.dart';
export 'src/composition/slots/klp_screen_body.dart';

// L3 — 組裝所需的平台與排版值；模板由庫內元件擁有。
export 'src/foundation/platform/klp_adaptive_mode.dart';
export 'src/foundation/platform/klp_device_class.dart';
export 'src/foundation/platform/klp_display_mode.dart';
export 'src/foundation/platform/klp_orientation.dart';
export 'src/foundation/platform/klp_id_context.dart';
export 'src/foundation/platform/klp_id_scope.dart';
export 'src/foundation/templates/klp_axis.dart';

// L4 — runtime 僅供庫內編譯與安裝，不提供 consumer 匯出。

// L5 — 庫擁有、可組裝的功能節點與資料／事件契約。
export 'src/features/editing/contracts/klp_editing_content.dart';
export 'src/features/editing/contracts/klp_block_note_editing_content.dart';
export 'src/features/editing/contracts/klp_canva_editing_content.dart';
export 'package:krepis_canva/krepis_canva.dart'
	show
		KrepisCanvaBridgeChannel,
		KrepisCanvaBridgePort,
		KrepisCanvaCloseResult,
		KrepisCanvaDocument,
		KrepisCanvaPersist,
		KrepisCanvaSessionController;
export 'package:krepis_block_note/krepis_block_note.dart'
	show
		KlpBlockNoteBridgeChannel,
		KlpBlockNoteBridgePort,
		KlpBlockNoteCloseResult,
		KlpBlockNoteDocument,
		KlpBlockNotePersist,
		KlpBlockNoteSaveResult,
		KlpBlockNoteSessionController;
export 'src/features/editing/contracts/klp_block_controls.dart';
export 'src/features/editing/contracts/klp_block_control_slot_child.dart';
export 'src/features/editing/contracts/klp_anchored_commands.dart';
export 'src/features/editing/contracts/klp_mode_toolbar.dart';
export 'src/features/editing/contracts/klp_mode_tool_slot_child.dart';
export 'src/features/editing/contracts/klp_command_slot_child.dart';
export 'src/features/workspace/layout/klp_app_layout.dart';
export 'src/features/workspace/layout/klp_frame_groups.dart';
export 'src/features/workspace/explorer/klp_explorer.dart';
export 'src/features/workspace/explorer/klp_explorer_model.dart';
export 'src/features/workspace/components/klp_workspace_command.dart';
export 'src/features/workspace/components/klp_document_tabs.dart';
export 'src/features/workspace/components/klp_window_controls.dart';
export 'src/features/workspace/components/klp_workspace_block.dart';
export 'src/features/workspace/components/klp_anchored_popup.dart';

// L6 — renderer 僅實現已封閉的準備結果，不提供 consumer 匯出。

// L7 — 唯一應用程式組合根。
export 'src/application/structure/klp_application.dart';
export 'src/application/structure/klp_screen.dart';
