# Workbench 當前交接

2026-10-13，完整goal ACTIVE。已授權Flutter／React同步交付：通用Workbench、全部公開元件頁面互動、VS Code／Blockbench／Blender各框架GUI、可替換風格檔及參數、docs與最終GitHub push。規格入口：docs/architecture/workbench-stage-v1.md、spec/workbench-v1.md、spec/style-pack-v1.md、spec/interactive-docs-v1.md。以下只保留當前真實狀態，歷史診斷與證據讀Git／module architecture／ignored closure，不重做已完成slice。

## 下一個可執行步驟

1. 雙框架command core／registered toolbar／menu／palette／popup及公開CommandsDemo完成。popup Flutter d17be03f protected16＋原23、analyze／scope2；React75c24b4e protected12＋原12、typedconsumer／build／scope3。consumer Flutter173cc9e9／Reactcb1c392d各exact1source：button bounds／右鍵point／Escape／outside無click-through／一次執行／focus／draft nativebrowser觀察。Flutter初次兩失敗是背景fixture收縮，由獨立TestAuthor修正並加入實際Overlay尺寸校验，原assertions保留。網站公開popup extract549；完整窄native／style矩陣與感官pending。快捷鍵共通契約WB-SHORTCUT-CORE-r1及兩端purecore已完成；Flutter11／React9 protected checks、analyze／build／scope2通過，不複製第二份rows或handler。
2. 雙框架快捷鍵purecore已完成，WB-SHORTCUT-HOST-r1兩端library已完成；React consumer e56976aa已完成exact1/typecheck/scope及nativebrowser錄製／重綁／設定；Flutter consumer f9118c25亦完成exact1/analyze/scope/web及nativebrowser，下一步網站專屬互動specimen／registry與bundle。不可用core冒充整個命令stage完成。
3. React公開元件extractor 1ae31d6f與23個專屬互動route bdd22417已完成；Flutter c7a841aa擷取與c84bd254 analyzer13 runtime已完成，561公開宣告全量成功，273可渲染元件（259 class＋14 final class），canonical identity零差異。下一步Flutter專屬route與網站registry/bundle/coverage。3GUI×2框架與typedrecipes／完整風格中立與參數／default權威切換仍需交付。
4. 補browser hoverpreview/cancel矩陣、Flutter continuousresize與React endcommit差異契約審核；保留所有既有CI/發布閘門，精確commit/push。感官接受human-pending。

## 最新完成：React公開清單與23個獨立互動展示

Flutter正式manifest8bff562a新增全量renderable boolean；原4獨立checks保護真Widget identity、所有modifiers、show/hide、跨surface去重與失敗保留，沒有固定254清冊。analyzer13與meta1.18.0支援當前Dart3.12.2；既有extractor無需API adapter。同byte放Flutter套件context分析No issues；根工具直接分析缺package config的錯誤不算source Red。實際全量extract561/273成功，generate/verify561成功。純Node網站15與SDK4入口分開（37bad812）；Flutter CI強制SDK4（26cc05f4）；portable launcher1c322b4d Windows4/4 Green、93.5秒，Linux待遠端執行。完整goal與GitHub push尚未完成。

共同IDOC-COMPONENT-REGISTRY-r1，React extractor 1ae31d6f由真實public d.ts與TypeScript symbols取得23個renderable exports；fresh獨立6checks、CLI failure保留舊JSON、scope1 Green。consumer bdd22417 exact3source，publicTS／productionbuild／scope3／原生23routes載入通過；basic/layout專屬參數、Button callback/reset、Explorer兩回呼、Provider語意解析及四模式、寬鬆pack／320測量寬度保留草稿、palette/popup/menu原命令結果、shortcut component作用域、Dock切tab／保存及style草稿觀察。錯誤space500引用改正式space600，validator維持。網頁iframe/bundle與Flutter清單／route仍pending，這不是全站完成；截圖main build/react-component-specimens.png，感官human-pending。

## 已完成：雙框架快捷鍵公開展示

React e56976aa只commands-demo.tsx：public TypeScript／scope1／diff Green；同registry default scopedkeys、chord、conflicts、record no-dispatch/max4/apply/cancel/restore、valid-invalid JSON與dark原draft nativebrowser觀察。closure與screenshot位於main ignored build。完整IME／style／窄viewport與感官pending。Flutter f9118c25 exact1source：analyze／scope1／release web46.4秒及nativekeyboard完整同React操作矩陣通過（Flutter風格切換仍pending）。下一packet為網站元件專屬互動registry／bundle，先依目前truth PLAN，不重做已完成command consumer。

