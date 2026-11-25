# KlpLocalizations

Flutter · Stable · 資料與型別

## 主要職責

集中 Kallopis 元件的使用者可見字串，供產品覆寫；透過 KlpLocalizationsDelegate 接入 MaterialApp。未提供覆寫時沿用下表預設，產品自行決定語言與翻譯。

## 公開入口

- `package:kallopis/kallopis_foundation.dart`

## 速成使用

前置：[平台接入](../quickstart.md)。以下為接入片段；必要資料由產品提供。

```dart
import 'package:kallopis/kallopis_foundation.dart';

// 由產品提供必要資料；可選參數沿用下表預設。
KlpLocalizations createExample() => KlpLocalizations();
```

<!-- reference-api:start -->

## 公開簽名

```dart
class KlpLocalizations
```

## 建構子 KlpLocalizations



```dart
const KlpLocalizations({
	String toastNowLabel = 'NOW',
	String codeViewerCollapseLabel = '收合',
	String codeViewerExpandLabel = '展開',
	String codeDataCopyLabel = 'Copy',
	String codeDiffApproveLabel = '同意',
	String codeDiffRejectLabel = '拒絕',
	String codeTerminalClearLabel = 'Clear',
	String dataTableSelectAllLabel = 'Select all rows',
	String dataTableSelectRowLabel = 'Select row',
	String jsonTreeLoadingLabel = 'Loading...',
	String jsonTreeInvalidLabel = 'Invalid structured data',
	String filePreviewOpenExternalLabel = 'Open externally',
	String filePreviewDownloadLabel = 'Download',
	String filePreviewLoadingLabel = 'Loading preview...',
	String filePreviewErrorLabel = 'Preview failed to load',
	String filePreviewUnsupportedLabel = 'No preview available for this type',
	String filePreviewEmptyLabel = 'No preview content',
	String panelToggleLabel = '切換面板',
	String Function(String) savedLabel = _defaultSavedLabel,
	String windowMinimizeLabel = 'Minimize window',
	String windowMaximizeLabel = 'Maximize window',
	String windowRestoreLabel = 'Restore window',
	String windowCloseLabel = 'Close window',
	String searchPreviousResultLabel = 'Previous result',
	String searchNextResultLabel = 'Next result',
	String searchCloseLabel = 'Close search',
	String entityPickerRemoveLabel = 'Remove',
	String entityPickerApplyLabel = 'Apply',
	String dockMoreActionsLabel = '更多操作',
	String explorerActionsLabel = 'Actions',
	String explorerExpandLabel = 'Expand',
	String explorerCollapseLabel = 'Collapse',
	String documentTabModifiedLabel = 'Modified',
	String documentTabPinLabel = 'Pin',
	String documentTabUnpinLabel = 'Unpin',
	String documentTabCloseLabel = 'Close',
	String oklchLightnessLabel = 'Lightness',
	String oklchChromaLabel = 'Chroma',
	String oklchHueLabel = 'Hue',
	String oklchAlphaLabel = 'Alpha',
	String oklchLightnessPlaneLabel = 'Lightness plane',
	String oklchChromaPlaneLabel = 'Chroma plane',
	String oklchHuePlaneLabel = 'Hue plane',
	String oklchOriginalPreviewLabel = 'Clipped original',
	String oklchFallbackPreviewLabel = 'sRGB fallback',
	String oklchFallbackWarningLabel = 'Outside sRGB gamut; fallback reduces chroma.',
	String formOptionsLabel = '選擇類型',
	String formPasswordShowLabel = '顯示密碼',
	String formPasswordHideLabel = '隱藏密碼',
	String formQuantityDecreaseLabel = '減少',
	String formQuantityIncreaseLabel = '增加',
	String formDateRangeCalendarLabel = '選擇日期區間',
	String editorUndoLabel = '撤銷',
	String editorRedoLabel = '重做',
	String editorMoreLabel = '更多',
	String editorSaveLabel = '保存',
	String editorUnsavedLabel = '未保存',
	String editorSavingLabel = '保存中',
	String editorSavedLabel = '已保存',
	String editorSaveFailedLabel = '保存失敗',
	String editorSaveUnknownLabel = '保存結果未知',
	String editorBlockActionsLabel = '區塊操作',
	String editorBlockMoveHint = '按空白鍵開始移動，使用方向鍵選擇位置，再按空白鍵放下',
	String editorMovePreviousLabel = '上移',
	String editorMoveNextLabel = '下移',
	String editorParagraphLabel = '段落',
	String editorHeading1Label = '標題 1',
	String editorHeading2Label = '標題 2',
	String editorHeading3Label = '標題 3',
	String editorOutdentLabel = '減少縮排',
	String editorIndentLabel = '增加縮排',
	String editorOrderedListLabel = '編號清單',
	String editorUnorderedListLabel = '項目清單',
	String editorBlockTypeLabel = '區塊類型',
	String editorTaskCompleteLabel = '完成任務',
	String editorTaskReopenLabel = '重新開啟任務',
	String editorToggleCollapseLabel = '收合區塊',
	String editorToggleExpandLabel = '展開區塊',
	String editorLoadFailedTitle = '無法載入正文編輯器',
	String editorLoadFailedMessage = '本機編輯器尚未完成啟動，請再試一次。',
	String editorRetryLabel = '重試',
	String editorInterruptedTitle = '編輯器已中斷',
	String editorInterruptedMessage = '編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。',
	String editorEnvironmentFailedTitle = '無法啟動正文編輯器',
	String editorEnvironmentFailedMessage = '系統無法建立本機 WebView2 環境。請確認 WebView2 Runtime 已安裝後重新開啟。',
	String menuSearchPlaceholder = '搜尋',
	String menuEmptyLabel = '沒有符合的元件',
})
```

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `toastNowLabel` | `String` | 否 | 'NOW' | [KlpToast] 時間戳徽章上的文字。 |
| `codeViewerCollapseLabel` | `String` | 否 | '收合' | [KlpCodeViewer] 展開／收合鈕在「已展開」狀態下顯示的文字。 |
| `codeViewerExpandLabel` | `String` | 否 | '展開' | [KlpCodeViewer] 展開／收合鈕在「未展開」狀態下顯示的文字。 |
| `codeDataCopyLabel` | `String` | 否 | 'Copy' | [KlpDiffViewer] 與 [KlpTerminal] 的複製動作文字。 |
| `codeDiffApproveLabel` | `String` | 否 | '同意' | [KlpDiffViewer] 的逐行同意動作文字。 |
| `codeDiffRejectLabel` | `String` | 否 | '拒絕' | [KlpDiffViewer] 的逐行拒絕動作文字。 |
| `codeTerminalClearLabel` | `String` | 否 | 'Clear' | [KlpTerminal] 的清除動作文字。 |
| `dataTableSelectAllLabel` | `String` | 否 | 'Select all rows' | [KlpDataTable] 全選控制項的無障礙標籤。 |
| `dataTableSelectRowLabel` | `String` | 否 | 'Select row' | [KlpDataTable] 單列選取控制項的無障礙標籤。 |
| `jsonTreeLoadingLabel` | `String` | 否 | 'Loading...' | [KlpJsonTree] 載入中的文字。 |
| `jsonTreeInvalidLabel` | `String` | 否 | 'Invalid structured data' | [KlpJsonTree] 無效資料的文字。 |
| `filePreviewOpenExternalLabel` | `String` | 否 | 'Open externally' | [KlpFilePreview] 外部開啟動作的文字。 |
| `filePreviewDownloadLabel` | `String` | 否 | 'Download' | [KlpFilePreview] 下載動作的文字。 |
| `filePreviewLoadingLabel` | `String` | 否 | 'Loading preview...' | [KlpFilePreview] 載入中的文字。 |
| `filePreviewErrorLabel` | `String` | 否 | 'Preview failed to load' | [KlpFilePreview] 載入失敗的文字。 |
| `filePreviewUnsupportedLabel` | `String` | 否 | 'No preview available for this type' | [KlpFilePreview] 不支援預覽時的文字。 |
| `filePreviewEmptyLabel` | `String` | 否 | 'No preview content' | [KlpFilePreview] 沒有預覽內容時的文字。 |
| `panelToggleLabel` | `String` | 否 | '切換面板' | [KlpPaneCollapseControl] 的無障礙標籤預設值。 |
| `savedLabel` | `String Function(String)` | 否 | _defaultSavedLabel | [KlpSaveStatusCard] 顯示最後儲存時間的文字，[savedAt] 是呼叫端已格式化好的<br>時間字串（例如「2 分鐘前」）。 |
| `windowMinimizeLabel` | `String` | 否 | 'Minimize window' | [KlpWindowControls] 最小化鈕的無障礙標籤。 |
| `windowMaximizeLabel` | `String` | 否 | 'Maximize window' | [KlpWindowControls] 最大化鈕的無障礙標籤。 |
| `windowRestoreLabel` | `String` | 否 | 'Restore window' | [KlpWindowControls] 還原視窗鈕的無障礙標籤（視窗已最大化時取代<br>[windowMaximizeLabel]）。 |
| `windowCloseLabel` | `String` | 否 | 'Close window' | [KlpWindowControls] 關閉鈕的無障礙標籤。 |
| `searchPreviousResultLabel` | `String` | 否 | 'Previous result' | 搜尋列上一筆結果按鈕的無障礙標籤。 |
| `searchNextResultLabel` | `String` | 否 | 'Next result' | 搜尋列下一筆結果按鈕的無障礙標籤。 |
| `searchCloseLabel` | `String` | 否 | 'Close search' | 搜尋列關閉按鈕的無障礙標籤。 |
| `entityPickerRemoveLabel` | `String` | 否 | 'Remove' | [KlpEntityPicker] 清除按鈕的文字。 |
| `entityPickerApplyLabel` | `String` | 否 | 'Apply' | [KlpEntityPicker] 套用按鈕的文字。 |
| `dockMoreActionsLabel` | `String` | 否 | '更多操作' | Dock header 溢位選單與按鈕的無障礙標籤。 |
| `explorerActionsLabel` | `String` | 否 | 'Actions' | Explorer 列操作、展開與收合控制的 chrome 字串。 |
| `explorerExpandLabel` | `String` | 否 | 'Expand' | 依公開型別提供此輸入。 |
| `explorerCollapseLabel` | `String` | 否 | 'Collapse' | 依公開型別提供此輸入。 |
| `documentTabModifiedLabel` | `String` | 否 | 'Modified' | Document Tabs 修改狀態、釘選與關閉控制的 chrome 字串。 |
| `documentTabPinLabel` | `String` | 否 | 'Pin' | 依公開型別提供此輸入。 |
| `documentTabUnpinLabel` | `String` | 否 | 'Unpin' | 依公開型別提供此輸入。 |
| `documentTabCloseLabel` | `String` | 否 | 'Close' | 依公開型別提供此輸入。 |
| `oklchLightnessLabel` | `String` | 否 | 'Lightness' | [KlpOklchColorEditor] 的 Lightness 控制標籤。 |
| `oklchChromaLabel` | `String` | 否 | 'Chroma' | [KlpOklchColorEditor] 的 Chroma 控制標籤。 |
| `oklchHueLabel` | `String` | 否 | 'Hue' | [KlpOklchColorEditor] 的 Hue 控制標籤。 |
| `oklchAlphaLabel` | `String` | 否 | 'Alpha' | [KlpOklchColorEditor] 的 Alpha 控制標籤。 |
| `oklchLightnessPlaneLabel` | `String` | 否 | 'Lightness plane' | [KlpOklchColorPicker] 的 Lightness 平面標籤。 |
| `oklchChromaPlaneLabel` | `String` | 否 | 'Chroma plane' | [KlpOklchColorPicker] 的 Chroma 平面標籤。 |
| `oklchHuePlaneLabel` | `String` | 否 | 'Hue plane' | [KlpOklchColorPicker] 的 Hue 平面標籤。 |
| `oklchOriginalPreviewLabel` | `String` | 否 | 'Clipped original' | [KlpOklchColorPicker] 原值裁切預覽的標籤。 |
| `oklchFallbackPreviewLabel` | `String` | 否 | 'sRGB fallback' | [KlpOklchColorPicker] sRGB fallback 預覽的標籤。 |
| `oklchFallbackWarningLabel` | `String` | 否 | 'Outside sRGB gamut; fallback reduces chroma.' | [KlpOklchColorPicker] 超出 sRGB 色域時顯示的說明。 |
| `formOptionsLabel` | `String` | 否 | '選擇類型' | 複合輸入欄位尾端選項按鈕的無障礙標籤。 |
| `formPasswordShowLabel` | `String` | 否 | '顯示密碼' | 密碼欄位顯示密碼按鈕的無障礙標籤。 |
| `formPasswordHideLabel` | `String` | 否 | '隱藏密碼' | 密碼欄位隱藏密碼按鈕的無障礙標籤。 |
| `formQuantityDecreaseLabel` | `String` | 否 | '減少' | 數量欄位減少按鈕的無障礙標籤。 |
| `formQuantityIncreaseLabel` | `String` | 否 | '增加' | 數量欄位增加按鈕的無障礙標籤。 |
| `formDateRangeCalendarLabel` | `String` | 否 | '選擇日期區間' | 日期區間欄位開啟日曆按鈕的無障礙標籤。 |
| `editorUndoLabel` | `String` | 否 | '撤銷' | 依公開型別提供此輸入。 |
| `editorRedoLabel` | `String` | 否 | '重做' | 依公開型別提供此輸入。 |
| `editorMoreLabel` | `String` | 否 | '更多' | 依公開型別提供此輸入。 |
| `editorSaveLabel` | `String` | 否 | '保存' | 依公開型別提供此輸入。 |
| `editorUnsavedLabel` | `String` | 否 | '未保存' | 依公開型別提供此輸入。 |
| `editorSavingLabel` | `String` | 否 | '保存中' | 依公開型別提供此輸入。 |
| `editorSavedLabel` | `String` | 否 | '已保存' | 依公開型別提供此輸入。 |
| `editorSaveFailedLabel` | `String` | 否 | '保存失敗' | 依公開型別提供此輸入。 |
| `editorSaveUnknownLabel` | `String` | 否 | '保存結果未知' | 依公開型別提供此輸入。 |
| `editorBlockActionsLabel` | `String` | 否 | '區塊操作' | 依公開型別提供此輸入。 |
| `editorBlockMoveHint` | `String` | 否 | '按空白鍵開始移動，使用方向鍵選擇位置，再按空白鍵放下' | 依公開型別提供此輸入。 |
| `editorMovePreviousLabel` | `String` | 否 | '上移' | 依公開型別提供此輸入。 |
| `editorMoveNextLabel` | `String` | 否 | '下移' | 依公開型別提供此輸入。 |
| `editorParagraphLabel` | `String` | 否 | '段落' | 依公開型別提供此輸入。 |
| `editorHeading1Label` | `String` | 否 | '標題 1' | 依公開型別提供此輸入。 |
| `editorHeading2Label` | `String` | 否 | '標題 2' | 依公開型別提供此輸入。 |
| `editorHeading3Label` | `String` | 否 | '標題 3' | 依公開型別提供此輸入。 |
| `editorOutdentLabel` | `String` | 否 | '減少縮排' | 依公開型別提供此輸入。 |
| `editorIndentLabel` | `String` | 否 | '增加縮排' | 依公開型別提供此輸入。 |
| `editorOrderedListLabel` | `String` | 否 | '編號清單' | 依公開型別提供此輸入。 |
| `editorUnorderedListLabel` | `String` | 否 | '項目清單' | 依公開型別提供此輸入。 |
| `editorBlockTypeLabel` | `String` | 否 | '區塊類型' | 依公開型別提供此輸入。 |
| `editorTaskCompleteLabel` | `String` | 否 | '完成任務' | 依公開型別提供此輸入。 |
| `editorTaskReopenLabel` | `String` | 否 | '重新開啟任務' | 依公開型別提供此輸入。 |
| `editorToggleCollapseLabel` | `String` | 否 | '收合區塊' | 依公開型別提供此輸入。 |
| `editorToggleExpandLabel` | `String` | 否 | '展開區塊' | 依公開型別提供此輸入。 |
| `editorLoadFailedTitle` | `String` | 否 | '無法載入正文編輯器' | 編輯器載入與中斷訊息；預設保留既有文案。 |
| `editorLoadFailedMessage` | `String` | 否 | '本機編輯器尚未完成啟動，請再試一次。' | 依公開型別提供此輸入。 |
| `editorRetryLabel` | `String` | 否 | '重試' | 依公開型別提供此輸入。 |
| `editorInterruptedTitle` | `String` | 否 | '編輯器已中斷' | 依公開型別提供此輸入。 |
| `editorInterruptedMessage` | `String` | 否 | '編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。' | 依公開型別提供此輸入。 |
| `editorEnvironmentFailedTitle` | `String` | 否 | '無法啟動正文編輯器' | 依公開型別提供此輸入。 |
| `editorEnvironmentFailedMessage` | `String` | 否 | '系統無法建立本機 WebView2 環境。請確認 WebView2 Runtime 已安裝後重新開啟。' | 依公開型別提供此輸入。 |
| `menuSearchPlaceholder` | `String` | 否 | '搜尋' | 依公開型別提供此輸入。 |
| `menuEmptyLabel` | `String` | 否 | '沒有符合的元件' | 依公開型別提供此輸入。 |


