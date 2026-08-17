import 'package:flutter/widgets.dart';

import '../controls/pln_button.dart';
import '../controls/pln_text_field.dart';
import '../data/pln_advanced_data.dart';
import '../data/pln_code_viewer.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';
import 'pln_form_controls.dart';

@immutable
class PlnRepeaterItem {
  const PlnRepeaterItem({required this.id, required this.child});

  final String id;
  final Widget child;
}

class PlnRepeaterField extends StatelessWidget {
  const PlnRepeaterField({
    super.key,
    required this.label,
    required this.addLabel,
    required this.removeLabel,
    required this.items,
    required this.onAdd,
    required this.onRemove,
  });

  final String label;
  final String addLabel;
  final String removeLabel;
  final List<PlnRepeaterItem> items;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
        for (final item in items) ...[
          PlnSurface(
            tone: PlnSurfaceTone.component,
            padding: const EdgeInsets.all(PlnSpace.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: item.child),
                const SizedBox(width: PlnSpace.sm),
                PlnButton(
                  label: removeLabel,
                  compact: true,
                  tone: PlnButtonTone.ghost,
                  onPressed: onRemove == null ? null : () => onRemove!(item.id),
                ),
              ],
            ),
          ),
          const SizedBox(height: PlnSpace.xs),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: PlnButton(label: addLabel, compact: true, onPressed: onAdd),
        ),
      ],
    );
  }
}

@immutable
class PlnKeyValueEntry {
  const PlnKeyValueEntry({
    required this.id,
    required this.keyText,
    required this.value,
  });

  final String id;
  final String keyText;
  final String value;

  PlnKeyValueEntry copyWith({String? keyText, String? value}) {
    return PlnKeyValueEntry(
      id: id,
      keyText: keyText ?? this.keyText,
      value: value ?? this.value,
    );
  }
}

class PlnKeyValueEditor extends StatelessWidget {
  const PlnKeyValueEditor({
    super.key,
    required this.label,
    required this.entries,
    required this.onChanged,
  });

  final String label;
  final List<PlnKeyValueEntry> entries;
  final ValueChanged<List<PlnKeyValueEntry>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlnText(label, role: PlnTextRole.caption),
        const SizedBox(height: PlnSpace.xs),
        for (var index = 0; index < entries.length; index++) ...[
          Row(
            children: [
              Expanded(
                child: PlnTextField(
                  initialValue: entries[index].keyText,
                  onChanged: onChanged == null
                      ? null
                      : (value) => _replace(
                          index,
                          entries[index].copyWith(keyText: value),
                        ),
                ),
              ),
              const SizedBox(width: PlnSpace.xs),
              Expanded(
                child: PlnTextField(
                  initialValue: entries[index].value,
                  onChanged: onChanged == null
                      ? null
                      : (value) => _replace(
                          index,
                          entries[index].copyWith(value: value),
                        ),
                ),
              ),
            ],
          ),
          if (index < entries.length - 1) const SizedBox(height: PlnSpace.xs),
        ],
      ],
    );
  }

  void _replace(int index, PlnKeyValueEntry entry) {
    final next = List<PlnKeyValueEntry>.from(entries)..[index] = entry;
    onChanged?.call(next);
  }
}

class PlnCodeField extends StatelessWidget {
  const PlnCodeField({
    super.key,
    required this.label,
    required this.value,
    this.language,
    this.onChanged,
    this.readOnly = false,
    this.error,
  });

  final String label;
  final String value;
  final String? language;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return readOnly
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PlnText(label, role: PlnTextRole.caption),
              const SizedBox(height: PlnSpace.xs),
              PlnCodeViewer(code: value, language: language),
            ],
          )
        : PlnTextArea(
            label: label,
            value: value,
            error: error,
            onChanged: onChanged,
          );
  }
}

typedef PlnJsonEditorField = PlnCodeField;
typedef PlnExpressionField = PlnCodeField;

@immutable
class PlnFileValue {
  const PlnFileValue({required this.id, required this.name, this.metadata});

  final String id;
  final String name;
  final String? metadata;
}

class PlnFileField extends StatelessWidget {
  const PlnFileField({
    super.key,
    required this.label,
    required this.files,
    required this.chooseLabel,
    this.onChoose,
    this.onRemove,
  });

  final String label;
  final List<PlnFileValue> files;
  final String chooseLabel;
  final VoidCallback? onChoose;
  final ValueChanged<String>? onRemove;

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
            for (final file in files)
              PlnFilePreview(
                name: file.name,
                metadata: file.metadata ?? '',
                onPressed: onRemove == null ? null : () => onRemove!(file.id),
              ),
            PlnButton(label: chooseLabel, onPressed: onChoose),
          ],
        ),
      ],
    );
  }
}

class PlnColorRoleField extends StatelessWidget {
  const PlnColorRoleField({
    super.key,
    required this.label,
    required this.roles,
    required this.selectedId,
    required this.onSelected,
  });

  final String label;
  final List<PlnChoiceOption> roles;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return PlnSelectField(
      label: label,
      valueLabel: roles
          .firstWhere(
            (role) => role.id == selectedId,
            orElse: () => roles.first,
          )
          .label,
      options: roles,
      onSelected: onSelected,
    );
  }
}
