# Workbench 當前交接

2026-10-12。持續 goal ACTIVE，完整需求不得縮減：[本階段計畫](architecture/workbench-stage-v1.md)。使用者已接受 Workbench v1，並授權所有元件頁面互動、三種 GUI 範例、可替換風格及最後 GitHub push，不需再次詢問同一授權。

## 已完成與真實限制

- STYLE-PACK-1：預設 JSON 及純 ESM 匯入／驗證／表格匯出；269 原料、350 四模式語意、118 配方；65 個含子測試 checks 全過，逐 cell round trip、CLI --check、scope gate 通過。Test Author SHA256 `8316DE83F1381D17D8BF99137A9CEF1B794AF306C79B7E029793FA0C75D5CA6E`，不得由 implementation 改 tests。
- DOCS-STAGE-1：五份研究／規範／計畫接入網站來源清單；15 checks 及正式生成／verify 通過。新 worktree 初次缺 build/reference-api.json 是輸入未準備，已用現有 committed manifest 準備，未改 generator 或 manifest。
- 尚未完成：typed 參數 catalog／resolver、風格 adapter／權威切換、Workbench 雙框架完整能力、全部元件互動 specimen、GUI 範例、網站互動 bundle、最終 CI／GitHub push。
- 正式 Markdown 暫仍是值權威；現有 Flutter／React 路徑及外觀維持。不要提前宣稱框架已接受 JSON。

## 隔離與 Git

可寫隔離 checkout：`C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis`。主目录 `D:/Projects/Kallopis` 有既有大量搬移／未提交變更，index 未被操作。新 checkout 的初始保留 snapshot 是 `3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de`；這是保留基線，不代表全部差異可直接發布。先前 cross-framework archive 還原回報 snapshot missing，不再依賴它。

STYLE-PACK-1 test baseline `02bbe67f732dafd141c05f833d8c3f3cbbddc51a`，實作 commit `fdc7f3660e3f5d5812b8695ea1d68ee84b1b44da`；docs registry commit `a7adba8ed0da46b00df85103fb99c441bc90c65a`。Packet 在主目錄 ignored `build/task-packets/`，不是 source。下一 packet 必須取當前乾淨 HEAD，不復用上述舊 base。

## 下一步

讀 [styles 架構](../styles/architecture.md) 與 [風格規範](../spec/style-pack-v1.md)，完成 STYLE-PACK-2 的公開 typed resolver／metadata 及 min／max 合法範圍契約；必要測試由 fresh Test Author 分離撰寫。SP-02 目前只完成交換結構／引用／循環，runtime 型別及尺寸範圍尚未完成。

曲線原文陣列保留字串（如末項 1.0），typed resolver 需明確轉換且保留資料權威；不可更改保護測試掩蓋來源遺失。對兩框架的色碼／單位／字型轉換應由公開 fixture 比較，不能只看 token 數量。

GUI 場景：VS Code、Blockbench、Blender，均使用公開本庫元件與自己 example state；Blender 官方正文目前 open 失敗，實作前需取得官方內容或 GUI 觀察證據。跨視窗／浮動 panel 與編輯器核心維持範圍外。
