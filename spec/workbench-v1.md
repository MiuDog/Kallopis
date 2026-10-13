# 跨框架通用 Workbench v1

擁有模組：通用 Workbench 組合與互動契約。

階段：0→1（建立雙框架完整通用流程；沿用既有 Flutter 能力）。

目標版本：Workbench v1；Flutter、React 同步交付。

能力地平線：v1 完成單一宿主內的停靠、分割、縮放、分頁、布局保存還原、工具列／選單、命令面板及快捷鍵註冊。跨視窗拖放、浮動 panel、產品編輯與執行核心不在此版本。

Readiness：READY／使用者已於 2026-10-12 接受執行，並新增互動 docs、GUI 範例與可替換風格。未宣稱已完成 BUILD 或 push。

## 目標與權威

產品可用 Kallopis 的公開元件及註冊能力，建立類似桌面創作工具的工作台；只提供內容、狀態與事件，即取得一致的外觀、布局互動及命令入口。

本文件擁有跨框架通用行為；[研究對照](../docs/research/workbench-reference-survey.md) 提供來源證據；[正式視覺規範](../docs/design-tokens/KALLOPIS-DESIGN-MAP.md) 擁有語意與 token。[KLP-0024](decisions/KLP-0024-workbench-and-dock-layout-boundary.md) 的雙布局邊界保持有效。本規範不要求兩個框架使用相同類別名稱或執行環境。

## 需求

| ID | 版本 | 優先級 | 需求或決策 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| WB-01 | v1 | P1 | Flutter 與 React 同步交付全部通用能力。 | 每項能力皆有兩個框架的公開入口、可操作展示及使用文件，不以單框架實作代替完成。 | accepted |
| WB-02 | v1 | P1 | 一般布局與可停靠布局保持獨立。 | 一般 Row／Column／Pane 不要求 panel registry；一般 divider 不可拖曳，Dock 可拖曳調整；不將產品 Widget／React tree 序列化。 | accepted |
| WB-03 | v1 | P1 | 通用幾何支援巢狀水平／垂直布局、受限尺寸與 flex。 | 每層先扣 gutter，再分配內容；尺寸有限且非負，正常空間守恆；不足 min 總和時給出明確可預期的退化，不產生 NaN 或無限尺寸。 | accepted |
| WB-04 | v1 | P1 | Dock 沿用 Stage 與 Left／Right／Bottom 停靠區、panel registry 及合法能力限制。 | 可移動、分割、合併、收合及重新開啟 panel；禁止的位置不接受拖放；取消拖曳不提交布局。 | accepted |
| WB-05 | v1 | P1 | 分頁可選取、重排、跨群組移動與關閉，支援 pinned／dirty 呈現。 | ID 唯一，active tab 必須存在；移除空群組與 active fallback 可預期；關閉由 callback 交給產品決定，dirty 不自動丟棄產品資料。 | accepted |
| WB-06 | v1 | P1 | 可調整停靠區及群組尺寸，提供 drop feedback 與 resize feedback。 | 拖放與縮放依 constraints 解析；viewport 改變後布局仍有效；操作不誤觸內容 action，完成後輸出受控布局變更。 | accepted |
| WB-07 | v1 | P1 | 布局可版本化匯出、還原與重設。 | 分頁順序、active、群組、位置、尺寸與收合狀態 round trip；不序列化內容、函式或產品文件；未知版本／重複 ID／非法結構拒絕且保留當前狀態。 | accepted |
| WB-08 | v1 | P1 | 還原與現有 registry 的不一致必須可診斷。 | 不存在的 panel 可排除並回報，新 panel 保留可開啟入口；還原結果及警告可由產品處理，不靜默覆寫儲存資料。 | accepted |
| WB-09 | v1 | P1 | 工具列、選單、context menu、命令面板與快捷鍵共用命令註冊。 | 命令包含唯一 ID、顯示 metadata、條件及 handler；註冊可解除，重複 ID 明確失敗；解除後所有入口同步失效。 | accepted |
| WB-10 | v1 | P1 | 命令狀態支援可見、可用及非同步結果／錯誤。 | disabled 命令不能由其他入口繞過；執行失敗輸出可處理結果；執行中狀態不阻塞整個工作台；產品擁有業務副作用與錯誤文案。 | accepted |
| WB-11 | v1 | P1 | 命令面板可搜尋、鍵盤選取、執行、取消並還原焦點。 | 以已註冊命令為資料來源，空結果有回饋；方向鍵／Enter／Escape 可完成流程；不可用項目不執行。 | accepted |
| WB-12 | v1 | P1 | 快捷鍵支援平台 modifier、單鍵及 chord、作用域與條件。 | app／page／region／component 依焦點生效；chord 可取消／逾時，焦點改變不遺留 prefix；只攔截已處理的事件。 | accepted |
| WB-13 | v1 | P1 | 快捷鍵可錄製、重綁、移除、還原，並診斷衝突。 | 同作用域及條件下同鍵衝突可查詢；解析順序固定且文件化；使用者覆寫可還原預設；註冊 disposer 不移除其他 owner 的 binding。 | accepted |
| WB-14 | v1 | P1 | 不干擾文字輸入、IME 與宿主既有鍵盤能力。 | 組字中不執行工作台命令；文字欄位預設保留輸入及編輯鍵，只有明確允許的 binding 生效；repeat 行為可控制；瀏覽器／OS 保留鍵限制明示。 | accepted |
| WB-15 | v1 | P1 | 所有共用呈現讀取既有 semantic／recipe。 | Frame、Explorer、tabs、menu、button、input、gutter／feedback 與 disabled／focus 狀態接入正式規範；hover／selected 同色，不複製第二份 theme 或直接套用上游外觀。 | accepted |
| WB-16 | v1 | P1 | 元件可受控組合，保留現有公開相容性及直接框架模型。 | Flutter consumer 從 stable 公開 library 使用，React 從 package 公開入口使用；既有 Dock 與 keybinding caller 不需破壞性改寫；不匯入 private src 或重建 declarative runtime。 | accepted |
| WB-17 | v1 | P1 | 展示與 docs 完整涵蓋成功及失敗流程。 | 雙框架展示可操作拖放／分割／縮放／分頁／還原／命令／重綁衝突；docs 網頁提供能力、公開 API、合法組合、儲存責任及平台限制。 | accepted |
| WB-18 | v1 | P1 | 完整驗證後提交並 push 到現有 GitHub repository。 | 每項 P1 有證據；既有失敗單列，測試不被弱化；保留他人變更；只提交已授權且確認的路徑，記錄 branch、commit 與 push 結果。 | accepted |
| WB-19 | v1 | P1 | 所有公開元件網頁有實際互動展示。 | Flutter／React 的可呈現元件各有對應 specimen，操作會更新元件狀態；資料型別與 enum 不冒充元件。網站拒絕遺漏元件或失效展示路由。詳見互動文件規範。 | accepted |
| WB-20 | v1 | P1 | 多種 GUI 場景以公開本庫元件復刻並放入網站。 | 至少三種有官方參考的工作區，各有 Flutter／React 範例，操作 panel、tabs、命令及布局；不以截圖或手寫另一套共用元件代替。 | accepted |
| WB-21 | v1 | P1 | 元件中立，接受可替換風格檔並公開風格參數。 | 現有外觀是可替換的預設 pack；consumer 可更換 pack，不改元件原始碼；有效風格修改保持尺寸守恆、停靠合法性及組合語意。詳見風格檔規範。 | accepted |

