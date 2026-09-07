# Kallopis 消費端客製化責任樹

本文件描述消費產品從 `KlpApp` 往下需要提供的資料、狀態與事件。Kallopis
只提供無產品語意的視覺、Panel Tree、平台資訊與互動基礎設施；產品命令、資料模型
與保存責任留在消費端。

```text
KlpApp
├── style / theme mode
│   └── 消費端：品牌色、產品字體或幾何覆寫（只在規格允許的 token 範圍）
├── keyBindingController
│   └── 消費端：註冊 app 層級命令與快捷鍵
├── router
│   └── 消費端：page id、路由表、頁面生命週期與導航狀態
├── window header
│   └── 消費端：產品標題、圖示、標題列 action、視窗 callback
└── home : KlpPanelLayout
    └── KlpPanelLayout
        ├── KlpAdaptive（只有平台呈現不同的區域才使用）
        │   ├── Windows view
        │   ├── Android view
        │   └── other platform view
        ├── KlpPanelFrame
        │   └── 消費端：panel identity、標題、內容與 panel action
        ├── KlpDockLayout
        │   └── 消費端：panel registry、dock layout state、allow side/bottom、active tab
        ├── KlpNavigationRailFrame
        │   └── 消費端：rail data model、selected item、reorder event
        ├── KlpKeyBindingRegion
        │   └── 消費端：region id、page id、region 命令註冊
        └── page content
            ├── Explorer container
            │   ├── 消費端：Explorer data model、selection、filter、sort
            │   └── 事件：open、select、rename、delete、reorder
            ├── Stage container
            │   ├── 消費端：目前 page/document model、editing state
            │   └── 事件：edit、save、undo、redo、close
            ├── Rail container
            │   ├── 消費端：Rail entry model、badge、selected state
            │   └── 事件：activate、reorder、context action
            └── product widgets
                └── 消費端：資料轉換、狀態機、錯誤／空狀態與保存流程
```

## Keybinding 消費方式

消費端從 `KlpApp.of(context).keyBindings` 取得 controller，命令使用穩定字串識別，
不直接把產品 callback 寫進 Kallopis 元件：

```dart
final unregister = KlpApp.of(context).keyBindings.register(
	 binding: const KlpKeyBinding(
		 commandId: 'explorer.delete',
		 activator: SingleActivator(LogicalKeyboardKey.delete),
		 scope: KlpKeyBindingScope.region,
		 scopeId: 'explorer',
	 ),
	 action: controller.deleteSelected,
);
```

Explorer、Stage 或 Rail 的根節點以 `KlpKeyBindingRegion` 包裝，點擊或取得焦點時
啟用該 region：

```dart
KlpKeyBindingRegion(
	 controller: KlpApp.of(context).keyBindings,
	 regionId: 'explorer',
	 pageId: 'notes',
	 child: explorer,
)
```

解析優先序固定為：

```text
component → region → page → app
```

沒有命中較窄 scope 時才回退到上層。Kallopis 不定義 `note.create`、`page.save` 等
產品命令名稱；這些名稱與其資料、權限、保存及錯誤處理均由消費端擁有。

## 不應由消費端重複實作

- 不在每個元件呼叫 `HardwareKeyboard.addHandler`。
- 不在 Kallopis 內放入 Note、Explorer、Stage 等產品資料模型。
- 不以視窗寬度推導平台；平台差異使用 `KlpAdaptive` 與 `KlpAppScope` 的平台資訊。
- 不繞過 `KlpPanelLayout` 直接在 App root 建立未受規範的自由 layout。
