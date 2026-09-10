part of '../klp_shortcut_hint.dart';

/// 鍵盤快捷鍵提示標籤。
class KlpShortcutHint extends StatelessWidget {
  const KlpShortcutHint({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return _KlpShortcutHintFrame(
      child: KlpText(label, role: KlpTextRole.code, tone: KlpTextTone.muted),
    );
  }
}
