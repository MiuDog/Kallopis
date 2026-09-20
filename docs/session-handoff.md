# 當前交接

日期：2026-09-20

## 現行架構

Kallopis 已完成 [KLP-0022](../spec/decisions/KLP-0022-thin-design-system-boundary.md)：consumer 直接使用 Flutter、Kallopis theme 與公開 Widget。舊 application host、declarative runtime、renderer、固定 Catalog 遷移與相容入口均已移除，不得恢復。

唯一產品用法見 [產品使用方式](ai/product-usage.md)，架構與驗證見 [Single Architecture v1](architecture/thin-design-system/architecture.md)。

## 正文編輯器

方向維持 [KLP-0020](../spec/decisions/KLP-0020-blocknote-editor-adoption.md)：Planist → Krepis 統一介面 → BlockNote。正文、selection、undo 與 persistence 權威由 Krepis／BlockNote 持有；依 [KLP-0023](../spec/decisions/KLP-0023-product-editor-host-ownership.md)，WebView host、bridge、資產與工具移交 Planist，Kallopis 只提供共用語意外觀與視覺元件。

遷移目標是 Planist 自有 editor tooling 與 Flutter assets；Flow host 位於 `modules/flow/presentation/editor/`，不得放入 Workspace。Workspace presentation 直接把既有 Krepis session controller 傳給 `PlnBlockNoteEditor`。

畫布使用相同責任分界：Workspace presentation 把 Krepis Canva controller 傳給 `modules/canva/presentation/editor/` 中的 `PlnCanvaEditor`，不建立第二份內容權威。

## 後續工作規則

- Kallopis 唯一可寫工作樹為 `D:/Projects/Kallopis`；Krepis 唯一可寫工作樹仍是 `D:/Projects/Krepis-m0-checked-save`。
- 延伸產品功能時先由產品持有 Flutter layout、導航、狀態與流程；只有跨產品重用的視覺或互動能力才加入 Kallopis。
- 修改編輯器資產時，在 Planist 重建 `tool/editors/block_note` 或 `tool/editors/canva`，並執行相鄰 verifier；不得把 editor host、資產或 WebView dependency 搬回 Kallopis。
- 視覺與互動手感由人類接受；自動檢查只證明 deterministic 行為。
