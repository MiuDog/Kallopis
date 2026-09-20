# Tabs Architecture

狀態：IMPLEMENTED

目前階段：Document Tabs Restore v1

規格：[KLP-0022](../../../../../../spec/decisions/KLP-0022-thin-design-system-boundary.md)

## 目的與邊界

本 module 提供兩種直接 Flutter 分頁元件：`KlpTabs` 是簡單的索引式文字分頁；
`KlpDocumentTabs` 是具穩定 ID、修改狀態、釘選及關閉意圖的文件分頁列。

Consumer 擁有分頁清單、選取、文件生命週期與重新排序；Kallopis 只擁有分頁列的
視覺、水平捲動、鍵盤操作、hover／focus 與 accessibility。不得恢復 node、adapter、
bound model、renderer 或文件 repository。

## 公開介面

- `KlpDocumentTab`：不可變顯示資料，包含 `id`、`label`、`dirty`、`closable`、`pinned`。
- `KlpDocumentTabs`：受控 Widget，接收 tabs、`selectedId` 及 select／close／pin callbacks。
- `KlpTabs`：既有簡單索引式分頁，不因 rich variant 改變契約。

所有 ID 使用現行元件慣例的 `String`；callback 只回報意圖，不修改 consumer 資料。

## 不變條件

- tab 的 `id` 與 trim 後的 `label` 不得為空；同一分頁列的 ID 不得重複。
- 選取狀態只由 `selectedId` 決定；元件不保存產品選取、關閉或釘選狀態。
- `dirty` 同時具可見標記與語意標籤；不能只靠顏色表達。
- pin 與 close 是獨立可聚焦動作；`closable == false` 時不建立 close action。
- `←`／`→` 依目前選取位置循環回報相鄰 tab ID；沒有 select callback 時不攔截。
- 分頁列水平捲動，尺寸、間距、色彩、圓角、字型與 icon 均來自現行 semantic theme。
- 本 module 不擁有文件內容、排序、持久化、路由或產品流程。

## 依賴方向

```text
KlpDocumentTabs widget
	→ tabs internal interaction／presentation
	→ Kallopis localization／semantic theme／icons
	→ Flutter focus／semantics／scrolling
```

不得依賴 application、runtime、bound presentation、private renderer、Dock state 或產品 model。

## DTR-S1：直接 Flutter 文件分頁還原

可觀察結果：consumer 可由 `kallopis_foundation.dart` 建立受控文件分頁列，呈現 dirty／
pinned／closable 狀態並接收 select／close／pin 意圖；鍵盤與 accessibility 不低於舊能力。

允許寫入：

- `lib/src/features/navigation/widgets/tabs/**`
- `lib/kallopis_foundation.dart`

驗收：公開入口與 tabs sources 局部 analyze；既有 tabs tests；source scan 不含 declarative
runtime。必要新 deterministic tests 由獨立 Test Author 擁有，本 BUILD 不修改 tests。

Milestones：

1. 受控資料與選取：model 驗證、水平捲動、selected／dirty 呈現與方向鍵選取完成。
2. 文件動作與公開入口：pin／close 的獨立 semantics、localization 及 foundation export 完成。

估計：cold-start，參照既有 `KlpTabs` 與歷史 Document Tabs；預期 10k–18k tokens、
45–100 分鐘。超過 26k tokens 或 150 分鐘時停止檢查焦點與 action ownership。

DTR-S1 已完成：直接 Flutter rich tabs、受控事件、鍵盤選取、dirty／pin／close semantics
已由 foundation 匯出；公開入口 analyze、既有 tabs／a11y tests 與 scope check 通過。
