# KlpNavigator 組裝指南

Sidebar 的一般導覽內容統一使用 `KlpNavigator`。AI 與消費產品只能建立三種具體
資料模型：Category、Element、Component。

```dart
KlpNavigator(
	items: [
		const KlpNavigatorComponent(
			id: 'search',
			child: KlpTextField(placeholder: '搜尋'),
		),
		const KlpNavigatorElement(
			id: 'overview',
			label: 'Overview',
			icon: KlpIcons.grid,
		),
		const KlpNavigatorCategory(
			id: 'documents',
			label: 'Documents',
			items: [
				KlpNavigatorElement(
					id: 'design-system',
					label: 'Design System',
					children: [
						KlpNavigatorElement(id: 'tokens', label: 'Tokens'),
					],
				),
			],
		),
	],
)
```

## 三種模型

- `KlpNavigatorCategory`：可折疊列表，只負責組織項目。
- `KlpNavigatorElement`：可選取、可巢狀；可在根層或 Category 內出現。
- `KlpNavigatorComponent`：任意 Widget 插槽，適合搜尋框、虛線分隔線、按鈕列表。

Category 與 Element 的高度不可由產品覆寫。Component 不接受 Navigator 固定高度，
所需 padding 與高度由被注入元件自己決定。產品持有資料、受控狀態與事件；
Kallopis 持有視覺、縮排、hover、selected 與折疊呈現。
