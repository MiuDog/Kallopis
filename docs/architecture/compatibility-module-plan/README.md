# COMPAT-V1-r1 相容用途與節點封閉

Execution complete。CAP-V1-03 與 FEAT-V1-07 分別驗收，不需原子runtime改寫。

COMPAT-V1-r1／CAP-V1-03：用途分類以符號及用途為準。舊 text/IME intent、request/reply、block/list/undo 操作、layout／hit testing／text window 與 pending-resync submission 僅作既有資料相容、必要維護與回退；新 BlockNote 不使用其即時正文操作建立第二交易／undo／正文權威。保留全部42 editing exports＋9 parts與root44exports、base provider snapshot/stream、save job/confirmed revision/unknown outcome、stamp identity、共用drawing／geometry／anchor／command資料與handwriting/mode合約；不將共享Projection/Endpoint一概棄用，不新增Deprecated警告、刪除export或停用舊路徑。手寫及Spatial未定案不在本片決定。新正文content/adapter/bound/renderer只借用原Krepis BlockNote controller/channel，正文／排版／選取／undo由上游掌管。共享presentation library為其他legacy parts匯入DTO合法；驗收依BlockNote typed members/操作，不把共享名稱解析誤當第二權威。

COMPAT-V1-r1／FEAT-V1-07：關閉清冊中仍開放的七個layout節點對外extends/implements，精確改為final class；原constructor/default/member/body/slots/definition IDs與合法建構保持。KlpLayoutNode等qualification仍可表達資料資格，不能取得註冊權或冒用已知catalog identity。真catalog必須以node_type_mismatch拒絕已知ID偽裝並保留前一個committed frame/resources。完整24feature components（23公開＋1rail）、28總ID、67exports與ownership/presentation分工不變。舊Stable Explorer/WindowControls與新declarative canonical維持不同library面向；P9完整條件為下游完成遷移、無受支援舊入口匯入、相容證據及發布說明允許破壞性移除。仍有舊caller，不執行P9刪除。

## 用途分類

下表 C = lib/src/capabilities/editing/contracts/；公開可達性以原provider library為準。

| 分類 | 精確來源／符號 | 可實作規則 |
| --- | --- | --- |
| 明確舊正文輸入與交易用途，僅供相容 | C/klp_editing_intent.dart 及其七 part：klp_replace_text_intent.dart、klp_select_text_intent.dart、klp_begin_composition_intent.dart、klp_update_composition_intent.dart、klp_commit_composition_intent.dart、klp_cancel_composition_intent.dart、klp_editing_command_intent.dart；C/klp_editing_request.dart、klp_editing_reply.dart | 保留舊文本／IME 往返；不提供新 BlockNote 正文 transaction 或另建 undo history。七 part 保持原 library，不拆 sealed hierarchy。 |
| 明確舊 block／list／undo 操作用途，僅供相容 | C/klp_block_request.dart 的 KlpBlockIntent：含 block 選取、移動、轉換、list 操作、task/collapse、undo/redo；C/klp_editing_source.dart 的 KlpBlockControlSource.submitBlock | 只描述舊 provider 的請求，不讓 BlockNote 同步或回放這套操作，不將 enum 本身當資料模型權威。 |
| 舊文字投影／輸入視窗與排版使用邊界 | C/klp_composition_attribute.dart、klp_composition_segment.dart、klp_composition_text.dart、klp_editing_endpoint.dart、klp_editing_projection.dart、klp_editing_text_window.dart、klp_text_offsets.dart、klp_editing_point_request.dart、klp_editing_layout.dart；C/klp_editing_source.dart 的 KlpEditingLayoutSource、KlpEditableSource | 「供舊正文投影、hit testing、layout 和 IME 維護使用」列 compatibility。投影是值，不能說 Kallopis 已有正文模型權威。Endpoint／Projection 又由 drawing 與手寫 frozen snapshot 引用，不可整個型別禁用／刪除。 |
| 通用 provider／保存／身分保留 | C/klp_editing_source.dart 的 KlpEditingSource；C/klp_editing_save_projection.dart、klp_editing_save_reply.dart、klp_editing_save_request.dart、klp_editing_save_source.dart；C/klp_editing_stamp.dart；lib/src/capabilities/state/klp_state.dart、lib/src/kernel/diagnostics/klp_contract_error.dart | 保留 snapshot/stream、完整 stamp、sequence、save job、confirmed revision、unknown outcome 與 close 協定。KlpEditingSaveSource extends 的是既有 EditingSource，不能因此連保存一起 deprecated；也不藉分類抽換成新的通用保存 API。 |
| 共用呈現與命令資料保留，舊正文用途受限 | C/klp_editing_draw_command.dart、klp_editing_drawing.dart、klp_editing_path.dart、klp_editing_style.dart、klp_editing_viewport.dart、klp_editing_interaction.dart；C/klp_block_item.dart、klp_block_projection.dart、klp_block_viewport_request.dart；C/klp_command_anchor.dart 及 klp_block_command_anchor.dart、klp_caret_command_anchor.dart；C/klp_command_item.dart、klp_command_projection.dart、klp_command_request.dart、klp_command_reply.dart；C/klp_editing_source.dart 的 KlpAnchoredCommandSource | 不擅判純資料、唯讀幾何、定位與候選命令全面棄用。舊正文 caret/block selection 定位用途列相容；不保證這些就是未來 Spatial 或 BlockNote 的新協定。 |
| 手寫及模式選擇保留，產品範圍仍未定案 | C/klp_handwriting_state.dart、klp_handwriting_state_source.dart；C/klp_editor_mode_item.dart、klp_editor_tool_item.dart、klp_editor_viewport_projection.dart、klp_editor_mode_projection.dart、klp_editor_mode_request.dart、klp_editor_viewport_request.dart、klp_editor_mode_reply.dart；C/klp_editing_source.dart 的 KlpEditorModeSource | handwriting 是既有 input purpose，publisher 引用同一 KlpEditingDrawing/Projection/Endpoint/Stamp。保存其凍結圖像、單調版本、unknown/terminal 規則；不決定手寫納入正文、Spatial 引擎、Canva 替代或付費方案。 |

清冊涵蓋 provider 現有 42 個 editing exports 及 9 個 part；根 barrel 另有 error/state 共 44 條 export。C/klp_block_drop_preview.dart 非 provider export；lib/src/capabilities/editing/klp_block_drop_target.dart、klp_editing_submission.dart 是具名套件內契約，前者舊 block 拖放用途、後者舊提交／pending-resync 用途維持相容，不擅加公開 export。internal/klp_editing_draw_command_validation.dart 維持共用內部驗證。



## 派工

[精確path-map](path-map.json)。CAP03 source dartdoc、features相容dartdoc、FEAT07 modifiers三個模組內packet依clean base逐一執行scope；根provider library文件由Steward修改且44exports保持。兩位隔離Test Author只寫各自清單，不修改fixtures／configuration／要求。新測試必要性為新正文資料權威與公開封閉架構契約，不增加感官或coverage測試。

M1用途分類與comments-only證明；M2七個final modifier與原body完整保留；M3新有效Red→Green、舊provider/save/handwriting/BlockNote與layout/catalog檢查、atlas及原樹hash回存。每worker cold-start 1,000–4,000 token／5–25分鐘，作者各4,000–10,000／15–45分鐘；沿用主模型、Flutter/Node，參考LOWER/METRICS但無逐工時量測。越界立即停；超過12k token或60分鐘記錄異常。

[驗證](verification.md) 與 [執行證據](execution.json) 保存兩切片各自完成判準。
