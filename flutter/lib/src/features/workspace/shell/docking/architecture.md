# Flutter Dock

修訂 `FLUTTER-DOCK-UI-r1`；PLAN READY。擁有此 docking 目錄；公開入口由 foundation 匯出。保留直接 KlpDockLayout／Panel／Area／Group；不引入通用 node tree、renderer 或產品 storage。

## 當前 slice FLUTTER-DOCK-OPS-1（完成）

依共通 WB-DOCK-OPS-r1，公開 applyKlpDockAction({required KlpDockLayoutData layout, required List<KlpDockPanelPolicy> panels, required KlpDockAction action}) → KlpDockActionResult（layout／changed），由 foundation 匯出。保留全部原 const model／Widget API，純操作不認識產品內容、theme 或 storage。

公開 enum KlpDockArea 為 left／right／bottom。const KlpDockDestination.tab({required area, required String groupId, required int index})、.group（同欄位加 required double extent）擁有 readonly area／groupId／index／nullable extent／createsGroup。const KlpDockAction 的 named constructors：select({required panelId})、move／open({required panelId, required destination})、merge({required sourceGroupId, required targetGroupId, required int index})、close({required panelId, required bool approved})、visibility({required area, required bool isVisible})、resizeArea({required area, required double extent})、resizeGroup({required groupId, required double extent})。所有identity為String、area為KlpDockArea、destination為KlpDockDestination；Action私有tag／payload由typed constructors維持合法形狀，不提供JSON action parser或通用Widget schema。index為int，extent在apply驗證finite／range；constructor不以assert阻止負數，以便在operation邊界用FormatException明確拒絕。new group id依操作前全域groups檢查，index依移除source後列表長度驗證。

來源 klp_dock_layout_operations.dart 擁有 typed action／destination及單步操作；使用現有 codec.encode／restore 驗證目前與結果，不複製保存parser。working collections必為自己的lists；最後用codec產生深層immutable快照。非法目前layout、缺清冊、capability、unknownpanel/group、identity、index或extent全部FormatException；close false合法no-op；pure action不執行關閉callback，UI必先交產品批准。resize只是偏好尺寸，不替代UI finite constraints。

BUILD僅write flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_operations.dart、flutter/lib/kallopis_foundation.dart新增export；architecture、所有tests、codec／model／Widget／theme／style／example／config及其他module唯讀。TestAuthor唯一可寫flutter/test/dock_layout_operations_test.dart，採React operations test同一初始layout及成功／拒絕情境；typed Dart不能表示錯誤primitive類型，不用compile failures冒充behaviorRed。

M1 tabs／groups／close／visibility及atomic rejection，M2 resizepreferences／immutable／publicanalyze／scope。cold-start5k–9k tokens／40–70分鐘，參照REACT-DOCK-OPS-1；12k tokens／90分鐘或需要改現有codec／Widget回PLAN。根module擁有publicexport，細節責任在此module；GUI與Dock尺寸保護接續同一Workbench stage。

```mermaid
flowchart TD
	UI[產品或UI提交] --> Action[KlpDockAction / Destination]
	Action --> Apply[applyKlpDockAction]
	Apply --> Codec[既有encode / restore]
	Apply --> Working[owned working lists / action]
	Working --> Codec
	Codec --> Result[immutable layout / changed]
	Result --> UI
```

## 已完成 slice FLUTTER-DOCK-STATE-1

依 [WB-DOCK-STATE-r1](../../../../../../../docs/architecture/workbench-dock-contract.md) 完成 JSON 保存／載入／registry reconciliation。BUILD 僅可寫 `flutter/lib/src/features/workspace/shell/docking/klp_dock_layout_codec.dart` 與 `flutter/lib/kallopis_foundation.dart` 的新增 export。既有模型、Widget、私有拖放算法、theme、style、example、config、architecture、tests 唯讀。Test Author 唯一可寫 `flutter/test/dock_layout_codec_test.dart`。

