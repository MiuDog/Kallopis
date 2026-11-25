# Kallopis 雙區工作台

識別名稱：`sidebar-stage-workbench`。狀態：使用者已確認並要求保存為可複製的組裝模板，2026-10-17。

之後使用者提到「Kallopis 雙區工作台」、「雙區工作台」或 `sidebar-stage-workbench`，即指本模板；直接複製本目錄的 TSX／CSS 到產品專案，再填入 sidebar、stage、header。不重新設計布局、不重問已確認的組裝選項；只有使用者另有指定時才調整。不是新增公開套件 API，也不要求複製 Unico 的業務資料或導覽名稱。

## 複製入口

- [SidebarStageWorkbench.tsx](SidebarStageWorkbench.tsx)：React 元件及三個產品內容插槽。
- [layout.css](layout.css)：本布局幾何，沿用 Kallopis 的視覺與語意值。
- [architecture.md](architecture.md)：實際組成、呼叫鏈與驗證。

Consumer 需安裝支援 `KlpFrame surface="raised"` 的 `@kallopis/react` 與 React 19，字型與樣式由套件提供。將宿主根元素設為全高；模板內已有預設主題 Provider，嵌入既有 Provider 時在產品副本移除重複 Provider 並保留宿主高度。直接以 `<SidebarStageWorkbench sidebar={navigation} stage={content} header={headerItems} />` 組裝。多個 header 項目請用 ReactNode 陣列傳入，每項自動包一個微立體 Panel；省略 header 仍保留空間，不附帶「高度檢查」測試文字。

## 接受基線

樣式及合法限制由[正式 Header 配方](../../docs/design-tokens/recipes.md#側欄與-stage-header2026-10-17-使用者已確認)擁有；本模板是其可複製實現。以下為目前組裝尺寸，更新須同步核對程式與正式規則：

Panel 強調方式與 Rail 組合另遵守[正式 Panel 呈現契約](../../docs/design-tokens/recipes.md#panel-強調與現代生產力呈現2026-11-01-使用者已確認)：以微立體陰影／亮邊呈現，不使用深色外框包住淺色內部。本輪為規範記錄，未修改或重新驗收本模板程式。

| 項目 | 初版值／行為 |
| --- | --- |
| 版面 | 僅 sidebar 與 Stage 兩區；不增加全域頂欄、右側欄或底部區 |
| 主題與 Panel | Kallopis 預設主題；sidebar、Stage、Stage header 內所有直接項目皆用微立體 Panel |
| Sidebar header | 無軟體名稱；收合／展開方形按鈕 24×24px |
| Sidebar 元件留白 | 上／左／右 8px，底部 4px |
| 分割帶 | 虛線上／下各 4px；低對比、細虛線；元件底部到虛線中心 8px |
| Header 總高 | 8 + 24 + 4 + 4 + 4 = 44px；由元件及留白推導，不以縮小元件滿足新留白 |
| Stage header | 容器透明，內部元件頂緣對齊 sidebar 外框頂緣；元件高 36px，至 Stage 留白 8px |
| 對齊 | Sidebar 虛線中心對齊 Stage header／Stage 之間留白中心 |
| 產品責任 | 導覽、選取、路由、資料、未保存內容及功能皆由 consumer 提供 |

來源：Unico 已接受布局，最新畫面與 DOM 證據見該 repo 的 `docs/verification/header-equal-spacing-44px-2026-10-17.png`。此模板按使用者明確要求保存供後續複製；不宣稱已有第二個產品使用，也不提升為固定業務模板。

## 註記限制（2026-10-18）

遵守[產品畫面的註記限制](../../docs/design-tokens/recipes.md)：複製模板後不得加入「本機流程／模擬清單／前端編輯器／儲存位置／未接引擎」等常駐工程說明；Header 只承載實際操作，沒有操作時保留空間。限制寫入產品文件，錯誤及操作回饋仍正常呈現。


## 2026-10-18工作台修訂

依Unico01使用者需求，collapsed完全隱藏sidebar（不保留窄列），展開按鈕出現在Stage header最左。sidebarHeader／sidebarFooter／windowControls為產品slot；edgeToEdge=true讓無限畫布滿Panel且0 padding，其他Stage左右採contentInset×2。

需要桌面／設定組裝時，同時複製相鄰desktop-workbench模板目錄以保留相對CSS依賴。SidebarBanner提供左內容／右按鈕列slot；WindowToolbar提供三個純回呼，不可在模板內加入Electron、team、帳戶或Store。使用者已接受的header／divider幾何不變。
