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

## 有限 Dock 幾何 WB-DOCK-GEOMETRY-r1

READY；對應 WB-03／04／08、SP-05。Dock 宿主需有限非負寬高；render 不提交 onLayoutChanged，不修改保存的 area/group 偏好、順序、active 或 visibility。所有 actual rect 與 gutter 有限非負且位於宿主；內容槽與把手 paint 裁切。左區全高；contentHeader 跨中央及右區，最高宿主高度；右區在頂列下方；Bottom 只在中央的 Stage 下方。不存在 floating/cross-window 模型。

root 水平使用既有 linear resolver：可見且非空 side item 的 minimum/max 為產品 area constraints、preferred 為保存 extent、flex0；中央 minimum0/preferred0/flex1；gutterCount 是實際可見 side 數，gutter 是 style resizeHandleExtent。視窗不足時共通 minimum 比例退化，無回寫偏好。header clamp0..height，其下中央垂直：Stage min0/preferred0/flex1；可見非空 Bottom min/max 為constraints、preferred保存extent/flex0；只保留一個有效gutter。hidden/empty area 不占正文配額，邊緣 reopen handle 不預留空間，但厚度不得超過各軸可用尺寸、不得產生負座標；右邊與底邊在 header 下方。

每區 groups 使用同一 resolver，gutterCount=n-1；沿用既有 logical minimum：vertical32／horizontal120，這是目前操作限制，不是另造品牌 theme，完整recipe参数化仍待既定style stage。所有非末group preferred 為保存mainAxisExtent/flex0，最後group minimum/preferred為logical minimum/flex1，延續正常空間最後群組填剩餘的語意。preferred 總和不足預算時按共通規則縮配，不能以順序優先剝奪後組；不足minimum同比例退化。每個 group rect、把手、offset、resize pairStart及split drop檢查都使用同一actual extents/gutter。僅render可有零槽，保存group偏好仍正值。

area resize 使用當前 effective handle、root可用預算，扣另一可見side與把手或header，requested有限時在logicalmin/max及實際可用上限內提交；上限小於min時不提交尺寸（低於closeThreshold仍可collapse），不以視窗變窄自行覆寫偏好。group pair不足兩個logical minima時保持no-op；正常pair操作只改相鄰兩組偏好且守恆，不改其他組。

DockHeader 保留公開constructor及extent32相容常數；native preferred高度讀既有chromeTab，最終由PanelFrame槽限制。overflow slots 的计算必避免iconButton=0或巨大有限尺寸的除零/Infinity floor；全部actions仍可由既有more menu到達，保持原enabled/label/callback語意。resize indicator 的loose-tight可能負值，須clamp0，並在有效handle槽裁切。水平group的merge header判定讀實際PanelFrame margin/header配額，不能固定假設32。Stage drop提示只畫實際Stage邊界，stroke限制至該槽，不能畫整個Dock根邊界。

本slice不改保存格式／pure action／close metadata、hover/cancel提交策略或產品content內部；這些仍依OPS-r1後續接入。驗收含正常root/header/groups配額、左右及上下shortage、巨大/零handle、zero容器、hidden/empty、style inverted indicator、Header actions zero icon slot、area/group pointer resize與非回寫、內容State保留。獨立Widget checks只觀察caller probes與公開gesture，不讀私有RenderBox型別，不做golden。

WB-DOCK-GEOMETRY-r1 的area maxExtent保留既有constructor可用的正Infinity，native adapter視為沒有邏輯上限，傳linear maximum=null；minimum及保存preferred仍需有限。實際resize最大值永遠以finite viewport限定。

## 拖曳預覽 WB-DOCK-PREVIEW-r1

READY；對應 WB-04／06／16。隱藏但非空的合法 area 在拖曳進入既有邊緣觸發帶時，以產品 constraints.minimum 暫時展開；僅為本 Dock instance 的 presentation，不能呼叫 onLayoutChanged、pure action 或修改 caller 的保存 layout。預覽仍使用 GEOMETRY-r1 的同一有限配額，不另做尺寸算法。空 area 沿用 Stage create-area 提示與成功提交。

