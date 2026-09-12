# 風格 v1.0.0 使用方式

顏色、padding、圓角與陰影以 [正式規格](../../spec/style-v1.md) 為準。本版不更動其他尺寸，也不等同完整畫面定型。

## 工作區配方

`KlpWorkspacePreset.light()` 與 `.dark()` 預設暖灰；`KlpWorkspacePreset.styleVersion` 為 `1.0.0`。使用者選擇中性色調時，在 Application 組合根替換整套原料：

```dart
final primitives = KlpWorkspacePreset.light(tone: KlpWorkspaceTone.neutral);
```

沿用 `KlpApplication.primitives` 唯一注入來源，不在產品端重寫 widget 顏色。明暗選擇不由紙張材質推定。

## 可選紙片陰影

`KlpSurfaceTemplate.shadow` 可接受 `KlpSurfaceShadowSemantics(color: shadowColor, scale: shadowScale)`，兩者必須是所屬定義可讀取的 semantic key。顏色可映射 color i6，尺度映射 distance i3；暖灰配方下分別為黑色 alpha34 與 12px。

`shadow: null` 保持平面。使用者的微浮偏好由應用選用有陰影或無陰影的元件定義，再循現有 Application／registry 重建流程更新；不是 renderer 讀取全域變數。切換時保持元件的其他語意與內容一致。

不要讓 Frame 或 Rail 取得紙片陰影。Surface 只有明確屬於獨立內容物件時才選用；既有未宣告陰影的 Surface 保持平整。此能力不自動生成紙色、紋理、便利貼或筆記畫面。

## 相容入口

Legacy 預設 light／dark 色彩、shape 與 surface 配方同步採新風格。Surface 新增接觸陰影與陰影色欄位，JSON 可完整保存；`separation` 不使用 shadow 時回傳空陰影。既有 UltraDark、透明模式及品牌／狀態語意維持相容政策，不視為本輪新設計。
