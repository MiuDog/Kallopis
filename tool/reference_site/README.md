# Kallopis Reference Site

本工具從正式共通視覺 Markdown 與 `kallopis_theme.dart`、`kallopis_foundation.dart`、`kallopis_experimental.dart` 的 analyzer export closure 產生 GitHub Pages。通用視覺入口為 `docs/design-system/index.html`；目前框架 API 為 Flutter。網站不收錄 declarative、compatibility 或 private `lib/src` API。

`documents.mjs` 是唯一來源／路由清單，正文只在 Markdown 維護；必要來源缺失會在清理舊輸出之前失敗。`markdown.mjs` 保留表格、code、公式、相對文件連結及中文 anchor，正文同時進入搜尋索引。`verify.mjs` 檢查文件來源、實際內容、搜尋及本地 link／anchor，與既有 API 閘門一起執行。

## 本機驗證

```sh
cd flutter
flutter pub get
cd ..
dart --packages=flutter/.dart_tool/package_config.json tool/reference_site/extract_api.dart --output build/reference-api.json
npm ci --prefix tool/reference_site
npm test --prefix tool/reference_site
node tool/reference_site/generate.mjs
node tool/reference_site/verify.mjs
```

輸出位於 `build/reference-site`。本機 extraction Green 後，將 `build/reference-api.json` 同步為 `tool/reference_site/reference-api.json`；後者是 Pages 在 Krepis bindings 尚未遠端可重建期間使用的已驗證輸入。網站輸出不提交。

每個 canonical declaration 以 `sourceUri + publicName` 識別。跨 public barrel re-export 只產生一頁；同名不同來源則各自產生頁面。
