# klp_app.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/application/legacy/klp_app.dart)

## 範圍

核心是 `lib/src/application/legacy/klp_app.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_app.dart"]
	n1["package:flutter/material.dart"]
	n2["../localization/klp_localizations.dart"]
	n3["../../foundation/platform/klp_environment_scope.dart"]
	n4["../../foundation/platform/klp_platform_info.dart"]
	n5["../../foundation/layout/klp_panel_layout.dart"]
	n6["../../foundation/layout/klp_box.dart"]
	n7["../../foundation/layout/klp_column.dart"]
	n8["../../foundation/layout/klp_directional_position.dart"]
	n9["../../foundation/layout/klp_directional_positioned.dart"]
	n10["../../foundation/layout/klp_box_insets.dart"]
	n11["../../foundation/layout/klp_stack.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_app.dart"]
	n1["../../features/overlays/klp_popup.dart"]
	n2["../../features/navigation/legacy_router/klp_router.dart"]
	n3["../../features/workspace/shell/window/klp_window_header.dart"]
	n4["../../features/workspace/shell/window/klp_window_action.dart"]
	n5["../../features/workspace/shell/window/klp_window_header_height.dart"]
	n6["../../styling/legacy_theme/klp_theme.dart"]
	n7["../../styling/legacy_theme/klp_visual_style.dart"]
	n8["../../foundation/interaction/keybinding/klp_key_binding_controller.dart"]
	n9["../../foundation/surface/klp_surface.dart"]
	n10["klp_app_controller.dart"]
	n11["klp_app_scope.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_app.dart"]
	n1["klp_app_controller.dart"]
	n2["klp_app_scope.dart"]
	n3["klp_app_frame.dart"]
	n4["klp_app_state.dart"]
	n0 -->|"export"| n1
	n0 -->|"export"| n2
	n0 -->|"part"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/material.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:1](../../../../../lib/src/application/legacy/klp_app.dart#L1) |
| import | <code>import &#x27;../localization/klp_localizations.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:3](../../../../../lib/src/application/legacy/klp_app.dart#L3) |
| import | <code>import &#x27;../../foundation/platform/klp_environment_scope.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:4](../../../../../lib/src/application/legacy/klp_app.dart#L4) |
| import | <code>import &#x27;../../foundation/platform/klp_platform_info.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:5](../../../../../lib/src/application/legacy/klp_app.dart#L5) |
| import | <code>import &#x27;../../foundation/layout/klp_panel_layout.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:6](../../../../../lib/src/application/legacy/klp_app.dart#L6) |
| import | <code>import &#x27;../../foundation/layout/klp_box.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:7](../../../../../lib/src/application/legacy/klp_app.dart#L7) |
| import | <code>import &#x27;../../foundation/layout/klp_column.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:8](../../../../../lib/src/application/legacy/klp_app.dart#L8) |
| import | <code>import &#x27;../../foundation/layout/klp_directional_position.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:9](../../../../../lib/src/application/legacy/klp_app.dart#L9) |
| import | <code>import &#x27;../../foundation/layout/klp_directional_positioned.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:10](../../../../../lib/src/application/legacy/klp_app.dart#L10) |
| import | <code>import &#x27;../../foundation/layout/klp_box_insets.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:11](../../../../../lib/src/application/legacy/klp_app.dart#L11) |
| import | <code>import &#x27;../../foundation/layout/klp_stack.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:12](../../../../../lib/src/application/legacy/klp_app.dart#L12) |
| import | <code>import &#x27;../../features/overlays/klp_popup.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:13](../../../../../lib/src/application/legacy/klp_app.dart#L13) |
| import | <code>import &#x27;../../features/navigation/legacy_router/klp_router.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:14](../../../../../lib/src/application/legacy/klp_app.dart#L14) |
| import | <code>import &#x27;../../features/workspace/shell/window/klp_window_header.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:15](../../../../../lib/src/application/legacy/klp_app.dart#L15) |
| import | <code>import &#x27;../../features/workspace/shell/window/klp_window_action.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:16](../../../../../lib/src/application/legacy/klp_app.dart#L16) |
| import | <code>import &#x27;../../features/workspace/shell/window/klp_window_header_height.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:17](../../../../../lib/src/application/legacy/klp_app.dart#L17) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_theme.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:18](../../../../../lib/src/application/legacy/klp_app.dart#L18) |
| import | <code>import &#x27;../../styling/legacy_theme/klp_visual_style.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:19](../../../../../lib/src/application/legacy/klp_app.dart#L19) |
| import | <code>import &#x27;../../foundation/interaction/keybinding/klp_key_binding_controller.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:20](../../../../../lib/src/application/legacy/klp_app.dart#L20) |
| import | <code>import &#x27;../../foundation/surface/klp_surface.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:21](../../../../../lib/src/application/legacy/klp_app.dart#L21) |
| import | <code>import &#x27;klp_app_controller.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:22](../../../../../lib/src/application/legacy/klp_app.dart#L22) |
| import | <code>import &#x27;klp_app_scope.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:23](../../../../../lib/src/application/legacy/klp_app.dart#L23) |
| export | <code>export &#x27;klp_app_controller.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:25](../../../../../lib/src/application/legacy/klp_app.dart#L25) |
| export | <code>export &#x27;klp_app_scope.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:26](../../../../../lib/src/application/legacy/klp_app.dart#L26) |
| part | <code>part &#x27;klp_app_frame.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:28](../../../../../lib/src/application/legacy/klp_app.dart#L28) |
| part | <code>part &#x27;klp_app_state.dart&#x27;;</code> | [lib/src/application/legacy/klp_app.dart:29](../../../../../lib/src/application/legacy/klp_app.dart#L29) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpApp"]
```

