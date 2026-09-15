# CC-V1-r1 舊案例遷移與保護記錄

基線：`17216dcb4a7caa0dc32c0ae44d7c827b54fdf0e7`。起始 Git 狀態乾淨。起始 SHA-256 在 D:/Projects/Kallopis-cc-evidence/test-author-start.json；本檔不記自身 hash。

## M1 最小保護集合

1. 實際 application catalog 與 manifest 完整性、順序、來源 AST、負向副本。
2. 既有 tree runtime 所有交易／擷取／lease 案例；真實內建樹提交及未知身分拒絕。
3. 既有 public compile 控制組及全部禁止入口；移除 compiler 專有 prefix。
4. 呼叫端保留斷言；binding 遷至現行 composition／semantic resolver 與內建 adapter。

套件內介面讀取理由：公開 barrel 不暴露 catalog、已驗證 range 或語意 owner；只讀包內准許的 adapter contract、宣告、capture／bound 值及 resolver 公開方法，不讀 runtime installation/update 演算法，不複製 compiler。

## 逐案例矩陣

| 舊路徑 | 舊案例名稱／原契約 | 決策 | 現行保護或退役理由 |
| --- | --- | --- | --- |
| `test/klp_closed_component_catalog_contract_test.dart` | library-owned application declaration compiles | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_closed_component_catalog_contract_test.dart` | public barrel exports only consumer-owned module layers | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_closed_component_catalog_contract_test.dart` | consumer cannot use ${item.name} | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | captures getters once and prepares entire tree before resources | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | invalid preparation leaves old resources frame and lease usable | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | creation rollback preserves previous frame and cleans staged resources | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | reuses identities removes resources and revokes stale action lease | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | commit revokes old actions before resource notifications | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | committed notification failure still publishes consistent new frame | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | internal materialization violation cannot retain stale resource frame | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_tree_runtime_test.dart` | consumer component adapter binds data and changes style without resource replacement | 移轉 | built-in component changes data and style without replacing resources or old snapshots；真實 workspace adapter 保留 resource identity、資料/風格更新、舊快照與 lease 撤銷。 |
| `test/klp_tree_runtime_test.dart` | dispose releases resources and permanently revokes last frame | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | inactive scope blocks captured callbacks while retaining resource and selection | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | inactive ancestor cannot be reenabled by an active descendant | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | replaced and removed frames revoke all previous scoped callbacks | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | preparation failure keeps the previous active lease usable | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | dispose revokes every derived callback | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scope_activation_test.dart` | derived leases combine enabled ancestry and share frame revocation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scoped_runtime_test.dart` | one transaction retains independent scoped resources and removes one entry | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_scoped_runtime_test.dart` | invalid scoped descendant preserves every previously committed entry | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_app_frame_style_test.dart` | frame roles resolve through the selected primitive set | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_app_frame_style_test.dart` | $axis $arrangement preserves a single twelve pixel gutter | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_frame_groups_test.dart` | Frame groups resolve padding and divider choices through semantic tokens | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_frame_groups_test.dart` | Frame group renderer distinguishes invisible, dashed, and solid dividers | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_rail_adapter_test.dart` | prepared rail preserves regions and revokes old actions | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_rail_adapter_test.dart` | blank accessibility label fails during preparation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_rail_adapter_test.dart` | unsupported action is rejected before a rail placement is installed | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_rail_adapter_test.dart` | scoped preparation reads the exact item and emits only its local callback identity | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_surface_shadow_test.dart` | paper shadow resolves only explicit semantics into immutable snapshots | 移轉 | 同檔同名案例：styling validateUsage／resolve 與既有 bound shadow 值。 |
| `test/klp_surface_shadow_test.dart` | shadow references enforce actual kind and owner permissions | 移轉 | 同檔同名案例：styling validateUsage／resolve 與既有 bound shadow 值。 |
| `test/klp_surface_shadow_test.dart` | paper shadows paint outside clip and preserve surface layout | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_component_binding_test.dart` | style changes preserve placement and existing bound snapshots | 移轉 | 同檔：built-in workspace 的資料／語意不可變快照、composition 驗證與 semantic resolver。 |
| `test/klp_component_binding_test.dart` | each text placement selects once and data creates a new snapshot | 移轉 | data updates produce new snapshots and preserve old text；selector 計數隨 compiler 退役。真正單次 getter 擷取仍由 test/klp_tree_runtime_test.dart 的 captures getters once and prepares entire tree before resources 保護。 |
| `test/klp_component_binding_test.dart` | invalid node contracts fail before invoking selectors | 移轉 | invalid node contracts fail before preparation 保留 wrong type／unknown／empty ID；component_children_unsupported 僅是舊 standalone bind 規則而退役，現行具資格 children 由 capture/range 案例保護。 |
| `test/klp_component_binding_test.dart` | nested narrower templates fail before any sibling selector runs | 退役 | CC-V1-r1 移除外部 compiler 的 template dispatcher／selector 例外包裝；沒有現行此 API。 |
| `test/klp_component_binding_test.dart` | direct invalid template references fail at compilation | 移轉 | direct semantic references retain owner public and actual type checks，保留 private／未宣告 dependency／實際 kind／unknown 四個錯誤碼。 |
| `test/klp_component_binding_test.dart` | declared public foreign template reference binds normally | 移轉 | declared public foreign semantic reference resolves normally，以相同 public／dependency 條件檢查正式 resolver 的量值。 |
| `test/klp_component_binding_test.dart` | selector errors preserve cause stack and placement template path | 退役 | CC-V1-r1 移除外部 compiler 的 template dispatcher／selector 例外包裝；沒有現行此 API。 |
| `test/klp_component_binding_test.dart` | component accessibility label rejects empty data after validation | 移轉 | test/klp_rail_adapter_test.dart：blank accessibility label fails during preparation；移除 compiler 專有 accessibility template。 |
| `test/klp_component_binding_test.dart` | component accessibility selector preserves its failure boundary | 退役 | CC-V1-r1 移除外部 compiler 的 template dispatcher／selector 例外包裝；沒有現行此 API。 |
| `test/klp_component_children_binding_test.dart` | nested qualified children materialize once in template slot order | 移轉 | nested qualified children retain capture and materialization order，真實 workspace adapter 保護 root/first/grandchild/second 順序、直接 children 數、range、不可變輸出；template selector／水平垂直模板分派隨 compiler 退役。 |
| `test/klp_component_children_binding_test.dart` | definition derives nested slots and rejects owner or duplicate positions | 移轉 | definition preserves explicit slots and rejects owner or duplicate positions，保留 composition 的 duplicate_slot／slot_owner_mismatch；template 推導功能退役。 |
| `test/klp_component_children_binding_test.dart` | standalone binding explicitly requires child context even for empty slots | 退役／移轉 | 退役：KlpComponentCompiler.bind 的 component_requires_child_context 不再有入口；capture rejects missing duplicate or reordered slot assignments 保留空 slots 必需指派與零長度 range。 |
| `test/klp_component_children_binding_test.dart` | bad captured ranges fail before any data selector | 退役／移轉 | 退役人工 validateCaptured/prepareCaptured 快照入口；capture rejects missing duplicate or reordered slot assignments 保留 authoritative capture 拒絕缺／重複／錯序 slot，無 fixture 重建 compiler。 |
| `test/klp_component_children_binding_test.dart` | slot semantic references retain ownership validation | 移轉 | 同檔同名：正式 semantic resolver.validateUsage 拒絕 unknown_semantic。 |
| `test/klp_component_children_binding_test.dart` | materialization cannot omit or append direct child results | 退役／移轉 | 退役 compiler prepared.materialize 手工子結果輸入；nested qualified children retain capture and materialization order 由實際 runtime 子樹確認輸出數量與順序；不宣稱現行所有 adapter 會拒絕手工偽造參數。 |
| `test/klp_template_compile_contract_test.dart` | external rail item definition composes text linear and surface templates | 移轉 | 同檔：正向控制只使用仍存在模板；四項舊 definition 案例逐名退役於下表，其餘所有量值／封閉 subtype 負向保留。 |
| `test/klp_template_compile_contract_test.dart` | external template contract rejects ${item.name} | 移轉 | 同檔：正向控制只使用仍存在模板；四項舊 definition 案例逐名退役於下表，其餘所有量值／封閉 subtype 負向保留。 |
| `test/klp_slot_compile_contract_test.dart` | external composite uses public slots and supports multiple child qualifications | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_slot_compile_contract_test.dart` | external slot contract rejects ${item.name} | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_anchored_commands_installation_test.dart` | anchored commands inherit only the enclosing editing source | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_anchored_commands_installation_test.dart` | missing capability and orphan command slots are rejected | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | block geometry rejects overflowing endpoints | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | list information is closed by structural kind | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | block controls inherit the enclosing editing source | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | block controls reject an enclosing source without the capability | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | orphan block controls are rejected during preparation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_block_controls_installation_test.dart` | reinstalled hosts continue the sequence owned by the same source | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | mode tool slot qualification is available from declarative entry | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | mode toolbar inherits only its enclosing editor source | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | missing capability and orphan mode toolbar are rejected | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | text and handwriting tools require their installed handlers | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | later publication cannot enable a missing text handler | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_mode_toolbar_installation_test.dart` | later publication cannot reuse an older mode revision | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | editing content installs through workspace and resolves role colors | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | readonly layout source receives semantic style and exact viewport | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | authorized environment layouts drain bounded stale event watermarks | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | invalid source update is observable and preserves last drawing | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | same stamp collision and true source regression stay observable | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | placement reads the latest source snapshot after subscribing | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | queued catch-up events do not regress the getter watermark | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | same placement replaces a changed source and ignores the old source | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | failed replacement keeps the old source and committed frame | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | same source cannot reset generation during a runtime refresh | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | initial source failure cancels pending subscriptions without replacing a generation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_editing_installation_test.dart` | closed application catalog includes editing screen body | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | F2 開啟命名且 Escape 關閉右鍵選單，不執行命令 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 資料列頂部與底部拖放分別發出 before 與 after | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 跨 Explorer 拖放保留來源公開 ID，不丟失文件分類到收藏的意圖 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 拖放只發出合法的同樹移動意圖，拒絕的目的地不修改狀態 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 右鍵選單不開啟文件；停用命令不可執行，可用命令只通知一次 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 命名輸入支援取消與空白驗證，確認後才傳送新名稱 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | 永久刪除確認取消不執行，確認才觸發命令 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_sidebar_interactions_test.dart` | Ctrl 多選由消費端控制，純分類不能混入文件批次 | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | workspace action rejects an unsupported action without a handler | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | icon toolbar keeps one asset action and exposes its label without visible text | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | window controls share hover and press fill without borders and optically reduce square icons | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | floating action drags without activation, clamps and keeps footer fixed | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | compact categories have no persistent fill and document rows use button gaps | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | Explorer selection and click focus use the hover fill without borders | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | category toggles without selection and keeps icon badge children controlled | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | flat explorer preserves descendants and removes folder disclosure and indentation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | hover and selected share only the background and preserve text style | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | empty identity keeps utility actions in a navigation-height header | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | collapsed explorer descendants still participate in tree validation | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | explorer expansion and selection remain consumer controlled | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | document close requests preserve dirty data until consumer rebuilds | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | window controls dispatch host actions and reflect maximized input | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | new workspace components inherit replacement primitives | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |
| `test/klp_workspace_components_declarative_test.dart` | workspace actions remain keyboard accessible | 保留 | 同檔同名案例；只遷移 runtime 呼叫或固定測試 adapter。 |

## definition 專有編譯案例

- `component content rejects widget`：退役；KlpComponentDefinition 已整體移除。公開禁止型別案例保護同一入口不可使用，模板自身 Widget／context 限制繼續執行。
- `accessibility selector rejects widget`：退役；KlpComponentDefinition 已整體移除。公開禁止型別案例保護同一入口不可使用，模板自身 Widget／context 限制繼續執行。
- `accessibility selector rejects context`：退役；KlpComponentDefinition 已整體移除。公開禁止型別案例保護同一入口不可使用，模板自身 Widget／context 限制繼續執行。
- `component has no accessibility builder`：退役；KlpComponentDefinition 已整體移除。公開禁止型別案例保護同一入口不可使用，模板自身 Widget／context 限制繼續執行。

M1 狀態：範圍內策略已建立；manifest 與 runtime API 配對未完成，沒有有效 behavioral Red。

## 參數化案例展開

以 concurrency=1 的 M3 log 逐名核對；包含退役 definition 四個案例與新增公開禁止入口，沒有以執行數取代案例名稱。

| 檔案 | 完整案例名稱 | 決策 |
| --- | --- | --- |
| `klp_app_frame_style_test.dart` | Axis.horizontal adjacent preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.horizontal leading preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.horizontal middle preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.horizontal trailing preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.vertical adjacent preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.vertical leading preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.vertical middle preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_app_frame_style_test.dart` | Axis.vertical trailing preserves a single twelve pixel gutter | 保留原斷言 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpActionActivation | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpActionHandler | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpApplication.components registration | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpComponentAdapter | 新增公開禁止入口 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpComponentCompiler | 新增公開禁止入口 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpComponentDefinition | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpDefinition | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpPrepareContext | 新增公開禁止入口 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpRail | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpRailItem | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpRegistry | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpSemanticKey | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpSemanticSchema | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpSemanticToken | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpStyleRef | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpTemplate | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpTextSemantics | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpTreeRuntime | 新增公開禁止入口 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpTreeValidation | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpValidatedNode | 保留原目標診斷／控制組 |
| `klp_closed_component_catalog_contract_test.dart` | consumer cannot use KlpValidatedSlot | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects assignment direct construction | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects assignment style override | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects children raw style | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects extends KlpChildren | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects extends KlpChildrenTemplate<ExternalPanel, CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects extends KlpSlot<CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects extends KlpSlotAssignment<CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects implements KlpChildren | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects implements KlpChildrenTemplate<ExternalPanel, CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects implements KlpSlot<CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects implements KlpSlotAssignment<CardItem> | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects list children getter | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects missing children getter | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects native widget child | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects native widget qualification | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects plain iterable children getter | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects raw children without assignment | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects template children selector | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects template raw gap | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects template widget builder | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects template wrong qualification | 保留原目標診斷／控制組 |
| `klp_slot_compile_contract_test.dart` | external slot contract rejects unqualified child | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects accessibility selector rejects context | 退役舊 definition 專有 API；理由見上節 |
| `klp_template_compile_contract_test.dart` | external template contract rejects accessibility selector rejects widget | 退役舊 definition 專有 API；理由見上節 |
| `klp_template_compile_contract_test.dart` | external template contract rejects component content rejects widget | 退役舊 definition 專有 API；理由見上節 |
| `klp_template_compile_contract_test.dart` | external template contract rejects component has no accessibility builder | 退役舊 definition 專有 API；理由見上節 |
| `klp_template_compile_contract_test.dart` | external template contract rejects extends KlpLinearTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects extends KlpSurfaceTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects extends KlpTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects extends KlpTextTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects implements KlpLinearTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects implements KlpSurfaceTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects implements KlpTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects implements KlpTextTemplate | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects linear children reject widget | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects linear gap rejects 1.0 | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects linear gap rejects KlpDistance(1) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects linear gap rejects colorKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects selector cannot receive context | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects selector cannot return const SizedBox() | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects selector cannot return text | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface background rejects KlpColor(0, 0, 0) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface background rejects const Color(0xff000000) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface background rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface child rejects widget | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface inset rejects 1.0 | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface inset rejects KlpDistance(1) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface inset rejects colorKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface radius rejects 1.0 | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface radius rejects KlpRadius(1) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects surface radius rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects template has no widget builder | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text color rejects KlpColor(0, 0, 0) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text color rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontFamily rejects KlpFontFamily('External') | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontFamily rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontSize rejects KlpFontSize(12) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontSize rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontWeight rejects KlpFontWeight(400) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text fontWeight rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text letterSpacing rejects KlpLetterSpacing(0) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text letterSpacing rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text lineHeight rejects KlpLineHeight(1) | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text lineHeight rejects distanceKey | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text rejects raw Flutter color | 保留原目標診斷／控制組 |
| `klp_template_compile_contract_test.dart` | external template contract rejects text rejects raw font size | 保留原目標診斷／控制組 |

