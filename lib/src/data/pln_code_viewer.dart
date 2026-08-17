import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../interaction/pln_pressable.dart';
import '../overlay/pln_menu.dart';
import '../overlay/pln_tooltip.dart';
import '../surface/pln_dashed_border.dart';
import '../surface/pln_surface.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnCodeLanguageOption {
  const PlnCodeLanguageOption({
    required this.id,
    required this.label,
    this.supportsView = false,
  });

  final String id;
  final String label;
  final bool supportsView;
}

abstract final class PlnCodeLanguages {
  static const options = <PlnCodeLanguageOption>[
    PlnCodeLanguageOption(id: 'text', label: 'Plain text'),
    PlnCodeLanguageOption(id: 'shell', label: 'Shell'),
    PlnCodeLanguageOption(id: 'c', label: 'C'),
    PlnCodeLanguageOption(id: 'cpp', label: 'C++'),
    PlnCodeLanguageOption(id: 'csharp', label: 'C#'),
    PlnCodeLanguageOption(id: 'css', label: 'CSS'),
    PlnCodeLanguageOption(id: 'dart', label: 'Dart'),
    PlnCodeLanguageOption(id: 'go', label: 'Go'),
    PlnCodeLanguageOption(id: 'html', label: 'HTML', supportsView: true),
    PlnCodeLanguageOption(id: 'java', label: 'Java'),
    PlnCodeLanguageOption(id: 'javascript', label: 'JavaScript'),
    PlnCodeLanguageOption(id: 'json', label: 'JSON'),
    PlnCodeLanguageOption(id: 'kotlin', label: 'Kotlin'),
    PlnCodeLanguageOption(
      id: 'markdown',
      label: 'Markdown',
      supportsView: true,
    ),
    PlnCodeLanguageOption(id: 'mermaid', label: 'Mermaid', supportsView: true),
    PlnCodeLanguageOption(id: 'php', label: 'PHP'),
    PlnCodeLanguageOption(id: 'python', label: 'Python'),
    PlnCodeLanguageOption(id: 'rust', label: 'Rust'),
    PlnCodeLanguageOption(id: 'sql', label: 'SQL'),
    PlnCodeLanguageOption(id: 'swift', label: 'Swift'),
    PlnCodeLanguageOption(id: 'typescript', label: 'TypeScript'),
    PlnCodeLanguageOption(id: 'yaml', label: 'YAML'),
  ];
}

class PlnCodeViewerLabels {
  const PlnCodeViewerLabels({
    required this.copy,
    required this.menu,
    required this.toggleView,
    required this.languageMenu,
    required this.wrap,
    required this.lineNumbers,
  });

