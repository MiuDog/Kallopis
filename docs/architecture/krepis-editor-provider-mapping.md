# K01 核心提供者接入對照

2026-09-11，目前 Dart binding 建立 engine 要求 **ABI 1.28**，新增段落／標題 checked 轉換與類型查詢，驗證進度見 [K02 契約](block-controls-contract-plan.md)。1.27 已加入 checked ink capture，提供者手寫接線尚未完成。K04 checked Flow 內容高度於 1.26 加入；模式與捲動接線的協定證據見 [K04 契約](editor-mode-contract-plan.md)，可見切換入口及實機驗收未完成。先前 ABI 1.25 已包含 K02 checked 區塊操作，K01 跨行組字幾何於 1.24 加入。本頁分別描述已有證據與剩餘接線，不以階段性核心測試代替完整筆記元件驗收。

## 來源與工作樹

- 實作位置：`D:/Projects/Krepis-m0-checked-save`，分支 `codex/m0-checked-save-contract-v2`，基底 `7ab045eed2456ada6f1869456a1c609ba141ca08`，新增接口仍為未提交工作。
- [正式標頭](D:/Projects/Krepis-m0-checked-save/include/krepis/krepis_c.h)、[Dart 提供者接口](D:/Projects/Krepis-m0-checked-save/bindings/dart/README.md)、[核心輸入投影](D:/Projects/Krepis-m0-checked-save/docs/architecture/flow-input-projection.md)。
- `D:/Projects/Krepis` 的舊主工作樹另有儲存修改；不能覆蓋或把它的 DLL 當成本次產物。
- 既有 Notist 綁定僅作歷史參考。筆記功能分支 `d39c1cd` 已包含於上述基底，不需重新實作其 stable selection、跨區塊 replace 與 checked-save 整合。

## 目前接口與剩餘工作

最新接線：Kallopis 已安裝可重排／可編輯來源、完整解析風格輸送、viewport、點擊定位、DeltaTextInputClient 與中斷流程。ABI 1.24 新增 `krepis_editor_get_composition_rect`，由核心逐行文字範圍算出跨行組字外接框；空組字使用權威 caret，未組字回明確狀態。Dart scene 在同一 viewport 及 input／font／style 版本核對內擷取它，提供者不再從底線或游標猜測 marked-text 範圍。原生與真實 DLL 驗證通過，Windows 正常退出已確認；RTL 組字幾何、完整字型、無障礙、Windows 真實 IME 及組字中的關閉仍未驗收。下列早期續作記錄保留其當時基線，最新輸入與生命週期證據以 [K01 契約](editor-input-contract-plan.md) 為準。

來源通知續作：公開 [KlpEditingSource](../../lib/src/capabilities/editing/internal/klp_editing_source.dart) 以目前 drawing 與非同步 broadcast 提供快照；`KrepisKallopisSession` 已實作來源，每次成功發布先更新目前值再發通知。Kallopis 的只讀安裝借用此來源與取消訂閱，不取得 engine 釋放或編輯交易權威。

修改轉接續作：`KrepisKallopisSession` 已將公開 KlpEditingRequest 送入核心。ABI 1.23 共用既有字素算法，唯讀解析 stable block 的 UTF-8 範圍並核對完整 stamp，再以原子命令執行 select／replace／begin；update／commit／cancel 保留分段及明確生命周期。成功及拒絕附新投影；接受後回讀失敗保留 status 0 並要求重新同步。真實 DLL 測試已通過，讀寫資料接點已補。Kallopis 平台 session 到此提供者的輸入安裝、完整風格輸送、viewport 生命週期與實機 IME 仍待完成；唯讀 renderer 與訂閱安裝已新增。

讀取發布接線：Kallopis 已提供實驗性 `kallopis_editing_provider.dart` 資料入口；Krepis 獨立 `bindings/kallopis` 套件只依賴此公開契約，不引用本庫 src。`KrepisScene` 攜帶最終核對的 input 副本，`KrepisKallopisPublisher` 先完成同份 scene 的 projection 與 drawing 轉換，再更新發布狀態；轉換失敗不發布半套投影。真實 DLL 驗證反向選取、空組字、風格環境、重複／過期發布與 session 隔離通過；詳見 [轉接套件](D:/Projects/Krepis-m0-checked-save/bindings/kallopis/README.md)。修改意圖與權威回覆亦已接入，唯讀 `KlpEditingContent` 與來源訂閱亦已新增；剩餘為本庫完整排版樣式傳遞及平台輸入安裝。

