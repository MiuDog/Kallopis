# Kallopis 0.8.0 圖示資產來源

Kallopis 的所有介面圖示已統一替換為 Flaticon UIcons 的 Regular Rounded 字型，
不再散佈或載入 Lucide、SVG Repo 或內製 SVG 圖示。

## 上游版本與取得方式

- 指定來源：[Flaticon Top icon fonts](https://www.flaticon.com/icon-fonts-most-downloaded)
- 官方安裝文件：[Flaticon UIcons Get started](https://www.flaticon.com/uicons/get-started)
- 官方文件指定套件：`@flaticon/flaticon-uicons` 3.3.1
- npm tarball integrity：`sha512-WN2zuECCdjuGB[...]uidevGQ4OJORg==`
- 使用風格：Regular Rounded（CSS prefix `fi-rr`）
- 原始 webfont：`uicons-regular-rounded-J3WOUERV.woff2`
- Flutter 資產：`assets/fonts/FlaticonUIcons-RegularRounded.ttf`
- TTF SHA-256：`e718df7cfcea3e10b7307ff9c3689102d3b73252a6d6e73f43e25503f68e4cf5`

TTF 僅以 FontTools 將官方 WOFF2 容器轉為 Flutter 桌面端可穩定載入的 sfnt，
沒有改動 glyph、字碼或輪廓。`KlpIcons` 的既有公開語意名稱保留，字碼改為對應的
`fi-rr-*` glyph，因此消費端只需要重新編譯，不需要改呼叫點。

## 授權與歸因

- 授權原文：`assets/fonts/LICENSE-FLATICON-UICONS.txt`
- 授權檔 SHA-256：`fb5651df9951685a33e6e8a450d9cc1194956d641b46e2521493c5d7395ece4f`
- 免費方案歸因文字：[Uicons by Flaticon](https://www.flaticon.com/uicons)

Flaticon 官方頁面明示免費使用需要歸因；若產品沒有有效 Premium 授權，發布版本必須在
關於、致謝或其他可見 credits 區域保留上面的歸因連結。

## 發布閘門

- `KlpIcon` 必須指定 `fontPackage: 'kallopis'`，避免消費端靜默 fallback。
- 更新套件版本、字型檔或任一字碼時，必須同步更新本文件與 SHA-256 測試。
- 不得重新加入 `assets/icons/ui_oval/` 或任何非 Flaticon 圖示來源。
