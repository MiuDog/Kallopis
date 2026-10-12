# Workbench 當前交接

2026-10-12。持續 goal ACTIVE；完整需求：[本階段計畫](architecture/workbench-stage-v1.md)。已授權雙框架 Workbench、所有元件頁面互動、三種 GUI 範例、可替換風格、docs 與最終 GitHub push，不重問。

## 完成證據與限制

- STYLE-PACK-1／2 完成：269 原料、350 四模式語意、118 原文配方；typed catalog／四模式解析／原子覆寫；114 checks 全過、零跳過；migration --check、公開 TypeScript 宣告、scope gate 通過。React 現有 public tokens 經 codec 與 common 四模式 1400 值一致。
- DOCS-STAGE-1 完成：五份研究／規範／計畫已接入網站；15 checks、519 manifest 的 generate／verify 通過。尚未接互動 bundle。
- REACT-STYLE-1 完成：JSON 匯入、原子覆寫、350 項 catalog 公開、全量 scoped CSS／hook、owned runtime；21 React checks、generate freshness、build/example、scope gate 通過。獨立 tarball consumer 通過；瀏覽器確認 8→12px 間距、背景替換、壞 JSON 保留現況、還原、深色、窄畫面及字型載入。typed recipe 展開與布局算法仍待後續。
- FLUTTER-STYLE-1 完成：公開 JSON／object parser、四模式 typed resolver、原子覆寫、350 native 欄位及 ThemeExtensions 接入；19 項独立 checks、41 項既有 theme／accent checks、局部 analyze、generator freshness、scope gate 通過。未改受保護 tests 或 legacy JSON schema。
- FLUTTER-LINEAR-1／REACT-LINEAR-1 完成：有限主軸公開算法各21項独立 checks，包含min／max／preferred／flex、間距守恆、比例退化、巨大有限值及immutable；Flutter analyze、React build、各scope gate通過。實際 Widget／DOM 接入尚未完成。
- 未完成：recipe 全部視覺參數與元件對齊、風格下的布局保護及資料權威切換、Workbench 能力、全部 specimen、三種 GUI 各框架範例、網站互動 bundle、最終 CI／push。
- 正式 Markdown 暫仍是值權威，風格 JSON 是逐項驗證的遷移資料。

## Git 與下一步

隔離 checkout：`C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis`。Main `D:/Projects/Kallopis` 含先前搬移與未提交變更，index 不操作。保存基線 `3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de` 不等同 release。

SP2 實作 commit `9a002003cde0302faa9bff2610bc3b746f77556a`；runtime test SHA256 `CF5E9848E92BBE5A1A1057BE8B1D00CCA8E8A35A172287C766BEB46D725ECCA4`。每個 BUILD packet 必須取新 clean HEAD，packet 位於 main ignored build/task-packets/。

REACT-STYLE-1 commit `2243c4a7`；Test Author SHA256 `15EA38EC657834F2169FBC5792C9A05009AC949D6263D95BE38DD2BA8A3CA6A3` 未變。示範 dev server `http://127.0.0.1:5180/`，session 51939；browser tab 4（iab 2）已標記 handoff。截圖 main ignored `build/evidence/react-style-provider.png`。Vite 範例 505KB chunk 提示仍存在；非執行錯誤，後續網站 bundle 應分割載入，不弱化警告閾值。

FLUTTER-STYLE-1 實作 `17119f2b`；Test Author SHA256 `15B43CF1A61888D208B32785716163BEFD4B101D8ED02FB3ABF7D985C4527129` 未變。公開 `KlpStylePack`、`klpStyleParameters` 由 kallopis_theme.dart 匯出；buildKlpThemeVariant 的 stylePack 與 style 互斥，pack 不套舊透明度。

下一步 PLAN Row／Column／Pane 元件接入：使用已完成的公開幾何算法，固定 bounded axis／intrinsic fallback、root inset／gutter 壓縮、clip、min／max 投影，保留既有 Flutter API；React 建立直接元件。Dock、commands、specimens 隨後接續。GUI 選用 VS Code、Blockbench、Blender；Blender 官方 4.5 workspace 正文已取得 HTTP 200。範例使用公開本庫元件及自己的 state，不引入編輯器／3D／終端核心。

Flutter adapter 完成後重新 extraction：521 canonical API／17 modules／三個公開入口；已更新已驗證網站 manifest，generate／verify 通過。已同步 main：相對 31cea818 的 15 個受檢查路徑；全部先確認 main 等於基線或新內容，再複製，index 未修改。Main 的 19 項 style pack checks、generator freshness 與 521 API generate／verify 也通過。每次同步的精確 sourceRevision 記錄於 main ignored build/workbench-last-sync.json；後續先讀該基線再做 guarded sync。

一般布局現況（下一輪 bounded retrieval 起點）：Flutter module 為 flutter/lib/src/features/workspace/layout/architecture.md；實作只有 klp_app_layout.dart、klp_frame_groups.dart。現有線性配置使用原生 Row／Column／Expanded，加固定 semantic gutter；尚無一般 min／max 分配 resolver，極大 gap／固定 pane 可能溢出。LayoutResizeHandle 公開 onResize 且私有 _linearChildren 會建立手勢，和 KLP-0024 的一般 divider 不拖曳有差異；repo example／tests 未找到 callback caller。PLAN 必須保留公開相容性，明示處理，不能 BUILD 偷刪 API。React 尚無對應 layout module。

本輪 LINEAR：Test Author commit 4c57c994，Flutter test SHA256 26F406F0C231B0362C2C73760740117771B097C25043DCB8FE484A7D647A653F、React test SHA256 AAE3EEF26F5530F4D5002BEA3698FF9F42B13722C547746021C58C9138145803 均未變。React implementation dcc15e4f、Flutter a8124a62；packets 位於main ignored build/task-packets/{react,flutter}-linear-1.json，BUILD均已閉合。DOCS-LINEAR-1實作3cfe2eea，15既有checks與scope gate通過；新共通來源網頁 docs/guides/workbench-linear-contract.html。重新 extraction 524 API／17 modules／26 docs，已更新已驗證manifest，generate／verify通過。
