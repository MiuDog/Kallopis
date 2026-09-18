# Kallopis 產品網站與文件中心

首頁採 Planist 的導覽、主視覺與分段介紹結構，套用 Kallopis 風格 v1.0.0。設計範圍見 [網站規格](../../spec/reference-site-v1.md)。

## 本機建置

使用 Node.js 24：

```sh
npm ci --prefix tool/reference_site
npm test --prefix tool/reference_site
node tool/reference_site/generate.mjs
node tool/reference_site/verify.mjs
python -m http.server 57921 --bind 127.0.0.1 --directory build/reference-site
```

瀏覽 `http://127.0.0.1:57921/`。修改 layout.mjs、static/site.css、static/site.js 或 Markdown 後重新執行產生器。GitHub Pages 使用相同步驟，輸出位於 build/reference-site。

## 單一來源與路由

- docs、spec 及專案 README／CHANGELOG 仍是原始 Markdown；站內文件集中到 docs/ 子頁。
- 既有 api/、guides/、components/ 與 get-started.html 保留相對轉址。
- manifest.json 記錄來源映射；search-index.json 涵蓋指南、規格、元件與 API。
- link-report.json 明列原文件失效連結，網站新增斷鏈會使 verify 失敗。
- Mermaid 使用固定版本 11.4.1 CDN；無網路或圖表語法錯誤時保留原始定義。圖表使用淺紙底，避免深色模式吃掉原圖箭頭。

## 本次驗證（2026-09-12）

- Markdown renderer：5 passed、0 failed。
- 產生：129 元件、1416 API、315 指南、38 規格、2 專案文件。
- 驗證：3771 HTML（含舊址轉址）；來源覆蓋、表格、站內連結與錨點通過。
- 原 Markdown 失效連結 11 筆，完整清單在輸出 link-report.json；未以網站改寫掩蓋來源問題。
- 瀏覽器：桌面與 390px 手機首頁／文件無水平溢出；手機導覽收合；API 搜尋可找到 klp_workspace_preset；明暗、色調與陰影偏好跨頁保留；含兩個 Mermaid 的規格頁成功渲染且無 console error。
- 獨立審查抓出的選取小字及圖表深色對比均已修正。此變更未修改 Flutter 元件或幾何尺寸。

## PE-B4 驗證（2026-09-18）

- Markdown renderer：5 passed、0 failed。
- 產生：128 元件、1495 API、377 指南、47 規格、2 專案文件。
- 驗證：4060 HTML；來源覆蓋、表格、站內連結與錨點通過。
- 全站既有來源警告 43 筆；新增的初學者入口、能力清冊、固定 Catalog 轉接與 reference flows 各為 0 筆。
- 桌面與窄寬導航及可理解性仍待人類接受。

GitHub Pages 在 main 推送後自動部署；pull request 只執行同一套建置與驗證，不發布正式站。實際狀態以 Actions 為準。
