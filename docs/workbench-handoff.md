# Workbench 當前交接

2026-10-12，持續 goal ACTIVE。完整需求以 docs/architecture/workbench-stage-v1.md 及 spec/workbench-v1.md、spec/style-pack-v1.md、spec/interactive-docs-v1.md 為準。Flutter／React 同步交付、所有公開元件頁面互動、VS Code／Blockbench／Blender 各框架 GUI、可替換風格、docs與最終GitHub push均已授權，不重問。

## 現況與已驗證範圍

- Common STYLE-PACK-1／2完成：269原料、350四模式語意、118原文配方；catalog／四模式解析／原子覆寫，114checks、migration--check及scope通過。正式Markdown暫仍為值權威，JSON是逐項驗證遷移資料，尚未切換權威。
- REACT-STYLE-1完成2243c4a7：public pack／350catalog／scopedCSS與hook／ownedruntime；21checks、freshness、build、tarballconsumer通過；browser替換／拒絕／還原／dark／375px／fonts驗證。
- FLUTTER-STYLE-1完成17119f2b：public parser／四模式 resolver／原子覆寫／350native欄位及現有ThemeExtensions；19獨立checks＋41既有theme/accent checks、analyze／freshness／scope通過。stylePack與style互斥，pack不套舊透明度處理。
- LINEAR-GEOMETRY完成：React dcc15e4f、Flutter a8124a62；各21checks含極大有限數值、不足minimum、preferred／max／flex守恆，nativeanalyze／librarybuild／scope通過。共通契約docs/architecture/workbench-linear-contract.md。
- FLUTTER-LAYOUT-2完成273a0b4f：bounds／divider／Column alignment／root有效inset／內容槽裁切／naturalfallback與舊resizecallback相容；18獨立Widget checks＋4既有workspacechecks、analyze／scope、Catalog實際渲染通過。測試作者依原callback契約獨立修正自己的斷言，沒有弱化產品要求。
- REACT-LAYOUT-2完成6a2ca282：六個直接layout元件、元素量測／觀察器與有限px槽，9checks含獨立SSR→hydrateRoot（07a25d94）保留原input節點／編輯值，publicconsumerTypeScript／librarybuild／scope通過。
- REACT-LAYOUT-EXAMPLE-1完成920f0022：公開consumer有width/height/end/inset/gap控制；nativebrowser確認480×300 default120/8/336、160寬minimum各68、end留白、gap12、極大9999時零內容／可還原、native輸入保留、自然量測108=70+8+30；dark／375px无水平溢出、fontsloaded、error/warn空。視覺感官human-pending。Vite517KBchunk提示保留，網站bundle按需分割，不調高閾值。
- Docs現有27份來源及Flutter534canonical API／17modules／三surface generate／verify通過，15網站checks此前通過；React使用指南已包含新layout。尚無全部component-specific互動bundle，不能以總覽iframe宣稱完成。

- FLUTTER-DOCK-STATE-1完成69771496：WB-DOCK-STATE-r1公開schemaVersion1 codec／policy／restore diagnostics，7獨立checks、analyze／scope／protectedhash通過。未知version／欄位／identity／active／finite／capability整份拒絕；先驗證後reconcile，missing／available有序、result深層不可變，不動既有Dock model／Widget／storage。docs生成／verify及15網站checks通過，新增3公開API頁及保存契約。

- REACT-DOCK-STATE-1完成c6af55f6：native readonly資料、encodeKlpDockLayout／restoreKlpDockLayout使用同一手寫wire；7checks、build／typedconsumer／scope通過。全部結果deepfreeze、caller不動，registry optionalbool／unknown拒絕，malformedJSON轉TypeError，無DOM或storage。

- REACT-DOCK-OPS-1完成e5d8b0a6：公開applyKlpDockAction與typed action/destination/result，10checks、build／typedconsumer／scope通過。strictrequest、finalindex、capability、missing清冊先拒絕、empty／active fallback、close approved／denied／reopen、immutable／caller隔離。純utility不宣稱UI完成。

