/// 實驗中的編輯提供者資料契約；畫面節點由宣告式入口提供。
/// 提供者可轉接權威資料及意圖，不可注入原生 Widget、Pointer 或局部樣式。
/// KLP-0020 保留 provider／保存／身分及既有手寫合約；舊即時正文操作僅供相容與回退，BlockNote 不建立第二份正文權威。
/// 精確用途分類見 lib/src/capabilities/architecture.md 的 COMPAT-V1-r1 合約。
library;

export 'src/kernel/diagnostics/klp_contract_error.dart';
export 'src/capabilities/state/klp_state.dart';

export 'src/capabilities/editing/contracts/klp_block_item.dart';
export 'src/capabilities/editing/contracts/klp_block_projection.dart';
export 'src/capabilities/editing/contracts/klp_block_request.dart';
export 'src/capabilities/editing/contracts/klp_block_viewport_request.dart';
export 'src/capabilities/editing/contracts/klp_command_anchor.dart';
export 'src/capabilities/editing/contracts/klp_command_item.dart';
export 'src/capabilities/editing/contracts/klp_command_projection.dart';
export 'src/capabilities/editing/contracts/klp_command_request.dart';
export 'src/capabilities/editing/contracts/klp_command_reply.dart';
export 'src/capabilities/editing/contracts/klp_editor_mode_item.dart';
export 'src/capabilities/editing/contracts/klp_editor_tool_item.dart';
export 'src/capabilities/editing/contracts/klp_editor_viewport_projection.dart';
export 'src/capabilities/editing/contracts/klp_editor_mode_projection.dart';
export 'src/capabilities/editing/contracts/klp_editor_mode_request.dart';
export 'src/capabilities/editing/contracts/klp_editor_viewport_request.dart';
export 'src/capabilities/editing/contracts/klp_editor_mode_reply.dart';
export 'src/capabilities/editing/contracts/klp_handwriting_state.dart';
export 'src/capabilities/editing/contracts/klp_handwriting_state_source.dart';

export 'src/capabilities/editing/contracts/klp_editing_draw_command.dart';
export 'src/capabilities/editing/contracts/klp_editing_drawing.dart';
export 'src/capabilities/editing/contracts/klp_editing_interaction.dart';
export 'src/capabilities/editing/contracts/klp_editing_layout.dart';
export 'src/capabilities/editing/contracts/klp_editing_point_request.dart';
export 'src/capabilities/editing/contracts/klp_editing_path.dart';
export 'src/capabilities/editing/contracts/klp_editing_source.dart';
export 'src/capabilities/editing/contracts/klp_editing_style.dart';
export 'src/capabilities/editing/contracts/klp_editing_viewport.dart';

export 'src/capabilities/editing/contracts/klp_composition_attribute.dart';
export 'src/capabilities/editing/contracts/klp_composition_segment.dart';
export 'src/capabilities/editing/contracts/klp_composition_text.dart';
export 'src/capabilities/editing/contracts/klp_editing_endpoint.dart';
export 'src/capabilities/editing/contracts/klp_editing_intent.dart';
export 'src/capabilities/editing/contracts/klp_editing_projection.dart';
export 'src/capabilities/editing/contracts/klp_editing_reply.dart';
export 'src/capabilities/editing/contracts/klp_editing_request.dart';
export 'src/capabilities/editing/contracts/klp_editing_save_projection.dart';
export 'src/capabilities/editing/contracts/klp_editing_save_reply.dart';
export 'src/capabilities/editing/contracts/klp_editing_save_request.dart';
export 'src/capabilities/editing/contracts/klp_editing_save_source.dart';
export 'src/capabilities/editing/contracts/klp_editing_stamp.dart';
export 'src/capabilities/editing/contracts/klp_editing_text_window.dart';
export 'src/capabilities/editing/contracts/klp_text_offsets.dart';