  static const english = PlnCodeViewerLabels(
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

class PlnCodeViewer extends StatefulWidget {
  const PlnCodeViewer({
    super.key,
    required this.code,
    this.language,
    this.languageOptions = PlnCodeLanguages.options,
    this.labels = PlnCodeViewerLabels.english,
    this.showLineNumbers = false,
    this.startLine = 1,
    this.wrapped = false,
    this.loading = false,
    this.maxHeight = PlnCodeMetrics.defaultMaximumHeight,
    this.content,
    this.viewSelected = false,
    this.onLanguageChanged,
    this.onToggleWrap,
    this.onToggleLineNumbers,
    this.onToggleView,
    this.onCopy,
  });

  final String code;
  final String? language;
  final List<PlnCodeLanguageOption> languageOptions;
  final PlnCodeViewerLabels labels;
  final bool showLineNumbers;
  final int startLine;
  final bool wrapped;
  final bool loading;
  final double maxHeight;
  final Widget? content;
  final bool viewSelected;
  final ValueChanged<String>? onLanguageChanged;
  final VoidCallback? onToggleWrap;
  final VoidCallback? onToggleLineNumbers;
  final VoidCallback? onToggleView;
  final VoidCallback? onCopy;

  @override
  State<PlnCodeViewer> createState() => _PlnCodeViewerState();
}

class _PlnCodeViewerState extends State<PlnCodeViewer> {
  late bool _wrapped;
  late bool _showLineNumbers;

  PlnCodeLanguageOption? get _currentLanguage {
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
  }

  @override
  void didUpdateWidget(PlnCodeViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wrapped != widget.wrapped) _wrapped = widget.wrapped;
    if (oldWidget.showLineNumbers != widget.showLineNumbers) {
      _showLineNumbers = widget.showLineNumbers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlnDashedBorder(
      radius: PlnRadius.card,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(PlnRadius.card),
        child: PlnSurface(
          tone: PlnSurfaceTone.inset,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildHeader(), _buildBody()],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return ColoredBox(
      color: context.plnTheme.surfaceMuted,
      child: SizedBox(
        height: PlnCodeMetrics.headerHeight,
        child: Padding(
          padding: const EdgeInsets.only(
            left: PlnCodeMetrics.headerPaddingHorizontal,
          ),
          child: Row(
            children: [
              const _PlnTerminalMark(),
              const SizedBox(width: PlnCodeMetrics.terminalGroupGap),
              Builder(
                builder: (buttonContext) {
                  return _PlnCodeLanguageButton(
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
              if (_supportsView)
                _PlnCodeActionButton(
                  key: const ValueKey('pln-code-view-toggle'),
                  icon: PlnIcons.eye,
                  label: widget.labels.toggleView,
                  selected: widget.viewSelected,
                  onPressed: widget.onToggleView,
                ),
              _PlnCodeActionButton(
                key: const ValueKey('pln-code-copy'),
                icon: PlnIcons.clipboard,
                label: widget.labels.copy,
                onPressed: widget.onCopy,
              ),
              Builder(
                builder: (buttonContext) {
                  return _PlnCodeActionButton(
                    key: const ValueKey('pln-code-menu'),
                    icon: PlnIcons.menu,
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
        ? const PlnText(
            'Loading...',
            role: PlnTextRole.code,
            tone: PlnTextTone.muted,
          )
        : widget.content ??
              _PlnCodeLines(
                code: widget.code,
                startLine: widget.startLine,
                wrapped: _wrapped,
                showLineNumbers: _showLineNumbers,
              );

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.maxHeight),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: PlnCodeMetrics.bodyPaddingHorizontal,
          vertical: PlnCodeMetrics.bodyPaddingVertical,
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
          PlnMenuItemData(
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
        PlnMenuItemData(
          key: const ValueKey('pln-code-menu-wrap'),
          label: widget.labels.wrap,
          toggleValue: _wrapped,
          onPressed: () {},
        ),
        PlnMenuItemData(
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
    required List<PlnMenuItemData> items,
  }) async {
    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;

    final anchor = renderObject.localToGlobal(
      Offset(0, renderObject.size.height),
    );
    final position = PlnMenuLayout.resolvePosition(
      anchor: anchor,
      viewport: MediaQuery.sizeOf(context),
      itemCount: items.length,
    );
    return showGeneralDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierLabel: widget.labels.menu,
      barrierColor: Colors.transparent,
      transitionDuration: Duration.zero,
      pageBuilder: (dialogContext, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: position.dx,
              top: position.dy,
              child: Material(
                type: MaterialType.transparency,
                child: PlnMenu(
                  label: label,
                  items: [
                    for (var index = 0; index < items.length; index++)
                      PlnMenuItemData(
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

class _PlnTerminalMark extends StatelessWidget {
  const _PlnTerminalMark();

  @override
  Widget build(BuildContext context) {
    final color = context.plnTheme.textFaint;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 3; index++) ...[
          DecoratedBox(
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: const SizedBox.square(dimension: PlnCodeMetrics.terminalDot),
          ),
          if (index < 2) const SizedBox(width: PlnCodeMetrics.terminalDotGap),
        ],
      ],
    );
  }
}

class _PlnCodeActionButton extends StatefulWidget {
  const _PlnCodeActionButton({
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
  State<_PlnCodeActionButton> createState() => _PlnCodeActionButtonState();
}

class _PlnCodeActionButtonState extends State<_PlnCodeActionButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final active = widget.onPressed != null && (_hovered || _focused);
    final foreground = widget.onPressed == null
        ? tokens.textFaint
        : widget.selected
        ? tokens.selectionForeground
        : active
        ? tokens.text
        : tokens.textMuted;

    return PlnTooltip(
      message: widget.label,
      child: Semantics(
        button: true,
        selected: widget.selected,
        label: widget.label,
        child: Material(
          color: widget.selected
              ? tokens.selectionBackground
              : active
              ? tokens.hoverSurface
              : Colors.transparent,
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: PlnPressable(
            onPressed: widget.onPressed,
            onHover: (value) => setState(() => _hovered = value),
            onFocusChange: (value) => setState(() => _focused = value),
            borderRadius: BorderRadius.circular(PlnRadius.control),
            child: SizedBox.square(
              dimension: PlnCodeMetrics.actionButtonSize,
              child: Center(
                child: PlnIcon(
                  widget.icon,
                  size: PlnCodeMetrics.actionIconSize,
                  color: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PlnCodeLanguageButton extends StatefulWidget {
  const _PlnCodeLanguageButton({
    super.key,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  State<_PlnCodeLanguageButton> createState() => _PlnCodeLanguageButtonState();
}

class _PlnCodeLanguageButtonState extends State<_PlnCodeLanguageButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final active = widget.enabled && (_hovered || _focused);
    final color = widget.enabled ? tokens.textMuted : tokens.textFaint;

    return Align(
      widthFactor: 1,
      alignment: Alignment.centerLeft,
      child: Material(
        color: active ? tokens.hoverSurface : Colors.transparent,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: PlnPressable(
          onPressed: widget.enabled ? widget.onPressed : null,
          onHover: (value) => setState(() => _hovered = value),
          onFocusChange: (value) => setState(() => _focused = value),
          borderRadius: BorderRadius.circular(PlnRadius.control),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: PlnSpace.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlnText(
                  widget.label,
                  role: PlnTextRole.code,
                  color: active ? tokens.text : color,
                ),
                if (widget.enabled) ...[
                  const SizedBox(width: PlnSpace.xs),
                  PlnIcon(
                    PlnIcons.chevronDown,
                    size: PlnSize.disclosure,
                    color: active ? tokens.text : color,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlnCodeLines extends StatelessWidget {
  const _PlnCodeLines({
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
                  width: PlnCodeMetrics.lineNumberWidth,
                  child: PlnText(
                    '${startLine + index}',
                    role: PlnTextRole.code,
                    tone: PlnTextTone.faint,
                    textAlign: TextAlign.end,
                  ),
                ),
                const SizedBox(width: PlnSpace.sm),
              ],
              if (wrapped)
                SizedBox(
                  width: PlnCodeMetrics.wrappedLineWidth,
                  child: PlnText(
                    lines[index].isEmpty ? ' ' : lines[index],
                    role: PlnTextRole.code,
                  ),
                )
              else
                PlnText(
                  lines[index].isEmpty ? ' ' : lines[index],
                  role: PlnTextRole.code,
                ),
            ],
          ),
      ],
    );
    if (wrapped) return body;

    return SingleChildScrollView(scrollDirection: Axis.horizontal, child: body);
  }
}
