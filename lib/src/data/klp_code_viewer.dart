import 'package:flutter/material.dart';

import '../foundation/klp_palette.dart';
import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../foundation/klp_metrics.dart';
import '../interaction/klp_pressable.dart';
import '../overlay/klp_menu.dart';
import '../overlay/klp_tooltip.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpCodeLanguageOption {
  const KlpCodeLanguageOption({
    required this.id,
    required this.label,
    this.supportsView = false,
  });

  final String id;
  final String label;
  final bool supportsView;
}

abstract final class KlpCodeLanguages {
  static const options = <KlpCodeLanguageOption>[
    KlpCodeLanguageOption(id: 'text', label: 'Plain text'),
    KlpCodeLanguageOption(id: 'shell', label: 'Shell'),
    KlpCodeLanguageOption(id: 'c', label: 'C'),
    KlpCodeLanguageOption(id: 'cpp', label: 'C++'),
    KlpCodeLanguageOption(id: 'csharp', label: 'C#'),
    KlpCodeLanguageOption(id: 'css', label: 'CSS'),
    KlpCodeLanguageOption(id: 'dart', label: 'Dart'),
    KlpCodeLanguageOption(id: 'go', label: 'Go'),
    KlpCodeLanguageOption(id: 'html', label: 'HTML', supportsView: true),
    KlpCodeLanguageOption(id: 'java', label: 'Java'),
    KlpCodeLanguageOption(id: 'javascript', label: 'JavaScript'),
    KlpCodeLanguageOption(id: 'json', label: 'JSON'),
    KlpCodeLanguageOption(id: 'kotlin', label: 'Kotlin'),
    KlpCodeLanguageOption(
      id: 'markdown',
      label: 'Markdown',
      supportsView: true,
    ),
    KlpCodeLanguageOption(id: 'mermaid', label: 'Mermaid', supportsView: true),
    KlpCodeLanguageOption(id: 'php', label: 'PHP'),
    KlpCodeLanguageOption(id: 'python', label: 'Python'),
    KlpCodeLanguageOption(id: 'rust', label: 'Rust'),
    KlpCodeLanguageOption(id: 'sql', label: 'SQL'),
    KlpCodeLanguageOption(id: 'swift', label: 'Swift'),
    KlpCodeLanguageOption(id: 'typescript', label: 'TypeScript'),
    KlpCodeLanguageOption(id: 'yaml', label: 'YAML'),
  ];
}

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
    this.maxHeight = KlpCodeMetrics.defaultMaximumHeight,
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
  final double maxHeight;
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

class _KlpCodeViewerState extends State<KlpCodeViewer> {
  late bool _wrapped;
  late bool _showLineNumbers;
  late bool _expanded;

  KlpCodeLanguageOption? get _currentLanguage {
    final language = widget.language?.trim().toLowerCase() ?? 'text';
    for (final option in widget.languageOptions) {
      if (option.id.toLowerCase() == language) return option;
    }
    return null;
  }

  String get _languageLabel {
    final language = widget.language?.trim();
    if (language != null && language.isNotEmpty) return language;
    return _currentLanguage?.id ?? 'text';
  }

  bool get _supportsView =>
      _currentLanguage?.supportsView == true && widget.onToggleView != null;

  @override
  void initState() {
    super.initState();
    _wrapped = widget.wrapped;
    _showLineNumbers = widget.showLineNumbers;
    _expanded = widget.expanded;
  }

