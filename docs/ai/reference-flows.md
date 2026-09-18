# 端到端 Reference Flow

本頁用三條代表性流程檢查 Kallopis 的公開能力能否共同完成生產力工作。它是能力證據，不是產品模板：consumer 仍擁有功能選用、畫面順序、導航目的、產品資料、權限、同步、persistence 與商業流程。

所有結論沿用[生產力能力清冊](productivity-capabilities.md)。`supported` 表示目前證據足以合法完成該段；`partial` 表示已有公開入口但完整行為或證據尚缺；`unsupported` 表示新 consumer 沒有合法的完整路徑。舊 Catalog class 不會因存在而成為可用能力。

## 流程總覽

| Flow | 想完成的工作 | 整體結論 | 現在可證明的成功路徑 | 阻止完整交付的缺口 |
| --- | --- | --- | --- | --- |
| RF-WORKSPACE | 建立工作區、瀏覽階層資料、開啟命令並切換內容。 | `partial` | Explorer 與 Menu 本身為 `supported`；可放入公開 layout／frame 結構。 | shell navigation、tabs、window host、feedback、完整 adaptive／accessibility 矩陣仍不完整。 |
| RF-STRUCTURED | 建立表格／清單、表單輸入、篩選排序、驗證與提交。 | `unsupported` | 產品可先建立自己的資料模型；目前沒有可合法完成整條 UI 流程的新版元件組。 | forms、通用 collections、filter／sort、feedback 仍為 legacy 或未交付。 |
| RF-NOTE | 開啟正文、編輯、保存、關閉並重新開啟。 | `partial` | BlockNote host、editing shell 與保存協定已有公開或實驗入口。 | 完整輸入、可見保存入口、附件／引用、跨平台與無障礙證據不足；手寫仍 unsupported。 |

## RF-WORKSPACE：階層工作區

使用情境是「使用者在工作區瀏覽項目，選取一筆內容並執行命令」。產品可以自由決定它是筆記、檔案、專案或其他領域；本 flow 不固定 sidebar 功能或產品順序。

目前可證明的合法結構是：`KlpScreen → KlpAppLayout → KlpAppFrame → KlpFrameGroups → KlpExplorer／KlpMenu`。Explorer 與 Menu 只能出現在各自允許的 group content；`KlpRail` 仍是 internal，不能放進 consumer 組裝。

| 階段 | Consumer 工作 | Kallopis 能力與結論 | 直接證據 | 失敗／缺口 |
| --- | --- | --- | --- | --- |
| S1 視覺組成 | 決定工作區區域，以空 category、tree、selection scope 建立 Explorer。 | layout／groups `partial`；Explorer `supported`。 | [S1 空資料步驟](getting-started.md)、[應用與組裝](composition-templates.md)、[Explorer 契約](explorer-model.md)。 | 不得以 `KlpRail`、自訂 Widget 或任意 child 補 shell navigation。 |
| S2 產品資料模型 | 擁有項目 ID、階層、選取、展開、命令資料及內容生命週期。 | Explorer data contract `supported`；tabs／retained content `partial`。 | [Explorer 資料與事件](explorer-model.md)、[工作區元件責任](workspace-components.md)。 | Kallopis 不讀 repository、不決定開啟順序，也不保存第二份產品選取。 |
| S3 資料／互動接線 | 將產品資料投影成完整 Explorer data，處理 selection／activate／expand；以 Menu 或 anchored popup 發出命令。 | Explorer、Menu `supported`；anchored popup、application state `partial`。 | [Explorer 事件](explorer-model.md)、[Menu 更新](menu-model.md)、[Anchored popup](anchored-popup-model.md)、[應用更新](composition-templates.md)。 | tabs 關閉／保存政策、一般 shell navigation、通用錯誤回饋尚不能假設完成。 |
| S4 動畫／體驗優化 | 檢查鍵盤、焦點、拖放、窄寬、平台與操作回饋。 | adaptive／access input／style experience `partial`。 | [Adaptive 策略](adaptive-platform-strategies.md)、Explorer 與 Menu 的鍵盤契約及 Catalog 證據。 | 缺少跨所有平台與元件的完成矩陣；consumer 不得自行傳 duration、curve 或 style。 |

