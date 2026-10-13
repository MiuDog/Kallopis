part of '../klp_code_viewer.dart';

class _KlpTerminalMark extends StatelessWidget {
  const _KlpTerminalMark({required this.style});

  final _KlpCodeStyle style;

  @override
  Widget build(BuildContext context) {
    return KlpRow(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < 3; index++) ...[
          _KlpCodeFrame(kind: _KlpCodeFrameKind.terminalDot, style: style),
          if (index < 2)
            _KlpCodeSlot(kind: _KlpCodeSlotKind.terminalDotGap, style: style),
        ],
      ],
    );
  }
}
