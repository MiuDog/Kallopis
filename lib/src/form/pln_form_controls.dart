import 'package:flutter/material.dart';

import '../controls/pln_text_field.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_stroke.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnTextArea extends StatelessWidget {
  const PlnTextArea({
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
    return PlnTextField(
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

class PlnNumberField extends StatelessWidget {
  const PlnNumberField({
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
    return PlnTextField(
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

class PlnPasswordField extends StatelessWidget {
  const PlnPasswordField({
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
    final tokens = context.plnTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
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
            fillColor: PlnFieldStyle.inputFill(tokens, error: error != null),
            constraints: const BoxConstraints.tightFor(
              height: PlnFormMetrics.fieldHeight,
            ),
            contentPadding: PlnInsets.control,
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: PlnSpace.xs),
          PlnText(error!, role: PlnTextRole.caption, tone: PlnTextTone.danger),
        ],
      ],
    );
  }
}

class PlnDateField extends StatelessWidget {
  const PlnDateField({
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
    return PlnTextField(
      label: label,
      initialValue: value,
      placeholder: placeholder,
      onChanged: onChanged,
    );
  }
}

typedef PlnTimeField = PlnDateField;
typedef PlnDateTimeField = PlnDateField;
typedef PlnDurationField = PlnNumberField;

@immutable
class PlnChoiceOption {
  const PlnChoiceOption({
    required this.id,
    required this.label,
    this.disabled = false,
  });

  final String id;
  final String label;
  final bool disabled;
}

class PlnSelectField extends StatefulWidget {
  const PlnSelectField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.options,
    required this.onSelected,
  });

  final String label;
  final String valueLabel;
  final List<PlnChoiceOption> options;
  final ValueChanged<String>? onSelected;

  @override
  State<PlnSelectField> createState() => _PlnSelectFieldState();
}

class _PlnSelectFieldState extends State<PlnSelectField> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(widget.label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onSelected == null
              ? null
              : () => setState(() => _expanded = !_expanded),
          child: PlnStrokeFrame(
            role: PlnStrokeRole.field,
            state: widget.onSelected == null
                ? PlnStrokeState.disabled
                : _expanded
                ? PlnStrokeState.selected
                : PlnStrokeState.rest,
            child: Container(
              height: PlnFormMetrics.fieldHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: PlnSpace.md),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(PlnRadius.control),
              ),
              child: PlnText(widget.valueLabel),
            ),
          ),
        ),
        if (_expanded) ...[
          const SizedBox(height: PlnSpace.xs),
          Container(
            padding: const EdgeInsets.all(PlnSpace.xs),
            decoration: BoxDecoration(
              color: context.plnTheme.component,
              borderRadius: BorderRadius.circular(PlnRadius.card),
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
                        minHeight: PlnFormMetrics.fieldHeight,
                      ),
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                        horizontal: PlnSpace.sm,
                      ),
                      child: PlnText(
                        option.label,
                        tone: option.disabled
                            ? PlnTextTone.faint
                            : PlnTextTone.primary,
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

class PlnMultiSelectField extends StatelessWidget {
  const PlnMultiSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
  });

  final String label;
  final List<PlnChoiceOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
        Wrap(
          spacing: PlnSpace.xs,
          runSpacing: PlnSpace.xs,
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: PlnSpace.sm,
                    vertical: PlnSpace.xs,
                  ),
                  decoration: BoxDecoration(
                    color: selectedIds.contains(option.id)
                        ? context.plnTheme.selection
                        : context.plnTheme.surfaceInset,
                    borderRadius: BorderRadius.circular(PlnRadius.control),
                  ),
                  child: PlnText(
                    option.label,
                    role: PlnTextRole.caption,
                    color: selectedIds.contains(option.id)
                        ? context.plnTheme.onSelection
                        : context.plnTheme.text,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

typedef PlnComboBox = PlnSelectField;
typedef PlnTagField = PlnMultiSelectField;
typedef PlnSegmentedChoice = PlnSelectField;
typedef PlnTreeSelectField = PlnMultiSelectField;
