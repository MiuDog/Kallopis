import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/widgets.dart';

import 'internal/klp_language_catalog.dart';

String _defaultSavedLabel(String savedAt) => 'Saved $savedAt';

/// Kallopis 內建語言資源的位置與支援語系。
abstract final class _KlpLanguageFiles {
  static const Locale english = Locale('en', 'US');
  static const Locale traditionalChinese = Locale('zh', 'TW');

  static const supportedLocales = <Locale>[english, traditionalChinese];

  static Map<String, Object?> resolve(Locale locale) {
    return switch (locale.languageCode) {
      'zh' => klpTraditionalChineseLanguage,
      _ => klpEnglishLanguage,
    };
  }
}

/// Kallopis 固定元件使用的語意文字集合。
///
/// [KlpApp] 會依目前 [Locale] 解析由 `assets/l10n` 編譯的完整語言資源。元件只
/// 讀取這個類別的欄位，不在 widget 內放預設文案。建構子仍保留，供消費者用自訂
/// delegate 整組覆寫；產品資料、標題與內容文字不屬於這裡。
@immutable
class KlpLocalizations {
  static const Locale englishLocale = _KlpLanguageFiles.english;
  static const Locale traditionalChineseLocale =
      _KlpLanguageFiles.traditionalChinese;
  static const supportedLocales = _KlpLanguageFiles.supportedLocales;

  const KlpLocalizations({
    this.toastNowLabel = 'NOW',
    this.codeViewerCollapseLabel = 'Collapse',
    this.codeViewerExpandLabel = 'Expand',
    this.codeViewerLoadingLabel = 'Loading...',
    this.codeViewerCopyLabel = 'Copy',
    this.codeViewerMenuLabel = 'Code menu',
    this.codeViewerToggleViewLabel = 'Switch view',
    this.codeViewerLanguageMenuLabel = 'Code language',
    this.codeViewerWrapLabel = 'Wrap lines',
    this.codeViewerLineNumbersLabel = 'Line numbers',
    this.codeViewerPlainTextLabel = 'Plain text',
    this.panelToggleLabel = 'Toggle panel',
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
    this.formAddLabel = '+ Add',
    this.formClearAllLabel = 'Clear all',
    this.formAddStepLabel = '+ Add step',
    this.formChooseFilesLabel = 'Choose files',
    this.dataLoadingLabel = 'Loading...',
    this.dataInvalidStructuredLabel = 'Invalid structured data',
    this.fileOpenExternalLabel = 'Open externally',
    this.fileDownloadLabel = 'Download',
    this.filePreviewLoadingLabel = 'Loading preview...',
    this.filePreviewErrorLabel = 'Preview failed to load',
    this.filePreviewUnsupportedLabel = 'No preview available for this type',
    this.filePreviewEmptyLabel = 'No preview content',
    this.diffApproveLabel = 'Approve',
    this.diffRejectLabel = 'Reject',
    this.terminalTitle = 'terminal',
    this.terminalClearLabel = 'Clear',
    this.progressCancelLabel = 'Cancel',
    this.filterAddLabel = '+ Filter',
    this.filterClearAllLabel = 'Clear all',
    this.selectionClearLabel = 'Clear',
  });

