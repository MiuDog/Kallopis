part of '../klp_code_viewer.dart';

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
    final style = _KlpCodeStyle.from(context);
    final lines = code.split('\n');
    final body = KlpColumn(
      children: [
        for (var index = 0; index < lines.length; index++)
          _buildLine(style, lines[index], index),
      ],
    );
    if (wrapped) return body;

    return _KlpCodeViewport(
      kind: _KlpCodeViewportKind.horizontal,
      style: style,
      child: body,
    );
  }

  Widget _buildLine(_KlpCodeStyle style, String line, int index) {
    final content = KlpText(line.isEmpty ? ' ' : line, role: KlpTextRole.code);

    return KlpRow(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLineNumbers) ...[
          _KlpCodeSlot(
            kind: _KlpCodeSlotKind.lineNumber,
            style: style,
            child: KlpText(
              '${startLine + index}',
              role: KlpTextRole.code,
              tone: KlpTextTone.faint,
              textAlign: TextAlign.end,
            ),
          ),
          const KlpGap.widthSize(KlpSpaceSize.contentInline),
        ],
        if (wrapped) KlpExpanded(child: content) else content,
      ],
    );
  }
}
