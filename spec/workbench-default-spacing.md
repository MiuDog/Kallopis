# Workbench 預設間距契約

## Outcome

`KlpWorkbenchShell` 與 shell panel 不需消費端指定 spacing，即可呈現一致的 Kallopis
工作台版面：window header 維持全寬，header 下方的工作台四周與相鄰 panel 之間使用相同留白，
panel 內容則自帶一致內距。

## In scope / out of scope

- 範圍內：`KlpWorkbenchShell` 預設外距與欄距、`KlpPanelFrame`／`KlpSidebarFrame`／
  `KlpStageFrame` 預設內容內距、Notist 移除同義覆寫。
- 範圍外：個別產品頁面的內容排版、window header 內部圖示與控制按鈕幾何、色票與圓角。

## Visual contract

1. workbench 四周與相鄰 panel 之間都解析為 `context.klp.space.compact`。
2. panel 內容四周預設解析為 `context.klp.space.base`。
3. window header 不包進 workbench padding，外框仍與視窗左右邊界對齊。
4. 消費端明確提供 `padding`、`paneGap` 或 panel `padding` 時，仍以消費端值為準。

## Architecture constraints

- 預設值只能讀取 `context.klp` semantic token，不可參照 primitive 或寫死數值。
- Notist 不重複宣告與 Kallopis 預設相同的 spacing。
- 本契約取代歷史發布任務中「未指定 `paneGap` 維持 `space.base`」的舊版相容條件。

## Acceptance criteria

1. 未傳入 spacing 的 `KlpWorkbenchShell`，四周與 primary／stage／secondary 欄距皆等於
   `space.compact`。
2. 同一畫面中的 `KlpWindowHeader` bounds 維持全寬，只有 workbench panel 被內縮。
3. 未傳入 panel padding 時，sidebar 與 stage 的內容四周皆等於 `space.base`。
4. Notist 的 `KlpWorkbenchShell`、`KlpPanelFrame` 與 `KlpStageFrame` 不再傳入同義 spacing。
5. 呼叫端覆寫 spacing 的既有測試繼續通過。