codec 擁有外部資料驗證及 immutable snapshot；既有 model 繼續擁有原 caller 的 const／copyWith API。policy 是產品 registry 的資料投影，不持有 Widget；result 擁有 reconciliation 診斷。方法：encode 驗證 model → wire；restore 驗證 wire／policy → 過濾 missing → immutable model／diagnostics。錯誤由 FormatException 暴露；不捕捉錯誤假裝成功、不自動更新產品 state。

替代方案直接替既有 model 加 storage 與 registry：會改變 const caller 及 UI 責任，因此採獨立 codec。codec 只依 dart:convert、Flutter Axis 及既有公開 model；無 filesystem、network、theme 或 private state dependency。

```mermaid
flowchart TD
	Product[產品 registry / 保存策略] --> Policy[KlpDockPanelPolicy]
	Product --> Codec[KlpDockLayoutCodec]
	Policy --> Codec
	Wire[版本化 JSON] --> Codec
	Codec --> Result[KlpDockRestoreResult]
	Result --> Model[既有 KlpDockLayoutData]
	Model --> UI[既有受控 KlpDockLayout]
	Model --> Codec
```

M1 完整 schema／encode／restore：手寫 JSON 與拒絕證據；M2 reconciliation／immutable／公開入口：獨立 checks、analyze、scope。cold-start 6k–10k tokens／40–80分鐘，參照 FLUTTER-STYLE-1 的資料邊界；10k tokens／80分鐘或需要改既有 model／UI 時回 PLAN。保存及跨語言風險由 fresh Test Author 保護，不建 screenshot tests。尚未交付 tabs close／pinned／dirty、geometry 保護、React Dock 與 GUI／docs embed；後續按同一已接受 Workbench stage 接續。

## 實作清冊及完成證據

69771496：KlpDockPanelPolicy 的 id／allowSide／allowBottom 投影能力；KlpDockRestoreResult 的 layout／missingPanelIds／availablePanelIds 不可變。KlpDockLayoutCodec.encode 使用 _wire → _snapshot 驗證後 jsonEncode；restore 使用 jsonDecode → _snapshot → reconcile，保持原模型 API。_object 檢查 exact fields、_id 檢查非空、_extent 檢查有限數值、_invalid 擁有 FormatException。wire／snapshot／reconcile 分別擁有邊界轉換、全域 identity 與清冊診斷，沒有新增 renderer。

7 項獨立 checks、公開 foundation／codec analyze、scope gate 通過；測試 SHA256 129D62D2C11882215D2FB652A3DA99CCF64FBCBD547845270D7CACD0FDE9781C 未變。Test Author 基線35332e86僅有缺新符號的 compile Yellow；實作後全部 Green，沒有宣稱未存在的 behavior Red。BUILD 僅改兩個允許路徑，無感官結果。React codec 與 Dock UI 仍待接續；後續 owner 修改本 architecture 不回算為 BUILD worker scope。

## Operations 清冊及完成證據

b08d80e6／243d9f98：KlpDockArea、Destination、Action及ActionResult公開typed const API，applyKlpDockAction依codec驗證before／after；_DockWorking只持有owned replacements，原snapshot保持不可變。_findPanel／_placedPanel／_group定位，_setGroup／_deleteGroup／_removePanel統一copyWith及active fallback；_permitted驗證destination能力，_identity／_insertion／_extent／_invalid擁有FormatException。named constructors用私有tag/payload維持shape，不提供JSONaction或Widgettree。

10獨立checks（React同fixture／情境）、publicfoundation analyze No issues、scope通過；SHA256 3D9FEBC3F5B44A602CE755482FE66D3DD849225632BA1120CE42B293BBD4E3DF未變。TestAuthor基線ca9a4efd缺symbol為compileYellow。建構子清理中發現private initializing formal的callsite名稱編譯錯誤，已按diagnostic修正並重跑相同checks，無測試／contract改動及無Greenfallback。BUILD僅兩個allowedpaths，scope於243d9f98閉合；後續owner修改architecture與docs不回算worker。兩框架pure操作已完成，UI、有效handle／viewport geometry與pinned／dirty呈現待接入。

