import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

part 'klp_default_saved_label.dart';
part 'klp_localizations_delegate.dart';

/// Kallopis 元件用到的所有使用者可見字串，供呼叫端覆寫。
///
/// **這個庫不替產品決定用什麼語言。** 見 [KlpToast.closeLabel] 與 [KlpCalendar]
/// 的既有慣例——本類別把同一條規則套用到庫裡其餘散落的寫死字串上，統一成一個
/// 入口而不是每個元件各自加一組建構子參數。
///
/// 每個欄位的預設值刻意等於**目前實際顯示的文字**（中文、英文混雜）——這是抽取自
/// Planist 時就已經寫死的內容，換成別的預設會讓沒有註冊 delegate 的消費者畫面
/// 跟著變。要修正預設文案本身，是產品決策，不是 l10n 機制該做的事。
///
/// ## 用法
///
/// ```dart
/// MaterialApp(
///   localizationsDelegates: [
///     const KlpLocalizationsDelegate(
///       KlpLocalizations(toastNowLabel: 'NOW'),
///     ),
///     ...GlobalMaterialLocalizations.delegates,
///   ],
/// )
/// ```
///
/// 走 [KlpApp] 的消費者不需要手動註冊——[KlpApp] 已經自動掛上內建預設值，
/// 傳入的 [KlpApp.localizationsDelegates] 會與它合併而不是覆蓋。
@immutable
class KlpLocalizations {
	const KlpLocalizations({
		this.toastNowLabel = 'NOW',
		this.codeViewerCollapseLabel = '收合',
		this.codeViewerExpandLabel = '展開',
		this.codeDataCopyLabel = 'Copy',
		this.codeDiffApproveLabel = '同意',
		this.codeDiffRejectLabel = '拒絕',
		this.codeTerminalClearLabel = 'Clear',
		this.dataTableSelectAllLabel = 'Select all rows',
		this.dataTableSelectRowLabel = 'Select row',
		this.jsonTreeLoadingLabel = 'Loading...',
		this.jsonTreeInvalidLabel = 'Invalid structured data',
		this.filePreviewOpenExternalLabel = 'Open externally',
		this.filePreviewDownloadLabel = 'Download',
		this.filePreviewLoadingLabel = 'Loading preview...',
		this.filePreviewErrorLabel = 'Preview failed to load',
		this.filePreviewUnsupportedLabel = 'No preview available for this type',
		this.filePreviewEmptyLabel = 'No preview content',
		this.panelToggleLabel = '切換面板',
		this.savedLabel = _defaultSavedLabel,
		this.windowMinimizeLabel = 'Minimize window',
		this.windowMaximizeLabel = 'Maximize window',
		this.windowRestoreLabel = 'Restore window',
		this.windowCloseLabel = 'Close window',
		this.searchPreviousResultLabel = 'Previous result',
		this.searchNextResultLabel = 'Next result',
		this.searchCloseLabel = 'Close search',
		this.entityPickerRemoveLabel = 'Remove',
		this.entityPickerApplyLabel = 'Apply',
		this.dockMoreActionsLabel = '更多操作',
		this.oklchLightnessLabel = 'Lightness',
		this.oklchChromaLabel = 'Chroma',
		this.oklchHueLabel = 'Hue',
		this.oklchAlphaLabel = 'Alpha',
		this.oklchLightnessPlaneLabel = 'Lightness plane',
		this.oklchChromaPlaneLabel = 'Chroma plane',
		this.oklchHuePlaneLabel = 'Hue plane',
		this.oklchOriginalPreviewLabel = 'Clipped original',
		this.oklchFallbackPreviewLabel = 'sRGB fallback',
		this.oklchFallbackWarningLabel =
				'Outside sRGB gamut; fallback reduces chroma.',
		this.formOptionsLabel = '選擇類型',
		this.formPasswordShowLabel = '顯示密碼',
		this.formPasswordHideLabel = '隱藏密碼',
		this.formQuantityDecreaseLabel = '減少',
		this.formQuantityIncreaseLabel = '增加',
		this.formDateRangeCalendarLabel = '選擇日期區間',
		this.editorUndoLabel = '撤銷',
		this.editorRedoLabel = '重做',
		this.editorMoreLabel = '更多',
		this.editorSaveLabel = '保存',
		this.editorUnsavedLabel = '未保存',
		this.editorSavingLabel = '保存中',
		this.editorSavedLabel = '已保存',
		this.editorSaveFailedLabel = '保存失敗',
		this.editorSaveUnknownLabel = '保存結果未知',
		this.editorBlockActionsLabel = '區塊操作',
		this.editorBlockMoveHint = '按空白鍵開始移動，使用方向鍵選擇位置，再按空白鍵放下',
		this.editorMovePreviousLabel = '上移',
		this.editorMoveNextLabel = '下移',
		this.editorParagraphLabel = '段落',
		this.editorHeading1Label = '標題 1',
		this.editorHeading2Label = '標題 2',
		this.editorHeading3Label = '標題 3',
		this.editorOutdentLabel = '減少縮排',
		this.editorIndentLabel = '增加縮排',
		this.editorOrderedListLabel = '編號清單',
		this.editorUnorderedListLabel = '項目清單',
		this.editorBlockTypeLabel = '區塊類型',
		this.editorTaskCompleteLabel = '完成任務',
		this.editorTaskReopenLabel = '重新開啟任務',
		this.editorToggleCollapseLabel = '收合區塊',
		this.editorToggleExpandLabel = '展開區塊',
		this.editorLoadFailedTitle = '無法載入正文編輯器',
		this.editorLoadFailedMessage = '本機編輯器尚未完成啟動，請再試一次。',
		this.editorRetryLabel = '重試',
		this.editorInterruptedTitle = '編輯器已中斷',
		this.editorInterruptedMessage = '編輯器已中斷。請保留此視窗並嘗試儲存；尚未儲存內容不會自動重載。',
		this.editorEnvironmentFailedTitle = '無法啟動正文編輯器',
		this.editorEnvironmentFailedMessage = '系統無法建立本機 WebView2 環境。請確認 WebView2 Runtime 已安裝後重新開啟。',
	});