## 已完成：原生快捷鍵宿主

React64d9883f protected6 SHA256F73747DFCA15446033AED1DA46886EC01FC80B2E45E1913E3A0F6D7FCF0A57FB／librarybuild／scope2；Flutter4a3b1088 protected10 SHA256C4333601BD67F8087824B4A193AAAC52933F6F5240AB4F5827A5CDE047C92566／publicanalyze No issues／scope2，同hash保持。原生bubble／child-first、editable/composition OR、owned singleTimer、ignoredmodifier不延長期限、nativefocus取消、borrowedowner清理與same-session latest原async結果皆publiccodechecks通過。React author229cab86修zero-delay JSDOM selectionchange計數fixture；Flutterauthorcc2d4ef9→9ffc0dd7修原Focus dispatch及ignored方向鍵觸發Material巡覽後refocus，原assertions保持、補keydown/repeat確實到達數量。沒有repeat產品Red成立。暫時diagnostic已移除；沒有nativebrowser完成聲稱。公共Guide及使用指南更新，561API／34Markdown／generate/verify/15checks Green。

兩端SHORTCUT-EXAMPLE-r1已COMPLETE；command consumer不再是下一BUILD入口，不讀私有庫或改tests/config/CSS。default save primary+s/chord primary+k→s；page grid primary+g＋duplicate conflict；draft component grid override；region failure alt+shift+f；publichost同registry，stablefocus identity、record/application/cancel/restore、strict JSON import/export／原draft／結果一次nativebrowser。產品scope/composition投影由caller擁有，不新增第二handler或style。
## 最新完成：雙框架快捷鍵純核心

共同WB-SHORTCUT-CORE-r1，authors1c0c0542；ReactBUILD0b996490 protected9 SHA256127E0B72A6B61B190A5B6DD15F39436BF2953C3C07995913452F7F09584B4D6E，FlutterBUILD188273b8 protected11 SHA2562040C69AAECCF92DCFE542FC8DCB06038A82B4D617437E88B225FADDECF5EE1C，同hash保留。Reactbuild／Flutter publicanalyze／各scope2／diffcheck通過。React初次8Green／1Red是匯出null-prototype不同於普通DTO，以Object.fromEntries修正並安全保存__proto__ ID，同9Green；沒有改測試或Green fallback。Flutter首次11Green。原registry借用；legacy keybinding無改動、沒有native eventloop／timer／focus權威。現在website extract561／34Markdown，generate／verify／15websitechecks通過。實際functions與Mermaid已由owner更新兩端module架構；完整native快捷鍵與GUI尚未接入。

## 當前新完成：雙框架registered command入口

有限入口：Flutter author03d499f2（新geometrytest SHA256 8A88C0D5E29600D4FC20A7C03E12F3B10E2D1804F0BA0E41CA21A55873B2F3EB）2Green／4Red→6＋原23Green；BUILD1bdd6321單source，analyze／scope1／releaseweb47.6s／正常browser通過。React authordb3d4eef（SHA256 4A0A1367AF446966EAAB2237705DB0CE014AEA6DB5F5A4E92AAAE87816E3957A）新11含父項3pass／8fail→11＋原12Green；BUILDaff1eaf4兩source，build／consumer typecheck／scope2／正常＋百萬參數import browser通過；nativeparentclient861下rowpadding430.5，還原draft／checked保持。原protected hashes未改。Flutter極端native、Reactfiniteheight／精確窄viewport仍pending；此次tab10 viewport override未套用，actual1280×720，不冒充320×180證據。截圖flutter-command-entry-geometry.png／react-command-entry-geometry.png在main build/evidence。完整style audit與popup仍後續。

React viewport regression freshauthor a00fe4a2（SHA256 EECF13F973E41D40825EB784DFFF62A8E284336089BE7798583E7CF62C885925）：原inner1280/client1265→panel1264、原inset8只剩left0.4，native大style參數可重現；4checks有3behaviorRed/1Green。bounded單source修正使用實際client viewport/ResizeObserver，同4＋既有11checks/build/typedexample/scope1全部通過。nativeclient1265→panel1249、窄client305→panel289，兩側約8；query跨原生resize保留。style輸入先缺新增primitiveDescription被原子拒絕，補齊後正式import成功，未修改parser配合測試。還原default/dark/errorwarn空；截圖react-command-example.png已更新。

