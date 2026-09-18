# 上下文整理紀錄

2026-09-12。使用者要求降低上下文與測試成本，準備新 session。本次只改文件／skill；沒有更改產品程式、既有測試、CI、Git 歷史或使用者聊天紀錄。

- 新政策：[lean-development](C:/Users/ASUS_TUF/.codex/skills/lean-development/SKILL.md)。可控任務包最多 6,000 token，摘要＋最近 3 輪，按需檢索；必要測試由高階模型負責，中低階模型實作且不得改測試要求。
- 預設入口：[AGENTS](../AGENTS.md) → [交接頁](session-handoff.md) → 單一功能契約。其餘規則不預載。
- 已縮短 8 個工作流 skills 與 UI 設計路由，撤銷每改必測、全量 Verify 及固定八階段儀式。
- 三份舊進度／查核／重構摘要正文已移出；保留小型導向頁，避免生成圖集的既有連結斷裂。純歷史證據節與重複逐步日誌已移出；有效契約、功能範圍、API 範例及來源保留。
- 本次既有文件修改 22 份：UTF-8 大小 205,573 → 101,110 bytes，減少 50.8%。這是文字大小，不是精確 token 計費或整個平台上下文。

原文備份（1,771 份 Markdown／入口文件）：[before.zip](C:/Users/ASUS_TUF/.codex/tmp/kallopis-context-cleanup-20260912-192730/before.zip)。
逐檔整理清單：[cleanup-manifest.json](C:/Users/ASUS_TUF/.codex/tmp/kallopis-context-cleanup-20260912-192730/cleanup-manifest.json)。備份在專案外，只在查特定歷史時開啟，不預設讀取。

當前聊天與平台系統注入無法藉此清空。新 session 必須重新核對交接中指定的工作樹，不能把歷史代理狀態或通過數字當目前證據。原筆記開發維持停止，等待新的繼續指示。

驗證：已對變更文件做連結讀回，修正兩個舊 Workspace 連結後局部複查通過；skill 必要 frontmatter 欄位檢查通過。內建 skill 驗證器缺 PyYAML，未安裝額外相依。沒有執行產品測試。
