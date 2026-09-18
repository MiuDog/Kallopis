# LOWER-V1-r1 驗證

CAP-V1-02、REND-V1-04 已完成；全目標 43/50，其他七切片與最後稽核仍 active。

71 個既有來源移至具名契約，57 個直接 caller 配對，共 128 個來源的正文（除 leading indentation）相同，所有 directive 的順序與解析目標對應原身分。刪除舊路徑，不留 shim。Provider 原 44 個 exports 中 42 個 editing 契約與 9 parts 遷入 contracts；未公開的 submission/drop/helper 不增加 export。通用 bound 15 檔含 11 parts 仍在 foundation 同 library，兩個 styling 契約保持唯一值。

| 證據 | 結果 |
| --- | --- |
| 既有遷移測試及 prepared 邊界 | 185 項通過；35 個測試／fixture 的 76 URI 更新，反向還原後逐 byte 相同；prepared 原判準保留並涵蓋新 contracts。 |
| 獨立 lower/provider 契約 | 12 項通過；完整 renderer 跨模組 internal、公開 export／型別、單一實體與 part 所屬者。 |
| 既有 provider／catalog／frontend | 197 項通過；drawing、save、handwriting、兩個 catalog 與既有 frontend 架構閘門。 |
| Module scope／analysis | 七個真實 scope 全 PASS；七組局部分析 exit 0、無問題。 |
| Source atlas | 1195 來源、277 folder、3711 diagrams；1473 files freshness 逐 byte 通過。 |

新 boundary 在原基線因真實違規取得 Red；新 URI 編譯缺失明示為 integration pending，不算有效 Red。所有作者檔案 SHA256 保護，BUILD 未修改要求。初次將 128 paths 一起送分析碰到 Windows 命令列長度限制，已按模組分組完成同一選定範圍，並非產品失敗。

Module 狀態更新後的三項契約檢查與精確命令／日誌／hash 收據見 [執行紀錄](execution.json)。未執行全庫測試或感官品質驗收；其餘 host/session 與 P9 要求保持未結案。
