part of '../klp_toggle.dart';

class KlpToggle extends StatelessWidget {
  const KlpToggle({
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
    return KlpRow(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KlpToggleFrame(
          label: label,
          value: value,
          enabled: enabled,
          onPressed: enabled ? () => onChanged!(!value) : null,
          style: _KlpToggleFrameStyle.resolve(context.klp),
          child: KlpToggleIndicator(value: value, enabled: enabled),
        ),
        if (showLabel) ...[
          const KlpGap.widthSize(KlpSpaceSize.contentInline),
          KlpText(
            label,
            tone: enabled ? KlpTextTone.primary : KlpTextTone.faint,
          ),
        ],
      ],
    );
  }
}
