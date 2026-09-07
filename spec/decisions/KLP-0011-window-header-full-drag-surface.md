# KLP-0011：App Header 全表面拖動視窗

- 狀態：Accepted
- 日期：2026-09-04

## 決策

`KlpWindowHeader` 的完整占位範圍（包含 Header 自身 margin）都必須參與平台視窗
拖動。最外層 Header 手勢層接收 pan start 並呼叫 `KlpWindowAction.drag()`；內部按鈕、
選單與其他操作元件仍保留 tap 與語意事件，不得以吸收事件的覆蓋層實作。

Header 的雙擊最大化維持在 identity 與空白等非互動區域，避免雙擊操作按鈕時意外
切換視窗大小。

## 理由

App Header 應沿用 heading 全區可拖動的操作定義，只是拖動目標從 Dock panel 改為
作業系統視窗。由父層參與 gesture arena，可讓拖動與子元件點擊共存。

## 影響

- Windows、Linux 與 macOS Header 使用相同全表面 pan 行為。
- identity、空白、leading、actions、trailing 與視窗控制區都可作為拖動起點。
- 一般點擊仍由最接近的互動子元件處理。

## 邊界

- 本規則只適用 App Window Header，不改變 Dock Header 的 panel 拖放資料。
- Header 自身 margin 屬於拖動範圍；更外層 AppFrame padding 不屬於 Header，因此
  不是拖動範圍。
- 平台通道錯誤沿用現有容錯，不能使 App 崩潰。

## 閘門

- Header 最外層必須覆蓋完整可視表面的 pan gesture。
- 不得以 Positioned overlay 遮住 Header 子元件。
- 子元件 tap 與 accessibility semantics 必須保留。
- 雙擊 maximize 不得提升到互動按鈕之上。
