# Flutter package

## FLUTTER-LAYOUT-2（完成）

一般布局接入 [WB-LINEAR-UI-r1](../docs/architecture/workbench-linear-contract.md)，保留現有直接 Flutter API。責任與公開 bounds／divider 契約見 [layout](lib/src/features/workspace/layout/architecture.md)。BUILD write_paths 只含 `flutter/lib/src/features/workspace/layout/klp_app_layout.dart`、`flutter/lib/src/features/workspace/layout/internal/klp_linear_render.dart`；foundation 已匯出主檔，不須更動。architecture、純 geometry helper、tests、FrameGroups、example、Dock、風格檔及配置唯讀。獨立 Test Author 可寫 `flutter/test/workbench_layout_test.dart`。M1 finite geometry／bounds／root inset 接入，M2 natural fallback／protected checks／原公開入口與 Catalog 渲染證據；cold-start 8k–16k tokens／60–120分鐘，參照 FLUTTER-LINEAR-1。超過24k tokens或需要改 Dock／產品 state 回 PLAN。

本 module 為原 Flutter package 的完整機械搬移，擁有 `flutter/`。公開入口及實作責任保持 [library 架構](lib/architecture.md) 與 [實作架構](lib/src/architecture.md)；不引入跨框架 runtime。

## FLUTTER-LINEAR-1（完成）

沿用 [WB-LINEAR-r1](../docs/architecture/workbench-linear-contract.md)，先實作公開有限尺寸解析，下一個 slice 才接入既有直接 Widget。Item／result／函式由 foundation 匯出，具體責任見 layout module。BUILD 只可寫 `flutter/lib/src/features/workspace/layout/klp_linear_layout.dart` 與 `flutter/lib/kallopis_foundation.dart`；architecture、tests、既有 Widget、Dock 與風格資料唯讀。獨立 Test Author 可寫 `flutter/test/linear_layout_test.dart`，保護跨語言尺寸守恆及退化規則。此 slice 的公開 utility 不代表 WB-03 的全部 UI 已完成。

`lib/` 提供 Klp 公開元件與 theme；`assets/` 保有 package 字型、圖示及授權；`test/` 維持原斷言；`example/` 為產品資料投影的 Flutter consumer；`tool/` 產生 inventory／Catalog 與執行既有閘門。指向共通 spec／docs 的工具路徑為 `../spec/`／`../docs/`，docs 網站 extractor 留在 repository 根。

```mermaid
flowchart TD
	Common[共通視覺規範] --> Theme[Flutter semantic theme]
	Theme --> Library[公開 Klp library]
	Assets[package 資產] --> Library
	Library --> Product[Flutter consumer / example]
	Tool[Flutter 專用 tool] --> CommonDocs[根 spec / docs 生成內容]
```

搬移不修改元件行為。分析及 inventory 檢查通過；既有測試中的圖示 hover 與 Catalog 缺項在搬移前後相同，詳見 [整合紀錄](../docs/architecture/multi-framework-verification.md)。

## FLUTTER-STYLE-1（完成）

需求沿用 SP-02／03／04／07。新增 styling/style_pack 純資料解析及 adapter，依其 architecture 公開契約。既有 context.klp 與 ThemeExtensions 繼續供全部元件使用，不新增 environment 或產品 renderer。元件不匯入品牌 pack；框架入口生成預設資料。

BUILD write_paths：`flutter/lib/src/styling/style_pack/**`（architecture 除外）、`flutter/lib/src/styling/legacy_theme/klp_theme.dart`、`flutter/lib/kallopis_theme.dart`、`flutter/tool/generate_style_pack.mjs`、`flutter/README.md`。其他 preset／legacy JSON decoder／tests／example／pubspec 皆唯讀。本 slice 完成公開 pack／theme 接入及跨語言證據；example 全元件與 GUI 接續後續既定 stage。

Test Author 唯一可寫 `flutter/test/style_pack_test.dart`；跨語言風險保護完整四 mode、非法 pack／cycles／constraints、override isolation、現有 theme extension／context scope，以及 metadata。既有 inherited icon hover／Catalog failures 不改斷言規避。估算 8k–15k tokens／60–110 分鐘，M1 parser／generator，M2 Theme adapter／scope。若需要改 preset／legacy JSON schema 或切换全庫默認權威，回整合 PLAN。

