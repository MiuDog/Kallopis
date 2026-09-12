# Reference site

本庫的 GitHub Pages 參考網站由版本庫內的文件產生；網站產物不是手動維護的真相來源。

## Sources

- `docs/`：全部 Markdown 文件皆會保留目錄結構產生為 Documentation 頁面。
- `docs/architecture/src/`：逐一對應到來源檔的 API reference，不重複產生為 Documentation 頁面。
- `spec/component-inventory.md`：元件清單、分類與容器判定。
- `tool/reference_site/assembly_examples.json`：容器元件的 Dart 組裝範例。

## Local build

```powershell
node tool/reference_site/generate.mjs
node tool/reference_site/verify.mjs
python -m http.server 4173 --directory build/reference-site
```

開啟 `http://localhost:4173` 後，可從左側 navigator 依元件分類、API 領域或搜尋進入頁面。

## Publish

`.github/workflows/pages.yml` 會在推送至 `main` 時產生並部署 `build/reference-site` 到 GitHub Pages；pull request 只建置與驗證，不會發布。

## Maintenance

新增或刪除 public component 後，先更新 component inventory；新增容器型元件時，也在 `assembly_examples.json` 補上只使用公開入口的 Dart 範例。CI 會重建網站並檢查每個 inventory 元件、每份 API 文件與每份 guide 都有對應 HTML 頁面。