Flutter palette BUILD2a069faf：新來源／foundation兩path，21項protected公開Widget checks、public analyze No issues、scope2及diff check通過。fresh author e5de466f保留排序／Unicode分詞預期，修正native View root與LF輸入harness；SHA256 DB279A061B5016806C1F4EFC3C43AC78D4C5B808BA97BF3543E6C0278F97EBE9。原Portal modal traversal排序Red，owner b08b95e7 ACR改每owner build刷新同Theme／locale的獨立OverlayEntry；Tab唯一輸入焦點、Material透明宿主及Actions Escape fallback由新source修正。consumer browser已確認搜尋／pending／error／Tab／Escape／executed；scrim背景語意穿透Red已由35614d5b修正並通過原生browser回歸。感官／style矩陣仍pending，不重做已Green核心。

React palette BUILD160f2c18：new command-palette/index/styles三path，11項protected UI/SSR/hydration/type、library build/scope通過；SHA256 2753CE7F881BF0C0B56B8FE22EB0637EF4401F8023E64E057D55621A0FF7E6E5。原CSSStyleDeclaration非iterable Red以length/item標準讀法修正，同tests Green。public controlled modal、field search/multiwords/UTF16 score、samecore gates/session/latestcallback、native showModal/returnfocus/同Provider portal CSS及finite geometry；Flutter亦已實作，consumer browser待接續。

React CommandsDemo BUILD9999e289只新example與main兩行，public consumer TypeScript/prod build/2pathscope通過（569.17KB chunk提示）。native browser tab10 http://127.0.0.1:5182/：sv 文件跨field/subsequence、中文/canvas/空結果、ArrowDown Enter一次、executed focus回開啟按鈕；disabled保留不可選、failure保持modal、Tab input、Escape/outside；800ms pending三入口save disabled、完成一次結果/close；dark及320×180 panel304×164有限，草稿保留，error/warn空。main build/evidence/react-command-example.png。IME/產品externalfocus/完整極端style/嵌套modal矩陣pending，感官human-pending。網站共同palette Guide與React usage更新，30Markdown／547API／17modules／三surfaces，generate/verify及15網站checks通過；清冊不等於全部互動元件頁。

共同WB-COMMAND-ENTRY-r1 READY；React BUILDd05dca0e只新command-entries/indexexport/stylesappend，12項SSR/DOM/lifecycle/type checks及librarybuild/3pathscope通過，protectedhash72BB8ACAD50A754D376EE3CB38D80A0B1A2BE02317F2131F1079233C03449561未改。ownerf7f93520接入使用指南與共同契約網站Guide，當前29份Markdown、541API、15websitechecks/generate/verify通過；React act時機警告與browser/sensory待驗證。Flutter FLUTTER-COMMAND-ENTRY-r1亦已完成，證據如下。不以入口冒充popup/palette/shortcut全完成。

Flutter BUILDae01ca96只新command_entries來源及foundation匯出；23項protected Widget/lifecycle checks、analyze No issues、兩path scope通過。author3a3f2004→a4951f51→120bd313保留原斷言，修正SemanticsHandle try/finally與Future完成後第二frame flush，補兩callback原error/再執行保護；最終SHA256 4DC377CC7612B91719BDEEC6472B30D47722C225702788C923F48B2545F80189。不改舊controls/core/theme/config；nativebrowser與極端style參數audit待後續。owner重新extract後545 canonical API／17modules／三surfaces，29Markdown；generate/verify及15網站checks通過。

## Flutter 命令consumer與modal修正（完成）

consumer BUILD04cc372f只registered_commands_page.dart／registry.dart，原generated清冊保留，手寫入口投影pages／coverage；單一產品State使用stablefoundation registry／toolbar／menu／palette。analyze No issues／scope2／diffcheck／releaseweb --no-tree-shake-icons成功50.5s；library／tests／config／generated未改。

native Commands頁已確認草稿保留、sv 文件搜尋儲存、800ms pending三入口disabled、結果1／executed／原focus；save關與failure開、原Bad state error結果2／面板保持、Tab唯一輸入、實際空回饋、Escape及canvas／ArrowDown／Enter一次grid結果3／兩入口checked。Windows scrim(200,350)曾穿透背景導航；此已修正，不是當前blocking。

