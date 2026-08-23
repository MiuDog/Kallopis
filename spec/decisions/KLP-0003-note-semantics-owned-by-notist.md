# KLP-0003：筆記語意元件由 Notist 擁有

## 狀態

Accepted（2026-08-23）

## 決策與適用邊界

Kallopis 不再提供文件區塊、筆記頁面背景、背景編輯器與試算表格等筆記語意元件。這些元件
移至 Notist，以 `Nts` 前綴提供。Kallopis 僅保留它們依賴的通用 token 與機制，包括
`KlpContextMenu`、`KlpResizeHandle`、`KlpAccordion`、`KlpDataTable` 及圖樣色彩 token。

Notist 不自行定義這些元件的顏色、透明度或互動狀態外觀。通用可按壓表面的 rest、hover、
focus 與 selected 視覺由 Kallopis 提供；Notist 只組裝「內容編輯」與「操作鈕選取」等產品
語意。rest 必須透明，hover／focus 使用半透明中性高亮，selected 使用半透明選取色，且
selected 優先於 hover／focus。

## 推導依據

上述元件目前只有 Notist 具有相同產品語意，未通過 KLP-0001 的「至少兩個產品使用」規則。
把展示留在 Kallopis Catalog 會讓視覺庫成為筆記產品的除錯入口，反轉了依賴方向。

否決方案：

- 只搬 Catalog、保留公開元件：Kallopis 仍擁有未通過抽層規則的 API，拒絕。
- 把筆記元件提升成獨立 feature package：目前只有一個消費者，抽取時機尚未成立，拒絕。

## 代價

這是公開 API 的破壞性移除；消費端必須改用 Notist 的 `Nts` 型別。跨產品若未來真的共享同一
筆記語意，需要重新評估獨立 feature package，而不是直接放回 Kallopis。

## 閘門

Kallopis Catalog registry 不得出現 `Notes` 分組，公開入口不得匯出 `KlpBlock`、
`KlpPageBackground` 或 `KlpSheetGrid`。元件清單與 Catalog 覆蓋測試會機械驗證目前匯出面。
Notist 的筆記元件不得自行計算狀態色或 alpha，必須組合 Kallopis 的通用互動元件。

## 已知欠債

`pagePattern` 仍是 Kallopis 的通用圖樣色彩 token；它沒有筆記資料或互動語意，暫不搬移。
