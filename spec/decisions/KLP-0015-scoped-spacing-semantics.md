# KLP-0015：間距依使用 scope 定義語意

## 狀態

Accepted（2026-09-07）

## 決策與適用邊界

`KlpSpacingTheme` 不再公開 `compact` 與 `halfCompact`。內容、控制項、操作、chrome、導覽、
overlay 與 App 組合邊界各自擁有可注入欄位。完整間距欄位預設指向
`KlpScale.space200`（8px）；`appFrameInset`、`workbenchContentInset`、
`windowHeaderMargin`、`dockMargin` 預設指向 `KlpScale.space100`（4px）。

相同預設值不代表欄位可互換。元件必須依自身位置責任選擇 semantic；尺寸、半徑、命中區與
位移等精確幾何必須放在 `KlpGeometryTheme`，不得借用 spacing 欄位。

## 推導依據

單一 `compact` 同時控制內容間距、按鈕圖文、導覽、浮層與命中尺寸。任何消費端覆寫都會連動
無關元件，無法表達「只調整 overlay 密度」或「只調整 App 邊界」。依 scope 拆分後，JSON、
ThemeExtension 與元件 resolver 才能各自注入並保留清楚的除錯路徑。

否決保留 `compact` 作相容 alias：alias 會繼續成為最容易被誤用的入口，也無法決定應連動哪些
新欄位。舊 JSON 的相容只留在 v1 解碼邊界，runtime model 不保留 alias。

## 代價

Theme model 與 JSON 欄位數增加。新增元件時必須先判定 scope；若現有 scope 不足，需新增明確
語意，不能退回 primitive 或萬用密度名稱。

## 閘門

- `lib/`、`test/` 與 `example/` 不得讀取 spacing 的 `compact`／`halfCompact`。
- JSON v2 不接受或輸出 `spacing.compact`；v1 匯入時一次性展開，明寫的新欄位優先。
- 每個 scope 欄位必須涵蓋 constructor、copyWith、equality、hashCode 與 JSON round-trip。
- exact geometry 的 8px 使用點必須解析 `KlpGeometryTheme` 欄位。

## 已知欠債

歷史決策與規格仍可能使用 compact／halfCompact 描述當時的 8px／4px 幾何關係；這些名稱只供
追溯，不是現行 runtime API。
