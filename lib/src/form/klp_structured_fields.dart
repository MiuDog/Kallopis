import 'package:flutter/material.dart';

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

/// 審批步驟資料。
@immutable
class KlpApprovalStepData {
  const KlpApprovalStepData({required this.id, required this.roleLabel});

  final String id;
  final String roleLabel;
}

/// 審批步驟排序欄位。支援步驟上下移動、刪除與新增。
class KlpApprovalStepsField extends StatelessWidget {
  const KlpApprovalStepsField({
    super.key,
    required this.label,
    this.subtitle,
    required this.steps,
    this.onAddStep,
    this.onMoveUp,
    this.onMoveDown,
    this.onRemove,
    this.maxSteps,
  });

  final String label;
  final String? subtitle;
  final List<KlpApprovalStepData> steps;
  final VoidCallback? onAddStep;
  final ValueChanged<int>? onMoveUp;
  final ValueChanged<int>? onMoveDown;
  final ValueChanged<int>? onRemove;
  final int? maxSteps;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        if (subtitle != null) ...[
          SizedBox(height: klp.space.tight),
          KlpText(
            subtitle!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
        SizedBox(height: klp.space.tight),
        for (var index = 0; index < steps.length; index++) ...[
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: klp.space.compact,
              vertical: klp.space.tight,
            ),
            decoration: BoxDecoration(
              color: tokens.surfaceInset,
              borderRadius: BorderRadius.circular(klp.shape.control),
              border: Border.all(
                color: tokens.border,
                width: klp.shape.hairline,
              ),
            ),
            child: Row(
              children: [
                KlpText(
                  '${index + 1}',
                  role: KlpTextRole.code,
                  tone: KlpTextTone.muted,
                ),
                SizedBox(width: klp.space.compact),
                Expanded(
                  child: Container(
                    height: klp.space.controlHeightSmall,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(
                      horizontal: klp.space.compact,
                    ),
                    decoration: BoxDecoration(
                      color: tokens.component,
                      borderRadius: BorderRadius.circular(klp.shape.control),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KlpText(steps[index].roleLabel),
                        const KlpText(
                          '⌄',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: klp.space.compact),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onMoveUp == null ? null : () => onMoveUp!(index),
                  child: Padding(
                    padding: EdgeInsets.all(klp.space.tight),
                    child: const KlpText(
                      '⌃',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onMoveDown == null ? null : () => onMoveDown!(index),
                  child: Padding(
                    padding: EdgeInsets.all(klp.space.tight),
                    child: const KlpText(
                      '⌄',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onRemove == null ? null : () => onRemove!(index),
                  child: Padding(
                    padding: EdgeInsets.all(klp.space.tight),
                    child: const KlpText(
                      '×',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: klp.space.tight),
        ],
        Row(
          children: [
            if (onAddStep != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onAddStep,
                child: const KlpText('+ Add step', role: KlpTextRole.caption),
              ),
            if (maxSteps != null) ...[
              SizedBox(width: klp.space.compact),
              KlpText(
                '${steps.length}/$maxSteps',
                role: KlpTextRole.caption,
                tone: KlpTextTone.faint,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

/// 檔案附件資料。包含檔名、檔案大小與可選的上傳進度 (0.0~1.0)。
@immutable
class KlpFileAttachment {
  const KlpFileAttachment({
    required this.name,
    required this.size,
    this.progress,
  });

  final String name;
  final String size;
  final double? progress;
}

/// 檔案上傳拖曳區與附件清單元件。
class KlpFileDropzoneField extends StatelessWidget {
  const KlpFileDropzoneField({
    super.key,
    required this.label,
    this.hint,
    this.chooseButtonLabel = 'Choose files',
    required this.files,
    this.onChoose,
    this.onRemove,
  });

  final String label;
  final String? hint;
  final String chooseButtonLabel;
  final List<KlpFileAttachment> files;
  final VoidCallback? onChoose;
  final ValueChanged<int>? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: klp.space.tight),
        Container(
          padding: EdgeInsets.all(klp.space.base),
          decoration: BoxDecoration(
            color: tokens.surfaceInset,
            borderRadius: BorderRadius.circular(klp.shape.card),
            border: Border.all(color: tokens.border, width: klp.shape.hairline),
          ),
          child: Column(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onChoose,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: klp.space.base,
                    vertical: klp.space.compact,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.component,
                    borderRadius: BorderRadius.circular(klp.shape.control),
                    border: Border.all(
                      color: tokens.border,
                      width: klp.shape.hairline,
                    ),
                  ),
                  child: KlpText(chooseButtonLabel, role: KlpTextRole.caption),
                ),
              ),
              if (hint != null) ...[
                SizedBox(height: klp.space.tight),
                KlpText(
                  hint!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
            ],
          ),
        ),
        if (files.isNotEmpty) ...[
          SizedBox(height: klp.space.tight),
          for (var index = 0; index < files.length; index++) ...[
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: klp.space.base,
                vertical: klp.space.compact,
              ),
              decoration: BoxDecoration(
                color: tokens.surfaceInset,
                borderRadius: BorderRadius.circular(klp.shape.control),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: KlpText(
                          files[index].name,
                          role: KlpTextRole.code,
                        ),
                      ),
                      KlpText(
                        files[index].size,
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(width: klp.space.compact),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onRemove == null ? null : () => onRemove!(index),
                        child: const KlpText(
                          '×',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ),
                    ],
                  ),
                  if (files[index].progress != null) ...[
                    SizedBox(height: klp.space.tight),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              klp.shape.control,
                            ),
                            child: Container(
                              height: klp.shape.stroke,
                              color: tokens.border,
                              alignment: Alignment.centerLeft,
                              child: FractionallySizedBox(
                                widthFactor: files[index].progress,
                                child: Container(color: tokens.interaction),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: klp.space.compact),
                        KlpText(
                          '${(files[index].progress! * 100).toInt()}%',
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.muted,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (index < files.length - 1) SizedBox(height: klp.space.tight),
          ],
        ],
      ],
    );
  }
}

/// 結構化設定與程式碼編輯器欄位。支援頂部動作列、行內錯誤／警告提示與底部運算式動作列。
class KlpCodeEditorField extends StatelessWidget {
  const KlpCodeEditorField({
    super.key,
    required this.label,
    this.subtitle,
    this.actions,
    required this.code,
    this.error,
    this.warning,
    this.footerLeft,
    this.footerRight,
  });

  final String label;
  final String? subtitle;
  final List<String>? actions;
  final String code;
  final String? error;
  final String? warning;
  final Widget? footerLeft;
  final Widget? footerRight;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                KlpText(label, role: KlpTextRole.caption),
                if (subtitle != null) ...[
                  SizedBox(width: klp.space.compact),
                  KlpText(
                    subtitle!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ],
            ),
            if (actions != null)
              Row(
                children: [
                  for (final action in actions!) ...[
                    Padding(
                      padding: EdgeInsets.only(left: klp.space.compact),
                      child: KlpText(action, role: KlpTextRole.caption),
                    ),
                  ],
                ],
              ),
          ],
        ),
        SizedBox(height: klp.space.tight),
        Container(
          padding: EdgeInsets.all(klp.space.base),
          decoration: BoxDecoration(
            color: tokens.surfaceInset,
            borderRadius: BorderRadius.circular(klp.shape.card),
            border: Border.all(color: tokens.border, width: klp.shape.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KlpText(code, role: KlpTextRole.code),
              if (footerLeft != null || footerRight != null) ...[
                SizedBox(height: klp.space.base),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: klp.space.compact,
                    vertical: klp.space.tight,
                  ),
                  decoration: BoxDecoration(
                    color: tokens.component,
                    borderRadius: BorderRadius.circular(klp.shape.control),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      footerLeft ?? const SizedBox.shrink(),
                      footerRight ?? const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        if (error != null) ...[
          SizedBox(height: klp.space.tight),
          KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
        ],
        if (warning != null) ...[
          SizedBox(height: klp.space.tight),
          KlpText(warning!, role: KlpTextRole.caption, color: tokens.warning),
        ],
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
