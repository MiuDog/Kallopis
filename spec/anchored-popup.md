# 通用錨定 popup

Owning module：`features/workspace` 的 `Workspace.AnchoredPopup` 語意能力。Stage：0→1；公開契約：`POP-V1-r1`，主目錄整合：r1b。公開能力已實作；使用與驗證見 [consumer guide](../docs/ai/anchored-popup-model.md) 及 [交付紀錄](../docs/architecture/anchored-popup-delivery.md)。原生手感保留人工驗收。

## 目標與接受依據

由宣告式 trigger 開啟錨定內容，可在保持開啟時更新清單、命令及處理結果。Consumer 擁有資料、open 與業務操作；Kallopis 擁有呈現、焦點及受限組裝。

使用者已接受沿用既有元件預設外觀，並授權本任務指揮完成 [分派計畫](../docs/architecture/flow-agent-dispatch-plan.md)。依 AGENTS 的自動接受模式，以下以既有能力及最小可逆互動規則收斂實作所需契約；不擴張為新視覺變體。來源：[SID-K-POPUP-01](../../planist/docs/planning/first-release-component-gaps.md)、[E 收尾](../../planist/docs/planning/explorer-e-closeout.md)。

## 需求

| ID | 版本 | 優先級 | 需求 | 可觀察驗收 | 狀態 |
| --- | --- | --- | --- | --- | --- |
| POP-01 | v1 | P1 | 恰一個既有 action 類 trigger，由其實際 bounds 錨定；trigger 的啟用僅由 popup 開關契約處理，不同時附第二個業務 onPressed/action | pointer／鍵盤各只發一次開關事件；拒絕雙重處理、座標及原生 Widget 輸入 | accepted |
| POP-02 | v1 | P1 | Consumer 的 open 是唯一權威；trigger 再按、外點、Escape 只發關閉請求，consumer 回填後關閉 | 同一宣告身分可受控顯示／關閉；未回填不偷偷改成另一個 open 狀態；事件帶明確原因 | accepted |
| POP-03 | v1 | P1 | 恰一個 panel；受限語意次序為可選標題 → 可選清單 → 可選操作 → 可選回饋；至少有一個非標題區段。清單與操作為平面資料列，拒絕任意容器、child renderer 及 popup 巢狀 popup | role／數量／順序及巢狀正負例可驗證；不把產品功能順序寫入本庫 | accepted |
| POP-04 | v1 | P1 | 清單列可有主要事件、current／disabled 投影及既有共用 commands；只容許一個活躍的子命令選單 | current 僅是資料投影，不連動 Explorer selection；停用列不執行；子選單使用既有命令規則 | accepted |
| POP-05 | v1 | P1 | 支援 loading／ready／error／result 的狀態回饋；error/result 必須有非空訊息。保持 open 時可更新內容、disabled 與結果；內容 action 不自動關閉 | loading → error/result 原地更新、不丟目前清單；執行命令本身不關閉 popup | accepted |
| POP-06 | v1 | P1 | 開啟時進入首個有效控制，無可用控制時焦點停在面板；Tab 在開啟的 popup 內循環，關閉後回到有效 trigger；失效時使用宿主既有有效焦點回退 | expanded 語意、焦點進入／循環／返回、錯誤與結果語意回饋可由程式核對 | accepted |
| POP-07 | v1 | P1 | 開關不派送產品 navigation、Stage 或 Explorer selection；內容事件的業務效果由 consumer 擁有 | 純開關期間產品 selection／navigation callback 計數為零 | accepted |
| POP-08 | v1 | P1 | 沿用現有 overlay／selection semantic 的表面、間距、陰影與互動；方向感知地錨定下方起始側，空間不足翻到上方並限制在 viewport | 無 consumer style／像素參數；換 primitive preset 仍經 semantic resolver；位置與邊界規則可檢查 | accepted |
| POP-09 | v1 | P1 | trigger 移動時跟隨；trigger 消失時不留下可互動的孤立 overlay，發 anchorUnavailable 關閉請求，open 仍由 consumer 回填 | 移動重定位；失去有效錨點後不接受孤立內容事件，焦點安全回退 | accepted |
| POP-F1 | 後續 | P3 | 更多 trigger 類型、hover 開啟、placement／尺寸／動畫選項、多層 popup | 不列入本版 API 或 BUILD | deferred |

## 邊界與介面

- Kallopis 定義 trigger／panel／list／actions／feedback 的通用角色與合法組裝，不提供 Planist 專案模板、固定業務命令順序或 storage。
- Consumer 提供 open、列資料、current／disabled、回饋及事件接收者；傳回下一份有效宣告才採用新資料。相同身分更新不得重建正文 session 或導航。
- 內容只使用本庫列明的資料與語意角色，typed callback 不開放 renderer、Flutter Widget、HTML、style 或任意 child。PLAN 決定具體類別命名，不能擴張本表接受的角色。
- 跨 module 僅交付公開／具名契約；不建立第二份 theme、environment 或 l10n。新文案若確有必要由既有 localization owner 配對。
- 子命令選單的焦點／dismiss 必須與 popup 一起配對；點擊自己的子選單不視為外點。關閉子選單不自動關閉 popup。
- 當前宣告的錨點暫時零尺寸或完全移出 viewport 時，不保留可互動面板；若 consumer 保持 open，錨點恢復後重新呈現。Consumer 明確移除整個宣告、使 lease 退役時，不呼叫退役回呼。父 popup 關閉時僅移除自己的子選單／輸入／確認 route。
- 拒絕不合法宣告，保留前一有效畫面與既有資源；不靜默丟列或修正 consumer 的 selection。

## 驗收與交接

所有 P1 均有上表的 deterministic 驗收；PLAN 需要將同一受限宣告、語意／bound、renderer 與 consumer 公開入口配對後，才發各 module 的精確 Packet。新測試由獨立 Test Author 保護。

沿用外觀的實際 Catalog、原生指標／鍵盤／焦點手感供人類檢查；不新增 golden 或 AI 視覺评分。未觀察的原生平台不得宣稱已驗收。

沒有 open P1；後續能力只保留 POP-F1 的邊界，不在当前 stage 規劃。DEFINE READY 不等於已解除 SID-K-POPUP-01；需公開能力、必要證據與 E 接線後才結案。