## M2 保護證據

- 重簽：D:/Projects/Kallopis-cc-evidence/TEST-CC-V1-01.md 新增 `test/frontend_architecture_boundary_test.dart` 唯一刪除掃描清單的 foundation/definitions 一行；`advanced data, button, calendar, card, code data, color, docking, explorer, message composer, navigator, stepper, timeline, input, selection, toggle, feedback, form, foundation, l10n, overlay, routing, settings, and token files contain one structural definition` 的斷言不變。原失敗是目錄已退役的 setup 失配。
- `flutter test --no-pub test/klp_template_compile_contract_test.dart test/klp_slot_compile_contract_test.dart test/klp_closed_component_catalog_contract_test.dart --reporter expanded`：exit 0，87 通過（D:/flutter/bin/flutter.bat，工作目錄 D:/Projects/Kallopis-cc-tests）；test-author-compile.log。
- `flutter test --no-pub test/klp_application_catalog_contract_test.dart test/klp_closed_component_catalog_contract_test.dart test/klp_tree_runtime_test.dart --reporter expanded`：exit 1；兩個 load 失敗是隔離基線仍要求 components，23 公開契約通過。integration-pending，非 behavioral Red；test-author-integration-pending.log。
- `dart analyze --format machine`（catalog/binding/children/tree/surface 五檔）：只有 8 個預期舊 runtime 必填 components 錯誤與 1 個 analyzer API deprecated 提示。非 behavioral Red。
- fixture ownership：只改 assigned component/composite support；runtime fixture 保留原檔，沒有第二個 compiler，也沒有 skip/allowlist。
- 完整配對 Green 尚待整合工作樹；測試 hash 鎖在 test-author-m2.json。