  @override
  void didUpdateWidget(KlpCodeViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wrapped != widget.wrapped) _wrapped = widget.wrapped;
    if (oldWidget.showLineNumbers != widget.showLineNumbers) {
      _showLineNumbers = widget.showLineNumbers;
    }
    if (oldWidget.expanded != widget.expanded) {
      _expanded = widget.expanded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.card),
      child: Container(
        decoration: BoxDecoration(
          color: tokens.stageSurface,
          borderRadius: BorderRadius.circular(klp.shape.card),
          border: Border.all(color: tokens.divider, width: klp.shape.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildHeader(), _buildBody()],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: context.klpColors.surfaceInset,
        border: Border(
          bottom: BorderSide(
            color: context.klpColors.divider,
            width: context.klp.shape.hairline,
          ),
        ),
      ),
      child: SizedBox(
        height: KlpCodeMetrics.headerHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            left: KlpCodeMetrics.headerPaddingHorizontal,
          ),
          child: Row(
            children: [
              const _KlpTerminalMark(),
              const SizedBox(width: KlpCodeMetrics.terminalGroupGap),
              Builder(
                builder: (buttonContext) {
                  return _KlpCodeLanguageButton(
                    key: const ValueKey('pln-code-language'),
                    label: _languageLabel,
                    enabled:
                        widget.onLanguageChanged != null &&
                        widget.languageOptions.isNotEmpty,
                    onPressed: () => _openLanguageMenu(buttonContext),
                  );
                },
              ),
              const Spacer(),
              if (widget.expandable)
                _KlpCodeActionButton(
                  key: const ValueKey('pln-code-expand-toggle'),
                  icon: _expanded ? KlpIcons.collapse : KlpIcons.maximize,
                  label: _expanded ? '收合' : '展開',
                  selected: _expanded,
                  onPressed: () {
                    setState(() => _expanded = !_expanded);
                    widget.onToggleExpand?.call();
                  },
                ),
              if (_supportsView)
                _KlpCodeActionButton(
                  key: const ValueKey('pln-code-view-toggle'),
                  icon: KlpIcons.eye,
                  label: widget.labels.toggleView,
                  selected: widget.viewSelected,
                  onPressed: widget.onToggleView,
                ),
              _KlpCodeActionButton(
                key: const ValueKey('pln-code-copy'),
                icon: KlpIcons.clipboard,
                label: widget.labels.copy,
                onPressed: widget.onCopy,
              ),
              Builder(
                builder: (buttonContext) {
                  return _KlpCodeActionButton(
                    key: const ValueKey('pln-code-menu'),
                    icon: KlpIcons.menu,
                    label: widget.labels.menu,
                    onPressed: () => _openOptionsMenu(buttonContext),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    final content = widget.loading
        ? const KlpText(
            'Loading...',
            role: KlpTextRole.code,
            tone: KlpTextTone.muted,
          )
        : widget.content ??
              _KlpCodeLines(
                code: widget.code,
                startLine: widget.startLine,
                wrapped: _wrapped,
                showLineNumbers: _showLineNumbers,
              );

    final effectiveMaxHeight = widget.expandable && !_expanded
        ? 120.0
        : widget.maxHeight;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: effectiveMaxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: KlpCodeMetrics.bodyPaddingHorizontal,
          vertical: KlpCodeMetrics.bodyPaddingVertical,
        ),
        child: content,
      ),
    );
  }

  Future<void> _openLanguageMenu(BuildContext context) async {
    if (widget.onLanguageChanged == null || widget.languageOptions.isEmpty) {
      return;
    }

    final selectedIndex = await _openMenu(
      context,
      label: widget.labels.languageMenu,
      items: [
        for (var index = 0; index < widget.languageOptions.length; index++)
          KlpMenuItemData(
            key: ValueKey(
              'pln-code-language-${widget.languageOptions[index].id}',
            ),
            label: widget.languageOptions[index].label,
            selected:
                widget.languageOptions[index].id ==
                (_currentLanguage?.id ?? widget.language),
            onPressed: () {},
          ),
      ],
    );
    if (selectedIndex == null || !mounted) return;

    widget.onLanguageChanged!(widget.languageOptions[selectedIndex].id);
  }

  Future<void> _openOptionsMenu(BuildContext context) async {
    final selectedIndex = await _openMenu(
      context,
      label: widget.labels.menu,
      items: [
        KlpMenuItemData(
          key: const ValueKey('pln-code-menu-wrap'),
          label: widget.labels.wrap,
          toggleValue: _wrapped,
          onPressed: () {},
        ),
        KlpMenuItemData(
          key: const ValueKey('pln-code-menu-line-numbers'),
          label: widget.labels.lineNumbers,
          toggleValue: _showLineNumbers,
          onPressed: () {},
        ),
      ],
    );
    if (selectedIndex == null || !mounted) return;

    setState(() {
      if (selectedIndex == 0) _wrapped = !_wrapped;
      if (selectedIndex == 1) _showLineNumbers = !_showLineNumbers;
    });
    if (selectedIndex == 0) widget.onToggleWrap?.call();
    if (selectedIndex == 1) widget.onToggleLineNumbers?.call();
  }

  Future<int?> _openMenu(
    BuildContext context, {
    required String label,
    required List<KlpMenuItemData> items,
  }) async {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;

    final anchor = renderObject.localToGlobal(
      Offset(0, renderObject.size.height),
    );
    final position = KlpMenuLayout.resolvePosition(
      anchor: anchor,
      viewport: MediaQuery.sizeOf(context),
      context: context,
      itemCount: items.length,
    );
    return showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: widget.labels.menu,
      barrierColor: KlpPalette.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                type: MaterialType.transparency,
                child: KlpMenu(
                  label: label,
                  items: [
                    for (var index = 0; index < items.length; index++)
                      KlpMenuItemData(
                        key: items[index].key,
                        label: items[index].label,
                        icon: items[index].icon,
                        shortcut: items[index].shortcut,
                        toggleValue: items[index].toggleValue,
                        selected: items[index].selected,
                        onPressed: () => Navigator.of(dialogContext).pop(index),
                      ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _KlpTerminalMark extends StatelessWidget {
  const _KlpTerminalMark();

  @override
  Widget build(BuildContext context) {
    final color = context.klpColors.textFaint;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 3; index++) ...[
          DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox.square(dimension: KlpCodeMetrics.terminalDot),
          ),
          if (index < 2) const SizedBox(width: KlpCodeMetrics.terminalDotGap),
        ],
      ],
    );
  }
}

class _KlpCodeActionButton extends StatefulWidget {
  const _KlpCodeActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  State<_KlpCodeActionButton> createState() => _KlpCodeActionButtonState();
}

class _KlpCodeActionButtonState extends State<_KlpCodeActionButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final active = widget.onPressed != null && (_hovered || _focused);
    // hover 不改前景色。
    final foreground = widget.onPressed == null
        ? tokens.textFaint
        : widget.selected
        ? tokens.selectionForeground
        : tokens.textMuted;

    return KlpTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.label,
        child: Builder(
          builder: (context) {
            Widget button = Material(
              color: widget.selected
                  ? tokens.selectionBackground
                  : KlpPalette.transparent,
              borderRadius: BorderRadius.circular(context.klp.shape.control),
              child: KlpPressable(
                onPressed: widget.onPressed,
                onHover: (value) => setState(() => _hovered = value),
                onFocusChange: (value) => setState(() => _focused = value),
                borderRadius: BorderRadius.circular(context.klp.shape.control),
                child: SizedBox.square(
                  dimension: KlpCodeMetrics.actionButtonSize,
                  child: Center(
                    child: KlpIcon(
                      widget.icon,
                      size: KlpCodeMetrics.actionIconSize,
                      color: foreground,
                    ),
                  ),
                ),
              ),
            );

            if (active) {
              button = KlpDashedBorder(
                color: widget.selected
                    ? tokens.textMuted
                    : context.klp.hoverBorder,
                radius: context.klp.shape.control,
                child: button,
              );
            }

            return button;
          },
        ),
      ),
    );
  }
}