modal BUILD35614d5b只palette source：BlockSemantics在locale投影外層，named scrim原生tap／dismiss讀同caller本地化。fresh author32ba2a01／格式a47e7b8d只新modaltest，SHA256 2B973B68295A0493332366BF6337B59EE9C67F26AFB2F7F8474BC1D3ADD42220。基線3Green／2有效Red，修正後5＋原21全部Green，原hash DB279A061B5016806C1F4EFC3C43AC78D4C5B808BA97BF3543E6C0278F97EBE9未變；publicanalyze No issues／scope1／diffcheck通過。

releaseweb修正後45.0s成功；native tab11 http://127.0.0.1:5192/：open AX只剩panel／input／候選／Dismiss，背景操作消失；同scrim座標只outside，Commands頁與草稿保留、focus回開啟按鈕，原生Dismiss亦只outside，candidate pointer一次grid／executed。實際inner320×180、panel rect x8／y8／w304／h119，query canvas跨resize保留；viewport reset完成，error／warn空。main build/evidence/flutter-command-example.png（修正後）及flutter-command-modal-red.png（歷史重現）。原tab9 viewport工具沒有作用的嘗試不算窄尺寸證據；新tab11已觀察實際尺寸。GUI／全部specimen尚未網站整合；IME／externalfocus／同theme／完整style矩陣與sensory human-pending。

## React command core

共同docs/architecture/workbench-command-contract.md WB-COMMAND-r1 READY，PLAN6e42acd0／metadata及stale dispatch澄清58f366c4。React修訂REACT-COMMAND-CORE-r1 COMPLETE，BUILD53c6ac39只新增react/src/command-registry.ts及index匯出。generic caller context／metadata隔離／三條件／typed原值結果／per-entry pending／stale owner／獨立subscription／version-refresh-dispose；無DOM、產品state/storage、defaultcommands。

fresh獨立TestAuthor e568ac7c／補強3feb78b9，只寫react/test/command-registry.test.mjs；SHA256 FA7DD79C2A0F187212CC1283570627AE82DD09A5BD36F6709949960167E44010。11項checks全部Green、library build、ignored typedconsumer及2path scope通過，protectedhash不變。基線missingexport Yellow，不是behaviorRed；首次phase推導string的compile Red以literal修正，相同檢查通過，沒有改tests。packet/closure在main build/task-packets/react-command-core-1*.json；scope只在53c6ac39閉合。

## 新完成：Flutter command core

PLAN2be47a25／引用修正04a94326；fresh TestAuthor7607bc39只寫flutter/test/command_registry_test.dart，初始public API缺少為compile Yellow；BUILD b2cdee54新增原生命令來源及foundationexport，21checks/public analyze No issues/2path scope通過。scope packet首次architecture_path與module_root不符，修正為Flutter package root後同2path evidence通過，allowed_write未擴大。

owner b319af8c澄清removeListener只解除native addListener owner；獨立author7b660382保留原斷言並補3case，基線21Green/3behaviorRed。BUILD9cffc7e8只在observer新增isNative並限制removeListener，24checks/public analyze/1path scope通過。protected hash 09C8FFA8D207B6A10D83AC0FE7AAA74528408FD57934099758F978611F45AE1C。通知中dispose立即closed/clear/finalnotify，super ChangeNotifier cleanup安全延後；native Listenable保留。module詳見flutter/lib/src/features/actions/command_registry/architecture.md，packets/closures main build/task-packets/flutter-command-core-1*.json與flutter-command-observer-1*.json。沒有命令UI/keyboard完成宣稱。

## 已完成基礎及直接證據入口

| 能力 | 完成範圍／證據 | 仍待交付 |
| --- | --- | --- |
| 通用stylepack | 9a002003：269 primitives、350 semantics×4、118原文recipes；114checks；styles/kallopis-v1.json及typed catalog/immutable原子override | 正式Markdown仍值權威；typedrecipes/fullfidelity/default權威切換 |
| React style接入 | 2243c4a7：350 scopedCSSvars、Provider/hook、21checks、build/consumer/browser | 全部元件recipe/style參數audit |
| Flutter style接入 | 17119f2b：350native欄位、四模式parser/adapter、19新checks＋41既有themechecks | 同上 |
| finite linear pure | React dcc15e4f／Flutter a8124a62各21checks | 已完成，不重做 |
| native linear | Flutter273a0b4f 18＋4checks；React6a2ca282／07a25d94九checks含SSR/hydration；example920f0022browser finite/input/theme | 網站專屬specimens整合 |
| Dock codec／operations | Flutter69771496／243d9f98；Reactc6af55f6／e5d8b0a6；各7codec、10operationschecks | 已完成；consumer只投影id/capabilities清冊，不傳content/callback |
| Flutter Panel／Dock | Panel5e18ccd6／8d4fc334九checks；geometry296e7cab十三；preview3064c359七；UI4ff1c999十三，Dock合計33checks | browser preview/cancel全矩陣 |
| React Dock | geometry08ea39fc九；native1 7690b23b九；native2 681c0f6c／583818e8／6ee63c5e九，合計18nativechecks | native1部分act harness warnings保留，browser矩陣同上 |
| 參考網站 | Flutter561canonical API／17modules／三surface popup extract／generate／verify／15checks；34文件 | API清冊不等於互動頁；全部展示未完成 |