	/// [KlpToast] 時間戳徽章上的文字。
	final String toastNowLabel;

	/// [KlpCodeViewer] 展開／收合鈕在「已展開」狀態下顯示的文字。
	final String codeViewerCollapseLabel;

	/// [KlpCodeViewer] 展開／收合鈕在「未展開」狀態下顯示的文字。
	final String codeViewerExpandLabel;

	/// [KlpDiffViewer] 與 [KlpTerminal] 的複製動作文字。
	final String codeDataCopyLabel;

	/// [KlpDiffViewer] 的逐行同意動作文字。
	final String codeDiffApproveLabel;

	/// [KlpDiffViewer] 的逐行拒絕動作文字。
	final String codeDiffRejectLabel;

	/// [KlpTerminal] 的清除動作文字。
	final String codeTerminalClearLabel;

	/// [KlpDataTable] 全選控制項的無障礙標籤。
	final String dataTableSelectAllLabel;

	/// [KlpDataTable] 單列選取控制項的無障礙標籤。
	final String dataTableSelectRowLabel;

	/// [KlpJsonTree] 載入中的文字。
	final String jsonTreeLoadingLabel;

	/// [KlpJsonTree] 無效資料的文字。
	final String jsonTreeInvalidLabel;

	/// [KlpFilePreview] 外部開啟動作的文字。
	final String filePreviewOpenExternalLabel;

	/// [KlpFilePreview] 下載動作的文字。
	final String filePreviewDownloadLabel;

	/// [KlpFilePreview] 載入中的文字。
	final String filePreviewLoadingLabel;

	/// [KlpFilePreview] 載入失敗的文字。
	final String filePreviewErrorLabel;

	/// [KlpFilePreview] 不支援預覽時的文字。
	final String filePreviewUnsupportedLabel;

	/// [KlpFilePreview] 沒有預覽內容時的文字。
	final String filePreviewEmptyLabel;

	/// [KlpPaneCollapseControl] 的無障礙標籤預設值。
	final String panelToggleLabel;

	/// [KlpSaveStatusCard] 顯示最後儲存時間的文字，[savedAt] 是呼叫端已格式化好的
	/// 時間字串（例如「2 分鐘前」）。
	final String Function(String savedAt) savedLabel;

	/// [KlpWindowControls] 最小化鈕的無障礙標籤。
	final String windowMinimizeLabel;

	/// [KlpWindowControls] 最大化鈕的無障礙標籤。
	final String windowMaximizeLabel;

