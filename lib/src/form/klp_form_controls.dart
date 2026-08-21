import 'package:flutter/material.dart';

import '../controls/klp_text_field.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_stroke.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_calendar.dart';

/// 多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`，
/// 其餘外觀與行為完全繼承自 [KlpTextField]。
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

/// 數值輸入欄位，底層仍是文字輸入框（[KlpTextField]），但只在能解析成
/// [double] 且落在 [minimum]／[maximum] 範圍內時才呼叫 [onChanged]。
///
/// 超出範圍或無法解析的輸入會被直接忽略——欄位仍顯示使用者打的字，但
/// [onChanged] 不會觸發，因此外部的 `value` 不會更新。需要即時錯誤提示時
/// 請自行比較顯示字串與 [value] 是否一致，而不是依賴 [onChanged] 的呼叫時機。
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

/// 密碼規則要求項。包含檢核描述與是否滿足之狀態。
@immutable
class KlpPasswordRequirement {
  const KlpPasswordRequirement({required this.label, required this.satisfied});

  final String label;
  final bool satisfied;
}

/// 密碼輸入控制項。支援顯示／隱藏密碼切換與密碼強度／規則檢核清單。
class KlpPasswordField extends StatefulWidget {
  const KlpPasswordField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.error,
    this.onChanged,
    this.enabled = true,
    this.required = false,
    this.requirements,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool required;
  final List<KlpPasswordRequirement>? requirements;

  @override
  State<KlpPasswordField> createState() => _KlpPasswordFieldState();
}

class _KlpPasswordFieldState extends State<KlpPasswordField> {
  bool _obscured = true;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            KlpText(widget.label, role: KlpTextRole.caption),
            if (widget.required) ...[
              SizedBox(width: klp.space.tight),
              const KlpText(
                '*',
                role: KlpTextRole.caption,
                tone: KlpTextTone.danger,
              ),
            ],
          ],
        ),
        SizedBox(height: klp.space.tight),
        Material(
          type: MaterialType.transparency,
          child: TextFormField(
            initialValue: widget.value,
            obscureText: _obscured,
            enabled: widget.enabled,
            onChanged: widget.onChanged,
            style: TextStyle(
              color: tokens.text,
              fontSize: klp.type.body,
              fontFamily: klp.type.uiFamily,
              fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
            ),
            cursorColor: tokens.interaction,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.placeholder,
              hintStyle: TextStyle(color: tokens.textFaint),
              filled: true,
              fillColor: KlpFieldStyle.inputFill(
                tokens,
                error: widget.error != null,
                surface: klp.surface,
              ),
              border: KlpFieldStyle.borderFor(klp.shape),
              enabledBorder: KlpFieldStyle.borderFor(klp.shape),
              focusedBorder: KlpFieldStyle.borderFor(klp.shape),
              errorBorder: KlpFieldStyle.borderFor(klp.shape),
              focusedErrorBorder: KlpFieldStyle.borderFor(klp.shape),
              disabledBorder: KlpFieldStyle.borderFor(klp.shape),
              constraints: BoxConstraints.tightFor(
                height: klp.space.controlHeight,
              ),
              suffixIcon: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _obscured = !_obscured),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
                  child: Center(
                    widthFactor: 1,
                    child: KlpText(
                      _obscured ? 'Show' : 'Hide',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: klp.space.controlPaddingX,
                vertical: klp.space.controlPaddingY,
              ),
            ),
          ),
        ),
        if (widget.requirements != null && widget.requirements!.isNotEmpty) ...[
          SizedBox(height: klp.space.tight),
          Wrap(
            spacing: klp.space.base,
            runSpacing: klp.space.tight,
            children: [
              for (final req in widget.requirements!)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KlpText(
                      req.satisfied ? '✓ ' : '○ ',
                      role: KlpTextRole.caption,
                      tone: req.satisfied
                          ? KlpTextTone.success
                          : KlpTextTone.muted,
                    ),
                    KlpText(
                      req.label,
                      role: KlpTextRole.caption,
                      tone: req.satisfied
                          ? KlpTextTone.success
                          : KlpTextTone.muted,
                    ),
                  ],
                ),
            ],
          ),
        ],
        if (widget.error != null) ...[
          SizedBox(height: klp.space.tight),
          KlpText(
            widget.error!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.danger,
          ),
        ],
      ],
    );
  }
}

