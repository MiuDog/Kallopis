# KlpApp 受限高度佈局

## Outcome

`KlpApp` 在 Windows 啟動、縮放或 route transition 暫時取得小於標準 Header 的高度時，不產生
垂直 `RenderFlex overflow`；恢復正常高度後，Header 與內容仍使用既有尺寸與配置。

## In scope / out of scope

- 範圍內：`KlpApp` 根層 Header／內容的受限高度分配與 widget 回歸測試。
- 範圍外：修改標準 Header 高度、最小視窗尺寸、原生 runner、產品內容的捲動策略。

## Acceptance criteria

1. 可用高度小於 `windowToolbarHeight` 時，`KlpApp` 不拋出 `RenderFlex overflow`。
2. Header 最多取得目前可用高度，內容取得剩餘高度，不以固定子項高度超出父層約束。
3. 正常高度下的 Header 高度與現有視覺契約不變。
4. Kallopis Verify 全數 exit 0。
