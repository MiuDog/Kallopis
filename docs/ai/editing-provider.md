# 編輯提供者資料契約（實驗）

讀者是實作資料提供者的工程師與 AI。產品畫面依 [編輯內容組裝模板](editor.md)；目前已有幾何呈現、重排、文字輸入與區塊命令機制，完整筆記互動及實機驗收尚未完成。

## 入口與用途

提供者可匯入 `package:kallopis/kallopis_editing_provider.dart`，使用 `KlpEditingProjection`、stable endpoint、optional 文字視窗、stamp、封閉意圖及 reply。此入口不承諾 Stable，相容維護入口與宣告式組裝入口均不反向匯出它。

原生資料應在獨立轉接層映射。Pointer、Krepis 型別、Flutter Widget、BuildContext、Painter 或任意樣式均不能進入 Kallopis 元件資料。提交閘門與平台 session 仍為 internal，提供者不可直接 import `src` 使用它們。

## 發布格式

一次投影必須包含 document／page／generation、發布／內容／組字／排版版本與環境識別，以及完整 anchor／focus、affinity 與 blockSelection。單段輸入 window 可省略，但不能因此遺失跨區塊選取。

- 有 window：stamp 必須相同，屬於兩端共同的文字 block，且不是區塊模式。
- 無 window：保留完整選取，不以空字串代替；不能送出單段文字修改。
- window 位移為局部 UTF-8 bytes；stable endpoint 為核心字素位置，禁止只把整數欄位改名。
- accepted 代表已接受編輯，不代表已保存；未知結果不能自動重送。

## 幾何發布格式

`KlpEditingDrawing` 將同一份 `KlpEditingProjection`、viewport 寬高與不可變指令一起發布。提供者必須先核對文字、字型、風格及排版版本；不能將不同 frame 的選取矩形拼到新文字上。

指令封閉為矩形、輪廓、裁切與仿射變換；輪廓支援 move／line／quadratic／cubic／close。只可指定 `text`、`ink`、`caret`、`selection` 用途，不可輸入色碼、字型樣式或平台 `Path`。矩形、輪廓及變換必須是有限值；裁切與變換必須正確巢狀配對。

Kallopis 的內部 renderer 按順序重播幾何，使用繫結階段解析的用途色彩；不重新測量文字，也不縮放舊 frame 假裝適應新 viewport。`KlpEditingContent` 依來源能力安裝呈現、重排及輸入接點；平台輸入正在驗證，完整互動尚未完成。

## 來源通知契約

`KlpEditingSource` 提供 `KlpEditingDrawing get drawing` 與 `Stream<KlpEditingDrawing> get drawings`。安裝前必須先有真實初值；stream 必須是非同步 broadcast，每筆通知都是已成功發布的不可變快照。同一 stamp 重播必須沿用同一 drawing 物件，不能更換幾何內容。

提供者擁有來源與其底層資源，畫面安裝只借用來源並管理自己的 stream 訂閱。通知 listener 的例外必須可觀察，但不能同步回流為編輯命令失敗；Krepis adapter 的非同步 stream 將它交給訂閱所在 zone 處理。

## 可編輯來源契約（實驗）

`KlpEditingLayoutSource` 延伸上述來源，接受本庫排版要求，唯讀內容也可以實作。`KlpEditableSource` 再延伸它，加入輸入與生命週期接點。產品仍只把 source 注入 `KlpEditingContent`，不自行呼叫平台輸入或配置排版風格。

| 接點 | 呼叫端與責任 |
| --- | --- |
| `issueCommandSequence()` | 由同一來源發出文字與區塊共用的單調序號；來源重新安裝時續用，不能由各個 host 分別從零開始。 |
| `layout(KlpEditingLayout)` | Kallopis 傳入實際 viewport 與完整解析的 style；提供者重排並回傳已成為 current 的 drawing。不可縮放舊幾何替代重排。 |
| `submit(request, committedAtMs: ...)` | Kallopis 將輸入轉成版本化意圖；提供者回覆權威投影，未知提交結果不得自動重送。 |
| `selectPoint(KlpEditingPointRequest)` | Kallopis 傳入座標及預期版本；提供者以對應 frame 命中，不使用舊位置猜測。 |
| `bindInteraction(interaction)` | Kallopis 綁定唯一輸入生命週期，持有可解除的 binding；提供者關閉前等待 `interrupt()`。 |

`KlpEditingStyle` 是本庫向提供者輸送的解析結果，不是 consumer 可注入的元件樣式。提供者必須明確拒絕不支援的字型或度量，不能靜默改用另一種字型。一般 `KlpEditingSource` 保留固定幾何呈現；需要隨本庫風格及尺寸重排的唯讀內容應實作 `KlpEditingLayoutSource`，不必實作輸入接點。

正常關閉順序為停止新事件、等待在途結果、取消尚未確認的組字、斷開平台輸入，再釋放 source 與 engine。已提交內容保留；無法確認取消結果時回報失敗。此契約已有接線與協定檢查，仍不構成組字中關閉或 Windows IME 實機驗收證據。

區塊能力由同一來源另實作 `KlpBlockControlSource`，提供 `submitBlock` 並沿用上述序號。`KlpEditingDrawing.blocks` 與 drawing 共用 stamp／viewport；`KlpBlockProjection`、`KlpBlockItem`、`KlpBlockRequest` 與 `KlpBlockIntent` 由本資料入口匯出。使用與限制見 [區塊控制系統](block-controls.md)，不能把 core 能力當成已完成的畫面入口。

## Krepis 實作與範例

K03 的 `KlpAnchoredCommandSource` 與 `drawing.anchoredCommands` 格式見 [定位命令系統](anchored-commands.md)。同一來源繼承與共用序號規則保持一致，相關協定已驗證；可見選單尚未交付。

獨立轉接套件的 [使用方式與版本映射](D:/Projects/Krepis-m0-checked-save/bindings/kallopis/README.md) 已提供真實 DLL 的 scene → projection 實作及驗證腳本。文件／頁面身分來自開啟流程；核心 session、input、frame、font／style 各使用其真正來源，不把單一計數複製到所有版本欄位。

目前已有資料發布與修改回覆轉接：提供者 session 將 UTF-8 範圍交由核心解析，再使用 checked 修改並附權威投影；修改成功後回讀失敗保留接受狀態，不能重送。畫面與平台連線已接入，正式視覺與 Windows IME 實機驗收仍未完成。實作進度與剩餘條件見 [K01 契約](../architecture/editor-input-contract-plan.md) 及 [核心接入對照](../architecture/krepis-editor-provider-mapping.md)。