- FLUTTER-DOCK-OPS-1完成243d9f98（實作b08d80e6）：typed constaction／destination／area／result及applyKlpDockAction，10獨立checks與React同fixture／情境、publicanalyze No issues／scope通過。只改operations與foundationexport；原codec／model／Widget／style不動。建構子清理中的callsite compilefailure已按diagnostic修正，相同checks再通過，沒有改tests。

## Git 與工作環境

唯一BUILD隔離checkout：C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis，managed attached、detached commits。Main D:/Projects/Kallopis branch codex/productivity-reference-ecosystem 有先前搬移及未提交變更，index保留。保存基線3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de不是reviewed release。origin https://github.com/MiuDog/Kallopis.git，push尚未執行。
同步必須先讀main ignored build/workbench-last-sync.json的sourceRevision，逐路徑比較main=baseline或new後才複製，CRLF正規化；reference-api.json比較JSON值，Git maxBuffer100MB。同步前後cached diff byte/hash一致，禁止blindstage／reset。每個BUILD packet在main ignored build/task-packets/，必須newcleanbase；歷史scope證據於各自BUILD閉合commit，不拿後續owner/testauthor修改當worker違規。
本機Flutter D:/flutter/bin，3.44.2/Dart3.12.2；Node24、TS7（consumer直接檔案compile需--ignoreConfig）。
瀏覽器iab2：Reactlayout tab6 http://127.0.0.1:5182/ devsession89615；FlutterCatalog tab5 http://127.0.0.1:5191/ ttysession82480；舊Reactstyle tab4/5180/session51939可能仍在。使用前revalidatehandle，compaction後先cua.rewriteDocumentation。截圖main build/evidence/react-linear-layout.jpg及flutter-linear-layout.jpg，temporarytab標記handoff。

## 受保護測試與下一個動作

Common runtimehash CF5E9848E92BBE5A1A1057BE8B1D00CCA8E8A35A172287C766BEB46D725ECCA4；Reactstyle15EA38EC657834F2169FBC5792C9A05009AC949D6263D95BE38DD2BA8A3CA6A3；Flutterstyle15B43CF1A61888D208B32785716163BEFD4B101D8ED02FB3ABF7D985C4527129。
Flutterlinear26F406F0C231B0362C2C73760740117771B097C25043DCB8FE484A7D647A653F；ReactlinearAAE3EEF26F5530F4D5002BEA3698FF9F42B13722C547746021C58C9138145803。
Flutterwidget893CB1ABE6FE24C2F6CA54EA72769CC23EE91CD0C68B0909117DDAE5D63BBB75（flutter/test/workbench_layout_test.dart）；ReactwidgetD3547FAC11B6638E1F74C09E2E981ACFBEF610343136498D6656602BF8AC7495（react/test/workbench-layout.test.mjs）。獨立TestAuthor擁有上述檔，BUILD不得改測試。
Fluttercodec受保護tests flutter/test/dock_layout_codec_test.dart：129D62D2C11882215D2FB652A3DA99CCF64FBCBD547845270D7CACD0FDE9781C；author基線35332e86，BUILD scope在69771496閉合。手寫跨語言wire在該test首段；React下一個TestAuthor應採同樣wire成功／拒絕樣本，不用各端encode自我roundtrip代替格式驗證。
Reactcodec protected test react/test/dock-layout-state.test.mjs hash9D654F0FAA78FF9B02A97B4C7E337585179F25D3254F53F3C4ACB45E4DC77900，author基線c0c7fa76，BUILD scope於c6af55f6閉合。
Reactoperations protected test react/test/dock-layout-operations.test.mjs hash8856C5DC1A404D4B0797BEE8FFD3F5BE0D6295755A7FD48E734F65C5CCDDD14F，author基線6641d67e，BUILD scope在e5d8b0a6閉合。
Flutteroperations protected test flutter/test/dock_layout_operations_test.dart hash3D9FEBC3F5B44A602CE755482FE66D3DD849225632BA1120CE42B293BBD4E3DF，TestAuthor基線ca9a4efd，BUILD scope在243d9f98閉合。
下一步PLAN雙框架Dock受控UI：兩端保存codec／pure操作及Flutter finitegeometry均已完成，不重做。沿用WB04～08／16，保留Stage／Left／Right／Bottom及既有Fluttercaller；固定drag/resize/cancel/closecallback契約。Flutterhover開area目前呼叫onLayoutChanged，需要改成presentationpreview，取消不提交；用新的pureoperation提交成功drop／close。close callback需由產品批准且dirty不丟資料、pinned／dirty由產品metadata呈現。必要獨立Widget／DOMchecks先固定，再BUILD及公開example／nativebrowser證據。
其後命令／快捷鍵註冊、chord／scope／衝突／重綁、所有specimen、VSCode/Blockbench/Blender各双框架GUI、typedrecipe／全部元件風格對齊、網站展示registry/bundle/coverage、權威切換／CI／精確提交push仍未完成。完整goal保持ACTIVE。

