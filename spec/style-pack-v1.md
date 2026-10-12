# 可替換風格檔 v1

擁有模組：共通 style pack。階段：0→1。目標版本：Style Pack v1。

Readiness：READY。使用者於 2026-10-12 明確授權拆分現有風格、元件中立、公開參數並保護布局語意；JSON 是契約內的可逆交換格式選擇。

## 權威與範圍

現行正式表格提供首次遷移的完整來源。遷移成功後，`styles/kallopis-v1.json` 擁有預設風格值；原料、語意及配方表格改為生成文件，不再人工修改第二份權威。記號、合法組合與平台限制仍由通用規範擁有。遷移前保持現有生成路徑有效，切換只在逐項內容及框架驗證通過後完成。

風格檔不得包含可執行程式、HTML、Widget tree、command handler、panel 位置或業務規則。元件取得風格但不匯入指定品牌 pack；框架預設 adapter 為既有 caller 提供 Kallopis pack。

| ID | 版本 | 優先級 | 需求 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| SP-01 | v1 | P1 | 將現有風格拆成版本化、可替換 pack。 | 所有原料、四主題語意、配方及繼承逐項保留，包含 none／inherit／產品決定等差異；不是僅比較數量。 | accepted |
| SP-02 | v1 | P1 | 輸入驗證與解析必須確定且跨框架一致。 | schemaVersion、ID、型別、引用、循環及數值範圍檢查；未知版本或非法值拒絕，保留原有效風格；不用 eval。 | accepted |
| SP-03 | v1 | P1 | 以語意／配方注入風格，預設 pack 與元件分離。 | Flutter 與 React consumer 可提供 pack；兩個獨立 provider 可同時使用不同風格，不污染全域；既有入口及預設外觀相容。 | accepted |
| SP-04 | v1 | P1 | 盡量公開現有共用風格参数。 | 公開可查詢的參數目錄：ID、型別、單位、範圍、用途、受影響元件、支援平台；顏色、字型、spacing、size、shape、border、shadow、狀態及 motion 可替換；未映射參數明示原因，不能悄悄忽略。 | accepted |
| SP-05 | v1 | P1 | 風格參數與布局不變條件分離。 | 有效 gutter、padding、控制高度、字型及 min／max 修改後，幾何守恆且有限非負；不得改動 role／child 合法性、panel capability 或 handler。 | accepted |
| SP-06 | v1 | P1 | 配方只改視覺，不改元件行為與組合規範。 | hover／selected 共用規則及可及名稱不被 pack 覆寫；隱藏可點擊狀態、負尺寸及非法 constraints 有診斷。 | accepted |
| SP-07 | v1 | P1 | 風格資產有明確 ownership。 | 字型與圖示的來源、package 相對路徑及載入限制明示；JSON 不自動載入任意外部程式；沒有字型時不宣稱已成功套用。 | accepted |
| SP-08 | v1 | P1 | docs 有風格參數、匯入、更換、錯誤及布局驗證展示。 | 同一元件與工作區可切換預設及另一份有效 pack，改尺寸後仍能拖放／分頁；可看到非法風格的錯誤。 | accepted |

## 公開資料與失敗行為

Pack 提供身份／版本、primitive 值、各 mode 的 semantic 表達式、recipe 視覺參數及資產引用；型別／單位／合法性由 schema 和參數目錄定義。框架 adapter 執行色碼、單位與字型轉換，不能偷偷補入第二份預設。

Consumer 可載入完整 pack，也可在有效 pack 上套用經驗證的參數覆寫。變更必須整體成功才替換 provider，錯誤需含參數 ID 與原因；不以部分套用造成兩種風格混合。

布局 constraints 的數值可配置，但 min ≤ max、尺寸守恆、非負、drop capability 及不足空間策略是算法契約。可及焦點與 hit target 需維持有效；不足空間由既有 overflow／收合策略處理，不靠寫死品牌尺寸補救。

必要證據：遷移逐項對照、跨語言解析樣例、非法 pack、provider 隔離、替換恢復與不同 spacing／字型／尺寸下的布局不變條件。主觀外觀不由測試評分。
