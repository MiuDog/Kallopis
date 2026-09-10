import '../internal/klp_form_dependencies.dart';
import '../internal/klp_input_frame.dart';
import '../internal/primitives/klp_input_action.dart';
import '../internal/primitives/klp_input_editor.dart';
import '../internal/primitives/klp_input_segment_divider.dart';

/// 在同一控制框中編輯起訖日期，並可由尾端動作開啟產品提供的日期挑選器。
class KlpDateRangeField extends StatelessWidget {
  final String label;
  final TextEditingController? startController;
  final TextEditingController? endController;
  final String? initialStartValue;
  final String? initialEndValue;
  final String? startPlaceholder;
  final String? endPlaceholder;
  final ValueChanged<String>? onStartChanged;
  final ValueChanged<String>? onEndChanged;
  final VoidCallback? onCalendarPressed;
  final bool enabled;
  final bool readOnly;
  final String? error;
  final String? calendarLabel;

  const KlpDateRangeField({
    super.key,
    required this.label,
    this.startController,
    this.endController,
    this.initialStartValue,
    this.initialEndValue,
    this.startPlaceholder,
    this.endPlaceholder,
    this.onStartChanged,
    this.onEndChanged,
    this.onCalendarPressed,
    this.enabled = true,
    this.readOnly = false,
    this.error,
    this.calendarLabel,
  }) : assert(startController == null || initialStartValue == null),
       assert(endController == null || initialEndValue == null);

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && !readOnly;
    final labels = KlpLocalizations.of(context);

    return KlpInputFrame(
      label: label,
      enabled: enabled,
      readOnly: readOnly,
      error: error,
      child: KlpRow(
        children: [
          KlpExpanded(
            child: KlpInputEditor(
              controller: startController,
              initialValue: initialStartValue,
              placeholder: startPlaceholder,
              onChanged: onStartChanged,
              enabled: enabled,
              readOnly: readOnly,
            ),
          ),
          const KlpText('→', role: KlpTextRole.code, tone: KlpTextTone.muted),
          KlpExpanded(
            child: KlpInputEditor(
              controller: endController,
              initialValue: initialEndValue,
              placeholder: endPlaceholder,
              onChanged: onEndChanged,
              enabled: enabled,
              readOnly: readOnly,
            ),
          ),
          const KlpInputSegmentDivider(),
          KlpInputAction(
            icon: KlpIcons.calendar,
            label: calendarLabel ?? labels.formDateRangeCalendarLabel,
            onPressed: interactive ? onCalendarPressed : null,
          ),
        ],
      ),
    );
  }
}
