import 'package:flutter/material.dart';

import '../controls/klp_button.dart';
import '../controls/klp_text_field.dart';
import '../data/klp_advanced_data.dart';
import '../data/klp_code_viewer.dart';
import '../l10n/klp_localizations.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';
import 'klp_form_controls.dart';
import '../theme/klp_theme.dart';

/// [KlpRepeaterField] 裡的一個項目：識別碼加上該項目自己的輸入內容。
///
/// [child] 是整個項目的內容 widget（例如一組欄位），[id] 只用來在
/// [KlpRepeaterField.onRemove] 回報要刪除哪一項，與顯示內容無關。
@immutable
class KlpRepeaterItem {
  const KlpRepeaterItem({required this.id, required this.child});

  final String id;
  final Widget child;
}

/// 可新增／刪除項目的重複欄位群組（例如「新增一組聯絡方式」）。
///
/// 不維護項目清單的狀態——[items] 由呼叫端持有，新增／刪除都只是透過
/// [onAdd]／[onRemove] 回報意圖，實際要不要新增一項、刪哪一項由呼叫端決定
/// 並重新傳入新的 [items]。
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

/// [KlpKeyValueEditor] 裡的一組鍵值對，[id] 用來在清單改動時識別是哪一列
/// （純文字的 key 可能重複或暫時是空字串，不適合當識別碼）。
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

/// 任意鍵值對清單的編輯器（例如 HTTP header、環境變數），每列一個 key 輸入
/// 框與一個 value 輸入框。
///
/// 不提供新增／刪除列的按鈕——這個元件只負責編輯既有 [entries] 的內容，
/// 增減列數請自行在 [entries] 外包一層（可參考 [KlpRepeaterField] 的模式）。
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

/// 程式碼欄位：唯讀時走語法高亮的 [KlpCodeViewer]，可編輯時走純文字的
/// [KlpTextArea]。
///
/// [readOnly] 切換的是整套渲染方式而非同一個 widget 加鎖——唯讀模式沒有
/// [onChanged] 也沒有 [error] 提示，這兩者只在可編輯（[readOnly] 為 false）
/// 時才有意義。[language] 只影響唯讀模式下的語法高亮，可編輯模式不使用。
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

/// [KlpFileField] 顯示的一個已選檔案：識別碼、檔名，與選填的中繼資料文字
/// （例如檔案大小或上傳時間，顯示格式由呼叫端自行組字串）。
@immutable
class KlpFileValue {
  const KlpFileValue({required this.id, required this.name, this.metadata});

  final String id;
  final String name;
  final String? metadata;
}

/// 簡易的檔案選擇欄位：一排已選檔案的預覽卡片，加一顆選擇檔案按鈕。
///
/// 不處理實際的檔案選取或上傳邏輯——[onChoose] 只是回報「使用者按了選擇」，
/// 開檔案對話框、讀取內容、上傳進度都由呼叫端接手；需要顯示上傳進度時請改用
/// [KlpFileDropzoneField]。
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
                child: KlpText(
                  KlpLocalizations.of(context).formAddStepLabel,
                  role: KlpTextRole.caption,
                ),
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
    this.chooseButtonLabel,
    required this.files,
    this.onChoose,
    this.onRemove,
  });

  final String label;
  final String? hint;
  final String? chooseButtonLabel;
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
                  child: KlpText(
                    chooseButtonLabel ??
                        KlpLocalizations.of(context).formChooseFilesLabel,
                    role: KlpTextRole.caption,
                  ),
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

/// 從一組色彩角色（例如 semantic token 名稱）中選擇一個的下拉欄位。
///
/// 是 [KlpSelectField] 針對「選項本身就是色彩角色」這個情境的薄封裝——
/// [roles] 直接複用 [KlpChoiceOption]，實際渲染完全委派給 [KlpSelectField]。
/// 找不到 [selectedId] 對應的角色時會退回顯示 [roles] 的第一項。
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