## 有限 geometry 前置

共通 WB-PANEL-GEOMETRY-r1 已 READY；Panel 模組先處理 finite chrome／inset／State continuity，Dock 只使用公開 PanelFrame。Dock root/group/gutter/overlay 已由 FLUTTER-DOCK-GEOMETRY-1 接入共同配額；原保存偏好不因render改變。Panel slice 不改本目錄，後續 Dock slice 不複製 Panel chrome 算法。

## FLUTTER-DOCK-GEOMETRY-1（完成）

修訂FLUTTER-DOCK-GEOMETRY-r1；依WB-DOCK-GEOMETRY-r1接入有限viewport。klp_dock_layout.dart 擁有native positioned composition／group resolver接入／actual handle傳入resize/drop；新 private part internal/klp_dock_geometry.dart 只擁有 root rect 與handle配額，依公開resolveKlpLinearLayout，不建立第二份演算法。布局root用stable keyed Positioned/ClipRect保留原Stage/area/header內容；root需finite axes，不持有保存state。

private geometry回傳left/right/bottom/stage/header rect、各area handle rect與可提交max budget；areas可見條件沿用visible且groups非空。commoncontract固定全部數值規則。groups改用既有resolver結果的extents/gutter，最後group填剩餘。arearesize callbacks用當前geometry，groupresize沿用pair逻辑但使用effectivegutter。horizontalgroup header判定讀PanelFrame公开chrome/margin契约，不看私有Panel实现。

BUILD allowed_write：klp_dock_layout.dart、internal/klp_dock_geometry.dart、internal/klp_dock_header_state.dart、primitives/klp_dock_resize_handle.dart。models／codec／pureoperations／旧dataoperations／Panel／theme／style／example／config／architecture／tests全部唯讀。TestAuthor只寫flutter/test/dock_geometry_test.dart。不修改hover開area與cancel、更不在此聲稱close/pinned/dirty完成。Header state僅slots數值／高度安全，保留overflow菜单和callbacks。resizehandle僅safe lineLength/clip，不改手勢。

M1 root/area/group有效gutter守恆、normal/zero/extreme style；M2 area/group resize同一配額、Header zero slots與State continuity、protectedchecks/publicanalyze/scope。cold-start8k–14k tokens/60–100min，參照FLUTTER-LAYOUT-2與PANEL-GEOMETRY-1；20k tokens/120min或需要改pureoperations/Panel/model回PLAN。直接同一geometry配額避免仅ClipRect隐藏溢出；独立puregeometry part有root placement/resize共同reason to change，不引入genericruntime。

```mermaid
flowchart TD
	Layout[保存偏好 / controlled caller] --> Geometry[root rect / resize budget]
	Theme[semantic handle / header] --> Geometry
	Geometry --> Linear[既有public linear resolver]
	Geometry --> Native[同一Positioned / ClipRect槽]
	Group[既有group偏好] --> Linear
	Linear --> Native
	Geometry --> Resize[global pointer → local actual budget]
	Resize --> Callback[原onLayoutChanged]
	Native --> Panel[公開PanelFrame尺寸契約]
	Header[DockHeader slots] --> Panel
```

## Geometry 清冊與證據

296e7cab：_KlpDockGeometry 的 optional area/header rect、stage及三handle rect、maximum resize budgets只持有限當前呈現；_dockAreaItem把舊Infinity logicalmax轉nullable resolver上限。_resolveDockGeometry依共通root左右/上下規則调用既有solver。_dockSlot keyed native Positioned/ClipRect保持consumer State；_resolveGroupExtents回傳同一result.extents/gutter，offset/handle/drop/resize共享。_handleAreaResizeAt先檢查有限提交上限，min不容納時不寫尺寸；_handleGroupResizeAt只改相鄰pair。_buildStageDropIndicator只畫Stage rect；horizontalgroup header判定使用公開PanelFrame margin/chrome配額。

