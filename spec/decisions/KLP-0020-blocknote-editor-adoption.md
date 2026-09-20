# KLP-0020：採用 BlockNote 作為正文編輯器

狀態：Implementing（2026-09-20）。正式產品接線已完成；原生 IME、讀屏與完整資料轉換仍待人類／整合驗收。

## 唯一路徑

```text
Planist
	→ Krepis BlockNote session controller
	→ Planist Flow component／WebView host
	→ Planist packaged BlockNote Web asset
```

BlockNote 擁有正文模型、排版、selection、交易與 undo／redo。Krepis 擁有文件身份、session、保存與引擎協定。依 [KLP-0023](KLP-0023-product-editor-host-ownership.md)，Planist 擁有 Flutter WebView host、本地資產、封閉 bridge、文件選擇、產品流程、離開保護與錯誤處置。Kallopis 只提供宿主使用的共用語意風格與視覺元件。

現行產品不提供自研正文引擎、Markdown 中介正文、第二個 WebView host 或執行期切換選項。舊格式若仍需讀取，只能經明確的一次性轉換匯入 BlockNote 文件；轉換失敗必須保留原檔並回報，不得把舊引擎恢復成可選產品路徑。

## 公開邊界

- Planist 持有 `KlpBlockNoteSessionController` 與產品 callback，並把 controller 傳給獨立 Flow component 目錄中的 `PlnBlockNoteEditor`。
- `PlnBlockNoteEditor` 不接受任意 HTML、JavaScript、局部 style 或 consumer renderer。
- Web 資產由 Planist 的 editor tooling 建置到 Planist Flutter assets。
- 資產解析、開啟附件與開啟 reference 透過 typed callback 回到產品 owner。
- 編輯器選單由 Flutter 端 `KlpMenu` 呈現；WebView 只送出選項資料與錨點位置。

## 驗收

- Planist 可在唯一 Flutter 架構下建立 BlockNote session 並掛載產品擁有的 editor component。
- bridge 完成 configure、open、message、snapshot、asset、reference 與 menu 往返，不維持第二份即時正文。
- 保存失敗、載入失敗與 WebView 環境失敗可回報，且不得靜默丟失內容。
- 中文 IME、系統剪貼簿、讀屏及實機互動手感由原生驗收確認；headless 或 Widget test 不替代感官證據。

## 代價

接受 WebView、資產包、橋接與格式轉換成本，以換取上游成熟編輯能力。BlockNote MPL notices 必須隨正式資產散佈；若未來需要付費功能，另作授權決策，不在現行架構加入替代引擎。
