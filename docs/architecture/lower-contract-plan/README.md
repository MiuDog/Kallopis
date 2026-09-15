# LOWER-V1-r1 具名下層契約配對

Execution complete。已完成已接受 v1 的 CAP-V1-02／REND-V1-04 與必要直接 caller 配對。

LOWER-V1-r1：CAP-V1-02 與 REND-V1-04 配對，71 個既有檔案實體移至具名路徑；全部名稱、constructor、預設值、演算法、狀態與 callback 身分不變。Provider 42 個 editing export 與 9 個 part 移至 editing/contracts，根入口原 44 個 export 的符號可達性不變。draw_command_validation 留 internal，不新增公開；block_drop_preview 仍非公開，drop_target 與 editing_submission 為 editing/ 下具名套件內入口，保留整體演算法及狀態。Foundation 15 個通用 binding 檔案含 11 part 移至 binding/contracts，維持同 library、abstract KlpBoundTemplate 與非 consumer 公開協定；此條明確接替 PRES-V1-r1 的「路徑保留」，其名稱、constructor、模組責任與原行為仍保留。Styling 的 paper_shadow_recipe 與 control_density 移至各自具名入口，值與唯一來源不變。所有直接呼叫端與測試 URI 配對更新，不留 shim、不新增 export。完整 rendering 的 import/export/part/part-of/conditional 指令不得跨到任何其他模組 internal；不能只檢查 capabilities/foundation。維持 26 renderer 分支、28 catalog ID、未知類型拒絕、同模組 reciprocal part、Stable 與 provider 可達性。編輯 pending/resync、save job/confirmed revision、手寫生命週期與上游正文／undo 權威不變。CAP-V1-03 舊正文分類、FND-V1-05 metrics、host 與剩餘 APP-V1-06 不藉此宣告完成。

[精確路徑](path-map.json) 是寫入清單；7 個 module 各自取得外置 JSON Task Packet、以每個乾淨提交為 base_revision 執行 scope gate。根 provider barrel 只由 Architecture Steward 改 URI。測試由兩個獨立作者各寫不相交清單，BUILD 不修改測試。

1. M1：下層 3 個 owner 完成實體路徑與所有 reciprocal directives。
2. M2：上層 4 個 caller 配對及根 barrel 整合；原實作正文等價。
3. M3：獨立完整邊界／公開身分／現有編輯與 renderer 行為通過、atlas 更新，再回存原工作樹。

每個 module 估算 1,000–4,000 token、5–25 分鐘；測試作者各 4,000–10,000 token、15–45 分鐘。依 SEM／PRES／L10N 類似工作量推估，缺乏獨立逐工時統計，屬 cold-start 範圍；沿用主模型、現有 Flutter/Node/Python。越界或契約矛盾立即回報，超過 12,000 token 或 60 分鐘記錄異常證據。自動接受契約內可逆路徑選擇，無新產品決策。

驗證須保留原測試斷言、fixture 內容與 public exports，必要擴充既有 prepared 非公開路徑閘門以涵蓋新 contracts；不允許用舊路徑空集合假通過。所有 token 工時未知值明示，不推算為實測。

[驗證](verification.md) 與 [執行證據](execution.json) 記錄本批結果。
