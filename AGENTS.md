# Kallopis — Agent 入口

Kallopis 是 `-ist` 產品家族共用的 Flutter 宣告式視覺與互動層；公開 library 在 `lib/`，實作在 `lib/src/`，範例在 `example/`。

## Current truth

- 舊 Catalog 全面遷移與刪除以 [固定清冊及進度](docs/architecture/catalog-migration/README.md) 為準。固定254項分母不能因刪頁縮小；逐項具備新版公開宣告、資料／事件與可操作 Catalog 證據後，才完成整體遷移並刪除舊元件。已接受新版風格保持；目前尚未全部完成。

- 宣告式框架遷移以 [KLP-0019](spec/decisions/KLP-0019-declarative-framework-migration.md) 為準。
- 筆記正文新路徑以 [KLP-0020](spec/decisions/KLP-0020-blocknote-editor-adoption.md) 為準；接續筆記功能時再讀 [當前交接](docs/session-handoff.md)。
- Consumer API 與範本從 [AI 文件索引](docs/ai/README.md) 進入；查實作從 [架構圖集](docs/architecture/README.md) 搜特定節點，不預載整套計畫。
- 已接受 module 的責任、公開介面與目前 slices 以該 module root 的 `architecture.md` 為準；沒有該檔時先進入 PLAN，不由 BUILD worker 自行發明。
- 歷史與被取代決策不得混入現行規格；需要歷史時才查版本紀錄。
- 視覺元件由本庫統一維護；其他 agent 不得擅自新增元件或視覺變體。遷移以 [視覺元件統一維護](spec/visual-component-governance.md) 為準：保留新版已接受的 icon、按鈕列、Explorer、Frame 等風格及 hover／selected 同色；其餘舊元件全面遷移後再細調，不還原已接受的新外觀。能力缺口先提出資料／事件／組裝需求，新外觀候選由 Catalog 供人類檢查。
- Consumer 只可使用本庫契約明列的組裝方式；插槽型別相符不代表任意組合合法。父子、角色、數量、次序、巢狀及上下文限制均由本庫規定，未列出的組合不得自行推定或以自訂節點、布局參數繞過。
- Kallopis 只定義產品無關的通用元件組及合法組裝規則；consumer 在此範圍內自由組合，產品功能選用與組合邏輯由使用者設計並由產品專案擁有。不得在本庫新增 Planist 專用模板、固定業務功能順序或商業邏輯元件層。
- `Workspace.Explorer / EXP-V1-r2` 已完成直接替換，見 [公開宣告與組裝](docs/ai/explorer-model.md) 及 [模組配對](docs/architecture/explorer-v1-plan/README.md)。Consumer 可 implements item interface 或 method 包裝有限能力；這不開放 renderer。舊 API／專用實作已移除，不得重建相容入口。新外觀仍須 Catalog 接受。

## Intent routing

- 簡略產品想法、新系統或未定義的新行為：讀 `.agents/skills/spec-driven-development/SKILL.md`，只完成 DEFINE。
- 已有接受且 READY 的單一 module 規格，需要設計架構或 slices：讀 `.agents/skills/planning-and-task-breakdown/SKILL.md`，只規劃目前 stage。
- 已有完整 Task Packet 的實作：讀 `.agents/skills/incremental-implementation/SKILL.md`；必要新測試由隔離角色另讀 `test-driven-development`。
- 已有可重現 code failure 或非預期行為：讀 `.agents/skills/debugging-and-error-recovery/SKILL.md`，依 Red → Yellow → 最小 Green fallback 處理。
- 長 session、交接、上下文或協調成本問題：讀 `.agents/skills/lean-development/SKILL.md`；它不取代目前 phase owner。
- 不在 session 啟動時預載所有 skills。每次只讀目前 intent owner，以及任務確實需要的單一跨切面 owner。
- Claude Code 使用 `.claude/skills/` 內的同版本 skills；Codex、Gemini CLI 與 Antigravity 共用 `.agents/skills/`。

## Scope and evidence

- 採自動接受模式：契約內且可逆的選擇直接執行並記錄證據；只有公開相容性、資料權威、不可逆外部影響或確實需要新增授權時才停下詢問。
- 開工先檢查 Git 狀態，保留他人與未提交變更；禁止無差別 reset、清檔或 stage。
- BUILD worker 只能修改 Task Packet 的 `write_paths`；`architecture.md`、test-owned paths、fixture、baseline、測試設定與其他 module 預設唯讀。
- 跨 module 需求先停止 BUILD，交由架構負責人更新共通規格與 module contracts。
- 一般修改不預設新增或執行測試。具體風險成立時，先測受影響功能最高層級的局部主體，失敗才往下細分；保留既有 CI 與發布閘門。
- 確有必要的新測試由高階 Test Author 撰寫；實作 worker 可讀可執行，不得弱化測試要求來取得通過。
- Agent 只判斷 deterministic code evidence；視覺品質、互動手感與易用性由人類接受。只報已觀察證據，未執行或環境阻擋明示標記。
- 所有程式縮排使用 tab 字元，顯示寬度 2；註解使用繁體中文。教學實作一次只推進一個可執行步驟，其餘只列目錄。

## Kallopis invariants

- 品牌保留 Kallopis；宣告式 API 使用 Klp，consumer 從 `kallopis_declarative.dart` 組裝。資料夾及 GitHub 不改名。
- KLP-0019 要求唯一結構樹、受限插槽與固定 primitive schema 整套替換。Consumer 不注入原生 Widget、`build`/`context`、局部 style 或 painter。
- KLP-0020 要求 Planist 使用 Krepis 統一介面，Krepis 轉接 BlockNote；上游掌管正文模型、排版、選取與 undo，不維持雙正文權威。自研正文核心及專用路徑為暫時棄用，只保留舊資料相容與回退。
- Kallopis 掌管語意風格、呈現與 WebView 宿主；不得建立第二份 theme、environment 或 l10n 來源。
- `kallopis_theme.dart` 與 `kallopis_foundation.dart` 是 Stable；experimental 不得反向匯出。`lib/src` 對外 private；新舊 API 依公開 library 可達性區分。
- 樣式必須由本庫 semantic resolver 取得；舊路徑使用 `context.klp`。Consumer 與 renderer 不得寫死風格或新增另一份預設值。
- 修改 UI 時按需讀 [風格規格](spec/style-v1.md)、對應的 `design/` 已確認頁面與直接相關契約；不重問已授權事項，不把探索稿當定型。
- 修改架構邊界才讀 [前端邊界](docs/architecture/frontend-boundaries.md) 的相關段落；架構測試只在該風險涉及時執行，不加例外規避。

## Environment facts

- Flutter 指令入口為 `C:/development/flutter/bin`，目前不在 PATH；實際版本與相依以本機及 `pubspec.yaml` 為準。
- 字型及套件資產必須保留 package ownership，避免靜默 fallback。
- 筆記核心唯一可寫工作樹為 `D:/Projects/Krepis-m0-checked-save`；不得修改 `D:/Projects/Krepis` 或 Designist 副本。
- 規則衝突時：使用者當下指示 > 本檔 > 相關現行契約 > 舊文件。
