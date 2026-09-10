part of 'klp_editor_action_bars.dart';

/// 以緊密節奏呈現可換行的編輯器動作。
class KlpEditorToolbar extends StatelessWidget {
  const KlpEditorToolbar({super.key, required this.actions});

  final List<KlpEditorActionData> actions;

  @override
  Widget build(BuildContext context) {
    return _KlpEditorActionSurface(
      child: KlpWrap(
        spacingSize: KlpSpaceSize.tight,
        runSpacingSize: KlpSpaceSize.tight,
        children: [
          for (final action in actions) _KlpEditorAction(data: action),
        ],
      ),
    );
  }
}