DockHeader總slots先clamp至所需actions+1再floor，zero icon不除零；more 在zero icon尺寸時以當前標頭可用高/寬形成有限操作槽，保留menu enabled/callback。resize indicator lineLength=max0(loose-tight)，paint裁切於實際槽。沒有改model/codec/pureoperations/Panel/拖放state callback。

獨立TestAuthor d76784d7，13checks baseline2pass/11behavioralRed；最終13Green、publicDock/Headeranalyze No issues、4allowedpaths scopepass。protected SHA256 7F3D69E9C4B93BCC9EC8CA95D6197E361182784CA27326B2FEB878D81B2B4BE9 不變。首次geometry實作12pass/1menuRed，zero icon留下零clickable面積；只在Header原有more slot依有限標頭配額修正，originalmenucheck及全部13checks再通過，未改測試也無Green fallback。BUILDscope於296e7cab閉合，owner文件更新不回算worker。

logicalgroupmin32/120仍是舊操作限制，完整style recipe參數化尚未完成。hover/cancel不提交、close批准、pinned/dirty與pureoperation UI接入仍待同一Workbenchstage；有限geometry完成不代表整個Dock交付完成。

Release Catalog 另以 `flutter build web --release --no-tree-shake-icons` 成功建置；既有動態 IconData 要求保留完整字型。native browser 已確認 HISTORY 分頁切換、Bottom 收合與還原保留分頁，error/warn 空。截圖在 main ignored `build/evidence/flutter-dock-geometry.png`；Catalog 黃色雙底線與 Header 固定32px舊說明仍待 example/style 階段，不屬本 BUILD，感官接受仍 human-pending。

## FLUTTER-DOCK-PREVIEW-1（完成）

只實作WB-DOCK-PREVIEW-r1，保存／geometry已完成。State擁有此次drag的preview slots與drop提示；build由widget.layout投影臨時visible/minimum area，送既有geometry及group composition。caller layout是唯一保存權威。_finishDrag清preview及提示；target leave僅清提示，避免Stage→preview group跳轉時隱藏目標。didUpdateWidget僅在layout identity變更時清preview，不把theme/size rebuild當產品保存更新。success使用caller的原area尺寸與visible=true提交，不把presentation minimum帶回保存。

BUILD only klp_dock_layout.dart、internal/klp_dock_layout_data.dart。原publicmodel／codec／operations／geometry part／primitive Draggable／Panel／theme／style／example／config／architecture／tests唯讀。現有onDragFinished callback可接新的private lifecycle，不改primitive介面。TestAuthor只寫flutter/test/dock_preview_test.dart，readonly既有geometry test可作公開harness參考。下一slice才接入pureoperation與close metadata；本slice不發明新publicAPI或產品保存層。

M1 hover/cancel/capability/caller lifecycle，M2 success一次提交與保存extent／原geometry保護、publicanalyze/scope。cold-start6k–10k tokens／40–70分鐘，參照FLUTTER-DOCK-GEOMETRY-1與STATE-1；15k／90分鐘或需要改readonly API/geometry回PLAN。選擇局部presentation投影，替代hover提交後rollback會先污染產品保存、且與外部更新競爭，因此不採用。

```mermaid
flowchart TD
	Caller[唯一保存layout] --> Preview[State本次drag slots]
	Preview --> Effective[臨時visible/minimum投影]
	Effective --> Geometry[既有finite geometry]
	Geometry --> Native[既有Group/Stage]
	Gesture[公開drag] --> Preview
	Gesture --> Finish[cancel/end清preview]
	Gesture --> Commit[success讀caller原extent]
	Commit --> Callback[一次onLayoutChanged]
	Callback --> Caller
```