展開維持到此次拖曳完成／取消，離開 Stage 進入預覽 group 不立即收起；離開 target 只清提示。離開 Dock 後取消／未命中放下、pointer cancel及成功完成都清除 presentation。若產品在拖曳中提供不同 layout instance，立即清 preview 及目前 drop 提示，以新 caller 為準；相同 layout 的 theme／尺寸重建保留 preview，仍不提交。跨區不合法的 panel 不展開 area，也不能 drop。非 draggable panel 不開始 preview。

成功 drop 到預覽 group 才一次提交：目標 visible=true，原 area extent、axis及其他 group 偏好保持；source移除／active fallback、merge或split依OPS-r1語意。正常 tab move／split不得因取用 minimum 的呈現快照而把該值寫成保存 extent。split仍依當前 actual group／gutter限制；不足兩個minimum不提交並於拖曳完成收回preview。不改 codec、model、public constructor、style或close/pinned/dirty語意。此slice保留既有UI data提交路徑；全UI接入pureoperation由下一slice完成，不能因此聲稱完整Dock已完成。

獨立公開Widget checks保護：hidden非空hover展開且callback0、取消／miss恢復保存visibility/extent且callback0、移入預覽group成功一次提交且保存extent不變、capability拒絕、caller替換／theme或尺寸重建的生命週期、空area成功create及已完成geometry不退化。只使用公開consumer、native gesture及caller probes，不檢查private State或新增golden；感官仍human-pending。

## 原生 UI 提交 WB-DOCK-UI-r1

READY；對應WB-04／05／06／16。所有成功的select、tab重排／move／create／split、visibility與resize提交必依既有OPS-r1，UI只把pointer位置／原tab插入位置轉成typed action，沒有第二套source removal／active fallback規則。UI可在自己的immutable local snapshot連續apply多個actions，全部成功且保存值改變才一次onLayoutChanged；不能逐action通知或修改caller。no-op不通知。完整policy每次由當前panel registry投影，既有geometry與preview責任保留。產品可直接用pure open／merge／visibility；不新增native Widget命令樹或storage。

tab drop的原始插入位置轉成移除source後最終index；同group移入panel依OPS-r1設active。split只在actual target group扣effective gutter後容納兩個logical minima時生效，新group接在剩下的target後；若target就是只有一tab的source group則不split。成功split用兩個相同偏好extent且只一次提交，其他偏好不改。空Stage create保留原area extent在constraints內的clamp，new group extent至少該axis logicalminimum，確保零area偏好仍能產生正group偏好。area/group resize沿GEOMETRY-r1先算有限配額，再轉typed resize；collapse只改visibility、不把小於min的pointer值寫回extent。

pinned／dirty僅為產品metadata：預設false，顯示bookmark／modified提示，不改排序、拖曳能力、關閉批准或保存JSON。可關閉面板由產品提供可選的同步或非同步boolean批准callback；未提供時保留舊外觀且無關閉入口。每個可關閉tab均可請求（含非active），single panel同樣可請求；不依標頭是否有文字才能關閉。pending只禁用同面板關閉入口，重複請求不重入，其他面板與操作仍可用。false不提交，true才依pure close移出布局；不移除registry、不刪正文／dirty資料，仍能pure open。

關閉完成從最新caller layout套用；若panel曾離開布局／registry、callback已被替換或Dock已dispose，舊結果忽略，不能重建舊layout或關掉後來重開的panel。跨group移動但仍placed且同callback可從最新位置關閉；當前callback取得結果前的產品業務由产品自己管理。callback丟錯時保持layout，解除pending，Flutter透過標準FlutterError.reportError，React native error callback／宿主錯誤處理由其module固定；不吞錯假裝批准。labels讀既有l10n或產品可選closeLabel，外觀讀既有semantic與public IconButton/Icon/Text，不產生第二份style來源。

驗收：UI成功移動及split結果等於pure action、finalindex／active／source fallback、no-op callback0、一次提交及caller immutable、零area create、pointer resize配額；可選metadata呈現／同舊caller、inactive/single close、denied／asyncapproved／error／pending不重入／最新layout／移除再開或registry callback替換／dispose安全。使用公開Widget／DOM與callbacks，不驗私有call次序或golden。保留PREVIEW-r1／GEOMETRY-r1的protectedchecks。