	/// [KlpWindowControls] 還原視窗鈕的無障礙標籤（視窗已最大化時取代
	/// [windowMaximizeLabel]）。
	final String windowRestoreLabel;

	/// [KlpWindowControls] 關閉鈕的無障礙標籤。
	final String windowCloseLabel;

	/// 搜尋列上一筆結果按鈕的無障礙標籤。
	final String searchPreviousResultLabel;

	/// 搜尋列下一筆結果按鈕的無障礙標籤。
	final String searchNextResultLabel;

	/// 搜尋列關閉按鈕的無障礙標籤。
	final String searchCloseLabel;

	/// [KlpEntityPicker] 清除按鈕的文字。
	final String entityPickerRemoveLabel;

	/// [KlpEntityPicker] 套用按鈕的文字。
	final String entityPickerApplyLabel;

	/// Dock header 溢位選單與按鈕的無障礙標籤。
	final String dockMoreActionsLabel;

	/// [KlpOklchColorEditor] 的 Lightness 控制標籤。
	final String oklchLightnessLabel;

	/// [KlpOklchColorEditor] 的 Chroma 控制標籤。
	final String oklchChromaLabel;

	/// [KlpOklchColorEditor] 的 Hue 控制標籤。
	final String oklchHueLabel;

	/// [KlpOklchColorEditor] 的 Alpha 控制標籤。
	final String oklchAlphaLabel;

	/// [KlpOklchColorPicker] 的 Lightness 平面標籤。
	final String oklchLightnessPlaneLabel;

	/// [KlpOklchColorPicker] 的 Chroma 平面標籤。
	final String oklchChromaPlaneLabel;

	/// [KlpOklchColorPicker] 的 Hue 平面標籤。
	final String oklchHuePlaneLabel;

	/// [KlpOklchColorPicker] 原值裁切預覽的標籤。
	final String oklchOriginalPreviewLabel;

	/// [KlpOklchColorPicker] sRGB fallback 預覽的標籤。
	final String oklchFallbackPreviewLabel;

	/// [KlpOklchColorPicker] 超出 sRGB 色域時顯示的說明。
	final String oklchFallbackWarningLabel;

	/// 複合輸入欄位尾端選項按鈕的無障礙標籤。
	final String formOptionsLabel;

	/// 密碼欄位顯示密碼按鈕的無障礙標籤。
	final String formPasswordShowLabel;

	/// 密碼欄位隱藏密碼按鈕的無障礙標籤。
	final String formPasswordHideLabel;

	/// 數量欄位減少按鈕的無障礙標籤。
	final String formQuantityDecreaseLabel;

	/// 數量欄位增加按鈕的無障礙標籤。
	final String formQuantityIncreaseLabel;

	/// 日期區間欄位開啟日曆按鈕的無障礙標籤。
	final String formDateRangeCalendarLabel;

	final String editorUndoLabel;
	final String editorRedoLabel;
	final String editorMoreLabel;
	final String editorSaveLabel;
	final String editorUnsavedLabel;
	final String editorSavingLabel;
	final String editorSavedLabel;
	final String editorSaveFailedLabel;
	final String editorSaveUnknownLabel;
	final String editorBlockActionsLabel;
	final String editorBlockMoveHint;
	final String editorMovePreviousLabel;
	final String editorMoveNextLabel;
	final String editorParagraphLabel;
	final String editorHeading1Label;
	final String editorHeading2Label;
	final String editorHeading3Label;
	final String editorOutdentLabel;
	final String editorIndentLabel;
	final String editorOrderedListLabel;
	final String editorUnorderedListLabel;
	final String editorBlockTypeLabel;
	final String editorTaskCompleteLabel;
	final String editorTaskReopenLabel;
	final String editorToggleCollapseLabel;
	final String editorToggleExpandLabel;

	/// 編輯器載入與中斷訊息；預設保留既有文案。
	final String editorLoadFailedTitle;
	final String editorLoadFailedMessage;
	final String editorRetryLabel;
	final String editorInterruptedTitle;
	final String editorInterruptedMessage;
	final String editorEnvironmentFailedTitle;
	final String editorEnvironmentFailedMessage;