狀態 accepted 表示來自已接受完整範圍、現行契約及契約內可逆選擇，不代表已實作。子契約見 [風格檔](style-pack-v1.md) 與 [互動文件及範例](interactive-docs-v1.md)。無新增原生多視窗或產品流程的 P1。

## 狀態與責任

布局資料只描述本 compound component 的幾何及 panel 身分。產品提供內容、registry、受控狀態、開關／變更 callback，並決定儲存位置、保存時機、命名方案及同步。庫提供布局操作、編碼驗證與還原結果，不自行使用 localStorage、檔案或遠端帳號。

命令 registry 只負責通用註冊、metadata、條件查詢及 dispatch；產品 handler 擁有業務邏輯。條件透過明確 context 資料與原生函式判斷，不要求執行任意字串、不接管產品路由或全域狀態。選單／工具列可引用 command ID，避免不同入口複製 handler 和 disabled 判斷。

快捷鍵設定可輸出可序列化覆寫資料；儲存仍屬產品。快捷鍵作用域依宿主焦點更新；必須可查詢實際命中與衝突，不依賴註冊時序造成不可診斷結果。具體公開型別與同級排序在 PLAN 定義並納入跨框架驗收。

## 完整核心流程

Consumer 註冊 panel 與 command，提供初始布局；使用者拖放分頁、分割群組、調整尺寸，並從工具列、選單、面板或快捷鍵執行同一命令。產品取得布局匯出資料後儲存；重新建立工作台時還原，取得成功結果或明確診斷。解除註冊後，過期命令與快捷鍵不再觸發。

## 範圍外

- 3D 場景、程式碼／正文編輯器、終端執行核心與其資料模型。
- 產品畫面模板、固定業務功能順序、路由、專案儲存與文件 undo。
- 跨視窗拖放、原生浮動 panel、擴充套件宿主與任意產品 UI tree 的驗證。
- 重新設計已接受視覺；建立 workbench 專用第二份 token 權威。

## 驗收證據

PLAN 必須將上述公開行為對應到兩個框架的 owner 與證據。尺寸守恆、布局 round trip／非法輸入、命令生命週期與錯誤、chord／作用域／衝突是必要 deterministic evidence；必要新測試由獨立 Test Author 擁有。現有 CI 與發布閘門保留，既有失敗參照 [整合紀錄](../docs/architecture/multi-framework-verification.md)。

可操作展示需實際確認鍵盤、焦點、拖放及狀態接線；尚未觀察的項目不得宣稱通過。外觀與手感由人類判斷，本階段不新增主觀打磨門檻。
