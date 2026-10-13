part of '../klp_checkbox.dart';

class KlpCheckbox extends StatelessWidget {
  const KlpCheckbox({
    super.key,
    required this.value,
    required this.label,
    required this.onChanged,
    this.showLabel = true,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    final enabled = onChanged != null;
    final style = _KlpCheckboxStyle.resolve(context.klp, enabled: enabled);

    return KlpBox(
      insets: KlpBoxInsets.directional(
        top: style.verticalInset,
        bottom: style.verticalInset,
      ),
      child: KlpRow(
        mainAxisSize: showLabel ? MainAxisSize.max : MainAxisSize.min,
        children: [
          _KlpCheckboxFrame(
            value: value,
            label: label,
            onPressed: enabled ? () => onChanged!(!value) : null,
            style: style,
          ),
          if (showLabel) ...[
            const KlpGap.widthSize(KlpSpaceSize.contentInline),
            KlpExpanded(
              child: KlpText(
                label,
                tone: enabled ? KlpTextTone.primary : KlpTextTone.faint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