上述root/group/rawhandle問題已由296e7cab有限geometry修正；後續UI接入必須保留共同actualgutter／Rects／resize預算。

## 最新 Panel 前置完成

FLUTTER-PANEL-GEOMETRY-1：PLAN cf09051d，獨立TestAuthor2b0180b6，BUILD5e18ccd6。新test flutter/test/panel_geometry_test.dart protectedhash90B1B2CAE6705E5D13B8930EFE8FFB1A1FFD3AA8FED338442BDBC13786FB0BE7。baseline4pass/5behavioralRed，最終9Green、publicPanelanalyze No issues、5allowedpaths scopepass。packet及closure在mainignored build/task-packets/flutter-panel-geometry-1*.json；scope只於5e18ccd6閉合。

Panel module新architecture已固定finite chrome/inset/radius及內容State契約；FrameView依公開LayoutColumn/Pane/Bounds，Header依LayoutRow/Pane，所有stage wrappers在尺寸/theme變化穩定。未改Dock、theme、style、config、tests。根goal本輪工具量差127419tokens/517seconds含承接上下文與TestAuthor，不是純BUILD估算。

下一步PLAN Dock受控UI：Flutter finite geometry已完成，不重做；沿用pureoperations，hover只presentation preview/cancel不提交、close需產品批准且不丟dirty資料、pinned/dirty由產品metadata呈現。React native Dock UI仍缺。

Panel title對齊校正8d4fc334：原viewport wrapper改為AlignmentDirectional.centerStart，保留原方向起點而非把短文字置中；同一9checks與Headeranalyze通過，scope只1個Header來源，testhash不變。獨立packet base8da3c63b，scope於8d4fc334閉合，mainignored flutter-panel-geometry-align*.json。

## 最新 Dock finite geometry完成

PLAN1e8203e6/Infinity補充4fe6c76c；TestAuthord76784d7；BUILD296e7cab。13checks baseline2pass/11behavioralRed→13Green，Dock/Headerpublicanalyze No issues，4paths scopepass。protectedfile flutter/test/dock_geometry_test.dart hash7F3D69E9C4B93BCC9EC8CA95D6197E361182784CA27326B2FEB878D81B2B4BE9。不重做geometry或修改tests；packet與scopeclosure在mainignored build/task-packets/flutter-dock-geometry-1*.json，base d76784d7/scope閉合296e7cab。

新增privatepart internal/klp_dock_geometry.dart擁有rootRects/handles/resize預算，依既有publiclinear。UI root用stablekeyedPositioned/ClipRect，PanelFrame前置共用；保存prefs不變。groups最後填餘/其餘prefs依min與比例縮配，actualgutter供所有offset/resize/drop。arearesize扣另一side與把手/header，min不足no-op；horizontalheaderdrop讀actualmargin/chrome；Stageindicator只畫Stage邊界。Header zero icon slot多選單保留可點擊槽與enabledcallbacks；loose-tight lineclamp0。