  factory KlpLocalizations.fromJson(Map<String, Object?> json) {
    String text(String key) {
      final value = json[key];
      if (value is! String || value.isEmpty) {
        throw FormatException('語言檔欄位「$key」必須是非空字串。');
      }
      return value;
    }

    final savedTemplate = text('savedLabel');
    if (!savedTemplate.contains('{savedAt}')) {
      throw const FormatException('語言檔欄位「savedLabel」必須包含 {savedAt}。');
    }

    return KlpLocalizations(
      toastNowLabel: text('toastNowLabel'),
      codeViewerCollapseLabel: text('codeViewerCollapseLabel'),
      codeViewerExpandLabel: text('codeViewerExpandLabel'),
      codeViewerLoadingLabel: text('codeViewerLoadingLabel'),
      codeViewerCopyLabel: text('codeViewerCopyLabel'),
      codeViewerMenuLabel: text('codeViewerMenuLabel'),
      codeViewerToggleViewLabel: text('codeViewerToggleViewLabel'),
      codeViewerLanguageMenuLabel: text('codeViewerLanguageMenuLabel'),
      codeViewerWrapLabel: text('codeViewerWrapLabel'),
      codeViewerLineNumbersLabel: text('codeViewerLineNumbersLabel'),
      codeViewerPlainTextLabel: text('codeViewerPlainTextLabel'),
      panelToggleLabel: text('panelToggleLabel'),
      savedLabel: (savedAt) => savedTemplate.replaceAll('{savedAt}', savedAt),
      windowMinimizeLabel: text('windowMinimizeLabel'),
      windowMaximizeLabel: text('windowMaximizeLabel'),
      windowRestoreLabel: text('windowRestoreLabel'),
      windowCloseLabel: text('windowCloseLabel'),
      searchPreviousResultLabel: text('searchPreviousResultLabel'),
      searchNextResultLabel: text('searchNextResultLabel'),
      searchCloseLabel: text('searchCloseLabel'),
      entityPickerRemoveLabel: text('entityPickerRemoveLabel'),
      entityPickerApplyLabel: text('entityPickerApplyLabel'),
      formAddLabel: text('formAddLabel'),
      formClearAllLabel: text('formClearAllLabel'),
      formAddStepLabel: text('formAddStepLabel'),
      formChooseFilesLabel: text('formChooseFilesLabel'),
      dataLoadingLabel: text('dataLoadingLabel'),
      dataInvalidStructuredLabel: text('dataInvalidStructuredLabel'),
      fileOpenExternalLabel: text('fileOpenExternalLabel'),
      fileDownloadLabel: text('fileDownloadLabel'),
      filePreviewLoadingLabel: text('filePreviewLoadingLabel'),
      filePreviewErrorLabel: text('filePreviewErrorLabel'),
      filePreviewUnsupportedLabel: text('filePreviewUnsupportedLabel'),
      filePreviewEmptyLabel: text('filePreviewEmptyLabel'),
      diffApproveLabel: text('diffApproveLabel'),
      diffRejectLabel: text('diffRejectLabel'),
      terminalTitle: text('terminalTitle'),
      terminalClearLabel: text('terminalClearLabel'),
      progressCancelLabel: text('progressCancelLabel'),
      filterAddLabel: text('filterAddLabel'),
      filterClearAllLabel: text('filterClearAllLabel'),
      selectionClearLabel: text('selectionClearLabel'),
    );
  }

  final String toastNowLabel;
  final String codeViewerCollapseLabel;
  final String codeViewerExpandLabel;
  final String codeViewerLoadingLabel;
  final String codeViewerCopyLabel;
  final String codeViewerMenuLabel;
  final String codeViewerToggleViewLabel;
  final String codeViewerLanguageMenuLabel;
  final String codeViewerWrapLabel;
  final String codeViewerLineNumbersLabel;
  final String codeViewerPlainTextLabel;
  final String panelToggleLabel;
  final String Function(String savedAt) savedLabel;
  final String windowMinimizeLabel;
  final String windowMaximizeLabel;
  final String windowRestoreLabel;
  final String windowCloseLabel;
  final String searchPreviousResultLabel;
  final String searchNextResultLabel;
  final String searchCloseLabel;
  final String entityPickerRemoveLabel;
  final String entityPickerApplyLabel;
  final String formAddLabel;
  final String formClearAllLabel;
  final String formAddStepLabel;
  final String formChooseFilesLabel;
  final String dataLoadingLabel;
  final String dataInvalidStructuredLabel;
  final String fileOpenExternalLabel;
  final String fileDownloadLabel;
  final String filePreviewLoadingLabel;
  final String filePreviewErrorLabel;
  final String filePreviewUnsupportedLabel;
  final String filePreviewEmptyLabel;
  final String diffApproveLabel;
  final String diffRejectLabel;
  final String terminalTitle;
  final String terminalClearLabel;
  final String progressCancelLabel;
  final String filterAddLabel;
  final String filterClearAllLabel;
  final String selectionClearLabel;

  static KlpLocalizations of(BuildContext context) {
    return Localizations.of<KlpLocalizations>(context, KlpLocalizations) ??
        const KlpLocalizations();
  }
}

/// [KlpLocalizations] 的語言檔 delegate。
///
/// 未傳 [overrides] 時依 [Locale] 解析套件 JSON 的同步編譯資源；傳入時保留既有的
/// 整組覆寫能力，適合消費者自有語系或測試。同步資源避免語言載入延後應用首幀，
/// 且有測試保證它與原始 JSON 完全相同。
class KlpLocalizationsDelegate extends LocalizationsDelegate<KlpLocalizations> {
  const KlpLocalizationsDelegate([this.overrides]);

  final KlpLocalizations? overrides;

  @override
  bool isSupported(Locale locale) => KlpLocalizations.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<KlpLocalizations> load(Locale locale) {
    final provided = overrides;
    return SynchronousFuture(
      provided ?? KlpLocalizations.fromJson(_KlpLanguageFiles.resolve(locale)),
    );
  }

  @override
  bool shouldReload(KlpLocalizationsDelegate old) => overrides != old.overrides;
}