/// 標籤膠囊元件。呈現單一標籤並支援移除操作。
class KlpTagChip extends StatelessWidget {
  const KlpTagChip({super.key, required this.label, this.onRemove});

  final String label;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: klp.space.compact,
        vertical: klp.space.tight,
      ),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(klp.shape.control),
        border: Border.all(color: tokens.border, width: klp.shape.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpText(label, role: KlpTextRole.code),
          if (onRemove != null) ...[
            SizedBox(width: klp.space.tight),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onRemove,
              child: const KlpText(
                '×',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 標籤輸入與群組欄位。支援新增、移除個別標籤與清空所有標籤。
class KlpTagInputField extends StatelessWidget {
  const KlpTagInputField({
    super.key,
    required this.label,
    required this.tags,
    this.onAdd,
    this.onRemove,
    this.onClearAll,
    this.maxCount,
  });

  final String label;
  final List<String> tags;
  final VoidCallback? onAdd;
  final ValueChanged<String>? onRemove;
  final VoidCallback? onClearAll;
  final int? maxCount;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        SizedBox(height: klp.space.tight),
        Wrap(
          spacing: klp.space.tight,
          runSpacing: klp.space.tight,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tag in tags)
              KlpTagChip(
                label: tag,
                onRemove: onRemove == null ? null : () => onRemove!(tag),
              ),
            if (onAdd != null)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onAdd,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: klp.space.compact,
                    vertical: klp.space.tight,
                  ),
                  decoration: BoxDecoration(
                    color: context.klpColors.surfaceInset,
                    borderRadius: BorderRadius.circular(klp.shape.control),
                    border: Border.all(
                      color: context.klpColors.border,
                      width: klp.shape.hairline,
                    ),
                  ),
                  child: const KlpText('+ Add', role: KlpTextRole.caption),
                ),
              ),
            if (maxCount != null || onClearAll != null) ...[
              SizedBox(width: klp.space.tight),
              if (maxCount != null)
                KlpText(
                  '${tags.length}/$maxCount',
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
              if (onClearAll != null)
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onClearAll,
                  child: const KlpText(
                    ' Clear all',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ),
            ],
          ],
        ),
      ],
    );
  }
}

/// 狀態色彩角色色票組（Roles only）。只提供語意角色選擇，不提供直接色碼選擇。
class KlpStatusRoleSwatches extends StatelessWidget {
  const KlpStatusRoleSwatches({
    super.key,
    required this.label,
    this.helper,
    this.selectedRole,
    this.onSelectRole,
  });

  final String label;
  final String? helper;
  final String? selectedRole;
  final ValueChanged<String>? onSelectRole;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;

