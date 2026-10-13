part of 'klp_code_models.dart';

/// Code Viewer 的介面文字。
@immutable
class KlpCodeViewerLabels {
  const KlpCodeViewerLabels({
    required this.copy,
    required this.menu,
    required this.toggleView,
    required this.languageMenu,
    required this.wrap,
    required this.lineNumbers,
  });

  static const english = KlpCodeViewerLabels(
    copy: 'Copy',
    menu: 'Code menu',
    toggleView: 'Switch view',
    languageMenu: 'Code language',
    wrap: 'Wrap lines',
    lineNumbers: 'Line numbers',
  );

  final String copy;
  final String menu;
  final String toggleView;
  final String languageMenu;
  final String wrap;
  final String lineNumbers;
}
