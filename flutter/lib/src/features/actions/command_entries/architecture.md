# Registered command入口

FLUTTER-COMMAND-ENTRY-r1 COMPLETE，依[共同WB-COMMAND-ENTRY-r1](../../../../../../docs/architecture/workbench-command-entry-contract.md)。當前只交付直接原生toolbar/平面menu；popup／shortcut仍待接續，palette已完成，既有CommandMenu/WorkspaceCommand caller不變。

## 責任及公開契約

單一`klp_command_entries.dart`擁有enum `KlpCommandKind { action, toggle }`、immutable `KlpCommandReference`（const、required commandId、kind缺省action）及兩個generic原生Widgets。stablefoundation匯出新來源。

共同Widget參數registry:KlpCommandRegistry<C>、getContext:C Function()、items:List<KlpCommandReference>、label:String、onResult:ValueChanged<KlpCommandExecutionResult>必填，key可選。Menu另emptyLabel:String必填、autoFocus:bool=false、onDismiss:VoidCallback?。可const建構；build前以ArgumentError驗證字串非空白及同入口duplicate ID，不依assert。

private共享host持registry subscription disposer/generation、root及每ID FocusNode、當前focus ID，沒有context/handler/pending鏡像。init訂閱，didUpdateWidget更換registry先解除訂閱並提升generation，dispose解除訂閱/FocusNode並隔離舊結果。query每次讀getContext一次後依items順序getState；activation再次讀最新getContext並execute ID。samehost/sameregistry完成交當前onResult；context/callback異常交FlutterError，不合成業務結果。disposed registry不訂閱、不query。

toolbar左右/menu上下、Home/End在可用項循環；Enter/Space KeyDown啟動且handled，KeyRepeat不啟動；Escape只menu onDismiss。每ID原生Focus roving skipTraversal；停用/running不能requestFocus。Menu mount/registry replacement且autoFocus=true時postframe聚焦首可用項或空root；false不偷焦點。清冊更新保留存在ID FocusNode，移除node安全收尾。

row重用KlpText/KlpIcon/KlpPressable及context.klp；Semantics label/button/enabled/focus及toggle checked，action checked null，icon裝飾不重複語音。外層Focus/語意擁有鍵盤與activation，排除Pressable內部重複focus/semantics。menu沿既有recipe width/radius/itemHeight/padding/gap，有限垂直scroll與文字裁切；toolbar換行。hover/checked同semantic wash，無新palette/default。風格/尺寸不改ID或權限。

採薄row投影而不修改舊CommandMenu模型：舊模型缺icon/action-toggle區分，修改會改caller相容性。沒有新renderer/node/adapter，沒有第二份命令狀態；舊controls/theme/core/config/tests唯讀。

## slice及證據

FLUTTER-COMMAND-ENTRY-1只寫新來源及`flutter/lib/kallopis_foundation.dart`，本檔/rootarch唯讀。fresh TestAuthor只`flutter/test/registered_command_entries_test.dart`：public Widgets/core共享metadata/gates/order/toggle、pending/latestcallback/stale、keyboard/empty/autofocus/validation/finitehost。不得測privateState或pixel。public analyze、同hash checks、2path scope必要；browser/human-pending另記。

cold-start6k–12k tokens／30–60分鐘，參照REACT-COMMAND-ENTRY-1／FLUTTER-DOCK-UI-1；Flutter3.44.2已有packageconfig，不改config。M1metadata/query/dispatch（4k/20分鐘），M2lifecycle/Focus/finitehost/checks（10k/50分鐘）；15k/75分鐘或core/public契約變更回PLAN。

```mermaid
flowchart TD
	Product[ID / context / result] --> Toolbar[KlpRegisteredCommandToolbar]
	Product --> Menu[KlpRegisteredCommandMenu]
	Toolbar --> Host[private native host / focus lifecycle]
	Menu --> Host
	Host --> Registry[public KlpCommandRegistry]
	Host --> Row[KlpText / Icon / Pressable / semantic theme]
	Row --> Execute[ID / latest context]
	Execute --> Registry
	Registry --> Result[current same host callback]
```