class _KlpCodeLanguageButton extends StatefulWidget {
  const _KlpCodeLanguageButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  State<_KlpCodeLanguageButton> createState() => _KlpCodeLanguageButtonState();
}

class _KlpCodeLanguageButtonState extends State<_KlpCodeLanguageButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final active = widget.enabled && (_hovered || _focused);
    final color = tokens.textMuted;

    Widget button = Material(
      color: KlpPalette.transparent,
      borderRadius: BorderRadius.circular(context.klp.shape.control),
      child: KlpPressable(
        onPressed: widget.enabled ? widget.onPressed : null,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        borderRadius: BorderRadius.circular(context.klp.shape.control),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.tight),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KlpText(widget.label, role: KlpTextRole.code, color: color),
              if (widget.enabled) ...[
                SizedBox(width: context.klp.space.tight),
                KlpIcon(
                  KlpIcons.chevronDown,
                  size: KlpSize.disclosure,
                  color: color,
                ),
              ],
            ],
          ),
        ),
      ),
    );

    if (active) {
      button = KlpDashedBorder(
        color: context.klp.hoverBorder,
        radius: context.klp.shape.control,
        child: button,
      );
    }

    return Align(
      widthFactor: 1,
      alignment: Alignment.centerLeft,
      child: button,
    );
  }
}

