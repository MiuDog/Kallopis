# 互動狀態視覺語言

## Outcome

讓可操作元件的 hover／focus／selected 狀態依用途分成兩種一致的視覺語言。

## Visual contract

- Explorer 與樹狀資料列：hover／focus 使用低對比虛線框，selected 使用高對比虛線框。
- 表單輸入表面（欄位、選擇器、日曆儲存格）：hover 使用低對比虛線框，focus／selected 使用高對比虛線框。
- 一般按鈕：hover 使用 `selectionWash`，受控的 selected 使用 `interaction` 與 `focusWashOpacity` 組成的持續 wash；兩者不得共用同一視覺強度。
- Primary 按鈕以 `interactionSoft` 作為表面、`interaction` 作為前景，降低按鈕與頁面表面的反差，同時維持文字至少 WCAG AA 4.5:1。
- 其餘按鈕、導覽、選單與可操作資料表面：使用 theme 的背景高亮，不使用互動虛線框。
- 視窗控制按鈕採專用的 shell 語意尺寸，四周保留與 header 等距的 padding，不填滿 header 高度。
- 關閉視窗按鈕 hover／focus 時使用 `danger` 背景與對比前景；其他視窗控制按鈕使用一般背景高亮。
- 裝飾性或結構性的虛線框不受此規則影響。

## Architecture constraints

- 顏色、透明度、圓角與尺寸只能取自 `context.klp`。
- Explorer／表單的虛線顏色仍由 `hoverBorder` 與語意前景色提供，不在元件內寫死。
- 一般互動高亮使用 `selectionWash`；破壞性操作使用既有 `danger` 語意，不新增平行的顏色算法。

## Acceptance criteria

1. 一般視窗控制按鈕 hover 時顯示背景高亮，關閉鈕 hover／focus 時顯示 `danger` 背景。
2. 視窗控制按鈕使用 `windowControlButtonSize`，icon 尺寸不變，且 header 四邊 padding 相同。
3. 一般按鈕與 icon button hover 時不建立 `KlpDashedBorder`。
4. Explorer 與表單既有的低／高對比虛線狀態保持可用。
5. `flutter analyze`、Kallopis 測試與 example 測試全部通過。