實作 `17119f2b`；19 項独立 style pack checks、36 項既有 ThemeExtension／VisualStyle checks、5 項既有 accent／builders checks 通過。公開四模式／350 native 映射與 Theme scope 完整；局部 analyze、generator freshness、scope gate 及受保護 test hash 通過。詳見 style_pack module 的完成證據。未切換正式值權威；recipe 參數及布局保護仍為後續工作。

FLUTTER-LINEAR-1 實作 a8124a62：21 項獨立幾何 checks、公開入口 analyze 及 scope gate 通過；Test Author SHA256 26F406F0C231B0362C2C73760740117771B097C25043DCB8FE484A7D647A653F 未變。既有 Widget／Dock 未改。

FLUTTER-LAYOUT-2 實作 273a0b4f：公開 bounds／divider、Row／Column solver、有限 inset、槽裁切及 unbounded natural fallback 已接入；18 新 Widget checks、4 既有 workspace checks、analyze／scope 通過。既有 Catalog 已實際渲染，視覺接受仍由人類判斷。

## FLUTTER-DOCK-STATE-1（完成）

Dock 保存邊界依 [WB-DOCK-STATE-r1](../docs/architecture/workbench-dock-contract.md)，責任見 [Dock module](lib/src/features/workspace/shell/docking/architecture.md)。新增純 codec／policy／restore diagnostics，保留既有 const model 與受控 UI。write_paths 僅 codec 與 foundation 新增 export；獨立 Test Author 保護保存失敗、identity、跨語言格式與 registry reconciliation。一般布局及 Dock UI 皆唯讀；不把此 slice 宣稱成全部 WB-04～08 完成。

FLUTTER-DOCK-STATE-1 實作69771496：7 protected codec checks、public analyze、scope通過，schema／reconciliation／深層不可變結果完成。React相同wire、Dock互動與style尺寸保護尚未完成。

## FLUTTER-DOCK-OPS-1（完成）

修訂FLUTTER-DOCK-OPS-r1；依共通WB-DOCK-OPS-r1與[Dock module](lib/src/features/workspace/shell/docking/architecture.md)提供typed const action／destination／area／result與applyKlpDockAction。BUILD write_paths只含operations.dart及foundation新export；獨立TestAuthor唯一寫flutter/test/dock_layout_operations_test.dart。既有codec、model、Widget與style不改，原caller保持；新操作保存偏好及受控轉移，UI尺寸與drag接入尚未完成。

FLUTTER-DOCK-OPS-1實作b08d80e6／243d9f98：10獨立checks、publicanalyze No issues、scope通過；protectedhash未變，原codec／model／Widget保留。兩端純操作對齊，仍需Dock UI／style尺寸與產品callback接入。

## FLUTTER-PANEL-GEOMETRY-1（完成）

修訂 FLUTTER-PANEL-GEOMETRY-r1；依 WB-PANEL-GEOMETRY-r1，責任見 panel/architecture.md。有限 PanelFrame chrome 與 margin、內半徑，以及庫 PanelHeader／Footer inset／內容槽，先完成 Dock 壓缩前置。BUILD 僅五個 panel 來源；獨立 TestAuthor 唯一可寫 flutter/test/panel_geometry_test.dart。公開 layout 元件為只讀依賴；theme、Dock、config、tests 不由 worker 修改。default style/constructor 保留，內容 State 不因尺寸與合法 theme 更新丟失。

FLUTTER-PANEL-GEOMETRY-1完成5e18ccd6：finite chrome/margin/inset與slot clip、非負inner radius、title/label viewport；9獨立checks、publicPanelanalyze No issues及5paths scope通過，protectedhash未變。內容Element/State在resize/theme更新保留。Dock保存尺寸直接布局尚待有限viewport/effectivegutter接入。

## FLUTTER-DOCK-GEOMETRY-1（完成）

修訂FLUTTER-DOCK-GEOMETRY-r1；依WB-DOCK-GEOMETRY-r1完成bounded root/groups/actualhandles與resize預算。Dock module contract固定4個來源write_paths，独立TestAuthor擁有flutter/test/dock_geometry_test.dart。只讀既有public linear utility/PanelFrame/theme；不改codec/pureoperations/models/dragcallback/配置與產品state。Public Widget constructor不變，render不回寫保存偏好。

