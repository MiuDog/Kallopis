# Workbench Dock 保存契約

修訂 `WB-DOCK-STATE-r1`；READY。對應 WB-04／07／08／16，保留 KLP-0024 的固定 Stage 與 Left／Right／Bottom；Stage 內容由產品提供，不寫入保存資料。此契約先完成保存邊界，拖放、分頁及尺寸 UI 仍由各框架 Dock module 接續。

## 格式與責任

JSON 只有 `schemaVersion: 1` 與 `areas`；areas 必含 left、right、bottom。每個 area 必含 `axis`（horizontal／vertical）、`isVisible`（boolean）、`extent`（有限非負數）及 `groups`。group 必含 `id`、`panelIds`、`activePanelId`、`mainAxisExtent`（有限正數）。所有層拒絕缺欄、未知欄與錯誤型別；id 必為非空、非純空白字串，保留原始字元。群組 id 全域唯一；panel id 在全部群組中只能出現一次。群組必非空、active 必在自己的 panelIds；空 area 合法，visible 與 extent 照原值保留。axis 不固定於某個 area，保持現有 Flutter caller 相容。

codec 不寫入檔案或瀏覽器 storage，也不包含內容、Widget、函式、產品 dirty／pinned 狀態、命令或 style。encode 不做 registry reconciliation；只驗證並保存當前布局，輸出同一 schema。所有解析／輸出／結果集合與原始輸入分離；原始 layout 即使來自可變 lists 也不得被修改。

restore 先完整驗證保存資料，再與產品當前 registry 比對。registry policy 只有 id、allowSide／allowBottom（兩者預設 true）；registry id 重複或非法時拒絕。已存在 panel 若違反其 area capability，整份拒絕。缺少的 panel 按 left／right／bottom、group／tab 原始順序移除並回報 missingPanelIds；空 group 刪除，原 active 被移除時選剩下的第一個；不自動改 visible／extent／axis。availablePanelIds 按 registry 順序列出所有未放置 panel，包含新增及原本未放置項目，供產品自行開啟。不能自動把新 panel 填入保存布局。結果 layout 深層不可變。

非法 JSON、schema version、結構、數值、identity 或 capability 都是明確錯誤；Flutter 使用 FormatException，React 使用 TypeError。codec 不接收也不替換產品目前 state，產品只在成功後採用結果；失敗仍保留既有 state。reset 是產品提供預設 layout，不另造第二份預設權威。

## 公開介面

Flutter foundation 新增 `KlpDockPanelPolicy({required String id, bool allowSide=true, bool allowBottom=true})`、`KlpDockRestoreResult`（layout／missingPanelIds／availablePanelIds）與 `KlpDockLayoutCodec.encode(KlpDockLayoutData)` → String、`KlpDockLayoutCodec.restore(String source, {required List<KlpDockPanelPolicy> panels})` → result。既有 const model／copyWith／Widget API 不改；consumer 從自己的 KlpDockPanel registry 投影 policy。

React 對應相同 JSON wire contract，native 型別不引用 Flutter；其 BUILD 另由 React module packet 固定公開函式名稱與 owning paths。兩端必以明確同一份手寫 JSON 成功及拒絕樣本驗證跨語言，不依各自 encode 自我 roundtrip 取代格式驗證。

## 驗收

保存順序、active、axis、visibility、extents roundtrip；手寫 schema；未知版本／欄位／重複 identity／非法 active／NaN／Infinity／負數／零 group extent 拒絕；registry reconciliation／capability／缺少 active fallback；來源與結果隔離、不可變。無感官驗收，也不宣稱目前 Dock UI 已完整完成。
