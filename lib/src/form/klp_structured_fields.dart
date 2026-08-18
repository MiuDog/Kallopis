import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../controls/klp_text_field.dart';
import '../data/klp_advanced_data.dart';
import '../data/klp_code_viewer.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';
import 'klp_form_controls.dart';
import '../theme/klp_theme.dart';

@immutable
class KlpRepeaterItem {
  const KlpRepeaterItem({required this.id, required this.child});

  final String id;
  final Widget child;
}

class KlpRepeaterField extends StatelessWidget {
  const KlpRepeaterField({
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
  final List<KlpRepeaterItem> items;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        for (final item in items) ...[
          KlpSurface(
            tone: KlpSurfaceTone.component,
            padding: EdgeInsets.all(context.klp.space.compact),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: item.child),
                SizedBox(width: context.klp.space.compact),
                KlpButton(
                  label: removeLabel,
                  compact: true,
                  tone: KlpButtonTone.ghost,
                  onPressed: onRemove == null ? null : () => onRemove!(item.id),
                ),
              ],
            ),
          ),
          SizedBox(height: context.klp.space.tight),
        ],
        Align(
          alignment: Alignment.centerLeft,
          child: KlpButton(label: addLabel, compact: true, onPressed: onAdd),
        ),
      ],
    );
  }
}

@immutable
class KlpKeyValueEntry {
  const KlpKeyValueEntry({
    required this.id,
    required this.keyText,
    required this.value,
  });

  final String id;
  final String keyText;
  final String value;

  KlpKeyValueEntry copyWith({String? keyText, String? value}) {
    return KlpKeyValueEntry(
      id: id,
      keyText: keyText ?? this.keyText,
      value: value ?? this.value,
    );
  }
}

class KlpKeyValueEditor extends StatelessWidget {
  const KlpKeyValueEditor({
    super.key,
    required this.label,
    required this.entries,
    required this.onChanged,
  });

  final String label;
  final List<KlpKeyValueEntry> entries;
  final ValueChanged<List<KlpKeyValueEntry>>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: context.klp.space.tight),
        for (var index = 0; index < entries.length; index++) ...[
          Row(
            children: [
              Expanded(
                child: KlpTextField(
                  initialValue: entries[index].keyText,
                  onChanged: onChanged == null
                      ? null
                      : (value) => _replace(
                          index,
                          entries[index].copyWith(keyText: value),
                        ),
                ),
              ),
              SizedBox(width: context.klp.space.tight),
              Expanded(
                child: KlpTextField(
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
          if (index < entries.length - 1)
            SizedBox(height: context.klp.space.tight),
        ],
      ],
    );
  }

  void _replace(int index, KlpKeyValueEntry entry) {
    final next = List<KlpKeyValueEntry>.from(entries)..[index] = entry;
    onChanged?.call(next);
  }
}

class KlpCodeField extends StatelessWidget {
  const KlpCodeField({
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
              KlpText(label, role: KlpTextRole.caption),
              SizedBox(height: context.klp.space.tight),
              KlpCodeViewer(code: value, language: language),
            ],
          )
        : KlpTextArea(
            label: label,
            value: value,
            error: error,
            onChanged: onChanged,
          );
  }
}

typedef KlpJsonEditorField = KlpCodeField;
typedef KlpExpressionField = KlpCodeField;

@immutable
class KlpFileValue {
  const KlpFileValue({required this.id, required this.name, this.metadata});

  final String id;
  final String name;
  final String? metadata;
}

class KlpFileField extends StatelessWidget {
  const KlpFileField({
    super.key,
    required this.label,
    required this.files,
    required this.chooseLabel,
    this.onChoose,
    this.onRemove,
  });

  final String label;
  final List<KlpFileValue> files;
  final String chooseLabel;
  final VoidCallback? onChoose;
  final ValueChanged<String>? onRemove;

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
            for (final file in files)
              KlpFilePreview(
                name: file.name,
                metadata: file.metadata ?? '',
                onPressed: onRemove == null ? null : () => onRemove!(file.id),
              ),
            KlpButton(label: chooseLabel, onPressed: onChoose),
          ],
        ),
      ],
    );
  }
}

class KlpColorRoleField extends StatelessWidget {
  const KlpColorRoleField({
    super.key,
    required this.label,
    required this.roles,
    required this.selectedId,
    required this.onSelected,
  });

  final String label;
  final List<KlpChoiceOption> roles;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSelectField(
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