	/// 取得目前子樹適用的字串集合。
	///
	/// 沒有註冊 [KlpLocalizationsDelegate] 時回退到內建預設值而非拋錯——這與
	/// `KlpTheme.of` 對缺席 `ThemeExtension` 的處理方式一致：庫被放進一個沒有
	/// 設定 Kallopis l10n 的 app 時應該仍能渲染，只是文字长成預設值。
	static KlpLocalizations of(BuildContext context) {
		return Localizations.of<KlpLocalizations>(context, KlpLocalizations) ??
				const KlpLocalizations();
	}

	@override
	bool operator ==(Object other) =>
			identical(this, other) ||
			other is KlpLocalizations &&
					toastNowLabel == other.toastNowLabel &&
					codeViewerCollapseLabel == other.codeViewerCollapseLabel &&
					codeViewerExpandLabel == other.codeViewerExpandLabel &&
					codeDataCopyLabel == other.codeDataCopyLabel &&
					codeDiffApproveLabel == other.codeDiffApproveLabel &&
					codeDiffRejectLabel == other.codeDiffRejectLabel &&
					codeTerminalClearLabel == other.codeTerminalClearLabel &&
					dataTableSelectAllLabel == other.dataTableSelectAllLabel &&
					dataTableSelectRowLabel == other.dataTableSelectRowLabel &&
					jsonTreeLoadingLabel == other.jsonTreeLoadingLabel &&
					jsonTreeInvalidLabel == other.jsonTreeInvalidLabel &&
					filePreviewOpenExternalLabel == other.filePreviewOpenExternalLabel &&
					filePreviewDownloadLabel == other.filePreviewDownloadLabel &&
					filePreviewLoadingLabel == other.filePreviewLoadingLabel &&
					filePreviewErrorLabel == other.filePreviewErrorLabel &&
					filePreviewUnsupportedLabel == other.filePreviewUnsupportedLabel &&
					filePreviewEmptyLabel == other.filePreviewEmptyLabel &&
					panelToggleLabel == other.panelToggleLabel &&
					savedLabel == other.savedLabel &&
					windowMinimizeLabel == other.windowMinimizeLabel &&
					windowMaximizeLabel == other.windowMaximizeLabel &&
					windowRestoreLabel == other.windowRestoreLabel &&
					windowCloseLabel == other.windowCloseLabel &&
					searchPreviousResultLabel == other.searchPreviousResultLabel &&
					searchNextResultLabel == other.searchNextResultLabel &&
					searchCloseLabel == other.searchCloseLabel &&
					entityPickerRemoveLabel == other.entityPickerRemoveLabel &&
					entityPickerApplyLabel == other.entityPickerApplyLabel &&
					dockMoreActionsLabel == other.dockMoreActionsLabel &&
					oklchLightnessLabel == other.oklchLightnessLabel &&
					oklchChromaLabel == other.oklchChromaLabel &&
					oklchHueLabel == other.oklchHueLabel &&
					oklchAlphaLabel == other.oklchAlphaLabel &&
					oklchLightnessPlaneLabel == other.oklchLightnessPlaneLabel &&
					oklchChromaPlaneLabel == other.oklchChromaPlaneLabel &&
					oklchHuePlaneLabel == other.oklchHuePlaneLabel &&
					oklchOriginalPreviewLabel == other.oklchOriginalPreviewLabel &&
					oklchFallbackPreviewLabel == other.oklchFallbackPreviewLabel &&
					oklchFallbackWarningLabel == other.oklchFallbackWarningLabel &&
					formOptionsLabel == other.formOptionsLabel &&
					formPasswordShowLabel == other.formPasswordShowLabel &&
					formPasswordHideLabel == other.formPasswordHideLabel &&
					formQuantityDecreaseLabel == other.formQuantityDecreaseLabel &&
					formQuantityIncreaseLabel == other.formQuantityIncreaseLabel &&
				formDateRangeCalendarLabel == other.formDateRangeCalendarLabel &&
				editorUndoLabel == other.editorUndoLabel &&
				editorRedoLabel == other.editorRedoLabel &&
				editorMoreLabel == other.editorMoreLabel &&
				editorSaveLabel == other.editorSaveLabel &&
				editorUnsavedLabel == other.editorUnsavedLabel &&
				editorSavingLabel == other.editorSavingLabel &&
				editorSavedLabel == other.editorSavedLabel &&
				editorSaveFailedLabel == other.editorSaveFailedLabel &&
				editorSaveUnknownLabel == other.editorSaveUnknownLabel &&
				editorBlockActionsLabel == other.editorBlockActionsLabel &&
				editorBlockMoveHint == other.editorBlockMoveHint &&
				editorMovePreviousLabel == other.editorMovePreviousLabel &&
				editorMoveNextLabel == other.editorMoveNextLabel &&
				editorParagraphLabel == other.editorParagraphLabel &&
				editorHeading1Label == other.editorHeading1Label &&
				editorHeading2Label == other.editorHeading2Label &&
				editorHeading3Label == other.editorHeading3Label &&
				editorOutdentLabel == other.editorOutdentLabel &&
				editorIndentLabel == other.editorIndentLabel &&
				editorOrderedListLabel == other.editorOrderedListLabel &&
				editorUnorderedListLabel == other.editorUnorderedListLabel &&
				editorBlockTypeLabel == other.editorBlockTypeLabel &&
				editorTaskCompleteLabel == other.editorTaskCompleteLabel &&
				editorTaskReopenLabel == other.editorTaskReopenLabel &&
				editorToggleCollapseLabel == other.editorToggleCollapseLabel &&
				editorToggleExpandLabel == other.editorToggleExpandLabel &&
				editorLoadFailedTitle == other.editorLoadFailedTitle &&
				editorLoadFailedMessage == other.editorLoadFailedMessage &&
				editorRetryLabel == other.editorRetryLabel &&
				editorInterruptedTitle == other.editorInterruptedTitle &&
				editorInterruptedMessage == other.editorInterruptedMessage &&
				editorEnvironmentFailedTitle == other.editorEnvironmentFailedTitle &&
				editorEnvironmentFailedMessage == other.editorEnvironmentFailedMessage;