已重現releaseweb default build因原dynamicIconData不能tree-shake字型失败；按Flutterdiagnostic改用 --no-tree-shake-icons 保留完整字型，不改資產/consumer/config/tests。release建置成功（49.8s）；http://127.0.0.1:5192/ nativebrowser tab7已確認HISTORY切換呈現Change history、Bottom收合隱藏TERMINAL/PROBLEMS、再開恢復且HISTORY保留，error/warn皆空。證據mainignored build/evidence/flutter-dock-geometry.png，release靜態server session3043。觀察既有Catalog文字黃色雙底線及Header說明仍寫固定32px，待example/style/docs階段修正；沒有宣稱感官接受，human-pending。下一步Flutter hover/cancel/close/metadata/pureOPS受控接入，以及React nativeDock；logicalgroup min32/120完整recipe參數化、commands/keybindings、allGUI/specimens/docsregistry/authorityswitch/push尚未完成，goal ACTIVE。

## 最新 Dock preview 完成

PLAN5abc383a、TestAuthorf717c311、BUILD3064c359；7preview checks baseline2pass5behavioralRed→7Green，合併原13geometry共20Green/publicDockanalyze/scope2paths pass。protectedfile flutter/test/dock_preview_test.dart SHA25661335C6016B221D213DED7971F2654B38FB5932B3A86BA83A8E06F2635985CB2。packet/closure在mainignored build/task-packets/flutter-dock-preview-1*.json，basef717c311/scope閉合3064c359；只Widgetnativegesture證據，尚未browser重新驗證preview。

下一步PLAN FLUTTER-DOCK-UI：所有select/move/reorder/split/visibility/resize提交接入完成pureoperations，並以可選且相容public metadata及產品close批准接線pinned/dirty；不重做preview/geometry/codec/OPS。React native Dock、commands/keybindings、全部specimens/GUI、style recipes/權威切換/網站registry/CI/精確push均未完成，goal ACTIVE。舊文字「hover目前提交」只描述已修正問題，以本段及module contract為準。

## 最新 Flutter native Dock UI 完成

PLAN11e8c2b9、TestAuthor23fd02ad、BUILD4ff1c999。protectedfile flutter/test/dock_ui_test.dart SHA2568A8E346FCAE1B59533B3A5C4D5733BAC61C37B4023E7C75F88CA29D1AEDE8991；13UI+7preview+13geometry=33Green exit0session86014/publicDockPanelanalyze/scope5paths pass。初始compileYellow是新API缺符號，未取得baselinebehaviorRed；實作12Green1splitRed，新增pairgutter改用既有solver後同checks全Green。packet/closure mainignored build/task-packets/flutter-dock-ui-1*.json base23fd02ad/scope閉合4ff1c999。

State沒有第二份保存權威；所有UI提交pureOPS batch最終changed才一次通知。Panel增加optional isPinned/isDirty/onCloseRequested FutureOr<bool>/closeLabel；callback identity需穩定，metadata只呈現。pending stale/removed-reopened/latestlocation/dispose/error/deny及inactive/single無headerclose都由nativeWidget checks保護。新UI尚未nativebrowser example接線驗證；舊Catalogrelease只geometry證據。下一步React nativeDock PLAN或公開FlutterDockexample接線，完整命令/快捷鍵、全部specimens及VSCode/Blockbench/Blender雙框架GUI、typedrecipes及權威切換/CI/精確push仍未完成。

REACT-DOCK-GEOMETRY-1已完成08ea39fc：9protectedchecks、librarybuild、typedpublicconsumer與2paths scope通過；hash B617A4EC6DD751B430CB6C697FB7C753D0018C0C3B558FE82296BB5992FAC8C8。TestAuthor65909cb9獨立修正fixture handle4配292預算，所有assertions保留。packet/closure mainignored build/task-packets/react-dock-geometry-1*.json base65909cb9、scope閉合08ea39fc。pure root geometry提供nativeUI/resize共同有限Rects，尚無nativeDOM／pointer驗證。下一步React native Dock UI與Flutter example接線，完整goal保持ACTIVE。

