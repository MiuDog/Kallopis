# 正式 bundle 的確定性驗收

版本 KBF-WEB-TEST-r2a。Tool Test Author 只持有 verify_blocknote_flow_references.cjs、verify_blocknote_operation_gate.cjs 及 fixtures/blocknote_flow_protocol.json；既有 template 驗收唯讀。測試使用獨立 browser context、localhost 正式 build 輸出與自建文件，不接觸使用者筆記。共享 fixture 原始權威由 Krepis Test Author 持有，位元組一致複製後驗證相同 schema。驗收依 ../docs/architecture/blocknote-flow-pairing.md 與其 r2a wire 唯一來源；不讀或仿照產品內部實作。兩份腳本接受 playwright 模組路徑、browser executable 與 bundle root 作命令列參數。

可測 custom schema round-trip、投影不變更正文、單交易列命令與真實 undo/redo、非法位置零變更、有序 receipt、所有正文入口 gate、重載 history 世代與 unlock 後新編輯恢復。原生 Windows WebView／IME手感及視覺品質為 human-pending，不用截圖分數冒充驗收。
