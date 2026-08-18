import 'package:flutter/material.dart';

import '../controls/klp_text_field.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_stroke.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

class KlpTextArea extends StatelessWidget {
  const KlpTextArea({
    super.key,
    this.label,
    this.value,
    this.placeholder,
    this.error,
    this.onChanged,
    this.enabled = true,
  });

  final String? label;
  final String? value;
  final String? placeholder;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      label: label,
      initialValue: value,
      placeholder: placeholder,
      error: error,
      onChanged: onChanged,
      enabled: enabled,
      multiline: true,
    );
  }
}

class KlpNumberField extends StatelessWidget {
  const KlpNumberField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.minimum,
    this.maximum,
    this.unit,
    this.error,
  });

  final String label;
  final double value;
  final ValueChanged<double>? onChanged;
  final double? minimum;
  final double? maximum;
  final String? unit;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      label: label,
      initialValue: value.toString(),
      error: error,
      onChanged: onChanged == null
          ? null
          : (text) {
              final parsed = double.tryParse(text);
              if (parsed == null) return;
              if (minimum != null && parsed < minimum!) return;
              if (maximum != null && parsed > maximum!) return;
              onChanged!(parsed);
            },
    );
  }
}

class KlpPasswordField extends StatelessWidget {
  const KlpPasswordField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.error,
    this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        TextFormField(
          initialValue: value,
          obscureText: true,
          enabled: enabled,
          onChanged: onChanged,
          style: TextStyle(color: tokens.text),
          cursorColor: tokens.interaction,
          decoration: InputDecoration(
            isDense: true,
            hintText: placeholder,
            hintStyle: TextStyle(color: tokens.textFaint),
            filled: true,
            fillColor: KlpFieldStyle.inputFill(tokens, error: error != null),
            constraints: const BoxConstraints.tightFor(
              height: KlpFormMetrics.fieldHeight,
            ),
            contentPadding: context.klp.space.controlInsets,
          ),
        ),
        if (error != null) ...[
          SizedBox(height: context.klp.space.tight),
          KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
        ],
      ],
    );
  }
}

class KlpDateField extends StatelessWidget {
  const KlpDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.placeholder,
  });

  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      label: label,
      initialValue: value,
      placeholder: placeholder,
      onChanged: onChanged,
    );
  }
}

typedef KlpTimeField = KlpDateField;
typedef KlpDateTimeField = KlpDateField;
typedef KlpDurationField = KlpNumberField;

@immutable
class KlpChoiceOption {
  const KlpChoiceOption({
    required this.id,
    required this.label,
    this.disabled = false,
  });

  final String id;
  final String label;
  final bool disabled;
}

class KlpSelectField extends StatefulWidget {
  const KlpSelectField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final String valueLabel;
  final List<KlpChoiceOption> options;
  final ValueChanged<String>? onSelected;

  @override
  State<KlpSelectField> createState() => _KlpSelectFieldState();
}

class _KlpSelectFieldState extends State<KlpSelectField> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(widget.label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onSelected == null
              ? null
              : () => setState(() => _expanded = !_expanded),
          child: KlpStrokeFrame(
            role: KlpStrokeRole.field,
            state: widget.onSelected == null
                ? KlpStrokeState.disabled
                : _expanded
                ? KlpStrokeState.selected
                : KlpStrokeState.rest,
            child: Container(
              height: KlpFormMetrics.fieldHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(context.klp.shape.control),
              ),
              child: KlpText(widget.valueLabel),
            ),
          ),
        ),
        if (_expanded) ...[
          SizedBox(height: context.klp.space.tight),
          Container(
            padding: EdgeInsets.all(context.klp.space.tight),
            decoration: BoxDecoration(
              color: context.klpColors.component,
              borderRadius: BorderRadius.circular(context.klp.shape.card),
            ),
            child: Column(
              children: [
                for (final option in widget.options)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: option.disabled
                        ? null
                        : () {
                            widget.onSelected?.call(option.id);
                            setState(() => _expanded = false);
                          },
                    child: Container(
                      constraints: const BoxConstraints(
                        minHeight: KlpFormMetrics.fieldHeight,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(
                        horizontal: context.klp.space.compact,
                      ),
                      child: KlpText(
                        option.label,
                        tone: option.disabled
                            ? KlpTextTone.faint
                            : KlpTextTone.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class KlpMultiSelectField extends StatelessWidget {
  const KlpMultiSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
  });

  final String label;
  final List<KlpChoiceOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        Wrap(
          spacing: context.klp.space.tight,
          runSpacing: context.klp.space.tight,
          children: [
            for (final option in options)
              GestureDetector(
                onTap: onChanged == null
                    ? null
                    : () {
                        final next = Set<String>.from(selectedIds);
                        next.contains(option.id)
                            ? next.remove(option.id)
                            : next.add(option.id);
                        onChanged!(next);
                      },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.klp.space.compact,
                    vertical: context.klp.space.tight,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIds.contains(option.id)
                        ? context.klpColors.selection
                        : context.klpColors.surfaceInset,
                    borderRadius: BorderRadius.circular(
                      context.klp.shape.control,
                    ),
                  ),
                  child: KlpText(
                    option.label,
                    role: KlpTextRole.caption,
                    color: selectedIds.contains(option.id)
                        ? context.klpColors.onSelection
                        : context.klpColors.text,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

typedef KlpComboBox = KlpSelectField;
typedef KlpTagField = KlpMultiSelectField;
typedef KlpSegmentedChoice = KlpSelectField;
typedef KlpTreeSelectField = KlpMultiSelectField;