成功邊界：目前可以合法證明「呈現階層資料、提交 Explorer 事件、顯示及操作 Menu」。不能由此推論整個工作區 shell、所有平台視窗操作或所有 feedback state 已 supported。

## RF-STRUCTURED：結構化資料與表單

使用情境是「使用者瀏覽結構化資料，以欄位編輯，通過驗證後提交」。這條流程刻意保留為缺口證據，因為建立看似合理的舊 Widget 範例會讓 consumer 誤以為新版能力已可使用。

目前不存在合法的完整組裝鏈。`KlpDataTable`、`KlpTextField`、`KlpForm`、`KlpFilterBar` 等固定清冊項目仍是 pending／legacy 路徑；consumer 不能從 foundation import、直接引用 `lib/src` 或注入 Flutter Widget 使它們變成新版能力。

| 階段 | Consumer 工作 | Kallopis 能力與結論 | 直接證據 | 失敗／缺口 |
| --- | --- | --- | --- | --- |
| S1 視覺組成 | 需要 list／table／grid、form section、field 與空白狀態。 | 完整 flow `unsupported`。 | [能力清冊](productivity-capabilities.md)中的 DATA-COLLECTIONS、FORM-INPUT、FORM-SELECTION、FEEDBACK-STATES。 | 新公開面沒有可完成表格加表單的合法 renderer／組裝證據。 |
| S2 產品資料模型 | consumer 可先定義 entity、欄位值、validation rule、query 與 submission state。 | UI flow 仍 `unsupported`；產品模型本身在 Kallopis scope 外。 | [四階段入門](getting-started.md)、[能力邊界](external-components.md)。 | 不得讓舊 field class 成為產品資料權威，也不能因模型已完成便宣稱 UI supported。 |
| S3 資料／互動接線 | 需要 field change、validation、filter、sort、pagination、submit 與 failure event。 | 完整 flow `unsupported`。 | [固定 254 項逐項轉接](catalog-capability-map.md)保留每個舊項目的 pending 狀態與 owner。 | 缺少新版 field data／event、合法 form parent、collection selection 及 submission contract。 |
| S4 動畫／體驗優化 | 需要 focus order、IME、錯誤 announcement、loading／success feedback 與 responsive table。 | 完整 flow `unsupported`。 | [能力清冊](productivity-capabilities.md)的 ACCESS-INPUT、ADAPT-PLATFORM 與 GAP-FORMS／GAP-DATA／GAP-FEEDBACK。 | 基礎流程尚未交付，不能先用 consumer animation 或 style 包裝舊控制。 |

成功邊界：目前只能完成產品端資料模型與需求描述，不能提供新 consumer 的可執行表單／表格 reference。後續由 GAP-FORMS、GAP-DATA、GAP-FEEDBACK 所屬 module 分別進入 DEFINE／PLAN，而不是在文件中偽造 API。

## RF-NOTE：正文、保存與重開

使用情境是「使用者開啟正文、修改內容、明確保存，關閉後再以同一格式重開」。正文權威遵守 KLP-0020：上游編輯核心擁有文件模型、排版、選取與 undo；Kallopis 擁有語意呈現與 host，不建立第二份正文權威。

目前合法核心包括把 `KlpBlockNoteEditingContent` 作為公開 screen body，或把已初始化 source 交給 `KlpEditingContent` 的合法 workspace content 插槽。兩者代表不同現行 host 契約，不能混成雙正文模型，也不能以 consumer WebView、Widget 或 painter 補齊限制。

