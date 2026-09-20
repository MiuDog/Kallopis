# Kallopis — Agent 入口

Kallopis 是 `-ist` 產品家族共用的 Flutter design system 與元件庫；公開 library 在 `lib/`，實作在 `lib/src/`，範例在 `example/`。

## Current truth

- 目前架構以 [KLP-0022](spec/decisions/KLP-0022-thin-design-system-boundary.md) 為準：所有 consumer 只使用 Flutter、`kallopis_theme.dart` 與 `kallopis_foundation.dart` 組合產品畫面；舊 declarative runtime 與相容入口已移除，不得重建。
- 固定 254 項舊 Catalog 清冊與遷移閘門已刪除；元件依實際 caller、跨產品重用與產品驗證決定保留、合併或移除。
- 筆記正文新路徑以 [KLP-0020](spec/decisions/KLP-0020-blocknote-editor-adoption.md) 為準；接續筆記功能時再讀 [當前交接](docs/session-handoff.md)。
- Consumer API 從 [唯一產品使用指南](docs/ai/product-usage.md) 進入；架構責任從 [架構入口](docs/architecture/README.md) 查詢。
- 已接受 module 的責任、公開介面與目前 slices 以該 module root 的 `architecture.md` 為準；沒有該檔時先進入 PLAN，不由 BUILD worker 自行發明。
- 歷史與被取代決策不得混入現行規格；需要歷史時才查版本紀錄。
- 本庫統一維護公開共用元件的內部視覺與互動；保留已接受的 icon、按鈕列、Explorer、Frame 等風格及 hover／selected 同色。產品可用 Flutter 組合畫面並建立產品專用 Widget；只有證明跨產品重用的能力才提升為 Kallopis 元件。
- Kallopis compound component 仍可限制自己的 child、role、數量與次序，但不驗證 consumer 的完整 Widget tree。Consumer 不得引用 `lib/src` 或在公開共用元件內繞過 semantic style。
- Kallopis 只定義產品無關的通用元件組及合法組裝規則；consumer 在此範圍內自由組合，產品功能選用與組合邏輯由使用者設計並由產品專案擁有。不得在本庫新增 Planist 專用模板、固定業務功能順序或商業邏輯元件層。
- Explorer 只保留 `KlpFileExplorer` 直接 Flutter 元件；產品投影 section／item 資料並接回 selection／toggle callback，不得重建 node、adapter 或 renderer。

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

- 品牌保留 Kallopis；公開型別使用 Klp。Consumer 從 `kallopis_foundation.dart`／`kallopis_theme.dart` 使用元件與風格；不存在 declarative 或 compatibility 入口。資料夾及 GitHub 不改名。
- Consumer 可使用原生 Widget、`build`／`context` 與 Flutter 布局組合產品畫面；產品專用視覺仍應讀 Kallopis semantic theme，不建立第二份共用 theme 或複製公開元件內部樣式。
- KLP-0020 要求 Planist 使用 Krepis 統一介面，Krepis 轉接 BlockNote；上游掌管正文模型、排版、選取與 undo，不維持雙正文權威。舊格式只能一次性轉換匯入，不得恢復自研正文執行路徑。
- Kallopis 掌管語意風格、呈現與 WebView 宿主；不得建立第二份 theme、environment 或 l10n 來源。
- `kallopis_theme.dart` 與 `kallopis_foundation.dart` 是 Stable；experimental 不得反向匯出。`lib/src` 對外 private；新舊 API 依公開 library 可達性區分。
- 樣式必須由本庫 semantic resolver 與 `context.klp` 取得；Consumer 不得寫死共用風格或新增另一份預設值。
- 修改 UI 時按需讀 [風格規格](spec/style-v1.md)、對應的 `design/` 已確認頁面與直接相關契約；不重問已授權事項，不把探索稿當定型。
- 修改架構邊界才讀 [前端邊界](docs/architecture/frontend-boundaries.md) 的相關段落；架構測試只在該風險涉及時執行，不加例外規避。

## Environment facts

- Flutter 指令入口為 `C:/development/flutter/bin`，目前不在 PATH；實際版本與相依以本機及 `pubspec.yaml` 為準。
- 字型及套件資產必須保留 package ownership，避免靜默 fallback。
- 筆記核心唯一可寫工作樹為 `D:/Projects/Krepis-m0-checked-save`；不得修改 `D:/Projects/Krepis` 或 Designist 副本。
- 規則衝突時：使用者當下指示 > 本檔 > 相關現行契約 > 舊文件。
