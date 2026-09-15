# TEST-CC-V1-01 — 封閉目錄與舊編譯器退役測試包

角色：獨立高階 Test Author。狀態：規格完整、待乾淨隔離基線重簽；本輪不撰寫或修改測試。

依據：[CC-V1-r1](../../../spec/module-architecture-v1.md#closed-catalog-completion-contract--cc-v1-r1)、五份 module architecture 及 [配對計畫](README.md)。採用 [.agents Test Author 技能](../../../.agents/skills/test-driven-development/SKILL.md)。測試／交易風險符合必要條件；不新增文件專用測試或感官測試。

## 版本與派工前置

共通規格與 module hash 使用相鄰 JSON 的 `contract_excerpts`／`architecture_revision`。派工時以已簽署 manifest 記錄這些 hash、此包 SHA-256、乾淨隔離 checkout 的真實 commit、所有 assigned test/fixture 起始 hash。計畫版 HEAD 為 `578d24ed111b95c429397b54245de09ade674704`，不代表目前未提交實作快照，不能直接作為測試修改基線。

獨立上下文只提供契約、測試介面與既有慣例，不提供 implementation worker 推理或結論。沿用主對話高階模型；產品 worker 不兼任 Test Author。只有使用端編譯契約或實際 catalog 比對無法由公開 barrel 表達時，才讀下面列出的套件內介面／宣告，並在保護記錄說明原因。

## 目標

保護 catalog 的完整性、使用端封閉邊界，以及 compiler 退役後仍存在的單次擷取、插槽、語意、交易與生命週期行為。必要時修訂既有測試以匹配已接受的移除契約；不為了讓產品通過而減少保護。

## allowed_read

- `AGENTS.md`、`.agents/skills/test-driven-development/SKILL.md`。
- `spec/module-architecture-v1.md` 的 CC-V1-r1 及 P1 要求。
- `lib/src/{composition,foundation,runtime,features,application}/architecture.md`（此處大括號是列舉縮寫，派工 manifest 展開為五個精確路徑）。
- 本包列出的既有測試及 `test/support/**`；`test/klp_composition_contract_test.dart`、`test/klp_slot_contract_test.dart`、`test/klp_installation_test.dart`、`test/klp_placement_identity_test.dart`、`test/frontend_architecture_boundary_test.dart`、`test/klp_application_router_session_test.dart`、`test/klp_application_review_test.dart`、現有 styling 語意契約測試作為唯讀參考。
- `lib/kallopis_declarative.dart`、`pubspec.yaml`、`pubspec.lock`、`.dart_tool/package_config.json`；公開編譯工具 `test/support/klp_external_compile_fixture.dart`。
- 依 `package_config.json` 解析之 analyzer 套件 `lib/dart/ast/ast.dart` 與其轉匯出的 `lib/src/dart/ast/ast.dart`：唯讀正式 AST 宣告介面，用於修正來源查核器的版本相容性；不得修改套件或掃描無關實作。
- runtime 介面：`compilation/internal/klp_node_adapter.dart`、`klp_prepared_node.dart`、`klp_prepare_context.dart`、`klp_prepared_resource_policy.dart`、`klp_runtime_frame.dart` 及 `installation/internal/klp_placement_resource.dart`／`klp_installation_exception.dart`，均相對 `lib/src/runtime/`。
- composition 定義、節點、插槽與已驗證值介面；foundation 現有 bound/prepared/template 契約；styling 既有 semantic schema／resolver 介面。僅為表達保留行為而按需讀取，不複製 compiler 實作。
- features 的清冊與公開宣告、清冊指向的 adapter contract；application 的清冊與 `klp_application_adapters.dart`、screen／retained-screen adapter，composition adaptive 與 runtime scope adapter。catalog 檢查需要核對來源中繼資料／實際 factory 輸出，故允許讀這些具名介面；不讀 runtime update／installation 演算法或 compiler 實作來鏡像測試。

## allowed_write：唯一測試擁有者

下列檔案是最大寫入邊界，只有確實受影響才修改；不得把列表理解為每個檔案都要重寫。

- `test/klp_application_catalog_contract_test.dart`（新：清冊完整性與唯一性）。
- `test/frontend_architecture_boundary_test.dart`（僅移除已整個退役的 `lib/src/foundation/definitions` 掃描清單項；不新增缺目錄豁免、不更改其他斷言）。
- `test/klp_closed_component_catalog_contract_test.dart`。
- `test/klp_tree_runtime_test.dart`。
- `test/klp_scope_activation_test.dart`。
- `test/klp_scoped_runtime_test.dart`。
- `test/klp_app_frame_style_test.dart`。
- `test/klp_frame_groups_test.dart`。
- `test/klp_rail_adapter_test.dart`。
- `test/klp_surface_shadow_test.dart`。
- `test/klp_component_binding_test.dart`。
- `test/klp_component_children_binding_test.dart`。
- `test/klp_template_compile_contract_test.dart`。
- `test/klp_slot_compile_contract_test.dart`。
- `test/klp_anchored_commands_installation_test.dart`。
- `test/klp_block_controls_installation_test.dart`。
- `test/klp_mode_toolbar_installation_test.dart`。
- `test/klp_editing_installation_test.dart`。
- `test/klp_sidebar_interactions_test.dart`。
- `test/klp_workspace_components_declarative_test.dart`。
- `test/support/klp_component_test_definition.dart`。
- `test/support/klp_composite_test_definition.dart`。
- `test/support/klp_runtime_fixture.dart`。
- `test/support/klp_runtime_catalog_adapter.dart`（新：僅測試用最小 adapter，按需）。
- `test/support/closed_catalog_migration.md`（新：案例對照與保護證據；不記自身 hash）。

`forbidden_paths`：全部 `lib/**`、`spec/**`、`docs/**`、`example/**`、架構與工作流程文件、測試設定、baseline、其他 fixture 與所有未列出的測試。不得改 fixture resolver、CI 或加入 skip／allowlist。新發現呼叫端需先由架構負責人重簽範圍。

派工補充（2026-09-14）：乾淨整合工作樹的單一結構定義檢查已重現 `PathNotFoundException`，來源為掃描已退役的 `lib/src/foundation/definitions`。此為測試路徑設定失配，並非產品行為 Red；僅授權刪除該掃描項，既有其餘路徑與失敗斷言維持。

## 具體案例遷移政策

| 既有範圍 | 處理與保護 |
| --- | --- |
| tree runtime 的 consumer component 正向案例 | 改為現有內建節點或最小套件內 adapter 的資料／風格更新；保留同 placement 資源重用、不可變舊輸出及舊 lease 撤銷。不得保留外部 compiler 或只刪整個案例。 |
| runtime 其他交易案例 | 保留 getter 擷取次數、全樹準備先於資源、回滾、已提交通知失敗、具體化失敗、dispose、租約等原有行為；移除空 components 只是呼叫更新。 |
| scope／frame groups／app frame／rail | 以現有內建節點或最小測試 adapter 替換舊 definition；移除 context compiler 欄位，保留動作資格、階層啟用、順序、確定性語意與生命週期斷言。 |
| component binding／children binding | 逐案例分類。單次擷取、不可變結果、合法 child 順序、slot 範圍、語意 owner/type 等現行契約應移轉至既有可觀察介面；僅屬 compiler 的 bind/selector/accessibility-template 錯誤包裝 API 可依 CC-V1-r1 退役，列出案例名稱與理由。沒有現行接受契約時不得發明 replacement compiler。 |
| template／slot compile contract | 保留仍存在的封閉模板 subtype、插槽型別與量值型別檢查；去掉測試 prefix 對已退役 definition 的依賴。只有直接宣告舊 component API 的案例退役或移入公開禁止編譯案例；控制組與 import 必須正常。 |
| surface shadow | 保留現行 shadow 語意量值、owner/public/type 驗證與 immutable 值證據，使用既有 resolver／bound 值介面；不為測試重建退役 compiler。 |
| installation／sidebar／workspace 直接呼叫 | 只移除 runtime 空 components 參數，原有斷言全部保留。 |
| closed catalog 公開禁止案例 | `components:`／退役型別名稱可作負向字串保留；不得因全域取代而破壞負向保護。 |
| Stable artifact／theme 同名 components 欄位 | 不屬於此 runtime API，唯讀且不修改。 |

每個受影響舊 `test` 案例名稱都寫入矩陣：原契約、保留／移轉／退役、對應現行檢查或退役理由。不得只列檔名或測試數量。若對某項保留行為沒有可行的現行介面，先回報具體契約缺口，不能自行削減。

## 新 catalog 契約的可觀察驗收

- 同一程序兩次建構 `klpApplicationAdapters()`，展開後的身分序列相同；每個身分只有一個轉接器組態。
- features components 與 application structural_components 無交集；聯集精確等於實際目錄；array 重複必須在轉成 set 前檢查。
- 檢查所有欄位型別、路徑／符號、定義 ID、owner/level、semantic owner、slots 及 factory variant，連同 public exports 與 compatibility 對照。使用 analyzer AST 或既有可觀察 contract；不能只以脆弱字串數量判定完整。
- 對 manifest 的測試內副本加入重複、移除一項、加入額外身分或改錯擁有者，驗證相應的明確錯誤；不修改產品 manifest 作負向 fixture。
- 至少一個現有內建應用樹經真實 catalog 成功提交；未知節點在建立資源前拒絕，並保持舊 frame/resource/lease。fixture 不新增 production catalog 身分。
- 重用現有 public compile 檢查，明確確認 definition／registry／compiler 或 components 不可由受支援使用端入口撰寫。若增加內部 update 退役 API 負向案例，須在正常 import/正向控制組下驗證目標 named parameter 診斷。
- 只增加現有檢查未保護的斷言，不為每個 JSON 欄位建立一整套重複測試。

## 執行與 Red／Yellow／Green

先執行受影響最高層局部主體：catalog、closed catalog、tree runtime；再執行確實修改的直接呼叫端檔案。只在失敗指向下層相依時細分，保留既有 CI 閘門，不例行跑全庫。

PowerShell 的主要整合命令（未在本輪執行）：

```powershell
& 'D:/flutter/bin/flutter.bat' test test/klp_application_catalog_contract_test.dart test/klp_closed_component_catalog_contract_test.dart test/klp_tree_runtime_test.dart --reporter compact
```

其餘命令由實際 `changed_paths` 決定：同一 Flutter 入口加上所有修改的 `*_test.dart` 精確檔名；support 改動還要加入其直接引用者。保留／移轉案例若有單獨既有保護，記錄其精確路徑與命令。架構相依風險用既有 `test/frontend_architecture_boundary_test.dart`，不加例外。

初始 Red：無已重現行為失敗。初始 Yellow：新清冊完整性與退役 API／fixture 遷移。Green：只有已記錄且未變更的歷史範圍，需明示未重跑。

缺少清冊檔、API 尚未配對、fixture 尚未遷移所造成的編譯／設定錯誤記 `integration-pending`，不宣稱有效 Red。新保護若能在正常設定下重現舊違約，記錄精確失敗；否則交付測試 hash、未執行原因與整合後驗證命令。產品完成後以相同受保護測試取 Green。

## 估算、里程碑與交接

冷啟動估算：10,000–20,000 token、90–210 分鐘；無可比較實測任務。假設主對話高階模型、Windows/PowerShell、本機 Flutter、約 18 份直接相關既有測試與少量 fixture；等待配對基線另記，不能掩蓋為執行時間。

| 里程碑 | 成果與證據 | 累計預期上界 | 異常門檻 |
| --- | --- | --- | --- |
| M1 | 舊案例矩陣與最小保護集合、起始 hash | 6,000 token／60 分鐘 | 9,000 token／90 分鐘或出現契約缺口 |
| M2 | catalog 保護與呼叫端／fixture 遷移，測試 hash、Red 或 integration-pending 原因 | 14,000 token／150 分鐘 | 21,000 token／225 分鐘或需要 forbidden write |
| M3 | 配對整合後相同檢查 Green、完整對照及範圍證據 | 20,000 token／210 分鐘 | 30,000 token／315 分鐘或保留行為沒有證據 |

每個里程碑完成才交一份 checkpoint。無 A/B 實驗。超門檻向架構負責人回報具體證據與最小調整，不擴張產品範圍。

最終交接包含：`changed_paths`、`acceptance_evidence`、`unresolved_blockers`、`scope_gate_result`、測試／fixture SHA-256、精確命令／exit code、舊案例矩陣、實際用時與可得 token 用量。用獨立 checkout Git 差異（含未追蹤檔）逐一對照本包精確 write list；既有 module scope checker 不適用 Test Author，不偽造 test module 或宣稱已通過該工具。

本包的產物必須先由架構負責人納入各產品 worker 的乾淨基線或受控整合基線。產品 worker 可讀可跑，不能改其要求。Test Author 最後確認 hash 與結果，才可接受整組完成。
