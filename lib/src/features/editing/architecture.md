# Editing：BlockNote Flow 配對責任

修訂 `KBF-PAIR-r2`，2026-09-15。本檔只固定 BlockNote Flow prerequisites v1 切片；其他既有 editing／Canva／舊核心責任沿 [features architecture](../architecture.md)，本次不重設。

**配對契約 READY，實作 pending。** 依 [共通配對](../../../../docs/architecture/blocknote-flow-pairing.md) 與其唯一 wire 來源，使用者已授權此配對。BUILD 仍須凍結公開 Krepis 宣告、獨立測試及合規 packet 基線；不是已發布 API。

## 目的與公開邊界

Kallopis 繼續以 `KlpBlockNoteEditingContent` 作唯一受限宣告節點，接收既有 Krepis session。新增 pageProjections、onOpenPage、onDatabaseDrop，型別／預設／生命周期以共通配對為準；不提供 consumer Widget、HTML、JS、raw Map、style 或任意 child。

公開 symbols 只從既有 `kallopis_declarative.dart` 暴露需要的 content 及 Krepis 值型別；Stable theme/foundation 不反向匯出此功能。Krepis 型別直接引用／re-export，不另建同名頁面或資料庫型別。

## 所屬路徑與責任

| 路徑（相對本 module） | KP-F1 允許的變更 |
| --- | --- |
| `contracts/klp_block_note_editing_content.dart` | optional 新參數、不可變投影 copy；保留原 constructor 相容性與 hosted channel 檢查 |
| `adapters/klp_block_note_editing_adapter.dart` | 精確透傳 projection／callback；只取得既有 semantic resolver 值 |
| `presentation/klp_bound_block_note_editing.dart` | 不可變 bound 資料，維持 controller 與 callback 身分 |
| `presentation/klp_editing_presentation.dart` | 僅新增所需型別 import；維持原 part/library 邊界 |

`lib/kallopis_declarative.dart` 的 exports 由 public facade owner 以獨立白名單同步，不給此 module worker 任意跨路徑權限。新增樣式／在地化配對須在其 owner 契約凍結後才派相應切片；本切片不發明 token、fallback 或第二套文案來源。

## 依賴、不變條件與生命週期

- composition/styling → features adapter → features bound → rendering；features 不依賴 rendering 實作。
- projection 更新不重開 session、不更新 dirty、不進 undo。完整集合替換；未提供的頁面為 unknown。
- 操作狀態由 Krepis.operationStatus/operationChanges 讀取；onChanged 留給原 registry，不能以覆寫回呼取得狀態。
- onOpenPage/onDatabaseDrop 的缺省值是 null；不可用能力明確拒絕，不能挪用舊 onOpenReference 或將文案當身分。
- 非同步 callback 錯誤經既有 KlpEditingHostFailureSink 向上回報。features 不接 storage、catalog 或 parent 修改。
- 聲明更新只替換 callback／projection，不替換 controller、不新增第二份即時 blocks。

## 切片與驗收

KP-F1：公開參數與 bound 透傳。前置為 Krepis r2 所需型別宣告可匯入，以及 Test Author 凍結測試。

獨立 test-owned path：`test/klp_block_note_flow_contract_test.dart`（相對 repo 根）；測試 optional 參數來源相容、完整身分、不可變投影、callback identity、prepared/bound 透傳與 onChanged 不被佔用。既有 `test/klp_editing_composition_test.dart` 在直接變更風險涉及時回歸，實作者不得修改。

估算 cold-start、無可比較 task ID、沿用目前模型及本機 Dart/Flutter：3k–7k tokens，30–70 分鐘。M1 凍結測試與公開參數（累計 1k–3k／15–30 分）；M2 bound／相容驗證與 scope（累計 3k–7k／30–70 分）。超過上限或需跨白名單寫入即回報，不自行增加授權。

architecture／共通 wire／測試／其他 editing 元件為保護路徑。實作仍未執行；視覺品質由人類接受。
