# Windows 自訂視窗框架契約

## Outcome

KlpApp 的 Windows runner 最大化後，頂層視窗只能占用目前螢幕的工作區，不能覆蓋或攔截
Windows 工作列；最大化時從 header 開始拖曳會由 Windows 還原成視窗化並接續移動；
視窗化時四邊與四角皆可調整尺寸，且不得小於 KlpApp 宣告的最小寬高。

## In scope / out of scope

- 範圍內：Kallopis example 與 Notist Windows runner 的最大化 bounds、原生拖曳與 resize
  hit test、KlpApp 最小尺寸契約、KlpWindowHeader 窄寬度配置。
- 範圍外：工作列自動隱藏設定、Flutter 視覺風格、其他桌面平台的原生視窗實作。

## Acceptance criteria

1. Windows runner 以目前螢幕的 `rcWork` 設定最大化位置與尺寸。
2. 最大化視窗的原生命中範圍不超過 Windows 工作區。
3. KlpWindowHeader 在內容寬度只有 148px，且同時有標題、圖示與 header action 時，
   不產生水平或垂直 RenderFlex overflow。
4. 窄寬度下最小化、最大化與關閉按鈕仍完整保留並可點擊。
5. KlpWindowHeader 無論是否最大化，都將 header 拖曳交給原生 `HTCAPTION` 行為；視窗控制鈕
   不得成為拖曳區。
6. 視窗化時 `WM_NCHITTEST` 對四邊與四角分別回傳 Windows resize hit-test code；
   最大化時回傳 `HTCLIENT`，避免隱藏邊框攔截 header 操作。
7. `KlpApp.minWidth` 與 `KlpApp.minHeight` 僅接受正的邏輯像素，透過 `setMinSize` 傳給
   runner，並在 `WM_GETMINMAXINFO` 依目前螢幕 DPI 寫入 `ptMinTrackSize`。
8. Kallopis Verify 與 Notist analyze/test 全數 exit 0。