本機main網站重建曾讀ignored build/reference-api.json舊534清冊；generator/verifier明確使用該建置輸入。已以同隔離已驗證547artifact更新main ignored輸入，原重建與verify回547，無source／test改動。tab3 reload已見33文件現行stage與新popup Guide；截圖main build/evidence/workbench-command-popup-guide.png。日後新公開API完成需先extract再generate，不把ignored stale產物當正式清冊。

共同Dock契約docs/architecture/workbench-dock-contract.md與linear契約workbench-linear-contract.md均READY。KLP0024要求一般Row/Column/Pane與Dock分開，保留direct native元件；不得重建node/adapter/declarative runtime。公開Flutter theme/foundation為stable，consumer不得引用src。

## 最新公開example與browser事實

React PLAN8a2267b4／BUILD9597e484，3examplepaths scope、TypeScript/prod build通過；550.99KBchunk提示保留。tab8 http://127.0.0.1:5182/（devsession89615）：save/restore/reset、invalidJSON原子保留、deny/approve/delaypending/open/merge；原生area180→210及group200→225各1callback；320×180無溢出/NaN，Stage/Search跨theme/size保留。HTMLdrag重排、跨區header合併、正文split各1通知，split96=(200−8)/2；初次長拖缺目的dragover，拓寬目的後成功，暫時診斷已移除Git內容不變。main build/evidence/react-dock-example.png為診斷移除後再操作的證據。

Flutter PLAN1bffc472／BUILD39d263e0（owner744c9533），2examplepaths scope、分析No issues、releaseweb --no-tree-shake-icons成功；預設tree-shake受既有dynamicIconData阻擋，未改資產。tab9 http://127.0.0.1:5192/、HTTP PID42840：History/Bottom2、deny0、approve/open/merge各1，invalidJSON保留/合法還原成功，Stage320×180及恢復保留；delay完成1，instantpending停用未取得browser證據。Inspector跨區合併/正文split各1，split106=(220−8)/2；area220→250 continuous pan共8callbacks，不能宣稱每gesture只一次。120寬Header search+更多→設定有回饋；Material透明祖先移除舊黃雙底線，最後error/warn空。main build/evidence/flutter-dock-example.png、flutter-dock-header-example.png。FlutterDOM.fill第二次追加，使用原生Ctrl+A/clipboard/Ctrl+V替換JSON，未改產品parser迎合工具。

## Git／BUILD與檢查規則

隔離checkout C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis為managedattached detached。Main D:/Projects/Kallopis branch codex/productivity-reference-ecosystem有先前搬移及其他未提交變更，index必須保留。保存基線3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de不是reviewed release。origin https://github.com/MiuDog/Kallopis.git；尚未push。

同步只用main ignored build/guarded-workbench-sync.mjs，先驗證main各path等checkpoint baseline或new，CRLF正規化/reference-api JSON值比較，然後copy；cached binarydiff前後一致，不blindstage/reset。checkpoint build/workbench-last-sync.json。每個BUILD packet在main build/task-packets/，cleanisolated base、exactallowedwrite；architecture/tests/config預設readonly，跨module先PLAN。必要新風險tests只fresh隔離Test Author；BUILD可讀執行不可弱化。所有code縮排tabs顯示2、繁中註解。歷史scope只在該BUILD closingcommit，不在owner後重跑。

本機Flutter D:/flutter/bin 3.44.2／Dart3.12.2；Node24。Browser後續使用前revalidatehandle；compaction後先cua.rewriteDocumentation。原生瀏覽器/syntheticcode事實與感官human-pending分開；不將截圖當完整互動或跨框架parity證據。goal保持ACTIVE直至全部交付及push完成。
