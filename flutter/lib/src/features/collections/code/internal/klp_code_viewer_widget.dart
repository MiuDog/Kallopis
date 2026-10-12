part of '../klp_code_viewer.dart';

class KlpCodeViewer extends StatefulWidget {
  const KlpCodeViewer({
    super.key,
    required this.code,
    this.language,
    this.languageOptions = KlpCodeLanguages.options,
    this.labels = KlpCodeViewerLabels.english,
    this.showLineNumbers = false,
    this.startLine = 1,
    this.wrapped = false,
    this.loading = false,
    this.expandable = false,
    this.expanded = false,
    this.viewportLimit,
    this.content,
    this.viewSelected = false,
    this.onLanguageChanged,
    this.onToggleWrap,
    this.onToggleLineNumbers,
    this.onToggleView,
    this.onToggleExpand,
    this.onCopy,
  });

  final String code;
  final String? language;
  final List<KlpCodeLanguageOption> languageOptions;
  final KlpCodeViewerLabels labels;
  final bool showLineNumbers;
  final int startLine;
  final bool wrapped;
  final bool loading;
  final bool expandable;
  final bool expanded;
  final KlpCodeViewportLimit? viewportLimit;
  final Widget? content;
  final bool viewSelected;
  final ValueChanged<String>? onLanguageChanged;
  final VoidCallback? onToggleWrap;
  final VoidCallback? onToggleLineNumbers;
  final VoidCallback? onToggleView;
  final VoidCallback? onToggleExpand;
  final VoidCallback? onCopy;

  @override
  State<KlpCodeViewer> createState() => _KlpCodeViewerState();
}