class _KlpCodeLines extends StatelessWidget {
  const _KlpCodeLines({
    required this.code,
    required this.startLine,
    required this.wrapped,
    required this.showLineNumbers,
  });

  final String code;
  final int startLine;
  final bool wrapped;
  final bool showLineNumbers;

  @override
  Widget build(BuildContext context) {
    final lines = code.split('\n');
    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var index = 0; index < lines.length; index++)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showLineNumbers) ...[
                SizedBox(
                  width: KlpCodeMetrics.lineNumberWidth,
                  child: KlpText(
                    '${startLine + index}',
                    role: KlpTextRole.code,
                    tone: KlpTextTone.faint,
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(width: context.klp.space.compact),
              ],
              if (wrapped)
                SizedBox(
                  width: KlpCodeMetrics.wrappedLineWidth,
                  child: KlpText(
                    lines[index].isEmpty ? ' ' : lines[index],
                    role: KlpTextRole.code,
                  ),
                )
              else
                KlpText(
                  lines[index].isEmpty ? ' ' : lines[index],
                  role: KlpTextRole.code,
                ),
            ],
          ),
      ],
    );
    if (wrapped) return body;

    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: body);
  }
}

/// Diff 單行變更類型：未變更、新增、刪除。
enum KlpDiffLineType {
  /// 未變更。
  unchanged,

  /// 新增行（呈現綠色底色與加號）。
  added,

  /// 刪除行（呈現紅色底色與減號）。
  deleted,
}

/// Diff 單行資料。
@immutable
class KlpDiffLine {
  const KlpDiffLine({
    this.oldNumber,
    this.newNumber,
    required this.content,
    this.type = KlpDiffLineType.unchanged,
    this.onApprove,
    this.onReject,
  });

  /// 舊行號。為新增行時可為 null。
  final int? oldNumber;

  /// 新行號。為刪除行時可為 null。
  final int? newNumber;

  /// 程式碼文字內容。
  final String content;

  /// 行差異類型。
  final KlpDiffLineType type;

  /// 接受此行變更的回呼。
  final VoidCallback? onApprove;

  /// 拒絕／捨棄此行變更的回呼。
  final VoidCallback? onReject;
}

/// 程式碼差異檢視器 (Diff Viewer)。
///
/// 呈現檔案名稱標題、雙欄行號對照、新增（綠底）與刪除（紅底）標記行，以及逐行審查操作。
class KlpDiffViewer extends StatelessWidget {
  const KlpDiffViewer({
    super.key,
    required this.filename,
    required this.lines,
    this.maxHeight,
    this.onCopy,
  });

  /// 檔案名稱或路徑標題。
  final String filename;

  /// 差異行清單。
  final List<KlpDiffLine> lines;

  /// 最大高度。超過時內部自動出現滾動條。
  final double? maxHeight;