## 成員與方法

### ==

```dart
bool ==(Object other)
```



| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `other` | `Object` | 是 | — | 依公開型別提供此輸入。 |


### hashCode

```dart
int get hashCode
```



### of

```dart
static KlpLocalizations of(BuildContext context)
```

取得目前子樹適用的字串集合。

沒有註冊 [KlpLocalizationsDelegate] 時回退到內建預設值而非拋錯——這與
`KlpTheme.of` 對缺席 `ThemeExtension` 的處理方式一致：庫被放進一個沒有
設定 Kallopis l10n 的 app 時應該仍能渲染，只是文字长成預設值。

| 參數／成員 | 型別 | 必填 | 預設值 | 說明 |
| --- | --- | --- | --- | --- |
| `context` | `BuildContext` | 是 | — | 依公開型別提供此輸入。 |


<!-- reference-api:end -->

## 使用限制與關聯

- 框架繼承成員：[Object](https://api.dart.dev/dart-core/Object-class.html)。
- [KlpCodeViewer](../components/content/klp-code-viewer.md)
- [KlpDataTable](../components/navigation/klp-data-table.md)
- [KlpDiffViewer](../components/content/klp-diff-viewer.md)
- [KlpFilePreview](../components/content/klp-file-preview.md)
- [KlpJsonTree](../components/collections/klp-json-tree.md)
- [KlpTerminal](../components/content/klp-terminal.md)
- [KlpToast](../components/feedback/klp-toast.md)
- [KlpOklchColorEditor](../components/content/klp-oklch-color-editor.md)
- [KlpOklchColorPicker](../components/inputs/klp-oklch-color-picker.md)
- [KlpEntityPicker](../components/inputs/klp-entity-picker.md)
- [KlpPaneCollapseControl](../components/layout/klp-pane-collapse-control.md)
- [KlpSaveStatusCard](../components/layout/klp-save-status-card.md)
- [KlpWindowControls](../components/content/klp-window-controls.md)
- [KlpLocalizationsDelegate](klp-localizations-delegate.md)
- [KlpTheme](../styling/klp-theme.md)
- [語意與 token 規範](../../../design-tokens/KALLOPIS-DESIGN-MAP.md)。
- [宣告來源](../../../../flutter/lib/src/foundation/localization/klp_localizations.dart)；來源位置不作為 consumer import。
- 來源識別：`package:kallopis/src/foundation/localization/klp_localizations.dart`。