## M3 整合驗證

- 整合工作樹：`D:/Projects/Kallopis-cc-integration`。初次測試基線 `c452bf88ae77441928095a9314459378185f649b`；catalog 最終版本在 `d17f022a`，產品與所有其他測試 bytes 未改。
- 首層命令：`D:/flutter/bin/flutter.bat test --no-pub --concurrency=1 test/klp_application_catalog_contract_test.dart test/klp_closed_component_catalog_contract_test.dart test/klp_tree_runtime_test.dart --reporter expanded`。初次 exit 1，36 通過／2 catalog AST setup 錯誤；23 公開編譯與 9 tree runtime 全部通過。
- Catalog 初次失敗是測試 helper 假設 AST token.next 形成完整鏈，analyzer 10 的正式 AST 不保證該用法。經重簽讀取 analyzer AST 公開介面後，改用 ClassDeclaration/EnumDeclaration.namePart、TypeAlias.name、ExtensionTypeDeclaration.primaryConstructor 與 ClassBody，沒有修改產品或弱化 metadata 斷言。fix1/fix2 hash 在外部 evidence；無 behavioral Red。
- Catalog 最終命令：`D:/flutter/bin/flutter.bat test --no-pub --concurrency=1 test/klp_application_catalog_contract_test.dart --reporter expanded`。exit 0，6 通過；`test-author-m3-catalog-final.log`。
- 直接 caller 命令：`D:/flutter/bin/flutter.bat test --no-pub --concurrency=1 test/klp_scope_activation_test.dart test/klp_scoped_runtime_test.dart test/klp_app_frame_style_test.dart test/klp_frame_groups_test.dart test/klp_rail_adapter_test.dart test/klp_surface_shadow_test.dart test/klp_component_binding_test.dart test/klp_component_children_binding_test.dart test/klp_template_compile_contract_test.dart test/klp_slot_compile_contract_test.dart test/klp_anchored_commands_installation_test.dart test/klp_block_controls_installation_test.dart test/klp_mode_toolbar_installation_test.dart test/klp_editing_installation_test.dart test/klp_sidebar_interactions_test.dart test/klp_workspace_components_declarative_test.dart --reporter expanded`。exit 0，150 通過；`test-author-m3-callers.log`。
- 確認範圍共 188 個不同測試：catalog 6＋closed catalog 23＋tree runtime 9＋直接 caller 150；沒有把重跑成功重複計數。
- Scope：只有 23 個重簽 write paths；`frontend_architecture_boundary_test.dart` 精確刪一行，其他架構斷言未變。其完整 gate 由 Architecture Steward 執行，不冒稱此 Test Author 已執行。
- 單次擷取、資源重用、回滾、提交後例外、具體化失敗、dispose、lease、scope action 資格、slot 型別／範圍／順序、語意 owner/public/type 及 immutable 值都有上述執行證據。沒有新增或宣稱感官接受。
- 所有程式 fixture 由 Test Author 擁有，產品 worker 不得改要求。最終精確 SHA-256 與受保護路徑在 `D:/Projects/Kallopis-cc-evidence/test-author-final.json`；本檔不記自身 hash。
