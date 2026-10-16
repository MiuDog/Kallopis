# Kallopis Reference Site

主要指南直接維護在 repository 的 Markdown，可在 GitHub 或本機 Markdown 預覽器閱讀並使用相對路徑嵌入圖片。現有網站與展示保留，本工具繼續提供本機產生與驗證。

線上 Pages 發布預設暫停。日後確認託管方案後，將 repository Actions variable `KALLOPIS_PAGES_DEPLOY` 設為字串 `true`，才會執行 Pages 設定及部署；既有建置、驗證與 artifact 步驟繼續保留。保留網址為 `https://technis-toolbox.github.io/Kallopis/`。

本工具從正式共通視覺 Markdown 與 `kallopis_theme.dart`、`kallopis_foundation.dart`、`kallopis_experimental.dart` 的 analyzer export closure 產生 GitHub Pages。通用視覺入口為 `docs/design-system/index.html`；Flutter API、React 專屬互動元件與兩框架 GUI 場景共同構成網站。網站不收錄 declarative、compatibility 或 private `lib/src` API。

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

以上產生規範與 Flutter API 文件。完整互動網站另需建置兩框架 example；從 repository 根執行：

```sh
npm ci --prefix react
npm run build --prefix react
npm run build:example --prefix react
node react/scripts/reference-components.mjs
cd flutter/example
flutter pub get
flutter build web --release --no-tree-shake-icons --base-href /Kallopis/examples/flutter/
cd ../..
node --test tool/reference_site/test/react_specimens.test.mjs tool/reference_site/test/react_scenarios.test.mjs tool/reference_site/test/flutter_scenarios.test.mjs
node tool/reference_site/generate.mjs --react --react-scenes --flutter-scenes
node tool/reference_site/verify.mjs --react --react-scenes --flutter-scenes
```

`--react` 讀公開 React 擷取清單與 example registry，驗證每個可渲染元件的專屬路由並複製 bundle。`--react-scenes` 與 `--flutter-scenes` 讀各框架擁有的場景清單，生成 GUI 頁面與 iframe；React 場景須同時啟用 `--react`。缺少必要清單或 bundle 時生成失敗並保留舊網站。

網站入口為 `docs/react/components/index.html`、`docs/react/scenarios/index.html` 與 `docs/flutter/scenarios/index.html`。README 由既有 registry 生成 `docs/guides/README.html`，正文同時加入搜尋。Flutter API 的 `renderable` 標記只表示型別可渲染，不能用來宣稱全部元件專屬展示已完成。

Pages 在 `main` 的 push、pull request 或手動觸發時建置；pull request 只驗證，其餘觸發在 `KALLOPIS_PAGES_DEPLOY=true` 且建置通過時發布。流程見 [pages.yml](../../.github/workflows/pages.yml)，遠端結果須以實際 Actions run 為準。

輸出位於 `build/reference-site`。本機 extraction Green 後，將 `build/reference-api.json` 同步為 `tool/reference_site/reference-api.json`；後者是 Pages 在 Krepis bindings 尚未遠端可重建期間使用的已驗證輸入。網站輸出不提交。

每個 canonical declaration 以 `sourceUri + publicName` 識別。跨 public barrel re-export 只產生一頁；同名不同來源則各自產生頁面。