原生焦點/scroll依[Flutter Focus](https://docs.flutter.dev/ui/interactivity/focus)及[SingleChildScrollView](https://api.flutter.dev/flutter/widgets/SingleChildScrollView-class.html)。row的hover/focus/checked背景由同context.klp.selectionWash解析；Pressable只提供pointer，hoverHighlight=false/selected=false，避免既有selectedWash混入不同色。這是新row內部呈現責任，舊Pressable不改。

## 完成證據及定義索引

23項public Widget/lifecycle checks、public analyze No issues、兩path scope通過。fresh TestAuthor3a3f2004原API missing compile Yellow；初跑10pass/11fail主要SemanticsHandle清理時機，authora4951f51以body try/finally修正；120bd313補Future完成後第二原生frame flush及兩callback錯誤case，未弱化原assertions。最終SHA256 4DC377CC7612B91719BDEEC6472B30D47722C225702788C923F48B2545F80189，BUILD重跑23Green且hash不變。原5個analyzer flow-control lint已在新來源修正，未改config/core/controls/theme。browser/感官及全參數style audit仍待後續stage。

所有下列定義位於[klp_command_entries.dart](klp_command_entries.dart)。

| 定義 | 責任與方法 |
| --- | --- |
| KlpCommandKind／KlpCommandReference | action/toggle語意與const ID引用 |
| KlpRegisteredCommandToolbar／KlpRegisteredCommandMenu | public原生參數、build委派同host |
| _CommandRowData | reference/state本次投影，enabled派生pending gate |
| _CommandEntryHost | 共用原生Widget輸入、createState |
| _CommandEntryHostState | initState/didUpdateWidget/dispose生命週期；_subscribe/_refresh訂閱；_scheduleAutofocus/focusAfterBuild掛載焦點；_activeId/_focus可用索引；_syncNodes/releaseAfterBuild安全釋放 |
| _CommandEntryHostState執行與呈現 | _activate/_isCurrent/_report原值/舊宿主/error通道；_key鍵盤；_validate/text字串與重複ID；_row/focusChanged原生Focus；build本次query及finite scroll/wrap |
| _RegisteredCommandRow | 新row呈現輸入、createState |
| _RegisteredCommandRowState | hovered視覺生命週期；build讀semantic與KlpText/Icon/Pressable及Semantics |

```mermaid
classDiagram
	KlpRegisteredCommandToolbar --> _CommandEntryHost : 原生組合
	KlpRegisteredCommandMenu --> _CommandEntryHost : 原生組合
	_CommandEntryHost --> _CommandEntryHostState : createState
	_CommandEntryHostState --> KlpCommandRegistry : 訂閱及ID執行
	_CommandEntryHostState "1" *-- "0..*" FocusNode : 原生生命週期
	_CommandEntryHostState --> _CommandRowData : 本次投影
	_CommandRowData --> KlpCommandReference : caller引用
	_CommandEntryHostState --> _RegisteredCommandRow : 薄視覺組合
	_RegisteredCommandRow --> _RegisteredCommandRowState : createState
```


## FLUTTER-COMMAND-ENTRY-GEOMETRY-1（READY）

修訂FLUTTER-COMMAND-ENTRY-GEOMETRY-r1，依[共同有限入口](../../../../../../docs/architecture/workbench-command-entry-geometry-contract.md)。public Widget／reference／coreAPI保持。當前source的menu外tight padding、row raw insets／iconSmall／gap尚未依有限槽縮配，需在重用menu的popup之前補保護；不以外層clip忽略內部RenderFlex overflow。

共享host build／row build持原責任，原生LayoutBuilder只供有限presentation budget；新的private有限值／比例padding解析可在同source，無新公開model／theme。menu actualwidth=min偏好及有限槽，outerpadding受短邊限制；row水平insets比例縮配、icon及gap按剩餘分配，labelFlexible／ellipsis保持。自然方向仍自然，height content仍scroll；subscription／generation／ID FocusNode／activation／pending及語意角色不改。

BUILD只klp_command_entries.dart。fresh TestAuthor只flutter/test/registered_command_entry_geometry_test.dart，原registered_command_entries_test.dart及其他tests／theme／core／palette／config／consumer／arch唯讀。M1新公開finite检查＋原23同hash（4k／25分鐘），M2publicanalyze／scope1及nativebrowser正常入口（7k／45分鐘）；cold-start4k～8k tokens／25～50分鐘，參照FLUTTER-PANEL-GEOMETRY-1／FLUTTER-COMMAND-ENTRY-1；12k／70分鐘或需要其他source回PLAN。browser極端style與全部參數audit另pending；感官human-pending。
