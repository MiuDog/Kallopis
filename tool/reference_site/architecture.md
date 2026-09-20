# Thin Design System Reference Site

狀態：`TDS-REF-r2` IMPLEMENTED；視覺理解性等待人類接受。

## 目的與非目標

本 module 將三個現行 public Dart barrels 與少量 current-truth Markdown 產生為 GitHub Pages。使用者先看到 foundation/theme 的產品入口，再依 module 瀏覽全部公開 API，最後進入一個 canonical declaration 一頁的 reference。

不建立 declarative／compatibility 區，不恢復已刪除文件、Catalog migration、runtime 或 architecture atlas；不修改 Flutter 元件、public exports 或視覺契約。

## 公開輸入與輸出

| surface | entrypoint | 網站標示 |
| --- | --- | --- |
| `theme` | `package:kallopis/kallopis_theme.dart` | Stable Theme |
| `foundation` | `package:kallopis/kallopis_foundation.dart` | Stable Components |
| `experimental` | `package:kallopis/kallopis_experimental.dart` | Experimental |

輸出固定在 `build/reference-site`，包含首頁、開始使用、module 索引、每個公開 declaration 頁、搜尋資料與 `site-manifest.json`。GitHub Pages workflow 只上傳通過 verifier 的 artifact。

## Manifest 與 declaration identity

Extractor 以 Dart analyzer 一次解析三個 surface，任何 entry 缺失或 analyzer error 都失敗且不留下部分 manifest。Manifest schema v1 頂層為 `schemaVersion`、`surfaces`、`modules`。

Canonical declaration identity 是 `sourceUri + publicName`。相同來源宣告跨 surface 只保留一筆並列出全部 surface；同名不同來源各自保留。一般 URL 為 `docs/api/<module>/<name-slug>.html`；同 module 內名稱碰撞時追加 `--<primary-surface>`，仍碰撞則 extraction 失敗。

Module 由來源 URI 分成 `application／capabilities／composition／features.*／foundation／kernel／rendering／runtime／styling`；目前三個 public barrels 實際未匯出的 module 仍可在索引顯示 0，但不得從 private source 推定 public API。

## 網站與驗證責任

- API 首頁列出三個 surface、stability、import 及所有 module。
- Module 頁列出全部 canonical declarations、kind 與可達 surfaces。
- Declaration 頁列出 surface imports、source URI、signature、型別關係、constructors 與 public members。
- Search 與 site manifest 以 canonical `id` 對應頁面，不以名稱去重。
- Verifier 雙向比較 manifest、module page、declaration page、search 與 site manifest，拒絕缺頁、多頁、額外 API 頁、漏 surface、private/declarative surface 或錯誤 identity。
- Product guide、README、Single Architecture、frontend boundary、style 與 KLP-0022 是 current docs；已刪歷史文件不恢復。

## 依賴方向

```text
public Dart barrels → analyzer manifest → static generator → verifier → Pages artifact
current Markdown ────────────────────────┘
```

本機以真實三個 barrels 與 analyzer 更新 `reference-api.json`。Krepis 遠端尚未包含 Kallopis path dependency 所需 bindings，因此 Pages workflow 使用已提交、已通過本機 extraction／verification 的 manifest 執行 test、generate、verify；不得在 workflow 失敗時沿用上一版 build artifact。Dart library 不依賴網站 manifest。

## Current-stage slices

1. `TDS-REF-T`：Test Author 只寫 `tool/reference_site/test/**`，固定三 surfaces、跨 surface 去重、同名不同來源、每 declaration 一頁與 verifier failure；舊／缺實作形成 Red。
2. `TDS-REF-D`：Implementation 寫 extractor、schema、generator、verifier、靜態資產與 package scripts；不修改 tests 或 public Dart exports。
3. `TDS-REF-I`：Integration 更新 Pages／CI workflow 與操作文件，真實產生網站並驗證；視覺理解性 human-pending。

估算：14k–28k tokens／75–180 分鐘，參考已刪除 AR-V1 的 generator 規模與本輪三 barrel 掃描，historical adjusted。M1 contract Red：4k–8k／20–45 分；M2 real extractor/site：10k–22k／55–140 分；M3 workflow/artifact：14k–28k／75–180 分。若需要恢復 declarative、修改 public exports 或無法由 source＋name 決定身分即回 PLAN。

三個 slices 均已完成。2026-09-20 以三個真實 public barrels 重新抽取、產生並驗證 17 個 module、515 個 canonical declaration 頁；schema／generator／verifier tests 4/4 通過。後續 public API 變更只需更新 committed manifest 並重跑同一條產生與驗證流程。
