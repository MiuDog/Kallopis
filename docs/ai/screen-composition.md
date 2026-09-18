# 消費端畫面組裝指南

Kallopis 不強迫產品採用固定 Workbench，但畫面拓撲必須由 `kallopis_declarative.dart` 已公開的庫擁有元件組成。Consumer 選擇元件、提供資料與事件、排列受限插槽；不能建立新的 `KlpScreenBody`／component type 或注入 Flutter 呈現。

## 權限劃分

| 角色 | 職責 | 禁止項目 |
| --- | --- | --- |
| Consumer | 選擇已公開元件，提供業務資料、語意 action／intent 與 router | 自訂 node/definition/registry、primitive／preset、Widget、`BuildContext`、局部 style 或 renderer callback |
| Kallopis | 擁有元件 identity、插槽資格、semantic schema、adapter、prepared record、renderer 與生命週期 | 讀取產品 repository/persistence，或要求 consumer 提供原生 view |

## 畫面組裝入口

所有畫面以 `KlpScreen` 宣告；`child` 只能使用 Kallopis 已公開且具 `KlpScreenBody` 資格的元件。第一層區域可使用 `KlpAppLayout`、`LayoutRow`／`LayoutColumn` 與 `KlpAppFrame`，完整契約見 [第一層布局](../../spec/klp-app-layout.md)。預設外距、欄距、Frame 圓角均為 12px。Frame 自身沒有 padding 或陰影，內容元件自行定義語意內距，避免累加兩份 padding。

`KlpAppFrame` 預設為 `KlpAppFrameRole.content`；導覽、工具等輔助區明確指定 `KlpAppFrameRole.auxiliary`。角色表示用途，不表示左右位置。深色預設主內容較亮；consumer 不傳入色值。

```dart
KlpScreen(
	id: scope / 'screen',
	accessibilityLabel: '產品主畫面',
	child: KlpAppFrame(
		id: scope / 'note.frame',
		child: noteContent,
	),
)
```

Frame 內若需要將功能分群，使用 `KlpFrameGroups` 與庫內已公開的群組元件。不要傳入原始距離、顏色或 Flutter `Padding`。

## 平台策略自適應組合

畫面根的分流順序固定為 `KlpScreen → KlpAdaptive → KlpPlatformStrategy.build`。策略可以依 `KlpAdaptiveContext` 選擇不同的已公開 Kallopis 元件樹，但不能回傳 consumer 自訂 component 或接觸 Flutter。

```dart
KlpAdaptive(
	id: scope / 'adaptive',
	fallback: buildTouchLayout(scope),
	strategies: {
		KlpAdaptivePlatform.windows: WindowsHomeStrategy(scope),
		KlpAdaptivePlatform.android: AndroidHomeStrategy(scope),
	},
)
```

完整契約與可複用策略見 [平台策略 Adaptive](adaptive-platform-strategies.md)。若現有元件無法表達必要結構，依 [元件能力與庫內擴充](external-components.md) 提交資料、事件、插槽與平台需求，由 Kallopis 新增完整的庫擁有能力。