    final roles = [
      ('SUCCESS', tokens.success),
      ('DANGER', tokens.danger),
      ('WARNING', tokens.warning),
      ('INFO', tokens.info),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        if (helper != null) ...[
          SizedBox(height: klp.space.tight),
          KlpText(helper!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
        SizedBox(height: klp.space.tight),
        Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.compact,
          children: [
            for (final (name, color) in roles)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSelectRole == null ? null : () => onSelectRole!(name),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: klp.space.compact,
                      height: klp.space.compact,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(
                          klp.shape.control / 2,
                        ),
                      ),
                    ),
                    SizedBox(width: klp.space.tight),
                    KlpText(
                      name,
                      role: KlpTextRole.code,
                      tone: selectedRole == name
                          ? KlpTextTone.primary
                          : KlpTextTone.muted,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}

/// [KlpDateField] 掛上月曆挑選面板所需的設定。**這是唯一的日曆狀態來源**——
/// 月份、選取日期、停用規則全部由呼叫端持有並傳入，欄位本身不記憶任何日期。
///
/// 提供這個物件時，欄位右側會出現月曆圖示，點擊會展開 [KlpCalendar]；不提供
/// 就退化為單純文字輸入（[KlpDateField] 抽取自 Planist 時的原始行為）。
@immutable
class KlpDateFieldCalendar {
  const KlpDateFieldCalendar({
    required this.month,
    required this.monthLabel,
    required this.weekdayLabels,
    required this.previousMonthLabel,
    required this.nextMonthLabel,
    required this.onDateSelected,
    this.selectedDate,
    this.isDateDisabled,
    this.onPreviousMonth,
    this.onNextMonth,
    this.today,
  });

  /// 面板目前顯示的月份，轉發給 [KlpCalendar.month]。
  final DateTime month;
  final String monthLabel;
  final List<String> weekdayLabels;
  final String previousMonthLabel;
  final String nextMonthLabel;
  final DateTime? selectedDate;
  final DateTime? today;
  final bool Function(DateTime date)? isDateDisabled;

  /// 使用者在面板上點了某一天。欄位會在轉發這個回呼之後自行收起面板。
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback? onPreviousMonth;
  final VoidCallback? onNextMonth;
}

/// 日期輸入欄位。文字輸入永遠可用；提供 [calendar] 時額外接上 [KlpCalendar]
/// 作為挑選面板，兩套輸入路徑共用同一個文字結果，不是各自獨立的兩個元件。
class KlpDateField extends StatefulWidget {
  const KlpDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.calendar,
  });

  final String label;
  final String value;
  final ValueChanged<String>? onChanged;
  final String? placeholder;

  /// 月曆挑選面板的設定；`null` 時欄位維持純文字輸入。
  final KlpDateFieldCalendar? calendar;

  @override
  State<KlpDateField> createState() => _KlpDateFieldState();
}

class _KlpDateFieldState extends State<KlpDateField> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final calendar = widget.calendar;
    final field = KlpTextField(
      label: widget.label,
      initialValue: widget.value,
      placeholder: widget.placeholder,
      onChanged: widget.onChanged,
      readOnly: calendar != null,
      leadingIcon: calendar == null ? null : KlpIcons.calendar,
    );

    if (calendar == null) {
      return field;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() => _expanded = !_expanded),
                child: AbsorbPointer(child: field),
              ),
            ),
          ],
        ),
        if (_expanded) ...[
          SizedBox(height: context.klp.space.tight),
          KlpCalendar(
            month: calendar.month,
            monthLabel: calendar.monthLabel,
            weekdayLabels: calendar.weekdayLabels,
            previousMonthLabel: calendar.previousMonthLabel,
            nextMonthLabel: calendar.nextMonthLabel,
            selectedDate: calendar.selectedDate,
            today: calendar.today,
            isDateDisabled: calendar.isDateDisabled,
            onPreviousMonth: calendar.onPreviousMonth,
            onNextMonth: calendar.onNextMonth,
            onDateSelected: (date) {
              calendar.onDateSelected(date);
              setState(() => _expanded = false);
            },
          ),
        ],
      ],
    );
  }
}

/// [KlpSelectField]、[KlpMultiSelectField] 與 [KlpColorRoleField] 共用的
/// 選項資料：識別碼、顯示文字，以及是否停用。
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

/// 單選下拉欄位：目前值顯示為一列文字，點擊展開選項清單並就地插入版面
/// （不是彈出層），選中後自動收合。
///
/// [valueLabel] 是呼叫端算好的顯示文字，不會反查 [options] 對應哪一項——
/// 這個元件不知道「目前選的是哪個 id」，只負責畫出清單與回報點擊。
/// 需要彈出式選單而非就地展開時請改用 [KlpMenu]。
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
              height: context.klp.geometry.control.fieldHeight,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: context.klp.space.base),
              decoration: BoxDecoration(
                color: context.klpColors.clear,
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
                      constraints: BoxConstraints(
                        minHeight: context.klp.geometry.control.fieldHeight,
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

/// 多選欄位：所有選項以可切換的標籤（chip）形式平鋪展示，不像
/// [KlpSelectField] 需要展開／收合。
///
/// [selectedIds] 由呼叫端持有——這個元件本身無狀態，點擊某個選項只會透過
/// [onChanged] 回報「切換後應該是這個集合」，不會自己更新畫面。
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