REACT-DOCK-NATIVE-1已完成7690b23b（PLAN8926bc20/TestAuthor9e3e7da3）：受控呈現/分頁keyboard/visibility/批准close與finite groups/chrome，9protectedDOM/SSRchecks、build、typedconsumer與scope4paths通過。protectedfile react/test/workbench-dock.test.mjs hashA85874E8854C56A775AA7E049EF40E8BF9BA8C157E8488EB8C752B9B4F9A296B未改；部分asyncclose act harness警告，沒有console空證據。packet/closure在mainignored build/task-packets/react-dock-native-1*.json base9e3e7da3、scope閉合7690b23b。尺寸synthetic/nativebrowser待example，感官human-pending。下一步PLAN native2接pointer reorder/move/split/resize/preview，再example/browser；不把native1宣稱完整Dock。完整goal包含雙框架GUI、全部互動specimens、commands/keybindings、style recipes與authorityswitch/CI/exactpush，保持ACTIVE。

最新REACT-DOCK-NATIVE-2完成681c0f6c+measure583818e8+hint/capture6ee63c5e，PLANc3d98971/TestAuthor70ab0435。protectedfile react/test/workbench-dock-input.test.mjs SHA256335DCA352EF2FAAA608AF9294CDA45D00B5A213FB8CAAA2E40A32FEFCAA17403；baseline2Green7behaviorRed→8Green1scaleRed→9Green，合併native1共18Green/session77278 exit0，build/publicconsumer及4path/measure1path/resumeinput1path scope閉合通過。根因為non-px CSS fallback取transformed DOMrect，600視為1200；owner修訂REACT-DOCK-MEASURE-r1允許唯一lifecycle量測檔，改用untransformed client，不改tests或另做pointer尺寸權威。packets/closures mainignored build/task-packets/react-dock-native-2*.json/react-dock-measure-1*.json；歷史scope不可在owner文件後重跑。

新增collapseThresholds optional產品邏輯/HTMLtabdrag/PointerEventsresize、purebatch1通知/finiteview/previewpref保留/cancelcleanup。native2 synthetic事件通過，beforeafterline/capture已接線但nativebrowser尚未觀察，感官human-pending；native1舊actwarnings仍在。下一步PLAN React公開Dockexample（save/load/reset/open/merge/approvedclose）並browser，Flutter新Dock UI example也待接線；完整命令/shortcut、雙框架3GUI、全部specimens/websitebundles、typedrecipes/權威切換/CI/exactpush仍未完成，goal ACTIVE。

## 最新公開React Dock example

PLAN8a2267b4，consumer實作9597e484，3allowedpaths scope/typecheck/prod build通過，既有550.99KBchunk提示未調高門檻。example只publicimports，strictcodec/OPS清冊投影id與capabilities，stableclosecallback由ref讀產品批准模式，layout只有產品state。初次browser metadata清冊Red已在example修正，未改庫或測試。

tab8 http://127.0.0.1:5182/（devsession89615）：select/收合/展開、save/restore/reset、invalidJSON原子保留、deny/approve/pendingdelay、open/merge均可操作；nativearea180→210與group200→225各1callback；320×180root scrollWidth320/scrollHeight180且style無NaN/Infinity，Stage及Search輸入跨theme/size保留。證據mainignored build/evidence/react-dock-example.png為診斷移除後重排及resize，呈現2次變更/left210/light。

native HTMLdrag已確認：短距離Search→Explorer重排1次；right拓寬360後Search跨區域header合併1次；Search拖正文split1次，兩group各96=(200−8)/2。最初未提交的兩次長拖，暫時eventprobe證明目的未收到有效dragover/drop，不是缺dragstart；拓寬目的即成功。診斷已移除且consumerGit不變，移除後重排/arearesize再成功。hover preview nativebrowser仍待接續，不宣稱已通過；無需改library或tests。下一步Flutter新UIexample與hover preview browser，再commands/keybindings及website展示stage。完整3GUI×2框架、全部互動頁面/網站registry、typedrecipes/風格中立與權威切換/CI/精確push仍未完成。goal ACTIVE，main dirty/index保留。