FLUTTER-DOCK-GEOMETRY-1完成296e7cab：root/group有限配額、effectivehandle/resizebudgets/Stage提示、Headerzeroslot/menu与Statecontinuity；13protectedchecks、publicanalyze No issues、4paths scopepass，testhash未變。原保存偏好不回寫。React Dock UI/Flutter受控操作接入仍未完成。

WB-DOCK-PREVIEW-r1 READY：hover僅instance presentation，cancel/end清除，success保留保存extent；Flutter當前PREVIEW-1不改publicAPI、geometry或pureoperations，React native Dock接入時遵循同一生命週期，不在此slice修改React。

FLUTTER-DOCK-PREVIEW-1完成3064c359：hover為局部presentation、cancel/miss不保存、success保留原extent，7preview+13geometry checks/publicanalyze/2paths scope通過。公開constructor未變，pureoperations接入與close metadata仍待接續。

FLUTTER-DOCK-UI-r1 READY：optional Panel isPinned/isDirty/onCloseRequested FutureOr<bool>/closeLabel及全部UI pureOPS commit；欄位由Panel擁有，公開foundation原export已可達無需變更。geometry/preview/codec不可重做。

FLUTTER-DOCK-UI-1完成4ff1c999：全部pointer提交pureOPS／single finalcallback；optional Panel isPinned/isDirty/onCloseRequested/closeLabel、async pending stale/error lifecycle。33 protectedWidgetchecks/publicDockPanelanalyze/scope5paths通過；新metadata尚未nativebrowser example證據，ReactDock/commands/keybindings/GUI/docsregistry/style權威切換未完成。

## FLUTTER-DOCK-EXAMPLE-1（完成）

修訂FLUTTER-DOCK-EXAMPLE-r1。既有example/lib/catalog/docking_layout_page.dart擁有此產品展示資料、Stage輸入、控制器、保存JSON與操作計數；使用穩定foundation入口，不引用src。panels清冊保留原能力、穩定callback，增加pinned/dirty/approve/deny/delay；metadata不進wire。LayoutCodec保存/還原，pureOPS visibility/open/merge，非法JSON保持layout並顯示diagnostics，Stage輸入由產品controller持有並dispose。宿主寬320/760/1040與高180/480由產品選擇，實際宽clamp到Catalog可用寬度；內部Dock配額樣式不複製。

KlpDockHeader specimen文案改為semantic chromeTab與finite viewport，不寫固定32；actions需顯示實際操作結果，不保留空callback。main.dart只允許替Catalog home加Material透明宿主，解決已有browser黃色雙底線的DefaultTextStyle祖先；不得改主題權威或Catalog導航。BUILD write_paths僅此兩example來源；庫/tests/config/generated/architecture及其他module唯讀。

責任清冊：dockingLayoutPage提供兩個公開Widget specimens；_DockLayoutDemo/createState連接產品state；_DockLayoutDemoState擁有_initialLayout/_panels/_policies/JSON與Stagecontrollers/closemode/count/message/width/height；_panel建立內容metadata與stableapprovecallback；dispose释放controllers；_approveClose只讀產品closemode，delay1200ms；_commit比較保存值/計數；_action委派pureOPS；_toggleArea/_clearBottom/_resetLayout/_saveLayout/_restoreLayout/_openPanel/_mergeGroups為產品意圖；build/_controls/_dock/_json組裝有限外部宿主與公開元件。_DockHeaderDemo/State只擁有action回饋；main KallopisCatalogApp與其State保持原生命週期，build只新增Material ancestor。

M1public consumer/analyze/type/2pathscope，M2releaseweb --no-tree-shake-icons與nativebrowser select/save/load/close/resize/有限尺寸；拖放可用時確認，未觀察明示pending，感官human-pending。新測試無必要，既有33Widgetchecks不變，不以snapshot評分。參照React Dock example，cold-start5k–9k tokens/25–50分鐘；12k/70分鐘或需要library改動回PLAN。後续三個GUI×雙框架與全component網頁specimens仍保留完整goal。

