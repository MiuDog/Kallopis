part of '../klp_command_menu.dart';

class _KlpCommandItem extends StatelessWidget {
  const _KlpCommandItem({required this.data, this.keyboardHighlighted = false});

  final KlpCommandItemData data;

  /// 由 [KlpCommandMenu] 以鍵盤方向鍵移動出的高亮狀態。沿用與
  /// [KlpCommandItemData.selected] 相同的底色語言。
  final bool keyboardHighlighted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final enabled = data.onPressed != null;
    final foreground = data.danger
        ? tokens.danger
        : enabled
        ? tokens.text
        : tokens.textFaint;

    return _KlpCommandItemActionFrame(
      onPressed: data.onPressed,
      selected: data.selected,
      highlighted: data.selected || keyboardHighlighted,
      child: KlpBox(
        insets: KlpBoxInsets.uniform(context.klp.space.controlInset),
        child: KlpRow(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpExpanded(
              child: KlpColumn(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KlpText(data.label, color: foreground),
                  if (data.caption != null)
                    KlpText(
                      data.caption!,
                      role: KlpTextRole.caption,
                      tone: enabled ? KlpTextTone.muted : KlpTextTone.faint,
                    ),
                ],
              ),
            ),
            if (data.shortcut != null)
              KlpText(
                data.shortcut!,
                role: KlpTextRole.code,
                tone: KlpTextTone.faint,
              ),
          ],
        ),
      ),
    );
  }
}