	@override
	int get hashCode => Object.hashAll([
		toastNowLabel,
		codeViewerCollapseLabel,
		codeViewerExpandLabel,
		codeDataCopyLabel,
		codeDiffApproveLabel,
		codeDiffRejectLabel,
		codeTerminalClearLabel,
		dataTableSelectAllLabel,
		dataTableSelectRowLabel,
		jsonTreeLoadingLabel,
		jsonTreeInvalidLabel,
		filePreviewOpenExternalLabel,
		filePreviewDownloadLabel,
		filePreviewLoadingLabel,
		filePreviewErrorLabel,
		filePreviewUnsupportedLabel,
		filePreviewEmptyLabel,
		panelToggleLabel,
		savedLabel,
		windowMinimizeLabel,
		windowMaximizeLabel,
		windowRestoreLabel,
		windowCloseLabel,
		searchPreviousResultLabel,
		searchNextResultLabel,
		searchCloseLabel,
		entityPickerRemoveLabel,
		entityPickerApplyLabel,
		dockMoreActionsLabel,
		oklchLightnessLabel,
		oklchChromaLabel,
		oklchHueLabel,
		oklchAlphaLabel,
		oklchLightnessPlaneLabel,
		oklchChromaPlaneLabel,
		oklchHuePlaneLabel,
		oklchOriginalPreviewLabel,
		oklchFallbackPreviewLabel,
		oklchFallbackWarningLabel,
		formOptionsLabel,
		formPasswordShowLabel,
		formPasswordHideLabel,
		formQuantityDecreaseLabel,
		formQuantityIncreaseLabel,
		formDateRangeCalendarLabel,
		editorUndoLabel,
		editorRedoLabel,
		editorMoreLabel,
		editorSaveLabel,
		editorUnsavedLabel,
		editorSavingLabel,
		editorSavedLabel,
		editorSaveFailedLabel,
		editorSaveUnknownLabel,
		editorBlockActionsLabel,
		editorBlockMoveHint,
		editorMovePreviousLabel,
		editorMoveNextLabel,
		editorParagraphLabel,
		editorHeading1Label,
		editorHeading2Label,
		editorHeading3Label,
		editorOutdentLabel,
		editorIndentLabel,
		editorOrderedListLabel,
		editorUnorderedListLabel,
		editorBlockTypeLabel,
		editorTaskCompleteLabel,
		editorTaskReopenLabel,
		editorToggleCollapseLabel,
		editorToggleExpandLabel,
		editorLoadFailedTitle,
		editorLoadFailedMessage,
		editorRetryLabel,
		editorInterruptedTitle,
		editorInterruptedMessage,
		editorEnvironmentFailedTitle,
		editorEnvironmentFailedMessage,
	]);
}