PREVIEW-1 實作3064c359：_previewAreaSlots只擁有此次gesture；_presentationLayout以caller投影minimum/visible，_finishDrag清所有暫態；didUpdateWidget只在layout identity改變時清除。_finishPanelDrop取caller原area再設visible=true，避免minimum污染保存extent；未改publicAPI或pureoperations，原data part只另改tab縮排。TestAuthor f717c311，7checks baseline2pass/5behavioralRed→全部Green；連同受影響13geometry共20Green，publicDockanalyze No issues、2paths scopepass。protected SHA25661335C6016B221D213DED7971F2654B38FB5932B3A86BA83A8E06F2635985CB2不變；scope於3064c359閉合。nativebrowser前次release僅geometry證據，本次preview由公開Widget gesture驗證，不宣稱新browser或感官接受。下一步所有UI提交接入pureoperations及產品close批准/pinned/dirty。

## 當前 slice FLUTTER-DOCK-UI-1（READY）

依WB-DOCK-UI-r1接入全部UI提交及optionalmetadata。公開KlpDockPanel新增const optional bool isPinned=false/isDirty=false、FutureOr<bool> Function()? onCloseRequested、String? closeLabel；dart:async僅用於型別。舊constructor不改必填欄／預設draggable規則。metadata只有產品投影，不寫codec或純policy。callback不接內容與dirty自動清除；closeLabel缺省用既有documentTabCloseLabel及panel id。

State擁有pending tokens與目前registry投影；_commitActions在local immutable snapshot依existingapplyKlpDockAction組合，只在最終保存值不同時通知一次。select、Stagecreate、tabmove/reorder/split、resize/visibility皆走該函式，pointer前置及preview保留。不增加新的pure utility或保存state。data part保留UI index轉換／groupid生成及batch action協調，刪除被pureOPS取代的source removal/reorder權威。group pair resize兩個actions一次commit。原target Area的保存extent保留；split只改兩個group偏好。

close lifecycle可用new private part internal/klp_dock_close.dart，理由是異步pending與結果有效性和pointer geometry不同。每次request建立token，pending拒重入；以同token/同callback/placed/registered/mounted判斷結果。didUpdateWidget在panel不再placed/registered或callback替換時invalidatetoken；dispose不提交。approved讀最新layout純close，denied/error不commit；error標準FlutterError.reportError。pending僅禁用該closebutton，解除後可重試。pinned不自動改closable，dirty不改approval。

single header與每個tab以現有semantic Text/Icon及inline IconButton組合metadata/close，保留原title/selected/hover風格及DockHeader viewport/overflow。decorative pinned使用KlpIcons.bookmark、dirty沿documenttabs的bullet與既有modified l10n；產品header保持Widget不強制轉字串。沒有metadata/callback的caller保留原結構。關閉button獨立gesture，不把click變成select/drag；即使header=null亦在single frame呈現close。shape/gap/icon尺寸讀theme，不新增硬編值。

BUILD allowed_write：klp_dock_layout.dart、internal/klp_dock_layout_data.dart、新internal/klp_dock_close.dart、klp_dock_panel.dart（僅importdartasync）、models/klp_dock_panel_data.dart。publicWidget constructor／codec／operations／geometry／其他primitive／Panel／theme／style／example／foundationexport／config／architecture／所有tests唯讀。公開檢查author只可寫flutter/test/dock_ui_test.dart；既有preview/geometry tests可讀及執行不得改。

M1全部UI pureactions及pointer/drop/index/immutable/no-op證據，M2close metadata／批准與pending stale lifecycle／publicanalyze/scope。cold-start10k–16k tokens／60–100分鐘，參照FLUTTER-DOCK-OPS-1及PREVIEW-1；24k／120分鐘或要改純OPS/codec/geometry/Panel回PLAN。跨模組公共新欄已由共同契約及Flutterroot/Reactcontracts先固定，不讓BUILD自行選擇。

```mermaid
flowchart TD
	Pointer[既有pointer/geometry] --> Intent[typed actions / finalindex]
	Intent --> Batch[local immutable batch]
	Batch --> Pure[既有applyKlpDockAction]
	Pure --> Callback[changed才一次通知]
	Product[Panel metadata / approval] --> Header[現有semantic header/tab]
	Header --> Close[pendingtoken / FutureOr approval]
	Close --> Current[latest caller / token有效]
	Current --> Batch
	Caller[controlled layout/registry] --> Current
	Caller --> Intent
```
