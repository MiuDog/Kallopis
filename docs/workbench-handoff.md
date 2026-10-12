# Workbench 當前交接

2026-10-12，完整goal ACTIVE。已授權Flutter／React同步交付：通用Workbench、全部公開元件頁面互動、VS Code／Blockbench／Blender各框架GUI、可替換風格檔及參數、docs與最終GitHub push。規格入口：docs/architecture/workbench-stage-v1.md、spec/workbench-v1.md、spec/style-pack-v1.md、spec/interactive-docs-v1.md。以下只保留當前真實狀態，歷史診斷與證據讀Git／module architecture／ignored closure，不重做已完成slice。

## 下一個可執行步驟

1. 雙框架command core已完成，共同WB-COMMAND-ENTRY-r1及React registered toolbar/menu已完成。下一個PLAN固定Flutter actions/command_entries local architecture與fresh TestAuthor，保持既有CommandMenu／WorkspaceCommand caller相容；不重做registry。overlay/context menu/palette仍待接續。
2. 雙框架快捷鍵/chord/scope/conflict/remap/recording契約與接入。不可用core冒充整個命令stage完成。
3. 網站每個公開可呈現元件專屬互動specimen、registry/bundle/coverage；3GUI×2框架；typedrecipes／完整風格中立與參數／default權威切換。
4. 補browser hoverpreview/cancel矩陣、Flutter continuousresize與React endcommit差異契約審核；保留所有既有CI/發布閘門，精確commit/push。感官接受human-pending。

## 當前新完成：React registered command入口

共同WB-COMMAND-ENTRY-r1 READY；React BUILDd05dca0e只新command-entries/indexexport/stylesappend，12項SSR/DOM/lifecycle/type checks及librarybuild/3pathscope通過，protectedhash72BB8ACAD50A754D376EE3CB38D80A0B1A2BE02317F2131F1079233C03449561未改。ownerf7f93520接入使用指南與共同契約網站Guide，當前29份Markdown、541API、15websitechecks/generate/verify通過；React act時機警告與browser/sensory待驗證。Flutter local FLUTTER-COMMAND-ENTRY-r1 READY；fresh TestAuthor保護公開Widget，產品實作尚未開始。不以入口冒充popup/palette/shortcut全完成。

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
| 參考網站 | Flutter541canonical API／17modules／三surface extract/generate/verify；29文件、15網站checks | 541 API清冊不等於541互動頁；全部展示未完成 |

共同Dock契約docs/architecture/workbench-dock-contract.md與linear契約workbench-linear-contract.md均READY。KLP0024要求一般Row/Column/Pane與Dock分開，保留direct native元件；不得重建node/adapter/declarative runtime。公開Flutter theme/foundation為stable，consumer不得引用src。

## 最新公開example與browser事實

React PLAN8a2267b4／BUILD9597e484，3examplepaths scope、TypeScript/prod build通過；550.99KBchunk提示保留。tab8 http://127.0.0.1:5182/（devsession89615）：save/restore/reset、invalidJSON原子保留、deny/approve/delaypending/open/merge；原生area180→210及group200→225各1callback；320×180無溢出/NaN，Stage/Search跨theme/size保留。HTMLdrag重排、跨區header合併、正文split各1通知，split96=(200−8)/2；初次長拖缺目的dragover，拓寬目的後成功，暫時診斷已移除Git內容不變。main build/evidence/react-dock-example.png為診斷移除後再操作的證據。

Flutter PLAN1bffc472／BUILD39d263e0（owner744c9533），2examplepaths scope、分析No issues、releaseweb --no-tree-shake-icons成功；預設tree-shake受既有dynamicIconData阻擋，未改資產。tab9 http://127.0.0.1:5192/、HTTP PID42840：History/Bottom2、deny0、approve/open/merge各1，invalidJSON保留/合法還原成功，Stage320×180及恢復保留；delay完成1，instantpending停用未取得browser證據。Inspector跨區合併/正文split各1，split106=(220−8)/2；area220→250 continuous pan共8callbacks，不能宣稱每gesture只一次。120寬Header search+更多→設定有回饋；Material透明祖先移除舊黃雙底線，最後error/warn空。main build/evidence/flutter-dock-example.png、flutter-dock-header-example.png。FlutterDOM.fill第二次追加，使用原生Ctrl+A/clipboard/Ctrl+V替換JSON，未改產品parser迎合工具。

## Git／BUILD與檢查規則

隔離checkout C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis為managedattached detached。Main D:/Projects/Kallopis branch codex/productivity-reference-ecosystem有先前搬移及其他未提交變更，index必須保留。保存基線3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de不是reviewed release。origin https://github.com/MiuDog/Kallopis.git；尚未push。

同步只用main ignored build/guarded-workbench-sync.mjs，先驗證main各path等checkpoint baseline或new，CRLF正規化/reference-api JSON值比較，然後copy；cached binarydiff前後一致，不blindstage/reset。checkpoint build/workbench-last-sync.json。每個BUILD packet在main build/task-packets/，cleanisolated base、exactallowedwrite；architecture/tests/config預設readonly，跨module先PLAN。必要新風險tests只fresh隔離Test Author；BUILD可讀執行不可弱化。所有code縮排tabs顯示2、繁中註解。歷史scope只在該BUILD closingcommit，不在owner後重跑。

本機Flutter D:/flutter/bin 3.44.2／Dart3.12.2；Node24。Browser後續使用前revalidatehandle；compaction後先cua.rewriteDocumentation。原生瀏覽器/syntheticcode事實與感官human-pending分開；不將截圖當完整互動或跨框架parity證據。goal保持ACTIVE直至全部交付及push完成。
