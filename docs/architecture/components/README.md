# Kallopis 元件樹架構全覽

> 本目錄遵循 `/focused-architecture-diagram` 規範，精確繪製 Kallopis 全部 229 個 Widget 元件之內部組成架構。

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
- [layout — 版面原語 (9)](#layout)
- [interaction — 互動 (12)](#interaction)
- [controls — 控制項 (15)](#controls)
- [form — 表單 (33)](#form)
- [data — 資料呈現 (28)](#data)
- [feedback — 狀態與回饋 (15)](#feedback)
- [overlay — 浮層 (11)](#overlay)
- [navigation — 導覽元件 (20)](#navigation)
- [editor — 編輯器周邊 (29)](#editor)
- [shell — 應用外殼 (23)](#shell)
- [routing — 分發 (2)](#routing)
- [app — 應用程式進入點與根容器 (4)](#app)

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
| `KlpDashedBorder` | `Stateless` | 虛線邊框容器。為子元件提供自訂粗細、圓角、顏色與虛線間距的虛線外框。  預設使用 theme 的 [KlpShapeTheme.dashedOpacity] 輔助線顏色與 [KlpShapeTheme.control] 圓角。 | [klp_dashed_border.md](./surface/klp_dashed_border.md) |
| `KlpDashedDivider` | `Stateless` | 虛線分隔線。支援水平與垂直兩種方向，以及自訂線寬、顏色與虛線間距。  預設使用 theme 的 [KlpShapeTheme.hairline] 粗細與 [KlpShapeTheme.dashedOpacity] 輔助線顏色。 | [klp_dashed_divider.md](./surface/klp_dashed_divider.md) |
| `KlpDivider` | `Stateless` | Kallopis KlpDivider 元件 | [klp_divider.md](./surface/klp_divider.md) |
| `KlpPageBackgroundEditor` | `Stateful` | 編輯受限 point／line 背景 recipe 的受控視覺元件。 | [klp_page_background_editor.md](./surface/klp_page_background_editor.md) |
| `KlpPageBackgroundPainter` | `Stateless` | 所有頁面背景 recipe 共用的 renderer。 | [klp_page_background_painter.md](./surface/klp_page_background_painter.md) |
| `KlpSection` | `Stateless` | 帶標題的內容分段。`label` 是標題上方的小型分類文字。 | [klp_section.md](./surface/klp_section.md) |
| `KlpStrokeFrame` | `Stateless` | Kallopis KlpStrokeFrame 元件 | [klp_stroke_frame.md](./surface/klp_stroke_frame.md) |
| `KlpSurface` | `Stateless` | 有底色的容器，是所有區塊的基底。`tone` 指定它在表面階層中的位置， 支援邊框、微漸層、外發光與霧化透明（毛玻璃）等多種原生 Box 視覺效果。 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）自適應渲染。 | [klp_surface.md](./surface/klp_surface.md) |

<a id="layout"></a>
### layout — 版面原語 (9)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpMasonryGrid` | `Stateless` | 將高度不同的內容依序分配到多欄的瀑布流版面。 | [klp_masonry_grid.md](./layout/klp_masonry_grid.md) |
| `KlpOverlayHost` | `Stateless` | 浮層容器掛載點。 | [klp_overlay_host.md](./layout/klp_overlay_host.md) |
| `KlpRegion` | `Stateless` | 區域容器。包裝標題、主要內容與頁尾。 | [klp_region.md](./layout/klp_region.md) |
| `KlpResizablePane` | `Stateless` | 寬度可調節面板容器。 | [klp_resizable_pane.md](./layout/klp_resizable_pane.md) |
| `KlpResizeHandle` | `Stateless` | 拖曳調整水平或垂直尺寸的把手。 | [klp_resize_handle.md](./layout/klp_resize_handle.md) |
| `KlpScrollViewport` | `Stateless` | 具備主題捲軸樣式的單向捲動容器。 | [klp_scroll_viewport.md](./layout/klp_scroll_viewport.md) |
| `KlpSplitLayout` | `Stateless` | 分割版面原語。支援左/中/右或左右分割，以及虛線分隔線。 | [klp_split_layout.md](./layout/klp_split_layout.md) |
| `KlpVirtualGrid` | `Stateless` | 格狀虛擬化捲動檢視。 | [klp_virtual_grid.md](./layout/klp_virtual_grid.md) |
| `KlpVirtualList` | `Stateless` | 長清單虛擬化捲動檢視。 | [klp_virtual_list.md](./layout/klp_virtual_list.md) |

<a id="interaction"></a>
### interaction — 互動 (12)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpDragPreview` | `Stateless` | Kallopis KlpDragPreview 元件 | [klp_drag_preview.md](./interaction/klp_drag_preview.md) |
| `KlpDropIndicator` | `Stateless` | Kallopis KlpDropIndicator 元件 | [klp_drop_indicator.md](./interaction/klp_drop_indicator.md) |
| `KlpDropTarget` | `Stateless` | Kallopis KlpDropTarget 元件 | [klp_drop_target.md](./interaction/klp_drop_target.md) |
| `KlpFilterBar` | `Stateless` | 篩選工具列。支援標籤、鍵值對、移除按鈕與新增篩選動作。 | [klp_filter_bar.md](./interaction/klp_filter_bar.md) |
| `KlpInteractionSettings` | `Stateless` | 長按門檻的區域覆寫。  門檻的**預設值來自 theme**（`KlpMotionTheme.longPressThreshold`），這個 InheritedWidget 只負責「某一小塊 UI 要用不一樣的門檻」。原本它自己持有一份 `defaultThreshold` 常數， 與 theme 構成同一條規則的兩份實作——兩份實作必然靜默分岔，改了 theme 卻沒改這裡時 不會有任何錯誤，只是門檻沒變。 | [klp_interaction_settings.md](./interaction/klp_interaction_settings.md) |
| `KlpKeyBindingHost` | `Stateless` | 將 controller 的目前 scope 接到 Flutter Shortcuts／Actions。 | [klp_key_binding_host.md](./interaction/klp_key_binding_host.md) |
| `KlpKeyBindingRegion` | `Stateless` | 宣告一個可成為快捷鍵 active scope 的畫面區域。 | [klp_key_binding_region.md](./interaction/klp_key_binding_region.md) |
| `KlpPresenceIndicator` | `Stateless` | 協作者在線／連線狀態標記。 | [klp_presence_indicator.md](./interaction/klp_presence_indicator.md) |
| `KlpPressable` | `Stateful` | 可按壓表面的 hover／focus 視覺。 | [klp_pressable.md](./interaction/klp_pressable.md) |
| `KlpSelectionToolbar` | `Stateless` | 批次選取浮動／固定操作列。 | [klp_selection_toolbar.md](./interaction/klp_selection_toolbar.md) |
| `KlpShortcutHint` | `Stateless` | 鍵盤快捷鍵提示標籤。 | [klp_shortcut_hint.md](./interaction/klp_shortcut_hint.md) |
| `KlpStateHighlight` | `Stateless` | 疊在內容上的狀態高亮。  **hover 與 selected 一律以高亮色表達，不畫邊框。** 先前這兩個狀態在庫裡有兩套 語彙——`KlpPressable` 用高亮、表單與 explorer 用虛線框——同一件事兩種畫法， 消費者無從預期。  高亮以 [Stack] 疊在內容之上而不是換掉內容的底色：後者會逼每個元件自己知道 「我原本的底色是什麼、混上去之後該是什麼」，而那正是元件不該知道的事。 | [klp_state_highlight.md](./interaction/klp_state_highlight.md) |

<a id="controls"></a>
### controls — 控制項 (15)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpButton` | `Stateful` | 主要動作按鈕。`tone` 決定語意強度（primary／secondary／ghost／dashed／danger）， `size` 支援五段緊湊尺寸階級（xs: 28px, sm: 32px, md: 36px, lg: 40px, xl: 48px）， 預設使用 sm，`compact` 使用 xs；`selected` 是由呼叫端持有的持續選取狀態。 圓角、內距、高度、狀態 wash 與邊框皆由風格表解析目前 theme。 | [klp_button.md](./controls/klp_button.md) |
| `KlpCheckbox` | `Stateless` | Kallopis KlpCheckbox 元件 | [klp_checkbox.md](./controls/klp_checkbox.md) |
| `KlpCombobox` | `Stateful` | 可輸入的下拉選單（autocomplete）。  **輸入框重用 [KlpTextField]，下拉面板重用 [KlpMenu]**——本庫「一條規則只能有 一個實作」：欄位外觀與選單外觀已經各自只有一份，這裡不重新畫一套。  是**受控元件**：目前的輸入文字（[query]）、候選清單（[options]）都由呼叫端 持有並傳入，本元件只負責過濾顯示、鍵盤導覽與觸發 [onQueryChanged]／ [onSelected]。選出一個選項後，呼叫端通常會把 [query] 更新成該選項的 [KlpComboboxOption.label]。  鍵盤：↓／↑ 在目前過濾結果間移動，Enter 選定醒目提示的項目；[allowFreeText] 為 `true` 時，Enter 在沒有醒目提示項目但輸入框非空時改觸發 [onFreeTextSubmitted]，讓呼叫端接受清單以外的自由輸入值。Esc 收起面板。 | [klp_combobox.md](./controls/klp_combobox.md) |
| `KlpCompactSwitch` | `Stateless` | Kallopis KlpCompactSwitch 元件 | [klp_compact_switch.md](./controls/klp_compact_switch.md) |
| `KlpIconButton` | `Stateful` | 只有圖示的按鈕。`label` 為必填且用於無障礙標註——圖示本身沒有可讀文字， 沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。 | [klp_icon_button.md](./controls/klp_icon_button.md) |
| `KlpOklchColorEditor` | `Stateless` | 以 Lightness、Chroma、Hue 與 Alpha 編輯 [KlpOklchColor] 的控制項。 | [klp_oklch_color_editor.md](./controls/klp_oklch_color_editor.md) |
| `KlpOklchColorPicker` | `Stateless` | 以三個二維色彩平面與四軸控制編輯 [KlpOklchColor]。  元件不持有產品狀態；呼叫端以 [value] 與 [onChanged] 控制目前色彩。 | [klp_oklch_color_picker.md](./controls/klp_oklch_color_picker.md) |
| `KlpSegmentedControl` | `Stateless` | Kallopis KlpSegmentedControl 元件 | [klp_segmented_control.md](./controls/klp_segmented_control.md) |
| `KlpSelect` | `Stateful` | 下拉選擇的觸發器。**它只負責顯示目前的值與觸發 `onPressed`**，選單本身由呼叫端 以 `KlpMenu` 開啟——選項來源是產品資料，不屬於視覺層。 | [klp_select.md](./controls/klp_select.md) |
| `KlpSlider` | `Stateless` | Kallopis KlpSlider 元件 | [klp_slider.md](./controls/klp_slider.md) |
| `KlpSlidingSelection` | `Stateless` | Kallopis KlpSlidingSelection 元件 | [klp_sliding_selection.md](./controls/klp_sliding_selection.md) |
| `KlpTextField` | `Stateful` | 單行或多行文字輸入。內部使用 `TextFormField`，所需的 `Material` 祖先由本元件 自行提供，消費者不需要另外包一層。 | [klp_text_field.md](./controls/klp_text_field.md) |
| `KlpToggle` | `Stateless` | Kallopis KlpToggle 元件 | [klp_toggle.md](./controls/klp_toggle.md) |
| `KlpToggleIndicator` | `Stateless` | Kallopis KlpToggleIndicator 元件 | [klp_toggle_indicator.md](./controls/klp_toggle_indicator.md) |
| `KlpTriStateToggle` | `Stateless` | Kallopis KlpTriStateToggle 元件 | [klp_tri_state_toggle.md](./controls/klp_tri_state_toggle.md) |

<a id="form"></a>
### form — 表單 (33)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAffixedTextField` | `Stateless` | 在文字輸入旁提供不可編輯前綴與尾端語意動作。 | [klp_affixed_text_field.md](./form/klp_affixed_text_field.md) |
| `KlpApprovalStepsField` | `Stateless` | 審批步驟排序欄位。支援步驟上下移動、刪除與新增。 | [klp_approval_steps_field.md](./form/klp_approval_steps_field.md) |
| `KlpCalendar` | `Stateless` | 月曆面板：月份切換、日期格、今天標記、選取狀態，並可停用特定日期。  **這是純顯示元件，不持有任何日期狀態**——目前顯示的月份、選取的日期都由呼叫端 透過 [month]、[selectedDate]／[selectedRange] 傳入，切換月份與選日期一律經 [onPreviousMonth]／[onNextMonth]／[onDateSelected] 回呼，由呼叫端決定下一步狀態。  **不內建任何語言字串。** 月份標題（[monthLabel]）與星期縮寫（[weekdayLabels]） 一律由呼叫端組出——本庫沒有 l10n 機制，不替產品決定用哪種語言、哪一天是一週的 開始（見 [firstWeekday]）。 | [klp_calendar.md](./form/klp_calendar.md) |
| `KlpCodeEditorField` | `Stateless` | 結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。 | [klp_code_editor_field.md](./form/klp_code_editor_field.md) |
| `KlpCodeField` | `Stateless` | 程式碼欄位：唯讀時走語法高亮的 [KlpCodeViewer]，可編輯時走純文字的 [KlpTextArea]。  [readOnly] 切換的是整套渲染方式而非同一個 widget 加鎖——唯讀模式沒有 [onChanged] 也沒有 [error] 提示，這兩者只在可編輯（[readOnly] 為 false） 時才有意義。[language] 只影響唯讀模式下的語法高亮，可編輯模式不使用。 | [klp_code_field.md](./form/klp_code_field.md) |
| `KlpColorRoleField` | `Stateless` | 從一組色彩角色（例如 semantic token 名稱）中選擇一個的下拉欄位。  是 [KlpSelectField] 針對「選項本身就是色彩角色」這個情境的薄封裝—— [roles] 直接複用 [KlpChoiceOption]，實際渲染完全委派給 [KlpSelectField]。 找不到 [selectedId] 對應的角色時會退回顯示 [roles] 的第一項。 | [klp_color_role_field.md](./form/klp_color_role_field.md) |
| `KlpCompoundField` | `Stateful` | 在單一控制框內組合主要文字與受控尾端選項。 | [klp_compound_field.md](./form/klp_compound_field.md) |
| `KlpConditionalFieldRegion` | `Stateless` | 依條件顯示／隱藏一段欄位，並用 [AnimatedSize] 補間高度變化，避免表單 其他欄位因為突然增減內容而跳動。  [visible] 為 false 時 [child] 會被整個換成 [SizedBox.shrink]，因此 child 的 widget 狀態不會保留——若 child 內有輸入控制項且需要在重新顯示時 保住使用者輸入，請自行在 child 上加 [GlobalKey] 或改用其他方式保存資料。 | [klp_conditional_field_region.md](./form/klp_conditional_field_region.md) |
| `KlpDateField` | `Stateful` | 日期輸入欄位。文字輸入永遠可用；提供 [calendar] 時額外接上 [KlpCalendar] 作為挑選面板，兩套輸入路徑共用同一個文字結果，不是各自獨立的兩個元件。 | [klp_date_field.md](./form/klp_date_field.md) |
| `KlpDateRangeField` | `Stateless` | 在同一控制框中編輯起訖日期，並可由尾端動作開啟產品提供的日期挑選器。 | [klp_date_range_field.md](./form/klp_date_range_field.md) |
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
| `KlpQuantityField` | `Stateless` | 以欄位等高的減少／增加操作調整數量。 | [klp_quantity_field.md](./form/klp_quantity_field.md) |
| `KlpReferencePicker` | `Stateless` | Kallopis KlpReferencePicker 元件 | [klp_reference_picker.md](./form/klp_reference_picker.md) |
| `KlpRepeaterField` | `Stateless` | 可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。  不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過 [onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定 並重新傳入新的 [items]。 | [klp_repeater_field.md](./form/klp_repeater_field.md) |
| `KlpSelectField` | `Stateful` | 單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面 （不是彈出層），選中後自動收合。  [valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項—— 這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。 需要彈出式選單而非就地展開時請改用 [KlpMenu]。 | [klp_select_field.md](./form/klp_select_field.md) |
| `KlpStatusRoleSwatches` | `Stateless` | 狀態色彩角色色票組（Roles only）。只提供語意角色選擇，不提供直接色碼選擇。 | [klp_status_role_swatches.md](./form/klp_status_role_swatches.md) |
| `KlpTagChip` | `Stateless` | 標籤膠囊元件。呈現單一標籤並支援移除操作。 | [klp_tag_chip.md](./form/klp_tag_chip.md) |
| `KlpTagInputField` | `Stateless` | 標籤輸入與群組欄位。支援新增、移除個別標籤與清空所有標籤。 | [klp_tag_input_field.md](./form/klp_tag_input_field.md) |
| `KlpTextArea` | `Stateless` | 多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`， 其餘外觀與行為完全繼承自 [KlpTextField]。 | [klp_text_area.md](./form/klp_text_area.md) |

<a id="data"></a>
### data — 資料呈現 (28)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAccordion` | `Stateful` | 可摺疊的內容區清單。  [multiple] 為 `false`（預設）時同一時間只能展開一項，再點其他標題會先收合原本 展開的那項；為 `true` 時各項互不影響。展開狀態是暫存的 UI 狀態而非產品資料， 因此元件自行持有——需要預先展開特定項目或觀察變化時用 [initialExpandedIds] 與 [onExpandedChanged]。 | [klp_accordion.md](./data/klp_accordion.md) |
| `KlpAvatar` | `Stateless` | Kallopis KlpAvatar 元件 | [klp_avatar.md](./data/klp_avatar.md) |
| `KlpAvatarGroup` | `Stateless` | Kallopis KlpAvatarGroup 元件 | [klp_avatar_group.md](./data/klp_avatar_group.md) |
| `KlpBadge` | `Stateless` | 狀態標記 (Badge)。預設使用 12px／16px 文字、6px 水平與 2px 垂直內距， 組成約 20px 高的 pill。 | [klp_badge.md](./data/klp_badge.md) |
| `KlpCard` | `Stateless` | 內容卡片。 | [klp_card.md](./data/klp_card.md) |
| `KlpCodeViewer` | `Stateful` | Kallopis KlpCodeViewer 元件 | [klp_code_viewer.md](./data/klp_code_viewer.md) |
| `KlpDataTable` | `Stateless` | 結構化資料表格：固定欄位、可選排序與多選。  不做分頁或虛擬捲動——列數多時請自行分頁後再傳入 [rows]。選取狀態 （[selectedIds]）與排序狀態（[sort]）都由呼叫端持有，這個元件本身無狀態， 只在使用者互動時透過 [onSelected]／[onSort] 回報意圖。 | [klp_data_table.md](./data/klp_data_table.md) |
| `KlpDateGrid` | `Stateless` | 一列七欄的日期概覽格。 | [klp_date_grid.md](./data/klp_date_grid.md) |
| `KlpDiffViewer` | `Stateless` | 程式碼差異檢視器 (Diff Viewer)。  呈現檔案名稱標題、雙欄行號對照、新增（綠底）與刪除（紅底）標記行，以及逐行審查操作。 | [klp_diff_viewer.md](./data/klp_diff_viewer.md) |
| `KlpFilePreview` | `Stateless` | [KlpFilePreview] 主體區塊要呈現的狀態。  這個狀態只決定預覽主體畫什麼，不影響外層卡片的 header／footer——載入中 或發生錯誤時，檔名與操作按鈕仍照常顯示。 檔案預覽卡片：header 顯示檔名與中繼資料，中段畫預覽內容，footer 放外部 操作。  [preview] 優先於 [textContent]——兩者都給時只會用 [preview]；都不給且 [state] 為 [KlpFilePreviewState.ready] 時顯示「無可用預覽」。[state] 由 呼叫端管理，這個元件不會自己判斷載入或解析是否失敗。 | [klp_file_preview.md](./data/klp_file_preview.md) |
| `KlpJsonTree` | `Stateless` | Kallopis KlpJsonTree 元件 | [klp_json_tree.md](./data/klp_json_tree.md) |
| `KlpKeyValueList` | `Stateless` | Kallopis KlpKeyValueList 元件 | [klp_key_value_list.md](./data/klp_key_value_list.md) |
| `KlpKeyValueTable` | `Stateless` | Kallopis KlpKeyValueTable 元件 | [klp_key_value_table.md](./data/klp_key_value_table.md) |
| `KlpListTile` | `Stateful` | Kallopis KlpListTile 元件 | [klp_list_tile.md](./data/klp_list_tile.md) |
| `KlpMessageBubble` | `Stateless` | 訊息作者、時間與內容的通用呈現單元。 | [klp_message_bubble.md](./data/klp_message_bubble.md) |
| `KlpMessageThread` | `Stateless` | 可載入較早內容的訊息串版面。 | [klp_message_thread.md](./data/klp_message_thread.md) |
| `KlpMetricCard` | `Stateless` | 指標呈現卡片 (Metric Card)。  呈現標籤、核心數值、單位、趨勢箭頭、狀態說明或迷你進度長條。 支援正常（neutral/success）與違規告警（danger 具備紅色外框與文字）。 | [klp_metric_card.md](./data/klp_metric_card.md) |
| `KlpPreviewCard` | `Stateless` | 預覽內容、標題與中繼資訊的通用卡片。 | [klp_preview_card.md](./data/klp_preview_card.md) |
| `KlpProgress` | `Stateless` | Kallopis KlpProgress 元件 | [klp_progress.md](./data/klp_progress.md) |
| `KlpScheduleList` | `Stateless` | 固定時間欄、標題與選填標籤的排程清單。 | [klp_schedule_list.md](./data/klp_schedule_list.md) |
| `KlpSortControl` | `Stateless` | Kallopis KlpSortControl 元件 | [klp_sort_control.md](./data/klp_sort_control.md) |
| `KlpStepper` | `Stateless` | 步驟流程指示。依 [currentIndex] 把 [steps] 分成已完成／進行中／未開始三態。  純顯示元件——不持有互動狀態，也不處理點擊；切換到下一步是呼叫端更新 [currentIndex] 後重建的結果。[direction] 決定排列方向。 | [klp_stepper.md](./data/klp_stepper.md) |
| `KlpTag` | `Stateless` | 可移除或可點擊的分類標籤 (Tag)。 | [klp_tag.md](./data/klp_tag.md) |
| `KlpTaskList` | `Stateless` | 帶有核取狀態與輔助資訊的待辦清單。 | [klp_task_list.md](./data/klp_task_list.md) |
| `KlpTerminal` | `Stateless` | 終端機模擬與指令執行檢視器 (Terminal)。  具備整體實線細邊框、頂部三點視窗標記、指令列與輸出區，內容區域採用 stage 底色。 | [klp_terminal.md](./data/klp_terminal.md) |
| `KlpTimeline` | `Stateless` | 時間軸：事件依序排列，每項有標記、標題、時間、可選內容。  只負責排版與標記／連接線的視覺語言；事件的先後順序、時間格式與內容完全由 呼叫端的 [items] 決定，這裡不做排序也不解讀時間字串。 | [klp_timeline.md](./data/klp_timeline.md) |
| `KlpTree` | `Stateless` | [KlpTree]／[KlpTreeItem] 的一個節點。  [hasChildren] 與 [children] 是分開的兩個訊號：[hasChildren] 讓呼叫端在還沒 載入子節點（例如遠端延遲載入）時就先畫出展開箭頭，[children] 才是實際已知 的子節點資料。[expanded] 是這個節點的預設展開狀態，只有在 [KlpTree.expandedIds] 為 null 時才生效——傳了 `expandedIds` 之後展開狀態 改由呼叫端控管，這個欄位就不再讀取。[tone] 為節點加上狀態色（例如標示 錯誤或警告的檔案）。 樹狀節點清單，用於檔案總管、大綱這類階層式導覽。  展開／選取狀態預設由每個 [KlpTreeNode] 自帶（[KlpTreeNode.expanded]／ [KlpTreeNode.selected]），適合靜態或一次性渲染；若要由呼叫端集中控管， 傳入 [expandedIds]／[selectedId] 即可覆蓋節點自帶的狀態。 | [klp_tree.md](./data/klp_tree.md) |
| `KlpTreeItem` | `Stateless` | 單一樹狀節點（含其子節點）的獨立渲染入口。  用於只需畫出一棵子樹、不需要 [KlpTree] 的清單容器與 `Semantics` 分組時。 展開／選取狀態一律讀取節點自帶的 [KlpTreeNode.expanded]／ [KlpTreeNode.selected]，沒有 [KlpTree] 那種由呼叫端集中控管的選項。 | [klp_tree_item.md](./data/klp_tree_item.md) |

<a id="feedback"></a>
### feedback — 狀態與回饋 (15)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpEmptyState` | `Stateless` | Kallopis KlpEmptyState 元件 | [klp_empty_state.md](./feedback/klp_empty_state.md) |
| `KlpErrorState` | `Stateless` | Kallopis KlpErrorState 元件 | [klp_error_state.md](./feedback/klp_error_state.md) |
| `KlpFocusBoundary` | `Stateful` | 建立可回復焦點的邊界；對話框或導覽完成後可呼叫 [requestFocus]。 | [klp_focus_boundary.md](./feedback/klp_focus_boundary.md) |
| `KlpInlineNotice` | `Stateless` | Kallopis KlpInlineNotice 元件 | [klp_inline_notice.md](./feedback/klp_inline_notice.md) |
| `KlpLiveRegion` | `Stateless` | 控制重複公告的可及性 live region；呼叫端提供已去重的訊息。 | [klp_live_region.md](./feedback/klp_live_region.md) |
| `KlpLoadingState` | `Stateless` | Kallopis KlpLoadingState 元件 | [klp_loading_state.md](./feedback/klp_loading_state.md) |
| `KlpPermissionState` | `Stateless` | Kallopis KlpPermissionState 元件 | [klp_permission_state.md](./feedback/klp_permission_state.md) |
| `KlpProgressOverlay` | `Stateless` | Kallopis KlpProgressOverlay 元件 | [klp_progress_overlay.md](./feedback/klp_progress_overlay.md) |
| `KlpRegionPlaceholder` | `Stateless` | Kallopis KlpRegionPlaceholder 元件 | [klp_region_placeholder.md](./feedback/klp_region_placeholder.md) |
| `KlpSkeletonLine` | `Stateless` | Kallopis KlpSkeletonLine 元件 | [klp_skeleton_line.md](./feedback/klp_skeleton_line.md) |
| `KlpStatusIndicator` | `Stateless` | 狀態指示標記與文字。 | [klp_status_indicator.md](./feedback/klp_status_indicator.md) |
| `KlpToast` | `Stateless` | 短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`， 但實際的顯示與收起由呼叫端控制。 | [klp_toast.md](./feedback/klp_toast.md) |
| `KlpToastStack` | `Stateless` | Kallopis KlpToastStack 元件 | [klp_toast_stack.md](./feedback/klp_toast_stack.md) |
| `KlpWorkflowProgress` | `Stateless` | 顯示具名稱的真實階段，並向輔助技術宣告目前階段。 | [klp_workflow_progress.md](./feedback/klp_workflow_progress.md) |
| `KlpWorkflowStateSurface` | `Stateless` | 將有限工作流狀態轉成可讀、可宣告的狀態表面。 | [klp_workflow_state_surface.md](./feedback/klp_workflow_state_surface.md) |

<a id="overlay"></a>
### overlay — 浮層 (11)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpContextMenu` | `Stateful` | 右鍵選單：掛在任意子樹上，滑鼠右鍵或觸控長按於指標位置彈出。  選單本體重用既有的 [KlpMenu] 與 [KlpMenuItemData]——本元件只負責觸發時機、 指標定位與點外部關閉，**不重新實作選單外觀**（一條規則只能有一個實作）。 彈出位置沿用 [KlpMenuLayout.resolvePosition]，與 [KlpMenu] 在其他彈出場景 使用同一套定位邏輯，才不會有兩份互相分岔的擺放規則。 | [klp_context_menu.md](./overlay/klp_context_menu.md) |
| `KlpDialog` | `Stateless` | 對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。 `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。 | [klp_dialog.md](./overlay/klp_dialog.md) |
| `KlpDrawer` | `Stateless` | 從邊緣滑入的面板：側邊欄、篩選面板，或（[KlpDrawerEdge.bottom] 方向）行動裝置 常見的 sheet。  **不負責彈出**——呼叫端決定用什麼容器承載這個 widget（例如 `KlpOverlayHost`、`Stack` 或 `Overlay`），並透過 [open] 驅動顯示與否； 本元件只負責滑入滑出的動畫、遮罩與「點遮罩關閉」這個互動。呼叫端持有 [open] 的狀態，本元件本身不追蹤開關。 | [klp_drawer.md](./overlay/klp_drawer.md) |
| `KlpMenu` | `Stateful` | 彈出式選單面板：標題列加上一組 [KlpMenuItemData]。  只畫面板本身（含陰影與圓角），不處理定位或觸發——插入 overlay 的位置請用 [KlpMenuLayout] 先算好，選單的顯示／關閉時機也由呼叫端（通常是 `showMenu` 或自訂 overlay）控制。  **鍵盤**：`↓`／`↑` 在項目間移動高亮（跳過 [KlpMenuItemData.enabled] 為 `false` 的項目，並在頭尾之間循環），`Home`／`End` 跳到首／尾一個可用項目， `Enter`／`Space` 觸發目前高亮的項目，`Escape` 呼叫 [onEscape]（通常用來關閉 選單，由呼叫端決定要不要提供）。索引移動的規則沿用 [KlpRovingIndex]，與 [KlpCombobox] 共用同一套實作，不是第二份重寫。  高亮的視覺沿用既有的 hover／focus 語言（[KlpMenuItem] 的 `active` 底色）， 不是新增的第三種視覺；只有 [KlpMenuItemData.selected]（真正的選取狀態）才會 用高對比的選取底色。  選單預設會在第一次 build 時自動取得鍵盤焦點（[autofocus]），因為選單通常是 剛彈出的 overlay，此時畫面上不會有其他東西持有焦點；若呼叫端要自行控制焦點 時機（例如選單嵌在一般版面裡而非彈出層），可以把 [autofocus] 設為 `false`。 | [klp_menu.md](./overlay/klp_menu.md) |
| `KlpMenuItem` | `Stateful` | [KlpMenu] 裡單一項目的渲染，自行追蹤 hover／focus 以決定背景與前景色。  選取狀態（[KlpMenuItemData.selected]）與 hover／focus 共用同一套「active」 視覺，但前景色只有選取或停用時才會變——hover 只加背景高亮， 與一般控制項的互動語言一致。一般透過 [KlpMenu] 間接使用， 只有要在選單容器之外單獨畫一個選單項目時才需要直接用它。 | [klp_menu_item.md](./overlay/klp_menu_item.md) |
| `KlpPopover` | `Stateless` | Kallopis KlpPopover 元件 | [klp_popover.md](./overlay/klp_popover.md) |
| `KlpPopupBackground` | `Stateless` | Popup 的背景遮罩。點擊 panel 以外的可互動背景時呼叫 [onDismiss]。  若位於 [KlpPopupInteractionScope] 之下，scope 的頂部範圍只負責顯示遮罩， 不會接收 pointer，因此視窗標題列的拖動與雙擊事件優先。 | [klp_popup_background.md](./overlay/klp_popup_background.md) |
| `KlpPopupInteractionScope` | `Stateless` | 供 App frame 注入視窗標題列保留範圍。 | [klp_popup_interaction_scope.md](./overlay/klp_popup_interaction_scope.md) |
| `KlpPopupPanel` | `Stateless` | Popup 的固定尺寸 surface。內容內距由 [child] 自己擁有。 | [klp_popup_panel.md](./overlay/klp_popup_panel.md) |
| `KlpTooltip` | `Stateless` | Kallopis KlpTooltip 元件 | [klp_tooltip.md](./overlay/klp_tooltip.md) |
| `KlpTooltipSurface` | `Stateless` | Kallopis KlpTooltipSurface 元件 | [klp_tooltip_surface.md](./overlay/klp_tooltip_surface.md) |

<a id="navigation"></a>
### navigation — 導覽元件 (20)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpActionGroup` | `Stateless` | 一組動作按鈕的容器，寬度不足時自動換行，換行時保留與同一行相同的間距。  只負責排版間距——按鈕本身的樣式、順序、是否停用都由 [children] 自行決定。 | [klp_action_group.md](./navigation/klp_action_group.md) |
| `KlpBreadcrumb` | `Stateless` | Kallopis KlpBreadcrumb 元件 | [klp_breadcrumb.md](./navigation/klp_breadcrumb.md) |
| `KlpExplorer` | `Stateless` | 具有統一表面、分類與節點排版的 Explorer。  產品只提供 [categories] 與互動 callback。分類節奏、節點列高、縮排與 表面層級全由 Kallopis 管理；查詢、搜尋 UI 與後端資料取得由產品負責。 | [klp_explorer.md](./navigation/klp_explorer.md) |
| `KlpFileExplorer` | `Stateful` | 檔案瀏覽器（File Explorer）。  支援分類分組（可折疊）、資料夾樹狀結構（可展開）與一般檔案節點選取。 支援受控（傳入 `expandedSectionIds` / `expandedItemIds` / `selectedId`） 與非受控（讀取各 Section 與 Item 的 `expanded` / `selected` 屬性）兩種模式。 | [klp_file_explorer.md](./navigation/klp_file_explorer.md) |
| `KlpFileExplorerFolderView` | `Stateful` | 折疊資料夾視圖（帶展開箭頭、資料夾圖示與縮排）。 | [klp_file_explorer_folder_view.md](./navigation/klp_file_explorer_folder_view.md) |
| `KlpFileExplorerItemView` | `Stateful` | 一般檔案項目視圖（含檔案圖示、文字標題、選取高亮與 Hover 回饋）。 | [klp_file_explorer_item_view.md](./navigation/klp_file_explorer_item_view.md) |
| `KlpFileExplorerSection` | `Stateless` | Kallopis KlpFileExplorerSection 元件 | [klp_file_explorer_section.md](./navigation/klp_file_explorer_section.md) |
| `KlpFileExplorerSectionView` | `Stateless` | 分類區塊視圖（含分類標題、折疊動畫與項目清單）。 | [klp_file_explorer_section_view.md](./navigation/klp_file_explorer_section_view.md) |
| `KlpNavigationRail` | `Stateful` | Workbench 的主要圖示導覽軌。  分組模式只接受 [KlpRailItemGroup]；群組之間自動加入分隔線，項目只能在 原群組內排序。 | [klp_navigation_rail.md](./navigation/klp_navigation_rail.md) |
| `KlpNavigator` | `Stateful` | Sidebar 的通用導覽組成。  Category 與 Element 沿用 Kallopis Catalog 目錄的視覺與高度；Component 是 不受固定列高限制的插槽。產品只提供資料、受控狀態與事件。 | [klp_navigator.md](./navigation/klp_navigator.md) |
| `KlpPagination` | `Stateless` | 上一頁／頁碼／下一頁的簡易分頁控制項。  頁碼從 1 開始（不是從 0）；在第一頁或最後一頁時對應按鈕會自動停用， 呼叫端不需要自己判斷邊界。不提供跳頁輸入框或頁碼清單，適合頁數不多、 只需要前後翻頁的場合。 | [klp_pagination.md](./navigation/klp_pagination.md) |
| `KlpPreviewTree` | `Stateless` | 提案專用樹；語意名稱明確區分預覽節點與 canonical 導覽節點。 | [klp_preview_tree.md](./navigation/klp_preview_tree.md) |
| `KlpPublicationProgressOverlay` | `Stateless` | 原子發布期間保持預覽樹穩定，並在其上呈現具名階段。 | [klp_publication_progress_overlay.md](./navigation/klp_publication_progress_overlay.md) |
| `KlpRailItem` | `Stateful` | Kallopis KlpRailItem 元件 | [klp_rail_item.md](./navigation/klp_rail_item.md) |
| `KlpSidebarIdentityHeader` | `Stateless` | Primary Sidebar 頂部的 workspace identity。  呼叫端提供圖示、名稱與選填尾端內容；Kallopis 統一負責圖示底面、文字層級、 間距與截斷行為。 | [klp_sidebar_identity_header.md](./navigation/klp_sidebar_identity_header.md) |
| `KlpSidebarNavigationButton` | `Stateful` | Primary Sidebar 內的全寬導覽按鈕。  消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、 hover 與選取色全部由 Kallopis theme 決定。 | [klp_sidebar_navigation_button.md](./navigation/klp_sidebar_navigation_button.md) |
| `KlpSidebarNavigationGroup` | `Stateless` | Primary Sidebar 的全寬導覽列群組。  呼叫端只決定項目順序；相鄰列緊密排列，不插入額外間距或分隔線。 | [klp_sidebar_navigation_group.md](./navigation/klp_sidebar_navigation_group.md) |
| `KlpSidebarSectionLabel` | `Stateless` | 側邊欄分組標題，固定高度且左對齊、使用低對比的 [KlpTextRole.label] 樣式。  固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會 讓上下間距看起來不一樣。 | [klp_sidebar_section_label.md](./navigation/klp_sidebar_section_label.md) |
| `KlpTabs` | `Stateless` | 分頁列。`selected` 是索引，`tabs` 是顯示文字；本元件不持有狀態。  **鍵盤**：任一分頁取得焦點後，`←`／`→` 會在分頁之間移動並直接切換選取 （在頭尾之間循環），沿用 [KlpRovingIndex]，與 [KlpMenu]、[KlpCombobox] 共用 同一套索引移動規則。 | [klp_tabs.md](./navigation/klp_tabs.md) |
| `KlpViewSwitcher` | `Stateless` | 同層級檢視切換器（例如「清單／看板」），以緊貼的膠囊按鈕組呈現， 選中項會有底色標示。  與 [KlpSegmentedControl] 的差異在於視覺重量更輕——[KlpViewSwitcher] 用 inset 表面搭配 hairline 間距，適合放在工具列這類次要控制的位置；需要更 強調的主要切換時請用 [KlpSegmentedControl]。 | [klp_view_switcher.md](./navigation/klp_view_switcher.md) |

<a id="editor"></a>
### editor — 編輯器周邊 (29)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAccessibilityContractPanel` | `Stateless` | 元件可及性合約表面，內容由產品的元件定義投影而來。 | [klp_accessibility_contract_panel.md](./editor/klp_accessibility_contract_panel.md) |
| `KlpBulkActionBar` | `Stateless` | Kallopis KlpBulkActionBar 元件 | [klp_bulk_action_bar.md](./editor/klp_bulk_action_bar.md) |
| `KlpCanvasDropIntent` | `Stateless` | 插入、重排、包覆、重設父層或疊放等 drop intent 指示器。 | [klp_canvas_drop_intent.md](./editor/klp_canvas_drop_intent.md) |
| `KlpCanvasMinimap` | `Stateless` | 大型空間文件的小地圖容器；viewport 投影由呼叫端提供。 | [klp_canvas_minimap.md](./editor/klp_canvas_minimap.md) |
| `KlpCanvasSelectionOverlay` | `Stateless` | 選取範圍與可選 resize handles 的通用覆層。 | [klp_canvas_selection_overlay.md](./editor/klp_canvas_selection_overlay.md) |
| `KlpCanvasToolbar` | `Stateless` | 畫布上的有限動作工具列；動作能力由呼叫端決定。 | [klp_canvas_toolbar.md](./editor/klp_canvas_toolbar.md) |
| `KlpCanvasViewport` | `Stateless` | 編輯器畫布視窗；背景直接繼承 Stage surface，不建立另一塊畫布色。 | [klp_canvas_viewport.md](./editor/klp_canvas_viewport.md) |
| `KlpCommandMenu` | `Stateful` | 命令面板：分組的指令清單，存在的意義就是不用滑鼠也能操作。  **鍵盤**：`↓`／`↑` 在（跨分組攤平後的）項目間移動高亮，跳過 [KlpCommandItemData.onPressed] 為 `null`（停用）的項目，並在頭尾之間循環； `Home`／`End` 跳到第一／最後一個可用項目；`Enter`／`Space` 觸發目前高亮的 項目；`Escape` 呼叫 [onEscape]。索引移動規則沿用 [KlpRovingIndex]，與 [KlpMenu]、[KlpCombobox] 共用同一套實作。  面板預設會在出現時自動取得鍵盤焦點（[autofocus]），因為命令面板通常是剛彈出 的 overlay。 | [klp_command_menu.md](./editor/klp_command_menu.md) |
| `KlpComponentDefinitionCard` | `Stateless` | 元件定義卡，不持有元件文件或 instance override。 | [klp_component_definition_card.md](./editor/klp_component_definition_card.md) |
| `KlpComponentLibraryGrid` | `Stateless` | 元件定義的響應式預覽網格。 | [klp_component_library_grid.md](./editor/klp_component_library_grid.md) |
| `KlpComponentStateSelector` | `Stateless` | 元件的狀態切換器；狀態值與標籤皆由呼叫端定義。 | [klp_component_state_selector.md](./editor/klp_component_state_selector.md) |
| `KlpDocumentEditActions` | `Stateless` | 文件的進入編輯、儲存與取消動作組。 | [klp_document_edit_actions.md](./editor/klp_document_edit_actions.md) |
| `KlpDocumentField` | `Stateless` | 文件欄位的標籤、值、說明與驗證組合。 | [klp_document_field.md](./editor/klp_document_field.md) |
| `KlpDocumentHeader` | `Stateless` | 結構化文件的標頭；修訂與狀態文字由產品提供。 | [klp_document_header.md](./editor/klp_document_header.md) |
| `KlpDocumentReferenceLink` | `Stateless` | 指向另一個 canonical artifact 的可及性連結。 | [klp_document_reference_link.md](./editor/klp_document_reference_link.md) |
| `KlpDocumentSection` | `Stateless` | 文件的單一語意章節；可選的動作不改變章節資料所有權。 | [klp_document_section.md](./editor/klp_document_section.md) |
| `KlpEditorToolbar` | `Stateless` | Kallopis KlpEditorToolbar 元件 | [klp_editor_toolbar.md](./editor/klp_editor_toolbar.md) |
| `KlpEntityPicker` | `Stateless` | Kallopis KlpEntityPicker 元件 | [klp_entity_picker.md](./editor/klp_entity_picker.md) |
| `KlpFlowNodeCard` | `Stateless` | Flow 節點卡；節點種類與風險文字由呼叫端提供。 | [klp_flow_node_card.md](./editor/klp_flow_node_card.md) |
| `KlpFlowValidationPanel` | `Stateless` | Flow 風險或驗證訊息清單；風險計算與修復動作由領域層提供。 | [klp_flow_validation_panel.md](./editor/klp_flow_validation_panel.md) |
| `KlpLayoutLens` | `Stateless` | 顯示 layout、size、padding、gap 與 parent 關係，不推導文件狀態。 | [klp_layout_lens.md](./editor/klp_layout_lens.md) |
| `KlpMessageComposer` | `Stateless` | 帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。 | [klp_message_composer.md](./editor/klp_message_composer.md) |
| `KlpMessageConversation` | `Stateless` | 在有限區域內組合可捲動訊息內容與底部 Composer。 | [klp_message_conversation.md](./editor/klp_message_conversation.md) |
| `KlpPageChrome` | `Stateless` | 頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面 大標題。  [breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑 請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示 多位協作者或多筆狀態，需自行組合字串或改用其他元件。 | [klp_page_chrome.md](./editor/klp_page_chrome.md) |
| `KlpPropertySummary` | `Stateless` | 實體的屬性摘要卡片：一排狀態徽章、一排標籤，再加一行中繼資料文字， 依序垂直排列。  三段固定按這個順序（badges → tags → metadata）呈現，不是各自獨立可 重排的插槽；若版面需要不同順序或省略某一段，請直接組合 [KlpBadge]／[KlpTag]／[KlpText] 而不是硬塞空清單進來。 | [klp_property_summary.md](./editor/klp_property_summary.md) |
| `KlpSaveStatusCard` | `Stateless` | 顯示最後儲存時間與一組相關狀態訊息的卡片，用於編輯器頁面告知使用者 目前的儲存／同步狀況。  [savedAt] 是已經格式化好的顯示文字（例如「2 分鐘前」），這個元件不處理 時間格式化或相對時間更新。 | [klp_save_status_card.md](./editor/klp_save_status_card.md) |
| `KlpSearchNavigator` | `Stateless` | Kallopis KlpSearchNavigator 元件 | [klp_search_navigator.md](./editor/klp_search_navigator.md) |
| `KlpTokenTable` | `Stateless` | 可排序 Token 清單的表格呈現；排序狀態由呼叫端持有。 | [klp_token_table.md](./editor/klp_token_table.md) |
| `KlpTokenValidationBanner` | `Stateless` | Token 圖形驗證結果，不自行推導循環或型別相容性。 | [klp_token_validation_banner.md](./editor/klp_token_validation_banner.md) |

<a id="shell"></a>
### shell — 應用外殼 (23)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAppScreen` | `Stateless` | 應用程式最外層，提供 Material 祖先與 app 背景。 | [klp_app_screen.md](./shell/klp_app_screen.md) |
| `KlpAppWindowHeader` | `Stateless` | 組合 App 視窗標題列的通用配方。 | [klp_app_window_header.md](./shell/klp_app_window_header.md) |
| `KlpDockHeader` | `Stateful` | Dock Group 專用的緊湊 Header。  左側區域可由 Layout 包成拖曳來源；右側 actions 是獨立 clickable 區域， 因此操作按鈕不會誤觸 panel 拖曳。 | [klp_dock_header.md](./shell/klp_dock_header.md) |
| `KlpDockLayout` | `Stateful` | Kallopis KlpDockLayout 元件 | [klp_dock_layout.md](./shell/klp_dock_layout.md) |
| `KlpNavigationRailFrame` | `Stateless` | Workbench Rail 的獨立表面。 | [klp_navigation_rail_frame.md](./shell/klp_navigation_rail_frame.md) |
| `KlpPaneCollapseControl` | `Stateful` | Pane 的收合互動控制。 | [klp_pane_collapse_control.md](./shell/klp_pane_collapse_control.md) |
| `KlpPanelFooter` | `Stateless` | Panel 底部區域的共用配方。  不繪製背景、邊框或圓角，完全繼承父 [KlpPanelFrame] 的 surface 與裁切； 只統一 footer 內容的水平 inset。 | [klp_panel_footer.md](./shell/klp_panel_footer.md) |
| `KlpPanelFrame` | `Stateless` | 通用面板：header 與 content，選用 footer。圓角使用較緊湊的 card 語意， 高度預設沿用 theme 的外殼密度。 文字顏色依據背景顏色階梯（500 以下為深色文字，600 以上為淺色文字）渲染。 | [klp_panel_frame.md](./shell/klp_panel_frame.md) |
| `KlpPanelHeader` | `Stateless` | Kallopis KlpPanelHeader 元件 | [klp_panel_header.md](./shell/klp_panel_header.md) |
| `KlpPrimarySidebarFrame` | `Stateless` | 桌面工作區的 Primary Sidebar 外框。  Identity、導覽與 Explorer 緊密排列；上下節奏由各區域自行決定。 content 與 footer 沿用 [KlpSidebarFrame] 的水平 padding 規則；footer 不再 額外包覆垂直 padding。 | [klp_primary_sidebar_frame.md](./shell/klp_primary_sidebar_frame.md) |
| `KlpResponsivePaneCoordinator` | `Stateless` | 依可用寬度切換 Pane 呈現的協調器。 | [klp_responsive_pane_coordinator.md](./shell/klp_responsive_pane_coordinator.md) |
| `KlpSidebarFrame` | `Stateless` | 側邊欄：由側邊欄自己決定內容與 footer 的內距，再交給無內距的 PanelFrame 提供背景、圓角與外側 dock margin。 | [klp_sidebar_frame.md](./shell/klp_sidebar_frame.md) |
| `KlpStageFrame` | `Stateless` | 舞台區：選用的頂部 header、中央 content、底部選用的 status 列。 | [klp_stage_frame.md](./shell/klp_stage_frame.md) |
| `KlpStageHeader` | `Stateless` | Stage 頂部的兩行識別標頭。  第一行顯示專案與區域，第二行顯示目前項目與類型；呼叫端只提供語意資料， 排版、間距與文字層級一律由 Kallopis theme 決定。 | [klp_stage_header.md](./shell/klp_stage_header.md) |
| `KlpStageTab` | `Stateless` | 顯示目前 Stage 項目的單一檔案分頁。  此元件只擁有分頁的視覺語言；檔名與目前項目的資料來源由產品提供。 | [klp_stage_tab.md](./shell/klp_stage_tab.md) |
| `KlpStageTopBar` | `Stateless` | 位於 Workbench window header 中央 Stage 區域的檔案分頁與動作列。  此列不屬於 Stage body。產品只注入檔案分頁與動作，不自行決定對齊。 | [klp_stage_top_bar.md](./shell/klp_stage_top_bar.md) |
| `KlpStatusBar` | `Stateless` | Kallopis KlpStatusBar 元件 | [klp_status_bar.md](./shell/klp_status_bar.md) |
| `KlpThemePreviewTile` | `Stateless` | Kallopis KlpThemePreviewTile 元件 | [klp_theme_preview_tile.md](./shell/klp_theme_preview_tile.md) |
| `KlpThemeToggle` | `Stateless` | Kallopis KlpThemeToggle 元件 | [klp_theme_toggle.md](./shell/klp_theme_toggle.md) |
| `KlpWindowControls` | `Stateless` | Kallopis KlpWindowControls 元件 | [klp_window_controls.md](./shell/klp_window_controls.md) |
| `KlpWindowHeader` | `Stateless` | 桌面應用程式自帶視窗標題列（Chrome Header）。整個 Header 表面都可拖動視窗； 內部操作元件仍保留 tap 等自身事件。  - **Windows / Linux 模式**：左側展示 App Icon 與標題，右側展示自訂動作與視窗控制項。 - **macOS 模式**：左側展示視窗控制項（交通燈），中間展示 App Icon 與標題，右側展示自訂動作。 | [klp_window_header.md](./shell/klp_window_header.md) |
| `KlpWorkbenchNavigationRegion` | `Stateless` | Workbench 左側導覽區域：並排獨立的 Rail 與 Sidebar surface。  本層只決定兩個同層區域的寬度與間距；完整的 Panel Tree 由 Dock layout 擁有。 | [klp_workbench_navigation_region.md](./shell/klp_workbench_navigation_region.md) |
| `KlpWorkbenchWindowHeader` | `Stateless` | Workbench 專用的單一視窗列。  在標準 [KlpWindowHeader] 上，依兩側 pane 的即時寬度定位收合按鈕； pane 收合後，Primary 按鈕會跟在標題右方，Secondary 按鈕則留在右側動作區。 | [klp_workbench_window_header.md](./shell/klp_workbench_window_header.md) |

<a id="routing"></a>
### routing — 分發 (2)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpRouterOutlet` | `Stateless` | 渲染目前的目的地。  它只做一件事：呼叫 `router.current.builder`。**不做轉場動畫**——轉場屬於產品外殼 的決定（有些頁該滑入，有些該直接換），庫替它決定就等於替所有產品決定。 | [klp_router_outlet.md](./routing/klp_router_outlet.md) |
| `KlpRouterScope` | `Stateless` | 把 [KlpRouter] 供給子樹。 | [klp_router_scope.md](./routing/klp_router_scope.md) |

<a id="app"></a>
### app — 應用程式進入點與根容器 (4)

| 元件名稱 | 類型 | 說明 | 架構文件 |
|---|---|---|---|
| `KlpAdaptive` | `Stateless` | 依 [KlpApp] 注入的平台選擇呈現分支。  只處理平台差異，不依據視窗尺寸切換平台策略。分支內部可自行處理 該平台的空間限制。 | [klp_adaptive.md](./app/klp_adaptive.md) |
| `KlpApp` | `Stateful` | `MaterialApp` 的接入層，收掉每個消費者都得自己組一次的樣板。  沒有它時，消費者要自己：套 `buildKlpTheme` 的亮／暗兩份 `ThemeData`、記得把 `themeAnimationDuration` 歸零（否則主題切換的動畫中途會有半數幀停在舊值上， 見 README「深淺切換不做過場」）、決定明暗狀態放哪裡並手刻切換入口、如果用了 [KlpRouter] 還要自己架 [KlpRouterScope]。這些細節不涉及任何產品語意，每個 `-ist` 產品各刻一次只會讓實作各自漂移——因此收進庫。  ## 最小用法  ```dart KlpApp(   home: KlpPanelFrame(content: const MyHomePage()), ) ```  ## 搭配 router  給了 [router] 但沒給 [home] 時，自動以 [KlpRouterOutlet] 當作首頁； 兩者都給時，[home] 仍會被包在 [KlpRouterScope] 之下，因此 [home] 的子樹 裡任何位置都能用 `context.klpRouter`（[KlpRouterOutlet] 放在哪一層由消費者 自己決定）。  ```dart KlpApp(   router: KlpRouter(     routes: [       KlpRoute(         id: 'home',         builder: (_) => KlpPanelFrame(content: const HomePage()),       ),     ],     initialId: 'home',   ), ) ```  ## 切換明暗  ```dart KlpApp.of(context).toggleBrightness(); ```  ## 換視覺風格  [style] 是向後相容的共用基底，依目前明暗換上內建色彩。需要完整控制亮／暗風格時， 改傳 [lightStyle] 與 [darkStyle]；對應模式一旦有完整風格，[KlpApp] 就不會改寫其中任一層。 | [klp_app.md](./app/klp_app.md) |
| `KlpAppScope` | `Stateless` | 供 [KlpApp.of] 查找的 `InheritedWidget`。  [brightness] 與 [themeMode] 是資料欄位而非只有 [controller] 一個引用， 這樣 [updateShouldNotify] 才能在它們改變時真正回傳 `true`，讓依賴它的 子樹重建——只放 controller 引用的話，同一個物件永遠 `==` 自己，不會觸發重建。 | [klp_app_scope.md](./app/klp_app_scope.md) |
| `KlpEnvironmentScope` | `Stateless` | 注入執行平台；視窗尺寸、語系與互動狀態仍由各自的來源提供。 | [klp_environment_scope.md](./app/klp_environment_scope.md) |