  /// 複製內容的回呼。
  final VoidCallback? onCopy;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.card),
      child: Container(
        decoration: BoxDecoration(
          color: tokens.stageSurface,
          borderRadius: BorderRadius.circular(klp.shape.card),
          border: Border.all(color: tokens.divider, width: klp.shape.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: KlpCodeMetrics.headerHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: KlpCodeMetrics.headerPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: tokens.surfaceInset,
                border: Border(
                  bottom: BorderSide(
                    color: tokens.divider,
                    width: klp.shape.hairline,
                  ),
                ),
              ),
              child: Row(
                children: [
                  KlpText(
                    filename.toUpperCase(),
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                  ),
                  const Spacer(),
                  if (onCopy != null)
                    KlpPressable(
                      onPressed: onCopy,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: klp.space.tight,
                        ),
                        child: const KlpText(
                          'Copy',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight ?? double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  vertical: KlpCodeMetrics.bodyPaddingVertical,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in lines) _KlpDiffLineRow(line: line),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KlpDiffLineRow extends StatelessWidget {
  const _KlpDiffLineRow({required this.line});

  final KlpDiffLine line;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    final (bgColor, prefix, prefixColor) = switch (line.type) {
      KlpDiffLineType.added => (
        tokens.success.withValues(alpha: klp.surface.diffFillOpacity),
        '+',
        tokens.success,
      ),
      KlpDiffLineType.deleted => (
        tokens.danger.withValues(alpha: klp.surface.diffFillOpacity),
        '-',
        tokens.danger,
      ),
      KlpDiffLineType.unchanged => (null, ' ', tokens.textFaint),
    };

    return Container(
      color: bgColor,
      padding: const EdgeInsets.symmetric(
        horizontal: KlpCodeMetrics.bodyPaddingHorizontal,
        vertical: 2,
      ),
      child: Row(
        children: [
          SizedBox(
            width: klp.space.gutterNumber,
            child: KlpText(
              line.oldNumber?.toString() ?? '',
              role: KlpTextRole.code,
              tone: KlpTextTone.faint,
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(width: klp.space.tight),
          SizedBox(
            width: klp.space.gutterNumber,
            child: KlpText(
              line.newNumber?.toString() ?? '',
              role: KlpTextRole.code,
              tone: KlpTextTone.faint,
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(width: klp.space.compact),
          SizedBox(
            width: klp.space.gutterMarker,
            child: KlpText(prefix, role: KlpTextRole.code, color: prefixColor),
          ),
          Expanded(child: KlpText(line.content, role: KlpTextRole.code)),
          if (line.onApprove != null || line.onReject != null) ...[
            if (line.onApprove != null)
              KlpPressable(
                onPressed: line.onApprove,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: klp.space.xxs),
                  child: KlpText(
                    '✓',
                    role: KlpTextRole.code,
                    color: tokens.success,
                  ),
                ),
              ),
            if (line.onReject != null)
              KlpPressable(
                onPressed: line.onReject,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: klp.space.xxs),
                  child: KlpText(
                    '✕',
                    role: KlpTextRole.code,
                    color: tokens.danger,
                  ),
                ),
              ),
          ],
        ],
      ),
    );
  }
}

/// 終端機模擬與指令執行檢視器 (Terminal)。
///
/// 具備整體實線細邊框、頂部三點視窗標記、指令列與輸出區，內容區域採用 stage 底色。
class KlpTerminal extends StatelessWidget {
  const KlpTerminal({
    super.key,
    this.title = 'terminal',
    required this.lines,
    this.maxHeight,
    this.onCopy,
    this.onClear,
  });

  /// 終端機視窗標題。
  final String title;

  /// 輸出字串行清單。
  final List<String> lines;

  /// 最大高度。超過時內部自動出現滾動條。
  final double? maxHeight;

  /// 複製終端機內容的回呼。
  final VoidCallback? onCopy;

  /// 清除終端機內容的回呼。
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(klp.shape.card),
      child: Container(
        decoration: BoxDecoration(
          color: tokens.stageSurface,
          borderRadius: BorderRadius.circular(klp.shape.card),
          border: Border.all(color: tokens.divider, width: klp.shape.hairline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: KlpCodeMetrics.headerHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: KlpCodeMetrics.headerPaddingHorizontal,
              ),
              decoration: BoxDecoration(
                color: tokens.surfaceInset,
                border: Border(
                  bottom: BorderSide(
                    color: tokens.divider,
                    width: klp.shape.hairline,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const _KlpTerminalMark(),
                  const SizedBox(width: KlpCodeMetrics.terminalGroupGap),
                  KlpText(
                    title,
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                  ),
                  const Spacer(),
                  if (onClear != null)
                    KlpPressable(
                      onPressed: onClear,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: klp.space.tight,
                        ),
                        child: const KlpText(
                          'Clear',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                    ),
                  if (onCopy != null)
                    KlpPressable(
                      onPressed: onCopy,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: klp.space.tight,
                        ),
                        child: const KlpText(
                          'Copy',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: maxHeight ?? double.infinity,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(
                  KlpCodeMetrics.bodyPaddingHorizontal,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final line in lines)
                      KlpText(line, role: KlpTextRole.code),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
