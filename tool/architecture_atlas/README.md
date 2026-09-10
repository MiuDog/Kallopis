# 架構圖集生成器

讀者是接手 Kallopis `lib/src` 的開發者。此工具以 Dart analyzer 10.1.0 的語法樹逐檔擷取宣告，產生 `docs/architecture/src/` 的逐目錄入口與逐檔細節；不修改產品程式碼。

## 使用

在本目錄先執行 `dart pub get --offline`（本機須已有鎖定套件；否則執行 `dart pub get`），再從專案根目錄執行：

```powershell
python tool/architecture_atlas/generate.py --dart D:/flutter/bin/dart.bat
python tool/architecture_atlas/generate.py --dart D:/flutter/bin/dart.bat --check
```

`--dart` 可改成現有 SDK 路徑；預設使用 PATH 的 `dart`。需要 Python 3.10 以上，Python 部分只使用標準函式庫。既有圖集會先完整備份至系統暫存目錄，再重建；備份位置印在輸出。`--check` 在獨立暫存目錄重建後逐位元比較，不修改現有圖集。

## 輸出與證據

- 每個實際目錄（包括空目錄）都有 `README.md`。
- 每個 Dart 檔案都有同名 Markdown：directives、宣告與關係、public／private 成員簽章與來源行號。
- `manifest.json` 列出來源 SHA-256、檔案／目錄清單與圖數；每張圖最多 12 個節點。
- `briefs/<第一層目錄>.md` 是人工閱讀摘要的保存位置，只注入該第一層目錄頁。相對連結須以生成後頁面為基準。

## 分析界線

這是未解析型別的靜態 AST 分析。只聲稱來源明寫的 import、export、part、extends、implements、with 與 on；不聲稱呼叫圖、執行期物件擁有權、狀態轉移或渲染順序。private 依底線名稱，並列類別所屬可見性；public 宣告是否經公開 library 匯出仍須讀入口。

簽章保留函式與方法參數；建構子省略初始化列表；欄位只呈現明寫型別與名稱，未明寫型別以 `(inferred)` 標註。註解摘要來自來源，宣告上限 700 字元、成員上限 350 字元。遇到不支援的宣告種類或語法診斷立即失敗，避免靜默遺漏。

Mermaid 圖碼由主交付流程另行渲染驗證；生成成功不代表圖形已視覺驗收。
