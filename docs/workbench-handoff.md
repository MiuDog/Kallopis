# Workbench 當前交接

2026-10-12。持續 goal ACTIVE；完整需求：[本階段計畫](architecture/workbench-stage-v1.md)。已授權雙框架 Workbench、所有元件頁面互動、三種 GUI 範例、可替換風格、docs 與最終 GitHub push，不重問。

## 完成證據與限制

- STYLE-PACK-1／2 完成：269 原料、350 四模式語意、118 原文配方；typed catalog／四模式解析／原子覆寫；114 checks 全過、零跳過；migration --check、公開 TypeScript 宣告、scope gate 通過。React 現有 public tokens 經 codec 與 common 四模式 1400 值一致。
- DOCS-STAGE-1 完成：五份研究／規範／計畫已接入網站；15 checks、519 manifest 的 generate／verify 通過。尚未接互動 bundle。
- REACT-STYLE-1 完成：JSON 匯入、原子覆寫、350 項 catalog 公開、全量 scoped CSS／hook、owned runtime；21 React checks、generate freshness、build/example、scope gate 通過。獨立 tarball consumer 通過；瀏覽器確認 8→12px 間距、背景替換、壞 JSON 保留現況、還原、深色、窄畫面及字型載入。typed recipe 展開與布局算法仍待後續。
- 未完成：雙框架 adapter 完整風格接入與資料權威切換、Workbench 能力、全部 specimen、三種 GUI 各框架範例、網站互動 bundle、最終 CI／push。
- 正式 Markdown 暫仍是值權威，風格 JSON 是逐項驗證的遷移資料。

## Git 與下一步

隔離 checkout：`C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis`。Main `D:/Projects/Kallopis` 含先前搬移與未提交變更，index 不操作。保存基線 `3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de` 不等同 release。

SP2 實作 commit `9a002003cde0302faa9bff2610bc3b746f77556a`；runtime test SHA256 `CF5E9848E92BBE5A1A1057BE8B1D00CCA8E8A35A172287C766BEB46D725ECCA4`。每個 BUILD packet 必須取新 clean HEAD，packet 位於 main ignored build/task-packets/。

REACT-STYLE-1 commit `2243c4a7`；Test Author SHA256 `15EA38EC657834F2169FBC5792C9A05009AC949D6263D95BE38DD2BA8A3CA6A3` 未變。示範 dev server `http://127.0.0.1:5180/`，session 51939；browser tab 4（iab 2）已標記 handoff。截圖 main ignored `build/evidence/react-style-provider.png`。Vite 範例 505KB chunk 提示仍存在；非執行錯誤，後續網站 bundle 應分割載入，不弱化警告閾值。

下一步 PLAN Flutter adapter 然後 BUILD，再進通用 layout。GUI 選用 VS Code、Blockbench、Blender；Blender 官方 4.5 workspace 正文已取得 HTTP 200，涵蓋 Areas／Editors、切換、新增、複製／刪除／排序。範例使用公開本庫元件及自己的 state，不引入編輯器／3D／終端核心。
