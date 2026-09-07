# KLP-0013：Panel Scrollbar 使用尾側 padding 槽

- 狀態：Accepted
- 日期：2026-09-04

## 決策

具有單一主要垂直 Scrollable 的 `KlpPanelFrame`，必須讓 Scrollbar 位於 panel 尾側
8px content padding 槽，內容仍保留完整水平 padding。Frame 與 Scrollable 共用
`ScrollController`，並停用該內容子樹的桌面自動 scrollbar。

Scrollbar thumb 以 `(endPadding - scrollbarThickness) / 2` 解析 cross-axis margin；
預設為 8px padding 與 5px thumb，因此能置中於既有 padding 槽。

## 理由

Scrollbar 是 panel 邊緣控制，不是內容元素。把它建立在 padding 後的 ListView 上，
會讓軌道向內偏移並占用內容的視覺寬度；把內容 padding 移除則會破壞文字與 panel
邊緣的安全距離。由 Frame 畫唯一 Scrollbar 可同時保留兩項責任。

## 影響

- `KlpPanelFrame` 接受可選 `contentScrollController`。
- `KlpDockPanel` 將相同 controller 轉交 Frame。
- `KlpNavigator` 與 `KlpExplorer` 可接受外部 controller。
- Catalog 目錄由 Shell 持有並釋放共用 controller。

## 邊界

- 本規則只處理 panel 的單一主要垂直捲動，不處理水平或巢狀捲動。
- 不影響 page／stage 自己擁有的 Scrollbar。
- RTL 以實際尾側 padding 計算位置。

## 被否決方案

- 只替 ListView 加 Scrollbar：render box 已位於 panel padding 內，位置仍過度向內。
- 移除內容右 padding：會讓文字與操作元件侵入 panel 邊緣安全距離。
- 疊加第二條 Scrollbar：桌面自動 scrollbar 仍存在，會形成重複軌道與 hit-test。

## 代價

Frame 與 Scrollable 必須共享 controller；具有多個獨立 ScrollPosition 的內容不能直接
使用此入口，需由產品指定主要捲動區。

## 閘門

- Catalog 目錄的 controller 必須同時傳給 KlpDockPanel 與 KlpExplorer。
- Frame 提供 controller 時，內容必須保留水平 padding 並停用自動 scrollbar。
- `flutter analyze --fatal-infos` 必須通過。

## 已知欠債

尚未定義水平 Scrollbar 與同一 panel 多捲動區的外觀；遇到實際產品需求時另立決策。