| 階段 | Consumer 工作 | Kallopis 能力與結論 | 直接證據 | 失敗／缺口 |
| --- | --- | --- | --- | --- |
| S1 視覺組成 | 選擇公開 editing host，放入合法 screen／workspace content 位置。 | EDT-NOTE、EDT-SHELL `partial`。 | [BlockNote host](blocknote-editor.md)、[Editing content](editor.md)、[共用 application 外層](composition-templates.md)。 | 完整筆記操作與所有可見工具入口尚未交付，不能寫成完整編輯器範例。 |
| S2 產品資料模型 | 產品持有 document／session identity、版本化文件、durable persist callback 與關閉政策。 | document host contract `partial`。 | [BlockNote 文件與 session](blocknote-editor.md)、[KLP-0020](../../spec/decisions/KLP-0020-blocknote-editor-adoption.md)。 | 不得建立 Kallopis 內第二份正文模型；舊資料遷移需另行定義。 |
| S3 資料／互動接線 | 接上保存、重試、dirty／close result、來源更新與資源釋放。 | 保存協定與 source mechanism `partial`。 | [保存與重開](editor-saving.md)、[編輯提供者](editing-provider.md)。 | 可見保存入口、完整平台輸入、組字中關閉與正式跨平台證據尚未完成。 |
| S4 動畫／體驗優化 | 檢查鍵盤／IME、選取、focus、錯誤回饋、附件、窄寬與輔助科技。 | ACCESS-INPUT、FILE-ASSET、STYLE-EXPERIENCE `partial`；HANDWRITING `unsupported`。 | [Editing 限制](editor.md)、[手寫狀態](handwriting-state.md)、[能力清冊](productivity-capabilities.md)。 | 資料協定不等於正式手寫或無障礙體驗；不得自行建立 canvas／ink renderer。 |

成功邊界：可以證明版本化 BlockNote 文件、persist／close contract，以及 editing source／save projection 的現行機制；不能宣稱完整筆記、附件、手寫、所有 IME 或正式視覺體驗已交付。

## 跨切面證據矩陣

| 跨切面 | 工作區 | 結構化資料 | 正文工作 | 共同判讀 |
| --- | --- | --- | --- | --- |
| application／navigation／state | `partial` | `partial` | `partial` | 公開 root、typed navigation 與 state 已存在，但完整瀏覽器 history、各 flow state 及 Catalog 證據不足。 |
| layout／合法組裝 | `partial` | `unsupported` | `partial` | 公開 workspace layout 可用但整組證據未完成；結構化表單／表格沒有合法完整鏈。 |
| keyboard／focus／accessibility | `partial` | `unsupported` | `partial` | Explorer／Menu 有局部確定性證據；尚無跨全部能力與平台的完成矩陣。 |
| loading／empty／error／permission | `partial` | `unsupported` | `partial` | anchored popup 與 editing 有局部狀態；通用 feedback family 尚未形成新版完整能力。 |
| adaptive／platform | `partial` | `unsupported` | `partial` | `KlpAdaptive` 有公開策略入口，但所有元件與 OS 組合尚未驗證。 |
| semantic style／animation | `partial` | `unsupported` | `partial` | 視覺值由 Kallopis 解析；缺少的動畫或回饋必須補庫能力，不能由 consumer 注入。 |
| persistence／sync／權限 | `unsupported` | `unsupported` | `partial` | 一般產品 persistence、sync、identity、permission 由 consumer 擁有；正文只有明示的 persist／save host contract。 |

矩陣中的 `unsupported` 只描述「Kallopis 是否提供該 flow 所需的通用 UI／host 能力」，不把 consumer 自己應擁有的商業資料或 persistence 重新納入 Kallopis。

## 缺口交接

| Flow | 後續 gap owner | 進入 module 規格前必須回答 |
| --- | --- | --- |
| RF-WORKSPACE | GAP-NAV、GAP-FEEDBACK、GAP-CROSSCUT | shell navigation 的資料／事件／slot、通用 view state，以及各平台鍵盤／焦點／adaptive 證據。 |
| RF-STRUCTURED | GAP-FORMS、GAP-DATA、GAP-FEEDBACK | field value authority、validation／submission、collection selection／editing／virtualization 與可見失敗狀態。 |
| RF-NOTE | GAP-NOTES、GAP-HANDWRITING、GAP-CROSSCUT | KLP-0020 權威、附件與 FILE-ASSET 生命週期、正式手寫輸入，以及 IME／accessibility／platform acceptance。 |

每個 gap 必須回到對應 module 的規格、架構與 Catalog 證據流程。Reference 只反映已交付能力，不會用未公開 class、舊 Widget 或漂亮的靜態 specimen 把缺口改寫成 supported。
