# Kallopis 元件樹架構全覽

> 本目錄遵循 `/focused-architecture-diagram` 規範，精確繪製 Kallopis 全部 151 個 Widget 元件之內部組成架構。

## 架構分層與展開規範

1. **同構分類**：嚴格對齊 `lib/src/` 的領域目錄分層。
2. **原生原語展開**：Flutter 原生元件（如 `Container`, `Row`, `Column`, `Padding`, `Material` 等）持續向下繪製到底。
3. **純容器中繼**：`KlpSurface`、`KlpStrokeFrame`、`KlpRegion` 等純容器型別不中斷，持續展開其內部 child。
4. **跨元件引用邊界**：遇到本專案之其他功能性元件（如 `KlpButton`, `KlpTextField`, `KlpIcon`, `KlpText` 等）即刻停步，標記為 `:::reference` 節點並提供超連結引用。

## 領域分類索引

- [theme — semantic 與 component token (1)](#theme)
- [foundation — 圖示、色盤、度量 (4)](#foundation)
- [typography — 文字 (2)](#typography)
- [surface — 表面與描邊 (8)](#surface)
- [layout — 版面原語 (8)](#layout)
- [interaction — 互動 (9)](#interaction)
- [controls — 控制項 (13)](#controls)
- [form — 表單 (29)](#form)
- [data — 資料呈現 (22)](#data)
- [feedback — 狀態與回饋 (11)](#feedback)
- [overlay — 浮層 (8)](#overlay)
- [navigation — 導覽元件 (11)](#navigation)
- [editor — 編輯器周邊 (8)](#editor)
- [shell — 應用外殼 (14)](#shell)
- [routing — 分發 (2)](#routing)
- [app — 應用程式進入點與根容器 (1)](#app)

<a id="theme"></a>
### theme — semantic 與 component token (1)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpTokenOverride` | `Stateless` | 用一組覆寫過的色彩 token 包住子樹。  「把 [KlpThemeData] 換掉、其餘 extension 原封不動」這件事原本在 `KlpSurface`、 `KlpPanelFrame`、`KlpStageFrame`、`KlpAppScreen` 各寫了一份完全相同的 `Theme.of(context).copyWith(extensions: ...)`。四份實作只要有一份漏掉 `where((ext) => ext is! KlpThemeData)`，該子樹就會拿到兩個色彩層，而且不會報錯。 | [klp_token_override.md](./theme/klp_token_override.md) |

<a id="foundation"></a>
### foundation — 圖示、色盤、度量 (4)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpGeometricSpinner` | `Stateful` | 幾何圖案載入動畫。  由四個對稱的小方塊圍繞中心旋轉，並伴隨對比色進行平滑色彩動畫， 適合用於載入狀態、資料請求或背景處理中指示。 | [klp_geometric_spinner.md](./foundation/klp_geometric_spinner.md) |
| `KlpIcon` | `Stateless` | Kallopis KlpIcon 元件 | [klp_icon.md](./foundation/klp_icon.md) |
| `KlpInlineCode` | `Stateless` | 行內程式碼片段。帶有圓角背景與等寬字體，適合在段落文字中呈現指令、變數或路徑。 | [klp_inline_code.md](./foundation/klp_inline_code.md) |
| `KlpSegmentedProgress` | `Stateless` | Kallopis KlpSegmentedProgress 元件 | [klp_segmented_progress.md](./foundation/klp_segmented_progress.md) |

<a id="typography"></a>
### typography — 文字 (2)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpRichText` | `Stateless` | 行內混排文字：連結、mention、粗斜體、行內程式碼可以出現在同一段落裡。  [spans] 與 [nodes] 是兩種不同精細度的輸入，二擇一——給了 [nodes]（非空） 就完全忽略 [spans]；只需要簡單加粗／換色時用 [spans] 即可，不需要為此 組出完整的節點樹。[onOpenLink]／[onOpenMention] 為 null 時，對應的連結與 mention 仍會照樣顯示，只是不可點擊。 | [klp_rich_text.md](./typography/klp_rich_text.md) |
| `KlpText` | `Stateless` | 文字。以**角色**指定樣式（`role`），不指定字級與字體——實際的字級、行高與 家族由 theme 的 typography 層決定，因此換風格時整體會一起變。 | [klp_text.md](./typography/klp_text.md) |

<a id="surface"></a>
### surface — 表面與描邊 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpBlock` | `Stateless` | Kallopis KlpBlock 元件 | [klp_block.md](./surface/klp_block.md) |
| `KlpBlockCanvas` | `Stateless` | Kallopis KlpBlockCanvas 元件 | [klp_block_canvas.md](./surface/klp_block_canvas.md) |
| `KlpDashedBorder` | `Stateless` | 虛線邊框容器。為子元件提供自訂粗細、圓角、顏色與虛線間距的虛線外框。  預設使用 theme 的 [KlpShapeTheme.dashedOpacity] 輔助線顏色與 [KlpShapeTheme.control] 圓角。 | [klp_dashed_border.md](./surface/klp_dashed_border.md) |
| `KlpDashedDivider` | `Stateless` | 虛線分隔線。支援水平與垂直兩種方向，以及自訂線寬、顏色與虛線間距。  預設使用 theme 的 [KlpShapeTheme.hairline] 粗細與 [KlpShapeTheme.dashedOpacity] 輔助線顏色。 | [klp_dashed_divider.md](./surface/klp_dashed_divider.md) |
| `KlpDivider` | `Stateless` | Kallopis KlpDivider 元件 | [klp_divider.md](./surface/klp_divider.md) |
| `KlpSection` | `Stateless` | 帶標題的內容分段。`label` 是標題上方的小型分類文字。 | [klp_section.md](./surface/klp_section.md) |
| `KlpStrokeFrame` | `Stateless` | Kallopis KlpStrokeFrame 元件 | [klp_stroke_frame.md](./surface/klp_stroke_frame.md) |
| `KlpSurface` | `Stateless` | 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置， 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）自適應渲染。 | [klp_surface.md](./surface/klp_surface.md) |

<a id="layout"></a>
### layout — 版面原語 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpOverlayHost` | `Stateless` | 浮層容器掛載點。 | [klp_overlay_host.md](./layout/klp_overlay_host.md) |
| `KlpRegion` | `Stateless` | 區域容器。包裝標題、主要內容與頁尾。 | [klp_region.md](./layout/klp_region.md) |
| `KlpResizablePane` | `Stateless` | 寬度可調節面板容器。 | [klp_resizable_pane.md](./layout/klp_resizable_pane.md) |
| `KlpResizeHandle` | `Stateless` | 拖曳調整寬度把手。 | [klp_resize_handle.md](./layout/klp_resize_handle.md) |
| `KlpScrollViewport` | `Stateless` | 具備主題捲軸樣式的單向捲動容器。 | [klp_scroll_viewport.md](./layout/klp_scroll_viewport.md) |
| `KlpSplitLayout` | `Stateless` | 分割版面原語。支援左/中/右或左右分割，以及虛線分隔線。 | [klp_split_layout.md](./layout/klp_split_layout.md) |
| `KlpVirtualGrid` | `Stateless` | 格狀虛擬化捲動檢視。 | [klp_virtual_grid.md](./layout/klp_virtual_grid.md) |
| `KlpVirtualList` | `Stateless` | 長清單虛擬化捲動檢視。 | [klp_virtual_list.md](./layout/klp_virtual_list.md) |

<a id="interaction"></a>
### interaction — 互動 (9)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpDragPreview` | `Stateless` | Kallopis KlpDragPreview 元件 | [klp_drag_preview.md](./interaction/klp_drag_preview.md) |
| `KlpDropIndicator` | `Stateless` | Kallopis KlpDropIndicator 元件 | [klp_drop_indicator.md](./interaction/klp_drop_indicator.md) |
| `KlpDropTarget` | `Stateless` | Kallopis KlpDropTarget 元件 | [klp_drop_target.md](./interaction/klp_drop_target.md) |
| `KlpFilterBar` | `Stateless` | 篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。 | [klp_filter_bar.md](./interaction/klp_filter_bar.md) |
| `KlpInteractionSettings` | `Stateless` | 長按門檻的區域覆寫。  門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget 只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數， 與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時 不會有任何錯誤，只是門檻沒變。 | [klp_interaction_settings.md](./interaction/klp_interaction_settings.md) |
| `KlpPresenceIndicator` | `Stateless` | 協作者在線/連線狀態標記。 | [klp_presence_indicator.md](./interaction/klp_presence_indicator.md) |
| `KlpPressable` | `Stateful` | Kallopis KlpPressable 元件 | [klp_pressable.md](./interaction/klp_pressable.md) |
| `KlpSelectionToolbar` | `Stateless` | 批次選取浮動/固定操作列。 | [klp_selection_toolbar.md](./interaction/klp_selection_toolbar.md) |
| `KlpShortcutHint` | `Stateless` | 鍵盤快捷鍵提示標籤。 | [klp_shortcut_hint.md](./interaction/klp_shortcut_hint.md) |

<a id="controls"></a>
### controls — 控制項 (13)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpButton` | `Stateful` | 主要動作按鈕。`tone` 提供 primary／secondary／ghost／dashed／danger；`size` 提供 xs／sm／md／lg／xl，預設為 sm、`compact` 為 xs。`selected` 由呼叫端持有，hover 與 selected 使用不同語意 wash。 | [klp_button.md](./controls/klp_button.md) |
| `KlpCheckbox` | `Stateless` | Kallopis KlpCheckbox 元件 | [klp_checkbox.md](./controls/klp_checkbox.md) |
| `KlpCombobox` | `Stateful` | 可輸入的下拉選單（autocomplete）。  **輸入框重用 [KlpTextField]，下拉面板重用 [KlpMenu]**——本庫「一條規則只能有 一個實作」：欄位外觀與選單外觀已經各自只有一份，這裡不重新畫一套。  是**受控元件**：目前的輸入文字（[query]）、候選清單（[options]）都由呼叫端 持有並傳入，本元件只負責過濾顯示、鍵盤導覽與觸發 [onQueryChanged]／ [onSelected]。選出一個選項後，呼叫端通常會把 [query] 更新成該選項的 [KlpComboboxOption.label]。  鍵盤：↓／↑ 在目前過濾結果間移動，Enter 選定醒目提示的項目；[allowFreeText] 為 `true` 時，Enter 在沒有醒目提示項目但輸入框非空時改觸發 [onFreeTextSubmitted]，讓呼叫端接受清單以外的自由輸入值。Esc 收起面板。 | [klp_combobox.md](./controls/klp_combobox.md) |
| `KlpCompactSwitch` | `Stateless` | Kallopis KlpCompactSwitch 元件 | [klp_compact_switch.md](./controls/klp_compact_switch.md) |
| `KlpIconButton` | `Stateful` | 只有圖示的按鈕。`label` 為必填且用於無障礙標註——圖示本身沒有可讀文字， 沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。 | [klp_icon_button.md](./controls/klp_icon_button.md) |
| `KlpSegmentedControl` | `Stateless` | Kallopis KlpSegmentedControl 元件 | [klp_segmented_control.md](./controls/klp_segmented_control.md) |
| `KlpSelect` | `Stateful` | 下拉選擇的觸發器。**它只負責顯示目前的值與觸發 `onPressed`**，選單本身由呼叫端 以 `KlpMenu` 開啟——選項來源是產品資料，不屬於視覺層。 | [klp_select.md](./controls/klp_select.md) |
| `KlpSlider` | `Stateless` | Kallopis KlpSlider 元件 | [klp_slider.md](./controls/klp_slider.md) |
| `KlpSlidingSelection` | `Stateless` | Kallopis KlpSlidingSelection 元件 | [klp_sliding_selection.md](./controls/klp_sliding_selection.md) |
| `KlpTextField` | `Stateful` | 單行或多行文字輸入。內部使用 `TextFormField`，所需的 `Material` 祖先由本元件 自行提供，消費者不需要另外包一層。 | [klp_text_field.md](./controls/klp_text_field.md) |
| `KlpToggle` | `Stateless` | Kallopis KlpToggle 元件 | [klp_toggle.md](./controls/klp_toggle.md) |
| `KlpToggleIndicator` | `Stateless` | Kallopis KlpToggleIndicator 元件 | [klp_toggle_indicator.md](./controls/klp_toggle_indicator.md) |
| `KlpTriStateToggle` | `Stateless` | Kallopis KlpTriStateToggle 元件 | [klp_tri_state_toggle.md](./controls/klp_tri_state_toggle.md) |

<a id="form"></a>
### form — 表單 (29)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpApprovalStepsField` | `Stateless` | 審批步驟排序欄位。支援步驟上下移動、刪除與新增。 | [klp_approval_steps_field.md](./form/klp_approval_steps_field.md) |
| `KlpCalendar` | `Stateless` | 月曆面板：月份切換、日期格、今天標記、選取狀態，並可停用特定日期。  **這是純顯示元件，不持有任何日期狀態**——目前顯示的月份、選取的日期都由呼叫端 透過 [month]、[selectedDate]／[selectedRange] 傳入，切換月份與選日期一律經 [onPreviousMonth]／[onNextMonth]／[onDateSelected] 回呼，由呼叫端決定下一步狀態。  **不內建任何語言字串。** 月份標題（[monthLabel]）與星期縮寫（[weekdayLabels]） 一律由呼叫端組出——本庫沒有 l10n 機制，不替產品決定用哪種語言、哪一天是一週的 開始（見 [firstWeekday]）。 | [klp_calendar.md](./form/klp_calendar.md) |
| `KlpCodeEditorField` | `Stateless` | 結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。 | [klp_code_editor_field.md](./form/klp_code_editor_field.md) |
| `KlpCodeField` | `Stateless` | 程式碼欄位：唯讀時走語法高亮的 [KlpCodeViewer]，可編輯時走純文字的 [KlpTextArea]。  [readOnly] 切換的是整套渲染方式而非同一個 widget 加鎖——唯讀模式沒有 [onChanged] 也沒有 [error] 提示，這兩者只在可編輯（[readOnly] 為 false） 時才有意義。[language] 只影響唯讀模式下的語法高亮，可編輯模式不使用。 | [klp_code_field.md](./form/klp_code_field.md) |
| `KlpColorRoleField` | `Stateless` | 從一組色彩角色（例如 semantic token 名稱）中選擇一個的下拉欄位。  是 [KlpSelectField] 針對「選項本身就是色彩角色」這個情境的薄封裝—— [roles] 直接複用 [KlpChoiceOption]，實際渲染完全委派給 [KlpSelectField]。 找不到 [selectedId] 對應的角色時會退回顯示 [roles] 的第一項。 | [klp_color_role_field.md](./form/klp_color_role_field.md) |
| `KlpConditionalFieldRegion` | `Stateless` | 依條件顯示／隱藏一段欄位，並用 [AnimatedSize] 補間高度變化，避免表單 其他欄位因為突然增減內容而跳動。  [visible] 為 false 時 [child] 會被整個換成 [SizedBox.shrink]，因此 child 的 widget 狀態不會保留——若 child 內有輸入控制項且需要在重新顯示時 保住使用者輸入，請自行在 child 上加 [GlobalKey] 或改用其他方式保存資料。 | [klp_conditional_field_region.md](./form/klp_conditional_field_region.md) |
| `KlpDateField` | `Stateful` | 日期輸入欄位。文字輸入永遠可用；提供 [calendar] 時額外接上 [KlpCalendar] 作為挑選面板，兩套輸入路徑共用同一個文字結果，不是各自獨立的兩個元件。 | [klp_date_field.md](./form/klp_date_field.md) |
| `KlpField` | `Stateless` | 單一表單欄位的完整外框：標籤、選填說明、輸入控制項（[child]），以及 底部的錯誤／狀態／字數提示列。  [error]、[status]、[counter]、[errorCode] 共用同一列版面：底部提示列只在 四者至少有一個非 null 時才出現；[error] 優先於 [status]（兩者同時給只顯示 error），[errorCode]／[counter] 則各自靠右並存，通常放系統層級的診斷代碼 （例如後端回傳的驗證錯誤碼）供支援排查用，不是給一般使用者讀的文案。 實際的驗證邏輯、何時算 required 都由呼叫端決定，這個元件只負責排版。 | [klp_field.md](./form/klp_field.md) |
| `KlpFieldDescription` | `Stateless` | 欄位輔助說明文字，統一使用低對比（[KlpTextTone.muted]）的 [KlpTextRole.caption] 樣式。  [KlpField] 內部就是用它畫 `description`——需要在 [KlpField] 版面之外 單獨放一段樣式一致的欄位說明時才需要直接用它。 | [klp_field_description.md](./form/klp_field_description.md) |
| `KlpFieldError` | `Stateless` | 單獨呈現的欄位錯誤文字，包了 `Semantics(liveRegion: true)`，讓螢幕 報讀器在錯誤出現時主動唸出來，不需要使用者手動聚焦。  [KlpField] 的內建錯誤列沒有這層 live region 包裝；需要非同步驗證結果 出現時立即被報讀器感知，才需要在 [KlpField] 之外單獨用它。 | [klp_field_error.md](./form/klp_field_error.md) |
| `KlpFieldGroup` | `Stateless` | 把多個相關輸入（例如一組 checkbox）當成單一 [KlpField] 呈現，用 [legend] 取代單一欄位的 `label`。  內部直接委派給 [KlpField]，因此標籤／錯誤的排版與單一欄位完全一致； 差別只在 `child` 換成 [children] 這組垂直排列的子項目。 | [klp_field_group.md](./form/klp_field_group.md) |
| `KlpFieldLabel` | `Stateless` | 欄位標籤文字，統一使用 [KlpTextRole.caption] 樣式。  [KlpField] 內部就是用它畫標籤——需要在 [KlpField] 版面之外單獨放一個 樣式一致的欄位標籤時（例如自訂版面）才需要直接用它。 | [klp_field_label.md](./form/klp_field_label.md) |
| `KlpFileDropzoneField` | `Stateless` | 檔案上傳拖曳區與附件清單元件。 | [klp_file_dropzone_field.md](./form/klp_file_dropzone_field.md) |
| `KlpFileField` | `Stateless` | 簡易的檔案選擇欄位：一排已選檔案的預覽卡片，加一顆選擇檔案按鈕。  不處理實際的檔案選取或上傳邏輯——[onChoose] 只是回報「使用者按了選擇」， 開檔案對話框、讀取內容、上傳進度都由呼叫端接手；需要顯示上傳進度時請改用 [KlpFileDropzoneField]。 | [klp_file_field.md](./form/klp_file_field.md) |
| `KlpForm` | `Stateless` | 整份表單的最外層版面：錯誤總覽、各個區塊（[sections]）與底部動作列 依序排列，各區塊之間插入固定間距。  不管理欄位資料或驗證邏輯——[sections] 由呼叫端組好（通常是多個 [KlpFormSection]），[errorSummary] 通常放 [KlpFormErrorSummary]， [actions] 通常放 [KlpFormActions]。三者皆為可選，缺席時不佔版位。 | [klp_form.md](./form/klp_form.md) |
| `KlpFormActions` | `Stateless` | 表單底部的動作列：送出／取消／重設按鈕，靠右對齊並在寬度不足時自動換行。  [cancelLabel]／[resetLabel] 為 null 時對應按鈕不會出現，[submitLabel] 與 [onSubmit] 恆為必填——表單至少要能送出。[submitting] 為 true 時三個按鈕 一併停用，避免送出過程中使用者重複觸發或誤按取消／重設。 | [klp_form_actions.md](./form/klp_form_actions.md) |
| `KlpFormErrorSummary` | `Stateless` | 表單頂部的錯誤總覽卡片，把所有驗證失敗的欄位集中列成清單。  [errors] 的 key 是欄位識別碼、value 是要顯示的錯誤文字；點擊某一項會透過 [onSelected] 回報該欄位的 key，呼叫端通常用它把焦點捲動或移到對應欄位。 不會反查欄位在畫面上的位置——[KlpForm] 之類的容器也不知道每個欄位的 GlobalKey，捲動與聚焦的實作留給呼叫端。 | [klp_form_error_summary.md](./form/klp_form_error_summary.md) |
| `KlpFormSection` | `Stateless` | 表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。  [collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否， 純粹依 [collapsed] 決定要不要畫出 [children]。標題整列可點擊觸發 [onToggle]，即使 [onToggle] 為 null 也一樣可安全點擊（等同無反應）。 | [klp_form_section.md](./form/klp_form_section.md) |
| `KlpKeyValueEditor` | `Stateless` | 任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入 框與一個 value 輸入框。  不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容， 增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。 | [klp_key_value_editor.md](./form/klp_key_value_editor.md) |
| `KlpMultiSelectField` | `Stateless` | 多選欄位：所有選項以可切換的標籤（chip）形式平鋪展示，不像 [KlpSelectField] 需要展開／收合。  [selectedIds] 由呼叫端持有——這個元件本身無狀態，點擊某個選項只會透過 [onChanged] 回報「切換後應該是這個集合」，不會自己更新畫面。 | [klp_multi_select_field.md](./form/klp_multi_select_field.md) |
| `KlpNumberField` | `Stateless` | 數值輸入欄位，底層仍是文字輸入框（[KlpTextField]），但只在能解析成 [double] 且落在 [minimum]／[maximum] 範圍內時才呼叫 [onChanged]。  超出範圍或無法解析的輸入會被直接忽略——欄位仍顯示使用者打的字，但 [onChanged] 不會觸發，因此外部的 `value` 不會更新。需要即時錯誤提示時 請自行比較顯示字串與 [value] 是否一致，而不是依賴 [onChanged] 的呼叫時機。 | [klp_number_field.md](./form/klp_number_field.md) |
| `KlpPasswordField` | `Stateful` | 密碼輸入控制項。支援顯示／隱藏密碼切換與密碼強度／規則檢核清單。 | [klp_password_field.md](./form/klp_password_field.md) |
| `KlpReferencePicker` | `Stateless` | Kallopis KlpReferencePicker 元件 | [klp_reference_picker.md](./form/klp_reference_picker.md) |
| `KlpRepeaterField` | `Stateless` | 可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。  不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過 [onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定 並重新傳入新的 [items]。 | [klp_repeater_field.md](./form/klp_repeater_field.md) |
| `KlpSelectField` | `Stateful` | 單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面 （不是彈出層），選中後自動收合。  [valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項—— 這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。 需要彈出式選單而非就地展開時請改用 [KlpMenu]。 | [klp_select_field.md](./form/klp_select_field.md) |
| `KlpStatusRoleSwatches` | `Stateless` | 狀態色彩角色色票組（Roles only）。只提供語意角色選擇，不提供直接色碼選擇。 | [klp_status_role_swatches.md](./form/klp_status_role_swatches.md) |
| `KlpTagChip` | `Stateless` | 標籤膠囊元件。呈現單一標籤並支援移除操作。 | [klp_tag_chip.md](./form/klp_tag_chip.md) |
| `KlpTagInputField` | `Stateless` | 標籤輸入與群組欄位。支援新增、移除個別標籤與清空所有標籤。 | [klp_tag_input_field.md](./form/klp_tag_input_field.md) |
| `KlpTextArea` | `Stateless` | 多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`， 其餘外觀與行為完全繼承自 [KlpTextField]。 | [klp_text_area.md](./form/klp_text_area.md) |

<a id="data"></a>
### data — 資料呈現 (22)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAccordion` | `Stateful` | 可摺疊的內容區清單。  [multiple] 為 `false`（預設）時同一時間只能展開一項，再點其他標題會先收合原本 展開的那項；為 `true` 時各項互不影響。展開狀態是暫存的 UI 狀態而非產品資料， 因此元件自行持有——需要預先展開特定項目或觀察變化時用 [initialExpandedIds] 與 [onExpandedChanged]。 | [klp_accordion.md](./data/klp_accordion.md) |
| `KlpAvatar` | `Stateless` | Kallopis KlpAvatar 元件 | [klp_avatar.md](./data/klp_avatar.md) |
| `KlpAvatarGroup` | `Stateless` | Kallopis KlpAvatarGroup 元件 | [klp_avatar_group.md](./data/klp_avatar_group.md) |
| `KlpBadge` | `Stateless` | 狀態標記 (Badge)。 | [klp_badge.md](./data/klp_badge.md) |
| `KlpCard` | `Stateless` | 內容卡片。 | [klp_card.md](./data/klp_card.md) |
| `KlpCodeViewer` | `Stateful` | Kallopis KlpCodeViewer 元件 | [klp_code_viewer.md](./data/klp_code_viewer.md) |
| `KlpDataTable` | `Stateless` | 緊湊的結構化資料表格；短內容列使用 `controlHeight` 與 `tight` 垂直 padding，較高內容可自然撐開。支援固定欄位、排序與多選。 | [klp_data_table.md](./data/klp_data_table.md) |
| `KlpDiffViewer` | `Stateless` | 程式碼差異檢視器 (Diff Viewer)。  呈現檔案名稱標題、雙欄行號對照、新增（綠底）與刪除（紅底）標記行，以及逐行審查操作。 | [klp_diff_viewer.md](./data/klp_diff_viewer.md) |
| `KlpFilePreview` | `Stateless` | 檔案預覽卡片：header 顯示檔名與中繼資料，中段畫預覽內容，footer 放外部 操作。  [preview] 優先於 [textContent]——兩者都給時只會用 [preview]；都不給且 [state] 為 [KlpFilePreviewState.ready] 時顯示「無可用預覽」。[state] 由 呼叫端管理，這個元件不會自己判斷載入或解析是否失敗。 | [klp_file_preview.md](./data/klp_file_preview.md) |
| `KlpJsonTree` | `Stateless` | Kallopis KlpJsonTree 元件 | [klp_json_tree.md](./data/klp_json_tree.md) |
| `KlpKeyValueList` | `Stateless` | Kallopis KlpKeyValueList 元件 | [klp_key_value_list.md](./data/klp_key_value_list.md) |
| `KlpKeyValueTable` | `Stateless` | Kallopis KlpKeyValueTable 元件 | [klp_key_value_table.md](./data/klp_key_value_table.md) |
| `KlpListTile` | `Stateful` | Kallopis KlpListTile 元件 | [klp_list_tile.md](./data/klp_list_tile.md) |
| `KlpMetricCard` | `Stateless` | 指標呈現卡片 (Metric Card)。  呈現標籤、核心數值、單位、趨勢箭頭、狀態說明或迷你進度長條。 支援正常（neutral/success）與違規告警（danger 具備紅色外框與文字）。 | [klp_metric_card.md](./data/klp_metric_card.md) |
| `KlpProgress` | `Stateless` | Kallopis KlpProgress 元件 | [klp_progress.md](./data/klp_progress.md) |
| `KlpSortControl` | `Stateless` | Kallopis KlpSortControl 元件 | [klp_sort_control.md](./data/klp_sort_control.md) |
| `KlpStepper` | `Stateless` | 步驟流程指示。依 [currentIndex] 把 [steps] 分成已完成／進行中／未開始三態。  純顯示元件——不持有互動狀態，也不處理點擊；切換到下一步是呼叫端更新 [currentIndex] 後重建的結果。[direction] 決定排列方向。 | [klp_stepper.md](./data/klp_stepper.md) |
| `KlpTag` | `Stateless` | 可移除或可點擊的分類標籤 (Tag)。 | [klp_tag.md](./data/klp_tag.md) |
| `KlpTerminal` | `Stateless` | 終端機模擬與指令執行檢視器 (Terminal)。  具備整體實線細邊框、頂部三點視窗標記、指令列與輸出區，內容區域採用 stage 底色。 | [klp_terminal.md](./data/klp_terminal.md) |
| `KlpTimeline` | `Stateless` | 時間軸：事件依序排列，每項有標記、標題、時間、可選內容。  只負責排版與標記／連接線的視覺語言；事件的先後順序、時間格式與內容完全由 呼叫端的 [items] 決定，這裡不做排序也不解讀時間字串。 | [klp_timeline.md](./data/klp_timeline.md) |
| `KlpTree` | `Stateless` | 樹狀節點清單，用於檔案總管、大綱這類階層式導覽。  展開／選取狀態預設由每個 [KlpTreeNode] 自帶（[KlpTreeNode.expanded]／ [KlpTreeNode.selected]），適合靜態或一次性渲染；若要由呼叫端集中控管， 傳入 [expandedIds]／[selectedId] 即可覆蓋節點自帶的狀態。 | [klp_tree.md](./data/klp_tree.md) |
| `KlpTreeItem` | `Stateless` | 單一樹狀節點（含其子節點）的獨立渲染入口。  用於只需畫出一棵子樹、不需要 [KlpTree] 的清單容器與 `Semantics` 分組時。 展開／選取狀態一律讀取節點自帶的 [KlpTreeNode.expanded]／ [KlpTreeNode.selected]，沒有 [KlpTree] 那種由呼叫端集中控管的選項。 | [klp_tree_item.md](./data/klp_tree_item.md) |

<a id="feedback"></a>
### feedback — 狀態與回饋 (11)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpEmptyState` | `Stateless` | Kallopis KlpEmptyState 元件 | [klp_empty_state.md](./feedback/klp_empty_state.md) |
| `KlpErrorState` | `Stateless` | Kallopis KlpErrorState 元件 | [klp_error_state.md](./feedback/klp_error_state.md) |
| `KlpInlineNotice` | `Stateless` | 以語意 tone 顯示行內回饋；icon 跟隨 body 字級，mono 狀態碼與 UI 標題共用 alphabetic baseline。 | [klp_inline_notice.md](./feedback/klp_inline_notice.md) |
| `KlpLoadingState` | `Stateless` | Kallopis KlpLoadingState 元件 | [klp_loading_state.md](./feedback/klp_loading_state.md) |
| `KlpPermissionState` | `Stateless` | Kallopis KlpPermissionState 元件 | [klp_permission_state.md](./feedback/klp_permission_state.md) |
| `KlpProgressOverlay` | `Stateless` | Kallopis KlpProgressOverlay 元件 | [klp_progress_overlay.md](./feedback/klp_progress_overlay.md) |
| `KlpRegionPlaceholder` | `Stateless` | Kallopis KlpRegionPlaceholder 元件 | [klp_region_placeholder.md](./feedback/klp_region_placeholder.md) |
| `KlpSkeletonLine` | `Stateless` | Kallopis KlpSkeletonLine 元件 | [klp_skeleton_line.md](./feedback/klp_skeleton_line.md) |
| `KlpStatusIndicator` | `Stateless` | 狀態指示標記與文字。 | [klp_status_indicator.md](./feedback/klp_status_indicator.md) |
| `KlpToast` | `Stateless` | 短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`， 但實際的顯示與收起由呼叫端控制。 | [klp_toast.md](./feedback/klp_toast.md) |
| `KlpToastStack` | `Stateless` | Kallopis KlpToastStack 元件 | [klp_toast_stack.md](./feedback/klp_toast_stack.md) |

<a id="overlay"></a>
### overlay — 浮層 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpContextMenu` | `Stateful` | 右鍵選單：掛在任意子樹上，滑鼠右鍵或觸控長按於指標位置彈出。  選單本體重用既有的 [KlpMenu] 與 [KlpMenuItemData]——本元件只負責觸發時機、 指標定位與點外部關閉，**不重新實作選單外觀**（一條規則只能有一個實作）。 彈出位置沿用 [KlpMenuLayout.resolvePosition]，與 [KlpMenu] 在其他彈出場景 使用同一套定位邏輯，才不會有兩份互相分岔的擺放規則。 | [klp_context_menu.md](./overlay/klp_context_menu.md) |
| `KlpDialog` | `Stateless` | 對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。 `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。 | [klp_dialog.md](./overlay/klp_dialog.md) |
| `KlpDrawer` | `Stateless` | 從邊緣滑入的面板：側邊欄、篩選面板，或（[KlpDrawerEdge.bottom] 方向）行動裝置 常見的 sheet。  **不負責彈出**——呼叫端決定用什麼容器承載這個 widget（例如 `KlpOverlayHost`、`Stack` 或 `Overlay`），並透過 [open] 驅動顯示與否； 本元件只負責滑入滑出的動畫、遮罩與「點遮罩關閉」這個互動。呼叫端持有 [open] 的狀態，本元件本身不追蹤開關。 | [klp_drawer.md](./overlay/klp_drawer.md) |
| `KlpMenu` | `Stateless` | 彈出式選單面板：標題列加上一組 [KlpMenuItemData]。  只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用 [KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端（通常是 `showMenu` 或自訂 overlay）控制。 | [klp_menu.md](./overlay/klp_menu.md) |
| `KlpMenuItem` | `Stateful` | [KlpMenu] 裡單一項目的渲染，自行追蹤 hover／focus 以決定外框與前景色。  選取狀態（[KlpMenuItemData.selected]）與 hover／focus 共用同一套「active」 視覺，但前景色只有選取或停用時才會變——hover 不改文字色，只加外框， 與本產品其他控制項的 hover 表達語言一致。一般透過 [KlpMenu] 間接使用， 只有要在選單容器之外單獨畫一個選單項目時才需要直接用它。 | [klp_menu_item.md](./overlay/klp_menu_item.md) |
| `KlpPopover` | `Stateless` | Kallopis KlpPopover 元件 | [klp_popover.md](./overlay/klp_popover.md) |
| `KlpTooltip` | `Stateless` | Kallopis KlpTooltip 元件 | [klp_tooltip.md](./overlay/klp_tooltip.md) |
| `KlpTooltipSurface` | `Stateless` | Kallopis KlpTooltipSurface 元件 | [klp_tooltip_surface.md](./overlay/klp_tooltip_surface.md) |

<a id="navigation"></a>
### navigation — 導覽元件 (11)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpActionGroup` | `Stateless` | 一組動作按鈕的容器，寬度不足時自動換行，換行時保留與同一行相同的間距。  只負責排版間距——按鈕本身的樣式、順序、是否停用都由 [children] 自行決定。 | [klp_action_group.md](./navigation/klp_action_group.md) |
| `KlpBreadcrumb` | `Stateless` | Kallopis KlpBreadcrumb 元件 | [klp_breadcrumb.md](./navigation/klp_breadcrumb.md) |
| `KlpFileExplorer` | `Stateful` | 檔案瀏覽器（File Explorer）。  支援分類分組（可折疊）、資料夾樹狀結構（可展開）與一般檔案節點選取。 支援受控（傳入 `expandedSectionIds` / `expandedItemIds` / `selectedId`） 與非受控（讀取各 Section 與 Item 的 `expanded` / `selected` 屬性）兩種模式。 | [klp_file_explorer.md](./navigation/klp_file_explorer.md) |
| `KlpFileExplorerFolderView` | `Stateful` | 折疊資料夾視圖（帶展開箭頭、資料夾圖示與縮排）。 | [klp_file_explorer_folder_view.md](./navigation/klp_file_explorer_folder_view.md) |
| `KlpFileExplorerItemView` | `Stateful` | 一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。 | [klp_file_explorer_item_view.md](./navigation/klp_file_explorer_item_view.md) |
| `KlpFileExplorerSectionView` | `Stateless` | 分類區塊視圖（含分類標題、折疊動畫與項目清單）。 | [klp_file_explorer_section_view.md](./navigation/klp_file_explorer_section_view.md) |
| `KlpPagination` | `Stateless` | 上一頁／頁碼／下一頁的簡易分頁控制項。  頁碼從 1 開始（不是從 0）；在第一頁或最後一頁時對應按鈕會自動停用， 呼叫端不需要自己判斷邊界。不提供跳頁輸入框或頁碼清單，適合頁數不多、 只需要前後翻頁的場合。 | [klp_pagination.md](./navigation/klp_pagination.md) |
| `KlpRailItem` | `Stateful` | Kallopis KlpRailItem 元件 | [klp_rail_item.md](./navigation/klp_rail_item.md) |
| `KlpSidebarSectionLabel` | `Stateless` | 側邊欄分組標題，固定高度且左對齊、使用低對比的 [KlpTextRole.label] 樣式。  固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會 讓上下間距看起來不一樣。 | [klp_sidebar_section_label.md](./navigation/klp_sidebar_section_label.md) |
| `KlpTabs` | `Stateless` | 分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。 | [klp_tabs.md](./navigation/klp_tabs.md) |
| `KlpViewSwitcher` | `Stateless` | 同層級檢視切換器（例如「清單／看板」），以緊貼的膠囊按鈕組呈現， 選中項會有底色標示。  與 [KlpSegmentedControl] 的差異在於視覺重量更輕——[KlpViewSwitcher] 用 inset 表面搭配 hairline 間距，適合放在工具列這類次要控制的位置；需要更 強調的主要切換時請用 [KlpSegmentedControl]。 | [klp_view_switcher.md](./navigation/klp_view_switcher.md) |

<a id="editor"></a>
### editor — 編輯器周邊 (8)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpBulkActionBar` | `Stateless` | Kallopis KlpBulkActionBar 元件 | [klp_bulk_action_bar.md](./editor/klp_bulk_action_bar.md) |
| `KlpCommandMenu` | `Stateless` | Kallopis KlpCommandMenu 元件 | [klp_command_menu.md](./editor/klp_command_menu.md) |
| `KlpEditorToolbar` | `Stateless` | Kallopis KlpEditorToolbar 元件 | [klp_editor_toolbar.md](./editor/klp_editor_toolbar.md) |
| `KlpEntityPicker` | `Stateless` | Kallopis KlpEntityPicker 元件 | [klp_entity_picker.md](./editor/klp_entity_picker.md) |
| `KlpPageChrome` | `Stateless` | 頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面 大標題。  [breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑 請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示 多位協作者或多筆狀態，需自行組合字串或改用其他元件。 | [klp_page_chrome.md](./editor/klp_page_chrome.md) |
| `KlpPropertySummary` | `Stateless` | 實體的屬性摘要卡片：一排狀態徽章、一排標籤，再加一行中繼資料文字， 依序垂直排列。  三段固定按這個順序（badges → tags → metadata）呈現，不是各自獨立可 重排的插槽；若版面需要不同順序或省略某一段，請直接組合 [KlpBadge]／[KlpTag]／[KlpText] 而不是硬塞空清單進來。 | [klp_property_summary.md](./editor/klp_property_summary.md) |
| `KlpSaveStatusCard` | `Stateless` | 顯示最後儲存時間與一組相關狀態訊息的卡片，用於編輯器頁面告知使用者 目前的儲存／同步狀況。  [savedAt] 是已經格式化好的顯示文字（例如「2 分鐘前」），這個元件不處理 時間格式化或相對時間更新。 | [klp_save_status_card.md](./editor/klp_save_status_card.md) |
| `KlpSearchNavigator` | `Stateless` | Kallopis KlpSearchNavigator 元件 | [klp_search_navigator.md](./editor/klp_search_navigator.md) |

<a id="shell"></a>
### shell — 應用外殼 (14)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAppScreen` | `Stateless` | 應用程式最外層：鋪滿 app 底色，並在頂端保留自訂視窗標題列的位置。  它同時提供整個子樹所需的 `Material` 祖先。少了它，`MaterialApp` 會在每一段文字下方 畫黃色雙底線——那是 Flutter 對「文字沒有 Material 祖先」的除錯提示。**由庫負責提供， 因為消費者沒有理由知道 Kallopis 的哪些元件需要它。** | [klp_app_screen.md](./shell/klp_app_screen.md) |
| `KlpAppWindowHeader` | `Stateless` | Kallopis KlpAppWindowHeader 元件 | [klp_app_window_header.md](./shell/klp_app_window_header.md) |
| `KlpPaneCollapseControl` | `Stateful` | Kallopis KlpPaneCollapseControl 元件 | [klp_pane_collapse_control.md](./shell/klp_pane_collapse_control.md) |
| `KlpPanelFrame` | `Stateless` | 通用面板：header 與 content，選用 footer。高度預設沿用 theme 的外殼密度。 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）渲染。 | [klp_panel_frame.md](./shell/klp_panel_frame.md) |
| `KlpPanelHeader` | `Stateless` | Kallopis KlpPanelHeader 元件 | [klp_panel_header.md](./shell/klp_panel_header.md) |
| `KlpResponsivePaneCoordinator` | `Stateless` | 依可用寬度決定面板顯示與否的協調器。斷點來自版面常數，不隨風格改變。 | [klp_responsive_pane_coordinator.md](./shell/klp_responsive_pane_coordinator.md) |
| `KlpSidebarFrame` | `Stateless` | 側邊欄：header、rail（圖示軌）、content 與選用的 footer。 | [klp_sidebar_frame.md](./shell/klp_sidebar_frame.md) |
| `KlpStageFrame` | `Stateless` | 舞台區：頂部 header、中央 content、底部選用的 status 列。 | [klp_stage_frame.md](./shell/klp_stage_frame.md) |
| `KlpStatusBar` | `Stateless` | Kallopis KlpStatusBar 元件 | [klp_status_bar.md](./shell/klp_status_bar.md) |
| `KlpThemePreviewTile` | `Stateless` | Kallopis KlpThemePreviewTile 元件 | [klp_theme_preview_tile.md](./shell/klp_theme_preview_tile.md) |
| `KlpThemeToggle` | `Stateless` | Kallopis KlpThemeToggle 元件 | [klp_theme_toggle.md](./shell/klp_theme_toggle.md) |
| `KlpWindowControls` | `Stateless` | Kallopis KlpWindowControls 元件 | [klp_window_controls.md](./shell/klp_window_controls.md) |
| `KlpWindowHeader` | `Stateless` | 桌面應用程式自帶視窗標題列（Chrome Header）。  - **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。 - **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。 | [klp_window_header.md](./shell/klp_window_header.md) |
| `KlpWorkbenchShell` | `Stateless` | 三欄工作區外殼：主要面板、舞台、次要面板，兩側可拖曳調寬並依斷點自動收合。 這是桌面型應用最外層的版面骨架。 | [klp_workbench_shell.md](./shell/klp_workbench_shell.md) |

<a id="routing"></a>
### routing — 分發 (2)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpRouterOutlet` | `Stateless` | 渲染目前的目的地。  它只做一件事：呼叫 `router.current.builder`。**不做轉場動畫**——轉場屬於產品外殼 的決定（有些頁該滑入，有些該直接換），庫替它決定就等於替所有產品決定。 | [klp_router_outlet.md](./routing/klp_router_outlet.md) |
| `KlpRouterScope` | `Stateless` | 把 [KlpRouter] 供給子樹。 | [klp_router_scope.md](./routing/klp_router_scope.md) |

<a id="app"></a>
### app — 應用程式進入點與根容器 (1)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpApp` | `Stateful` | `MaterialApp` 的接入層，收掉每個消費者都得自己組一次的樣板。  沒有它時，消費者要自己：套 `buildKlpTheme` 的亮／暗兩份 `ThemeData`、記得把 `themeAnimationDuration` 歸零（否則主題切換的動畫中途會有半數幀停在舊值上， 見 README「深淺切換不做過場」）、決定明暗狀態放哪裡並手刻切換入口、如果用了 [KlpRouter] 還要自己架 [KlpRouterScope]。這些細節不涉及任何產品語意，每個 `-ist` 產品各刻一次只會讓實作各自漂移——因此收進庫。  ## 最小用法  ```dart KlpApp(   home: const MyHomePage(), ) ```  ## 搭配 router  給了 [router] 但沒給 [home] 時，自動以 [KlpRouterOutlet] 當作首頁； 兩者都給時，[home] 仍會被包在 [KlpRouterScope] 之下，因此 [home] 的子樹 裡任何位置都能用 `context.klpRouter`（[KlpRouterOutlet] 放在哪一層由消費者 自己決定）。  ```dart KlpApp(   router: KlpRouter(     routes: [KlpRoute(id: 'home', builder: (_) => const HomePage())],     initialId: 'home',   ), ) ```  ## 切換明暗  ```dart KlpApp.of(context).toggleBrightness(); ```  ## 換視覺風格  [style] 決定字體、間距、圓角、動態、分層手法等**除了色彩以外**的每一層； 色彩固定由 [KlpApp] 依目前明暗在 `KlpThemeData.light` 與 `KlpThemeData.dark` 之間切換——這樣「切換明暗」才有事可做。要自訂色彩（例如品牌色），改用 `buildKlpTheme` 自己組 `MaterialApp`，而不是透過 [KlpApp]。 | [klp_app.md](./app/klp_app.md) |
