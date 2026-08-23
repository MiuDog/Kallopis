import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// [KlpLocalizations.savedLabel] 的預設實作。
///
/// 頂層函式而非閉包，這樣才能當成 `const` 建構子的預設值——閉包在 `const`
/// 語境下不合法。
String _defaultSavedLabel(String savedAt) => 'Saved $savedAt';

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
    this.sheetLabel = 'Sheet',
  });

  /// [KlpToast] 時間戳徽章上的文字。
  final String toastNowLabel;

  /// [KlpCodeViewer] 展開／收合鈕在「已展開」狀態下顯示的文字。
  final String codeViewerCollapseLabel;

  /// [KlpCodeViewer] 展開／收合鈕在「未展開」狀態下顯示的文字。
  final String codeViewerExpandLabel;

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

  /// [KlpSheetGrid] 的無障礙標籤。
  final String sheetLabel;

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
          sheetLabel == other.sheetLabel;

  @override
  int get hashCode => Object.hashAll([
    toastNowLabel,
    codeViewerCollapseLabel,
    codeViewerExpandLabel,
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
    sheetLabel,
  ]);
}

/// [KlpLocalizations] 的註冊入口。
///
/// 不做任何依 [Locale] 切換字串的機制——庫本身不內建多語系翻譯，只提供「換一組
/// 字串」的鉤子，實際的多語系邏輯（例如依 [Locale] 選字串）由消費者在建構
/// [overrides] 之前自己決定。[isSupported] 固定回傳 `true`：接不接受某個
/// locale 是 `MaterialApp`／消費者自己 `supportedLocales` 的責任，不歸這個
/// delegate 管。
class KlpLocalizationsDelegate extends LocalizationsDelegate<KlpLocalizations> {
  const KlpLocalizationsDelegate([this.overrides = const KlpLocalizations()]);

  /// 要套用的字串集合。預設為 [KlpLocalizations] 的內建預設值——顯式註冊這個
  /// delegate 但不覆寫任何欄位，效果等同完全不註冊。
  final KlpLocalizations overrides;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<KlpLocalizations> load(Locale locale) => SynchronousFuture(overrides);

  @override
  bool shouldReload(KlpLocalizationsDelegate old) => overrides != old.overrides;
}