```mermaid
flowchart TD
	Catalog[dockingLayoutPage] --> Demo[_DockLayoutDemoState]
	Demo --> Dock[public KlpDockLayout / Panel]
	Demo --> Codec[public LayoutCodec]
	Demo --> OPS[public applyKlpDockAction]
	Dock --> Commit[_commit / product state]
	Commit --> Demo
	Product[stable approval callback] --> Dock
	App[Catalog main Material host] --> Catalog
```

實作39d263e0；2pathscope與兩個example來源analyze No issues。releaseweb保留全部圖示建置成功60.6s，標頭外部loose限制修正後再建置成功52.1s（session3558 exit0）；未改庫/tests/assets/config。nativebrowser tab9/port5192：History選取+Bottom收合2次、deny0次、approve/open/merge各1次；invalidJSON保留，合法還原成功；Stagecontroller在320×180及760×180/1040×480後保留。delayed批准完成1次，pending停用的當下browser狀態未取得，不宣稱該項感官證據。Inspector跨area合併與正文後半split各1次，split保存106+106=(220−8)/2；area220→250沿既有continuous pan產生8次callback，不宣稱整個resize gesture一次提交。新release120寬header呈現更多選單，選設定顯示已執行設定。error/warn空；Material祖先後實際截圖無原黄色雙底線。header hoverpreview/cancel的完整nativebrowser矩陣仍待接續。

| 型別／定義 | 來源 | 責任 |
| --- | --- | --- |
| dockingLayoutPage | [docking_layout_page.dart](example/lib/catalog/docking_layout_page.dart) | 公開Dock/LayoutHeader specimens接入Catalog |
| _DockHeaderDemo／_DockHeaderDemoState | 同上 | createState/build、_width外部120/220限制、_action與overflow回饋 |
| _DockLayoutDemo／_DockLayoutDemoState | 同上 | createState/产品layout、初始groups/policies/controllers与stableclosecallback |
| _approveClose／_panel／dispose | 同上 | 产品批准模式与metadata、有限panel內容、controller释放 |
| _commit／_action／_area／_toggleArea／_clearBottom／_resetLayout | 同上 | publicpure結果採用/計數、area意圖與明確清空展示布局 |
| _saveLayout／_restoreLayout／_openPanel／_mergeGroups | 同上 | schema1資料邊界、错误保留、capability重開、同區合併 |
| _controls／_dock／_json／build | 同上 | 公開元件controls、外部有限宿主与Stage、JSON產品輸入 |
| KallopisCatalogApp／_KallopisCatalogAppState.build | [main.dart](example/lib/main.dart) | 原App/Theme生命週期；本slice只加Material透明祖先 |

## Flutter 命令 core契約（COMPLETE）

依[WB-COMMAND-r1](../docs/architecture/workbench-command-contract.md)，generic KlpCommandDefinition/C與immutable state/result、status/errorphase enums及ChangeNotifier registry由新增lib/src/features/actions/command_registry擁有，stablefoundation公開匯出。pureconditions/nativecontext/ownerdisposer/同tokenpending/typederrors/版本通知與React一致；icon型別沿既有KlpIconData，observer沿FlutterError。既有CommandMenu/WorkspaceCommand/KeyBindingController及產品handlers保持原API，不在core slice改寫。

具體責任及FLUTTER-COMMAND-CORE-r1見[command registry](lib/src/features/actions/command_registry/architecture.md)（COMPLETE）。單一原生來源與stablefoundation匯出；notification中dispose立即語意關閉，原生ChangeNotifier資源收尾延後到最外層通知返回。fresh獨立TestAuthor先保護publiccore，BUILD只寫該來源與foundation，不自行發明共通規則；已交付b2cdee54＋9cffc7e8，24項獨立checks、public analyze與2path/1path scope通過；observer原生解除與subscribe owner已隔離。命令入口及shortcut接入仍待後續stage。

## Flutter registered command入口邊界（READY）

依[WB-COMMAND-ENTRY-r1](../docs/architecture/workbench-command-entry-contract.md)，KlpCommandReference、KlpRegisteredCommandToolbar/Menu將以現有controls／CommandMenu風格呈現同registry資料，產品只給ID/order/kind與getContext/onResult。原CommandMenu models/caller保持原API，沒有新handler或context權威。實作前固定actions command_entries的local architecture與fresh TestAuthor；目前ReactENTRY slice不寫Flutter產品碼。overlay/context menu/palette仍屬已接受stage接續能力，未完成。
