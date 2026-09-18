# lib/src/capabilities：架構分析入口

[上一層](../README.md)

## 範圍

閱讀 `lib/src/capabilities` 的直接子目錄與 Dart 檔案。結構圖表示實際檔案包含關係；依賴圖表示本層檔案明寫的 directives。每個檔案頁另列直接依賴、宣告、欄位、方法、建構子及行號證據。

## 模組閱讀重點

## 分析入口

K02-S3 已新增 `KlpBlockIntent.convert` 與四值 `KlpBlockTextKind`；`KlpBlockItem.textKind` 明示可轉換的段落／標題類型，未支援類型為 null。轉換沿單一已選取區塊、同源序號與中斷機制執行；原生 ABI 1.28 以獨立 checked 類型查詢保留舊結構配置。轉換交易的獨立原生矩陣、真 DLL 提供者與本庫相關測試已通過，可見格式入口尚未完成。

K05 的 `KlpHandwritingStateSource` 在同一編輯來源提供獨立暫態狀態。`KlpHandwritingState` 引用原 drawing，以 capture 世代、批次收據及預覽版本追蹤筆劃；`KlpHandwritingStatePublisher` 驗證不可倒退、同筆容量固定與終態限制。預覽沿用封閉幾何及 `ink` 用途，不改寫已提交 drawing 的 stamp。這是資料接點，尚未接上核心落筆目標、平台手勢或 preview renderer。

K04 透過 `KlpEditorModeSource` 發布同版本模式／工具與核心 viewport 範圍。`KlpEditorModeSession` 與文字／區塊／命令共用序號，切換前等待組字中斷，已知拒絕可恢復原文字輸入，未知結果保持封鎖。唯讀導覽可獨立安裝；宣稱文字可用必須具可編輯能力，尚未接通的手寫不得啟用。可見工具列與切換入口尚未完成。

K03 由 `KlpAnchoredCommandSource` 提供同幀候選、封閉的 caret／block anchor 與 typed 確認請求，與文字、區塊操作共用來源序號。`KlpAnchoredCommandSession` 負責開啟前中斷、ID 導覽、確認與關閉；換錨點不能沿用舊確認意圖，晚到未知結果仍需重新同步。可見選單與焦點入口尚未完成，consumer 不能以原生 Widget 補接。

組字輸入由 `KlpCompositionText` 保存不可變暫定文字與語意分段，`KlpCompositionSegment` 使用 UTF-8 邊界並拒絕重疊／逆序。`KlpEditingSubmission` 序列化單次提交並檢查 begin／update／commit／cancel；Flutter 輸入接線與獨立 Krepis 提供者已加入，真實 Windows IME 驗收仍未完成。

`editing/internal/` 提供實驗性筆記資料契約，由 `kallopis_editing_provider.dart` 公開：`KlpTextOffsets` 映射 UTF-16／UTF-8；`KlpEditingStamp` 識別文件、頁面、session 與投影版本；`KlpEditingTextWindow` 驗證同份文字的選取／組字範圍。來源區分固定幾何、可重排與可編輯能力，已由編輯功能安裝至內部 renderer。K02 的 block 投影與 drawing 共用 stamp／viewport，區塊與文字命令由同一來源發出序號；區塊使用者入口尚未完成。完整狀態見 [筆記元件計畫](../../note-components-plan.md)，不能由資料 API 存在推定完整編輯器已交付。

目前提供純資料 state、借用 controller 與非同步資料擁有者。`state/klp_mutable_state.dart` 由擁有端寫入，`readOnly` 回傳私有 facade；`state/klp_state.dart` 是借用介面，訂閱取消在 `klp_subscription.dart`。

`controllers/klp_state_controller.dart` 只管理附接，不複製來源值或釋放外部 state。訂閱支援重入更新、通知中取消與釋放。

`data/klp_async_data.dart` 透過共用 state 發布待命、載入、成功與失敗。generation 使晚到結果失效；cancel 不終止底層 I/O。資料操作錯誤成為失敗狀態，訂閱通知錯誤回報呼叫端；初始通知失敗時，僅復原仍屬於原請求的狀態。此能力尚未接到功能樹的自動安裝或 Flutter renderer。

`navigation/` 提供型別化 destination、location、outcome 與 guard；`navigation/internal/` 是候選堆疊、取消、提交與結果完成的純 Dart 核心。`KlpNavigationMachine.start` 執行初始 guard，允許同步或非同步政策，成功後才呼叫應用提交埠。提交結果與離開結果分開，接點違約不能被誤報為一般拒絕。Application session 已持有並接線此核心，消費端只取得 entry 綁定的 typed input；核心不依賴 Screen 或 Flutter。網址、深連結與還原仍待後續策略。參見 [導覽交易樣板](../../navigation-transaction-prototype.md)。

## 本層直接依賴圖

箭頭以本層 Dart 檔案明寫的 directive 彙總到目標所在目錄或外部套件邊界；不遞迴將子目錄依賴算入本層。相同目標的不同 directive 類型分開計數。

本層檔案未宣告跨目錄依賴；子目錄依賴請循下一層入口閱讀。

| 目標邊界 | 關係 | directive 數 | 第一筆來源證據 |
|---|---|---|---|
| 無 | — | 0 | 來源清單見本層檔案 |

## 目錄結構圖

```mermaid
flowchart LR
	n0["lib/src/capabilities"]
	n1["actions/"]
	n2["block_note/"]
	n3["controllers/"]
	n4["data/"]
	n5["editing/"]
	n6["environment/"]
	n7["files/"]
	n8["navigation/"]
	n9["state/"]
	n0 -->|"contains"| n1
	n0 -->|"contains"| n2
	n0 -->|"contains"| n3
	n0 -->|"contains"| n4
	n0 -->|"contains"| n5
	n0 -->|"contains"| n6
	n0 -->|"contains"| n7
	n0 -->|"contains"| n8
	n0 -->|"contains"| n9
```

## 子目錄

| 目錄 | 導航 | 來源證據 |
|---|---|---|
| `actions/` | [架構入口](actions/README.md) | [來源目錄](../../../../lib/src/capabilities/actions) |
| `block_note/` | [架構入口](block_note/README.md) | [來源目錄](../../../../lib/src/capabilities/block_note) |
| `controllers/` | [架構入口](controllers/README.md) | [來源目錄](../../../../lib/src/capabilities/controllers) |
| `data/` | [架構入口](data/README.md) | [來源目錄](../../../../lib/src/capabilities/data) |
| `editing/` | [架構入口](editing/README.md) | [來源目錄](../../../../lib/src/capabilities/editing) |
| `environment/` | [架構入口](environment/README.md) | [來源目錄](../../../../lib/src/capabilities/environment) |
| `files/` | [架構入口](files/README.md) | [來源目錄](../../../../lib/src/capabilities/files) |
| `navigation/` | [架構入口](navigation/README.md) | [來源目錄](../../../../lib/src/capabilities/navigation) |
| `state/` | [架構入口](state/README.md) | [來源目錄](../../../../lib/src/capabilities/state) |

## 本層檔案

| 檔案 | 宣告 | 細節 | 來源證據 |
|---|---|---|---|
| 無 | 本層沒有 Dart 檔案 | — | — |

## 閱讀說明

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁的目錄與檔案由來源清冊產生；`manifest.json` 位於本圖集根目錄，可核對 SHA-256 與覆蓋數。人工模組摘要存於 `tool/architecture_atlas/briefs/`，重新生成時保留。