```mermaid
classDiagram
	class n0["KlpApp"]
	class n1["StatefulWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpApp

ClassDeclaration · public · [lib/src/application/legacy/klp_app.dart:31](../../../../../lib/src/application/legacy/klp_app.dart#L31)

<code>class KlpApp extends StatefulWidget</code>

來源註解摘要：`MaterialApp` 的接入層，收掉每個消費者都得自己組一次的樣板。 沒有它時，消費者要自己：套 `buildKlpTheme` 的亮／暗兩份 `ThemeData`、記得把 `themeAnimationDuration` 歸零（否則主題切換的動畫中途會有半數幀停在舊值上， 見 README「深淺切換不做過場」）、決定明暗狀態放哪裡並手刻切換入口、如果用了 [KlpRouter] 還要自己架 [KlpRouterScope]。這些細節不涉及任何產品語意，每個 `-ist` 產品各刻一次只會讓實作各自漂移——因此收進庫。 ## 最小用法 ```dart KlpApp( home: KlpPanelFrame(content: const MyHomePage()), ) ``` ## 搭配 router 給了 [router] 但沒給 [home] 時，自動以 [KlpRouterOutlet] 當作首頁； 兩者都給時，[home] 仍會被包在 [KlpRouterScope] 之下，因此 [home] 的子樹 裡任何位置都能用 `context.klpRouter`（[KlpRouterOutlet] 放在哪一層由消費者 自己決定）。 ```dart KlpApp( router: KlpRouter( routes: [ KlpRoute( id: &#x27;home&#x27;, builder: (_) =&gt; KlpPanelFrame(content: const HomePage()), ), ], initialId: &#x27;home&#x27;, ), ) ``` ## 切換明暗 ```

- `extends` → <code>StatefulWidget</code>：[lib/src/application/legacy/klp_app.dart:78](../../../../../lib/src/application/legacy/klp_app.dart#L78)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpApp</code> | public | <code>const KlpApp({ super.key, this.style = KlpVisualStyle.defaultStyle, this.lightStyle, this.darkStyle, this.initialThemeMode = ThemeMode.light, this.keyBindingController, this.router, this.home, this.popup, this.title = &#x27;&#x27;, this.appIcon, this.showWindowHeader = true, this.headerActions, this.windowHeader, this.onMinimize, this.onToggleMaximize, this.onClose, this.isMaximized = false, this.showWindowControls = true, this.startMaximized = true, this.minWidth, this.minHeight, this.locale, this.localizationsDelegates, this.supportedLocales = const &lt;Locale&gt;[Locale(&#x27;en&#x27;, &#x27;US&#x27;)], this.builder, this.debugShowCheckedModeBanner = true, })</code> |  | [lib/src/application/legacy/klp_app.dart:79](../../../../../lib/src/application/legacy/klp_app.dart#L79) |
| field <code>style</code> | public | <code>final KlpVisualStyle style</code> | 向後相容的共用風格基底；未提供對應的完整風格時，色彩仍隨明暗套用內建值。 | [lib/src/application/legacy/klp_app.dart:111](../../../../../lib/src/application/legacy/klp_app.dart#L111) |
| field <code>lightStyle</code> | public | <code>final KlpVisualStyle? lightStyle</code> | 淺色模式的完整視覺風格；提供後不會被 [style] 或內建色彩改寫。 | [lib/src/application/legacy/klp_app.dart:114](../../../../../lib/src/application/legacy/klp_app.dart#L114) |
| field <code>darkStyle</code> | public | <code>final KlpVisualStyle? darkStyle</code> | 深色模式的完整視覺風格；提供後不會被 [style] 或內建色彩改寫。 | [lib/src/application/legacy/klp_app.dart:117](../../../../../lib/src/application/legacy/klp_app.dart#L117) |
| field <code>initialThemeMode</code> | public | <code>final ThemeMode initialThemeMode</code> | 啟動時的明暗狀態。 | [lib/src/application/legacy/klp_app.dart:120](../../../../../lib/src/application/legacy/klp_app.dart#L120) |
| field <code>keyBindingController</code> | public | <code>final KlpKeyBindingController? keyBindingController</code> | 可選的快捷鍵 controller；未提供時由 [KlpApp] 建立並管理生命週期。 | [lib/src/application/legacy/klp_app.dart:123](../../../../../lib/src/application/legacy/klp_app.dart#L123) |
| field <code>router</code> | public | <code>final KlpRouter? router</code> | 選擇性的分發器。給了就自動架好 [KlpRouterScope]，見類別 dartdoc。 | [lib/src/application/legacy/klp_app.dart:126](../../../../../lib/src/application/legacy/klp_app.dart#L126) |
| field <code>home</code> | public | <code>final KlpPanelLayout? home</code> | 首頁內容。[router] 存在且這裡未給值時，退回 [KlpRouterOutlet]。 | [lib/src/application/legacy/klp_app.dart:129](../../../../../lib/src/application/legacy/klp_app.dart#L129) |
| field <code>popup</code> | public | <code>final KlpPopupBackground? popup</code> | 選擇性的 App 層 popup；顯示時仍會讓視窗標題列保有拖動與雙擊優先權。 | [lib/src/application/legacy/klp_app.dart:132](../../../../../lib/src/application/legacy/klp_app.dart#L132) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/application/legacy/klp_app.dart:134](../../../../../lib/src/application/legacy/klp_app.dart#L134) |
| field <code>appIcon</code> | public | <code>final Widget? appIcon</code> | 應用程式圖示內容；標題列尺寸由目前 [style] 的 shell geometry 決定。 | [lib/src/application/legacy/klp_app.dart:137](../../../../../lib/src/application/legacy/klp_app.dart#L137) |
| field <code>showWindowHeader</code> | public | <code>final bool showWindowHeader</code> | 是否顯示自帶的頂部視窗標題列（預設為 true）。 | [lib/src/application/legacy/klp_app.dart:140](../../../../../lib/src/application/legacy/klp_app.dart#L140) |
| field <code>headerActions</code> | public | <code>final List&lt;Widget&gt;? headerActions</code> | 標題列頂部自訂快捷按鈕。 | [lib/src/application/legacy/klp_app.dart:143](../../../../../lib/src/application/legacy/klp_app.dart#L143) |
| field <code>windowHeader</code> | public | <code>final Widget? windowHeader</code> | 完全自訂的視窗標題列 Widget（提供時覆蓋預設產生的 [KlpWindowHeader]）。 | [lib/src/application/legacy/klp_app.dart:146](../../../../../lib/src/application/legacy/klp_app.dart#L146) |
| field <code>onMinimize</code> | public | <code>final VoidCallback? onMinimize</code> | 視窗最小化回呼。 | [lib/src/application/legacy/klp_app.dart:149](../../../../../lib/src/application/legacy/klp_app.dart#L149) |
| field <code>onToggleMaximize</code> | public | <code>final VoidCallback? onToggleMaximize</code> | 視窗最大化／還原回呼。 | [lib/src/application/legacy/klp_app.dart:152](../../../../../lib/src/application/legacy/klp_app.dart#L152) |
| field <code>onClose</code> | public | <code>final VoidCallback? onClose</code> | 視窗關閉回呼。 | [lib/src/application/legacy/klp_app.dart:155](../../../../../lib/src/application/legacy/klp_app.dart#L155) |
| field <code>isMaximized</code> | public | <code>final bool isMaximized</code> | 視窗是否處於最大化狀態。 | [lib/src/application/legacy/klp_app.dart:158](../../../../../lib/src/application/legacy/klp_app.dart#L158) |
| field <code>showWindowControls</code> | public | <code>final bool showWindowControls</code> | 是否在標題列展示視窗管理控制鈕。 | [lib/src/application/legacy/klp_app.dart:161](../../../../../lib/src/application/legacy/klp_app.dart#L161) |
| field <code>startMaximized</code> | public | <code>final bool startMaximized</code> | 是否在首次建立時確保原生視窗最大化；已最大化時不會切換回視窗化。 | [lib/src/application/legacy/klp_app.dart:164](../../../../../lib/src/application/legacy/klp_app.dart#L164) |
| field <code>minWidth</code> | public | <code>final double? minWidth</code> | 視窗最小允許寬度（邏輯像素）。 | [lib/src/application/legacy/klp_app.dart:167](../../../../../lib/src/application/legacy/klp_app.dart#L167) |
| field <code>minHeight</code> | public | <code>final double? minHeight</code> | 視窗最小允許高度（邏輯像素）。 | [lib/src/application/legacy/klp_app.dart:170](../../../../../lib/src/application/legacy/klp_app.dart#L170) |
| field <code>locale</code> | public | <code>final Locale? locale</code> |  | [lib/src/application/legacy/klp_app.dart:172](../../../../../lib/src/application/legacy/klp_app.dart#L172) |
| field <code>localizationsDelegates</code> | public | <code>final Iterable&lt;LocalizationsDelegate&lt;dynamic&gt;&gt;? localizationsDelegates</code> | 額外的 localization delegate。[KlpApp] 會把這些 delegate 排在內建預設值前面， 因此消費者提供的 [KlpLocalizationsDelegate] 會優先覆寫預設字串；其他資源型別也會合併載入。 | [lib/src/application/legacy/klp_app.dart:176](../../../../../lib/src/application/legacy/klp_app.dart#L176) |
| field <code>supportedLocales</code> | public | <code>final Iterable&lt;Locale&gt; supportedLocales</code> |  | [lib/src/application/legacy/klp_app.dart:177](../../../../../lib/src/application/legacy/klp_app.dart#L177) |
| field <code>builder</code> | public | <code>final TransitionBuilder? builder</code> |  | [lib/src/application/legacy/klp_app.dart:178](../../../../../lib/src/application/legacy/klp_app.dart#L178) |
| field <code>debugShowCheckedModeBanner</code> | public | <code>final bool debugShowCheckedModeBanner</code> |  | [lib/src/application/legacy/klp_app.dart:179](../../../../../lib/src/application/legacy/klp_app.dart#L179) |
| method <code>of</code> | public | <code>static KlpAppController of(BuildContext context)</code> | 取得目前的 [KlpAppController]，通常用來切換明暗。 呼叫端會在 [brightness] 或 [themeMode] 改變時自動重建——這是 `InheritedWidget` 的標準行為，不需要另外訂閱。 | [lib/src/application/legacy/klp_app.dart:181](../../../../../lib/src/application/legacy/klp_app.dart#L181) |
| method <code>createState</code> | public | <code>State&lt;KlpApp&gt; createState()</code> |  | [lib/src/application/legacy/klp_app.dart:193](../../../../../lib/src/application/legacy/klp_app.dart#L193) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