| 系統 | 已實作並有執行證據 | 剩餘整合與驗收 |
|---|---|---|
| 身分與版本 | 非零 128-bit editor session、content／selection／composition 單調版本；讀取前後核對 | 產品 document／page ID 與 session generation 對應 |
| 輸入投影 | 雙端 stable selection、方向、affinity、分段、optional window 已映射 `KlpEditingStamp`；跨段／區塊模式保留 null window；Flutter 增量輸入鏡像已接入 | Windows IME 實機、跨區塊編輯與無障礙 |
| 修改 | checked select／replace／begin／update／commit／cancel 已轉接中立 intent；指定範圍 begin 原子驗證；平台批次逐筆等待權威回覆 | 完整筆記操作、跨區塊事件與平台實機驗收 |
| 權威回覆 | 已對應 Klp reply、同 request 快取與舊序號拒絕；未知結果封鎖新命令；中斷等待在途回覆後取消組字，來源切換失敗不開新連線；正常退出收到請求、等待 owner 完成並以 exit code 0 結束 | 組字中的關閉與完整路由／模式切換的實機驗收 |
| 繪製 | checked frame、完整字形輪廓、不可變 scene 與 lease 釋放；中立 drawing 原子發布；`KlpBoundEditing`／`KlpFlutterEditingPainter` 內部分支已存在 | 唯讀節點與四色 semantic 已新增；完整風格與實際呈現驗收未完成 |
| 游標與反白 | 核心 caret、逐行選取矩形及 ABI 1.24 跨行組字外接框皆在同 viewport／版本核對內；平台分別接收 caret 與 composing 範圍 | RTL 組字幾何、候選視窗實機位置、跨行視覺與無障礙呈現 |
| 命中與選取 | composed 文字唯讀命中；frame／input／font／style 約束；普通點擊及延伸 anchor | 手勢、拖曳排程、自動捲動；組字中的平台操作策略 |
| 風格 | 完整 style 輸入、獨立版本與 scene 最終核對；Kallopis semantic／viewport 已輸送至核心，套件 Noto Sans TC 已註冊；不支援度量明拒且不鎖死來源 | 完整字型家族／字重／字距支援與視覺定型 |
| 資源 | Dart 暫存與 frame／glyph lease 清理；owner 持有 engine 與 source，等待輸入中斷後釋放；真實 DLL 建立、中文輪廓、關閉協定及 Windows 正常退出檢查通過 | 組字中的關閉尚未驗收；目前證據與限制見 [原生 Catalog](../../example/editor_native/README.md) |

### 整套風格與環境一致性

Kallopis 解析語意風格，提供者搬運完整資料，Krepis 負責排版。清單排版使用完整 `KrepisEditorStyleV2`（96 bytes，保留舊版 64-byte prefix），包含 list indent、marker gap、minimum body em、marker color 與封閉格式政策；所有欄位必填，新版啟用後拒絕舊 setter 降級；沒有 consumer 局部 override 或 Flutter style 輸入。核心驗證 expected input stamp 與 style revision，完整相同值 no-op；風格改變保留文件、選取、組字與 undo history，舊 frame 命中失效。

`KrepisSceneReader` 已將 input、font、style 的前後核對與 frame／字形／游標／反白讀取整合；任一讀取途中變更拒絕整份 scene。font revision 或 style revision 各自只描述核心一項環境，不能任意複製成 Kallopis 的全部 layout／environment 欄位。

### 操作與組字邊界

指定替換範圍使用 `beginCompositionAt`，不能先改選取再 begin 假裝原子操作。取消只移除組字預覽，保留已接受的替換選取。普通點擊在組字中拒絕隱含提交或取消。2026-09-11 使用者已明確確認：失焦、換頁及換模式取消尚未確認的組字，保留已提交內容；本庫需顯式呼叫取消並處理在途結果，不能以平台緩衝清空代替核心確認。

核心 checked 命令尚無 operation sequence 去重快取。Dart session 的成功後回讀失敗會封鎖後續命令；提供者不能重送未知結果，也不能把 status 0 當作保存完成。

## 執行證據

歷史證據：2026-09-11，ABI 1.22 DLL 重新建置時（不代表目前仍是 1.22）：

- Dart 靜態分析：`No issues found!`，exit code 0。
- 真實 DLL 整合：`PASS: Dart ABI roundtrip, immutable snapshots, checked edits, composition lifecycle and allocation-failure cleanup`，exit code 0。
- CTest：`100% tests passed out of 4`，exit code 0；涵蓋 `krepis.c_abi`、`krepis.block_core_abi_consumer`、`krepis.flow_editor`、`krepis.editing_session`。

風格測試涵蓋配置故障無變更、過期風格拒絕、相同風格 no-op、行高更新、舊 frame 拒絕與 scene 讀取途中換風格拒絕。其餘測試涵蓋 Unicode、反向選取、空組字、原子 begin、session／字型變更及 lease 清理。沒有以這些原生測試宣稱 Flutter UI 或全部筆記功能完成。

目前 ABI 1.23 的提供者證據見其 README：`PASS: real Krepis scenes and Kallopis commands, Unicode resolution, composition, stale guards and accepted-failure recovery`，exit code 0。新增中立 drawing 可從 [mapper](D:/Projects/Krepis-m0-checked-save/bindings/kallopis/lib/src/krepis_kallopis_drawing.dart) 及 [publisher](D:/Projects/Krepis-m0-checked-save/bindings/kallopis/lib/src/krepis_kallopis_publisher.dart) 查證。這份文件沒有重跑 DLL，不把引用的歷史測試擴張成 painter／Windows UI 驗收。

繪製限制：Flow mapper 先發布 selection 背景、再保留核心內容順序；glyph 為核心輪廓，不能用 Flutter 字型重排。現有 rect 共用 caret role，尚未分開 caret 與各組字分段裝飾。核心現有線寬也不等於使用者核准視覺，屬性所有權見 [編輯表面](../../.agents/skills/kallopis-design-contract/references/design-knowledge/editor-surface.md)。

## 後續實作與驗收

1. 將本庫語意風格、產品文件身分、核心版本與 viewport 映射為中立 provider 契約，維持資料權威與樣式唯一來源。
2. 安裝本庫擁有的 renderer、游標／反白、點擊與平台文字連線；消費端只注入資料、callback 及受限結構樹。
3. 驗收跨行 Unicode、組字、過期輸入、風格切換與關閉；再依筆記、手寫及空間元件規格逐項補足。

完整範圍仍依 [筆記元件規劃](note-components-plan.md)、[Notion 元件規格](notion-note-components-spec.md)、[手寫規格](concepts-handwriting-spec.md)、[空間元件規格](miro-spatial-components-spec.md)。使用者已授權補足兩庫，以上缺口是後續實作工作，不是只交文件的結案理由。
