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

## 受控操作 WB-DOCK-OPS-r1

READY；對應 WB-04／05／06／16。操作 utility 接收目前 layout、完整純 policy registry 及單一 action，返回深層不可變 layout／changed。先依 STATE-r1 驗證當前布局及清冊；若有 missing panel 或 capability 衝突拒絕，不能藉操作默默修復原資料。所有 request 欄位嚴格驗證；非法請求整份拒絕，原始資料及 registry 不修改。changed 以完整保存值是否改變為準，no-op 仍回傳與 caller 隔離的不可變快照。Flutter FormatException／React TypeError；純 operation 無 UI、theme、storage 或非同步 callback。

- select：指定已放置 panel；更新該 group active，不改 area visibility。
- move／open：指定 panel 及 destination。move 要求已放置；open 要求 registry 存在且未放置。destination 為 tab（既有 area／groupId／index）或 group（area／新的 groupId／index／extent）。index 是移除來源後的最終插入位置，必為整數且在0～目標列表長度，不 clamp。tab 插入分頁，group 插入一個新群組，extent 有限正數；new groupId 不能與操作前任何 group 重複。移動到原群組就是重排，即使只有一個 tab 也保持 group；成功目標 area 設可見，active 為移入 panel。來源變空刪除 group，來源 active 被移走取剩下第一個；來源 area 其他欄位照原值保留。group extent 是偏好尺寸；viewport／divider 的實際配額由 UI geometry 處理，不在此假裝完成 resize constraint。
- merge：指定不同的 sourceGroupId／targetGroupId／index，按來源原 tab 順序插入目標，目標 active 取來源 active，刪除來源 group；index 對原目標 tabs 計算，target area 設可見。所有移入 panel 必須有 target area 能力。
- close：指定已放置 panel 及 approved boolean。false 是不改資料的合法 no-op；true 移除 panel，空 group 刪除，active fallback 同上。approved 必由產品／UI 的關閉 callback 決定；dirty／pinned 由產品面板 metadata 提供及呈現，不寫入 layout，也不在純 utility 自行決定業務關閉。純 close 不刪除 registry，所以 panel 仍可 open。
- visibility：指定 area 與 isVisible boolean，保留全部資料及偏好尺寸，供 collapse／reopen。
- resizeArea／resizeGroup：指定 area／groupId 與 extent。area extent 有限非負，group extent 有限正數；只更新偏好尺寸，UI 依當前 constraints／viewport 限制後提交。未知 group／panel／area 拒絕。

驗收：同群重排、跨區 tab move、新 group split、merge順序／active、empty fallback、collapse／reopen、close denied／approved／再open、capability／缺清冊拒絕、全量不修改 caller／不可變及非法 index／identity／geometry。每端 native API 由各自 module contract 定義；後續 Widget／React component 使用同一操作語意。取消拖曳不呼叫 utility／onLayoutChanged；hover 不提交布局。

## 有限面板前置契約 WB-PANEL-GEOMETRY-r1

READY；對應 SP-05／WB-03／04 的庫內 chrome 尺寸責任。Flutter PanelFrame 原本 Expanded 正文要求有限高度，此 slice 保持這個宿主前提及全部公開 constructor，不新增通用 tree 或產品內容權威。PanelFrame 在有限寬高下：外距每軸最多該軸一半；內框所有槽非負有限、總高度不超過內框。header／footer 為語意偏好高度且 minimum=0、flex=0；content minimum=0、preferred=0、flex=1；gutter=0，直接使用既有公開 linear resolver 語意。正常空間下保留標頭及底列高度，其餘正文；不足時 chrome preferred 按共通比例收縮，內容可為零。保存布局、theme 及產品狀態不因 render 修改。

PanelFrame 與各槽必裁切；庫自己的 PanelHeader 不以普通 Row／Column 固定尺寸造成 overflow。文字 title／label 保留，垂直不足時同一內容節點可捲動，文字水平仍 single-line ellipsis；leading、content、actions 次序與 dragRegionBuilder 包覆範圍不改，actions 可在不足時縮配及裁切，不用 remount 或任意移除取代合法 geometry。PanelHeaderFrame 的 horizontal／vertical semantic inset、PanelFooter 的 resolved inset 在有限軸上按比例限制至可用軸，保留既有 custom padding 及 RTL 解譯。card inner radius 至少0，合法 style 的 stroke 超過 card 不產生負半徑。

內容節點在 resize 與合法 theme 改變後保持 Element／State 身分；ScrollController 與 Scrollbar 契約不改。任意產品內容需自行處理其內部排版；本庫不驗證產品整棵 Widget tree。不承諾可見可用性或視覺感官接受。Dock root／group geometry、DockHeader overflow menu 與拖放 callback 不在此前置 slice 宣稱完成；後續 Dock slice 依這個公開 PanelFrame 前提分配有效槽。

驗收：default header/content/footer height、正常無 chrome、短及零尺寸守恆、巨大合法 margin/chrome/inset、stroke>radius、庫 PanelHeader title/label/actions 在窄低約束無 Flutter layout exception、RTL/custom footer padding、content state 保留。必要獨立 Widget checks 只觀察公開元件與 constraints，不檢查私有 tree 或 screenshot。
