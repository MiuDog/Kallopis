# Thin Design System Reference Site

本工具從 `kallopis_theme.dart`、`kallopis_foundation.dart`、`kallopis_experimental.dart` 的 analyzer export closure 產生 GitHub Pages。網站不收錄 declarative、compatibility 或 private `lib/src` API。

## 本機驗證

```sh
flutter pub get
dart run tool/reference_site/extract_api.dart --output build/reference-api.json
npm ci --prefix tool/reference_site
npm test --prefix tool/reference_site
node tool/reference_site/generate.mjs
node tool/reference_site/verify.mjs
```

輸出位於 `build/reference-site`。本機 extraction Green 後，將 `build/reference-api.json` 同步為 `tool/reference_site/reference-api.json`；後者是 Pages 在 Krepis bindings 尚未遠端可重建期間使用的已驗證輸入。網站輸出不提交。

每個 canonical declaration 以 `sourceUri + publicName` 識別。跨 public barrel re-export 只產生一頁；同名不同來源則各自產生頁面。
