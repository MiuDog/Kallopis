import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final formControlsPage = CatalogPageData(
  label: 'Form Controls',
  title: '表單控制項',
  description: '單一輸入與純量控制項。它們不知道自己在哪個表單裡，也不負責驗證。',
  icon: KlpIcons.edit,
  specimens: [
    Specimen(
      name: 'KlpTextField',
      note: '單行或多行文字輸入。支援清除按鈕、計數器、單位與數值步進器 (Stepper)。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpField(
              label: 'Node name',
              required: true,
              description:
                  'Lowercase, hyphen separated. Used as the node\'s stable reference.',
              counter: '15/48',
              child: const KlpTextField(
                initialValue: 'validate-schema',
                clearable: true,
              ),
            ),
            SizedBox(height: klp.space.base),
            KlpField(
              label: 'Slug',
              required: true,
              error: 'Another node already uses this slug.',
              errorCode: 'ERR_SLUG_TAKEN',
              child: const KlpTextField(initialValue: 'validate-schema'),
            ),
            SizedBox(height: klp.space.base),
            KlpField(
              label: 'Owner',
              requirement: 'optional',
              status: 'Validating..',
              child: const KlpTextField(initialValue: 'kevin@pianist.dev'),
            ),
            SizedBox(height: klp.space.base),
            KlpField(
              label: 'Retention',
              status: 'Changed elsewhere – review before saving',
              child: const KlpTextField(
                initialValue: '30',
                suffixText: 'days',
                stepper: true,
                conflict: true,
              ),
            ),
            SizedBox(height: klp.space.base),
            KlpField(
              label: 'Locked setting',
              requirement: 'conditional',
              child: const KlpTextField(
                initialValue: 'inherited from workspace',
                enabled: false,
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpTextArea',
      note: '多行輸入（含說明與字數上限計數器）。',
      build: (context) => const KlpField(
        label: 'Description',
        counter: '71/280',
        child: KlpTextArea(
          value:
              'Checks node payloads against node.schema.json before a run is accepted.',
        ),
      ),
    ),
    Specimen(
      name: 'KlpNumberField',
      note: '數值輸入（含單位與步進器）。',
      build: (context) => const KlpField(
        label: 'Timeout',
        child: KlpTextField(
          initialValue: '800',
          suffixText: 'ms',
          stepper: true,
        ),
      ),
    ),
    Specimen(
      name: 'KlpPasswordField',
      note: '密碼輸入（支援 Show/Hide 切換與要求檢核清單）。',
      build: (context) => const KlpPasswordField(
        label: 'Signing secret',
        required: true,
        value: 'correct horse battery staple',
        requirements: [
          KlpPasswordRequirement(label: '12+ chars', satisfied: true),
          KlpPasswordRequirement(label: 'has digit', satisfied: true),
        ],
      ),
    ),
    Specimen(
      name: 'KlpSlider',
      note: '連續數值滑桿（含即時數值與刻度標籤）。',
      build: (context) {
        var sliderVal = 0.7;
        return StatefulBuilder(
          builder: (context, setState) => KlpSlider(
            label: 'Temperature',
            value: sliderVal,
            displayValue: sliderVal.toStringAsFixed(1),
            marks: const ['precise', 'balanced', 'creative'],
            onChanged: (v) => setState(() => sliderVal = v),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpPhaseToggle',
      note: '階段與多態切換按鈕組（邊框軌道、正方形分段，寬度隨選項數量延展）。',
      build: (context) {
        final klp = context.klp;
        var twoPhase = 'check';
        var threePhase = 'slash';
        var fivePhase = 3;

        return StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KlpText(
                'TWO-PHASE',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              KlpPhaseToggle<String>(
                options: const [
                  KlpPhaseOption(
                    value: 'x',
                    icon: KlpIcons.x,
                    activeTone: KlpFeedbackTone.danger,
                  ),
                  KlpPhaseOption(
                    value: 'check',
                    icon: KlpIcons.check,
                    activeTone: KlpFeedbackTone.success,
                  ),
                ],
                selected: twoPhase,
                onSelected: (v) => setState(() => twoPhase = v),
              ),
              SizedBox(height: klp.space.base),
              const KlpText(
                'THREE-PHASE',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              KlpPhaseToggle<String>(
                options: const [
                  KlpPhaseOption(
                    value: 'x',
                    icon: KlpIcons.x,
                    activeTone: KlpFeedbackTone.danger,
                  ),
                  KlpPhaseOption(
                    value: 'slash',
                    label: '/',
                    activeTone: KlpFeedbackTone.neutral,
                  ),
                  KlpPhaseOption(
                    value: 'check',
                    icon: KlpIcons.check,
                    activeTone: KlpFeedbackTone.success,
                  ),
                ],
                selected: threePhase,
                onSelected: (v) => setState(() => threePhase = v),
              ),
              SizedBox(height: klp.space.base),
              const KlpText(
                'SINGLE CHOICE - 5 OPTIONS',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              KlpPhaseToggle<int>(
                options: const [
                  KlpPhaseOption(value: 1, label: '1'),
                  KlpPhaseOption(value: 2, label: '2'),
                  KlpPhaseOption(value: 3, label: '3'),
                  KlpPhaseOption(value: 4, label: '4'),
                  KlpPhaseOption(
                    value: 5,
                    label: '5',
                    activeTone: KlpFeedbackTone.danger,
                  ),
                ],
                selected: fivePhase,
                onSelected: (v) => setState(() => fivePhase = v),
              ),
              SizedBox(height: klp.space.base),
              const KlpText(
                'DISABLED',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              const KlpPhaseToggle<String>(
                options: [
                  KlpPhaseOption(
                    value: 'x',
                    icon: KlpIcons.x,
                    activeTone: KlpFeedbackTone.danger,
                  ),
                  KlpPhaseOption(
                    value: 'slash',
                    label: '/',
                    activeTone: KlpFeedbackTone.neutral,
                  ),
                  KlpPhaseOption(
                    value: 'check',
                    icon: KlpIcons.check,
                    activeTone: KlpFeedbackTone.success,
                  ),
                ],
                selected: 'x',
                enabled: false,
              ),
            ],
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpRadioGroup',
      note: '單選按鈕群組（支援直排與選項描述）。',
      build: (context) {
        var radioVal = 'strict';
        return StatefulBuilder(
          builder: (context, setState) => KlpField(
            label: 'Validation mode',
            error: 'Choose how strictly payloads are checked.',
            child: KlpRadioGroup<String>(
              vertical: true,
              value: radioVal,
              items: const {
                'strict': 'Strict',
                'lenient': 'Lenient',
                'off': 'Off',
              },
              descriptions: const {
                'strict': 'Reject any unknown field.',
                'lenient': 'Warn but allow unknown fields.',
              },
              onChanged: (v) => setState(() => radioVal = v),
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpDateField',
      note: '日期輸入。提供 calendar 設定時會接上 KlpCalendar 挑選面板；不提供時退化為純文字輸入。',
      build: (context) => KlpDateField(
        label: '截止日',
        value: '2026-08-18',
        onChanged: (_) {},
        calendar: KlpDateFieldCalendar(
          month: DateTime(2026, 8),
          monthLabel: '2026 年 8 月',
          weekdayLabels: const ['一', '二', '三', '四', '五', '六', '日'],
          previousMonthLabel: '上個月',
          nextMonthLabel: '下個月',
          selectedDate: DateTime(2026, 8, 18),
          onDateSelected: (_) {},
        ),
      ),
    ),
    Specimen(
      name: 'KlpCalendar',
      note: '月曆面板：月份切換、日期格、今天標記、選取狀態、可停用特定日期。不內建語言字串。',
      build: (context) => KlpCalendar(
        month: DateTime(2026, 8),
        monthLabel: '2026 年 8 月',
        weekdayLabels: const ['一', '二', '三', '四', '五', '六', '日'],
        previousMonthLabel: '上個月',
        nextMonthLabel: '下個月',
        today: DateTime(2026, 8, 19),
        selectedDate: DateTime(2026, 8, 5),
        isDateDisabled: (date) => date.day == 25,
        onDateSelected: (_) {},
        onPreviousMonth: () {},
        onNextMonth: () {},
      ),
    ),
    Specimen(
      name: 'KlpCombobox',
      note: '可輸入的下拉選單。輸入框重用 KlpTextField，下拉面板重用 KlpMenu；'
          '↓／↑ 導覽、Enter 選定。',
      build: (context) => KlpCombobox(
        label: '負責人',
        query: '',
        menuLabel: '成員',
        options: const [
          KlpComboboxOption(id: 'a', label: 'Chiayu'),
          KlpComboboxOption(id: 'b', label: 'Dog'),
          KlpComboboxOption(id: 'c', label: 'Miu'),
        ],
        onQueryChanged: (_) {},
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpCheckbox',
      note: '核取方塊群組。',
      build: (context) {
        final klp = context.klp;
        final selected = <String>{'Pages'};
        return StatefulBuilder(
          builder: (context, setState) => KlpField(
            label: 'Scope',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: klp.space.base,
                  children: [
                    KlpCheckbox(
                      value: selected.contains('Pages'),
                      label: 'Pages',
                      onChanged: (v) => setState(() {
                        if (v) {
                          selected.add('Pages');
                        } else {
                          selected.remove('Pages');
                        }
                      }),
                    ),
                    KlpCheckbox(
                      value: selected.contains('Assets'),
                      label: 'Assets',
                      onChanged: (v) => setState(() {
                        if (v) {
                          selected.add('Assets');
                        } else {
                          selected.remove('Assets');
                        }
                      }),
                    ),
                    KlpCheckbox(
                      value: selected.contains('Workflows'),
                      label: 'Workflows',
                      onChanged: (v) => setState(() {
                        if (v) {
                          selected.add('Workflows');
                        } else {
                          selected.remove('Workflows');
                        }
                      }),
                    ),
                  ],
                ),
                SizedBox(height: klp.space.tight),
                KlpCheckbox(
                  value: selected.contains('Audit'),
                  label: 'Audit',
                  onChanged: (v) => setState(() {
                    if (v) {
                      selected.add('Audit');
                    } else {
                      selected.remove('Audit');
                    }
                  }),
                ),
              ],
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpDateField',
      note: '日期與時間選擇輸入。',
      build: (context) {
        final klp = context.klp;
        return KlpField(
          label: 'Scheduled start',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 140,
                    child: KlpTextField(initialValue: '2026/08/14'),
                  ),
                  SizedBox(width: klp.space.compact),
                  KlpIcon(
                    KlpIcons.calendar,
                    color: context.klpColors.textMuted,
                  ),
                  SizedBox(width: klp.space.base),
                  KlpIcon(
                    KlpIcons.telescope,
                    color: context.klpColors.textMuted,
                  ),
                  SizedBox(width: klp.space.tight),
                  const KlpText(
                    'Asia/Taipei',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ),
              SizedBox(height: klp.space.tight),
              const KlpText(
                'Clear',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
            ],
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpToggle',
      note: '開關群組（Notifications）。',
      build: (context) {
        final klp = context.klp;
        var notifyFailure = true;
        var autoRetry = false;
        return StatefulBuilder(
          builder: (context, setState) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const KlpText('Notifications', role: KlpTextRole.caption),
              const KlpText(
                'Applied immediately.',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              KlpToggle(
                value: notifyFailure,
                label: 'Notify on failure',
                onChanged: (v) => setState(() => notifyFailure = v),
              ),
              const KlpText(
                '  Posts to the room when a run fails.',
                role: KlpTextRole.caption,
                tone: KlpTextTone.muted,
              ),
              SizedBox(height: klp.space.tight),
              Row(
                children: [
                  KlpToggle(
                    value: autoRetry,
                    label: 'Auto-retry',
                    onChanged: (v) => setState(() => autoRetry = v),
                  ),
                  SizedBox(width: klp.space.compact),
                  const KlpText(
                    'saving..',
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                ],
              ),
              SizedBox(height: klp.space.tight),
              const KlpToggle(
                value: false,
                label: 'Escalate to on-call',
                onChanged: null,
              ),
            ],
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpSegmentedControl',
      note: '分段選擇（Run mode）。',
      build: (context) {
        var selectedIdx = 1;
        return StatefulBuilder(
          builder: (context, setState) => KlpField(
            label: 'Run mode',
            child: Align(
              alignment: Alignment.centerLeft,
              child: KlpSegmentedControl(
                items: const ['Auto', 'Review', 'Manual'],
                selected: selectedIdx,
                onSelected: (v) => setState(() => selectedIdx = v),
              ),
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpTagInputField',
      note: '標籤輸入與頻道清單（Notify channels & Tags）。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const KlpTagInputField(
              label: 'Notify channels',
              tags: ['#eng-alerts'],
              maxCount: 3,
            ),
            SizedBox(height: klp.space.base),
            const KlpTagInputField(label: 'Tags', tags: ['schema', 'ci']),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpStatusRoleSwatches',
      note: '色彩角色選擇（Roles only — raw hex is intentionally not offered）。',
      build: (context) {
        var selected = 'success';
        return StatefulBuilder(
          builder: (context, setState) => KlpStatusRoleSwatches(
            label: 'Status color role',
            helper: 'Roles only — raw hex is intentionally not offered.',
            selectedRole: selected,
            onSelectRole: (role) => setState(() => selected = role),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpCompactSwitch',
      note: '緊湊版開關，用於清單列。',
      build: (context) {
        var val = false;
        return StatefulBuilder(
          builder: (context, setState) => KlpCompactSwitch(
            value: val,
            label: '顯示隱藏檔',
            onChanged: (v) => setState(() => val = v),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpTriStateToggle',
      note: '三態：開、關、未決定。',
      build: (context) {
        var state = KlpTriState.mixed;
        return StatefulBuilder(
          builder: (context, setState) => KlpTriStateToggle(
            value: state,
            label: '部分選取',
            onChanged: (v) => setState(() => state = v),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpToggleIndicator',
      note: '只有指示器，沒有互動——用於唯讀狀態的呈現。',
      build: (context) => const KlpToggleIndicator(value: true),
    ),
    Specimen(
      name: 'KlpSlidingSelection',
      note: '滑動式選擇，用於少量互斥選項。',
      build: (context) {
        final tokens = context.klpColors;
        var selectedIdx = 1;
        return StatefulBuilder(
          builder: (context, setState) => KlpSlidingSelection(
            label: '檢視模式',
            selectedIndex: selectedIdx,
            options: [
              KlpSelectionOption(icon: KlpIcons.grid, color: tokens.info),
              KlpSelectionOption(
                icon: KlpIcons.container,
                color: tokens.interaction,
              ),
            ],
            onSelected: (idx) => setState(() => selectedIdx = idx),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpSelect',
      note: '下拉觸發器。它只顯示目前的值並觸發 onPressed，選單本身由呼叫端開。',
      build: (context) =>
          KlpSelect(label: '排序', value: '最近修改', onPressed: () {}),
    ),
    Specimen(
      name: 'KlpCodeField',
      note: '程式碼輸入。',
      build: (context) => const KlpCodeField(label: '運算式', value: 'count > 0'),
    ),
    Specimen(
      name: 'KlpFileField',
      note: '檔案選擇。',
      build: (context) => const KlpFileField(
        label: '附件',
        chooseLabel: '選擇檔案',
        files: [KlpFileValue(id: 'a', name: 'spec.md')],
      ),
    ),
    Specimen(
      name: 'KlpColorRoleField',
      note: '色彩角色選擇。**選的是角色不是色碼**——直接選色會繞過整個 token 架構。',
      build: (context) {
        var selected = 'accent';
        return StatefulBuilder(
          builder: (context, setState) => KlpColorRoleField(
            label: '強調色',
            roles: const [
              KlpChoiceOption(id: 'accent', label: 'accent'),
              KlpChoiceOption(id: 'success', label: 'success'),
              KlpChoiceOption(id: 'danger', label: 'danger'),
            ],
            selectedId: selected,
            onSelected: (id) => setState(() => selected = id),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpTagChip',
      note: '標籤膠囊單元。',
      build: (context) => const KlpTagChip(label: '#eng-alerts'),
    ),
  ],
);

final formAssemblyPage = CatalogPageData(
  label: 'Form Assembly & Pickers',
  title: '表單組裝與挑選器',
  description: '把控制項組成表單，以及從既有資料裡挑一個出來。',
  icon: KlpIcons.clipboard,
  specimens: [
    Specimen(
      name: 'KlpForm',
      note: '表單的最外層，由 section 組成。',
      build: (context) => KlpForm(
        sections: [
          KlpFormSection(
            title: '基本資訊',
            children: [
              const KlpTextField(label: '名稱'),
              const KlpTextField(label: '描述'),
            ],
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpFormSection',
      note: '表單的一個分段。',
      build: (context) => const KlpFormSection(
        title: '進階',
        children: [KlpTextField(label: '路徑')],
      ),
    ),
    Specimen(
      name: 'KlpField',
      note: '單一欄位的外框：標籤、說明、錯誤。',
      build: (context) => const KlpField(
        label: '名稱',
        description: '會出現在所有產品裡',
        child: KlpTextField(),
      ),
    ),
    Specimen(
      name: 'KlpFieldLabel',
      note: '欄位標籤。',
      build: (context) => const KlpFieldLabel(label: '名稱'),
    ),
    Specimen(
      name: 'KlpFieldDescription',
      note: '欄位說明。',
      build: (context) =>
          const KlpFieldDescription(description: '這個值會寫進 spec。'),
    ),
    Specimen(
      name: 'KlpFieldError',
      note: '欄位錯誤訊息。',
      build: (context) => const KlpFieldError(error: '不可以留空'),
    ),
    Specimen(
      name: 'KlpFieldGroup',
      note: '一組相關欄位。',
      build: (context) => const KlpFieldGroup(
        legend: '尺寸',
        children: [
          KlpTextField(label: '寬'),
          KlpTextField(label: '高'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpFormActions',
      note: '送出與取消。',
      build: (context) =>
          KlpFormActions(submitLabel: '儲存', onSubmit: () {}, cancelLabel: '取消'),
    ),
    Specimen(
      name: 'KlpFormErrorSummary',
      note: '表單頂部的錯誤彙總。',
      build: (context) => const KlpFormErrorSummary(
        title: '有 2 個欄位需要修正',
        errors: {'name': '名稱不可留空', 'path': '路徑格式不正確'},
      ),
    ),
    Specimen(
      name: 'KlpConditionalFieldRegion',
      note: '依條件顯示的欄位區。動畫時長取自 theme。',
      build: (context) => const KlpConditionalFieldRegion(
        visible: true,
        child: KlpTextField(label: '只在勾選時出現'),
      ),
    ),
    Specimen(
      name: 'KlpRepeaterField',
      note: '可增減的重複欄位。',
      build: (context) => KlpRepeaterField(
        label: '標籤',
        addLabel: '新增',
        removeLabel: '移除',
        items: [
          KlpRepeaterItem(id: '1', child: const KlpTextField()),
          KlpRepeaterItem(id: '2', child: const KlpTextField()),
        ],
        onAdd: () {},
        onRemove: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpKeyValueEditor',
      note: '環境變數與鍵值對編輯（含重名衝突提示與計數器）。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpKeyValueEditor(
              label: 'Environment variables',
              entries: const [
                KlpKeyValueEntry(
                  id: '1',
                  keyText: 'API_BASE',
                  value: 'https://api.internal',
                ),
                KlpKeyValueEntry(
                  id: '2',
                  keyText: 'API_BASE',
                  value: 'https://api.dev',
                ),
              ],
              onChanged: (_) {},
            ),
            SizedBox(height: klp.space.tight),
            const KlpText(
              'Duplicate key – the later entry wins',
              role: KlpTextRole.caption,
              tone: KlpTextTone.danger,
            ),
            SizedBox(height: klp.space.tight),
            Row(
              children: [
                const KlpText('+ Add pair', role: KlpTextRole.caption),
                SizedBox(width: klp.space.compact),
                const KlpText(
                  '2/32',
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.faint,
                ),
              ],
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpApprovalStepsField',
      note: '審批流程順序控制項（Items keep a stable ID across reorder）。',
      build: (context) => KlpApprovalStepsField(
        label: 'Approval steps',
        subtitle: 'Items keep a stable ID across reorder.',
        steps: const [
          KlpApprovalStepData(id: '1', roleLabel: 'Any maintainer'),
          KlpApprovalStepData(id: '2', roleLabel: 'Any maintainer'),
        ],
        maxSteps: 4,
        onAddStep: () {},
        onMoveUp: (_) {},
        onMoveDown: (_) {},
        onRemove: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpFileDropzoneField',
      note: '檔案上傳拖曳區與附件清單（含上傳進度條）。',
      build: (context) => KlpFileDropzoneField(
        label: 'Fixtures',
        hint: 'JSON or CSV · max 10 MB each',
        files: const [
          KlpFileAttachment(name: 'fixtures.json', size: '12 KB'),
          KlpFileAttachment(name: 'trace.bin', size: '8.2 MB', progress: 0.45),
        ],
        onChoose: () {},
        onRemove: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpCodeEditorField',
      note: '結構化設定與程式碼編輯器（含頂部動作列與行內錯誤／警告提示）。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const KlpCodeEditorField(
              label: 'Node config',
              subtitle: 'node.schema.json · draft-07',
              actions: ['Format', 'Validate'],
              code: '{\n  "strict": true,\n  "maxDepth": 4\n}',
              error: '3:14 maxDepth exceeds the workspace limit of 3',
            ),
            SizedBox(height: klp.space.comfortable),
            const KlpCodeEditorField(
              label: 'Gate condition',
              subtitle: 'Evaluated after the upstream node completes.',
              code: '{{ node.validate.output.ok }} == true',
              footerLeft: KlpText(
                'Insert reference',
                role: KlpTextRole.caption,
              ),
              footerRight: KlpText(
                'Evaluate -> true',
                role: KlpTextRole.caption,
              ),
            ),
            SizedBox(height: klp.space.comfortable),
            const KlpCodeEditorField(
              label: 'Transform',
              subtitle: 'JQ',
              actions: ['Format'],
              code: '.results\n| map(select(.ok))\n| length',
              warning: 'line 2: select/1 is allowed in the restricted profile',
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpSelectField',
      note: '下拉選擇欄位。',
      build: (context) => KlpSelectField(
        label: '狀態',
        valueLabel: '進行中',
        options: const [
          KlpChoiceOption(id: 'open', label: '進行中'),
          KlpChoiceOption(id: 'done', label: '已完成'),
        ],
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpMultiSelectField',
      note: '多選欄位。',
      build: (context) => KlpMultiSelectField(
        label: '標籤',
        options: const [
          KlpChoiceOption(id: 'a', label: 'design'),
          KlpChoiceOption(id: 'b', label: 'token'),
        ],
        selectedIds: const {'a'},
        onChanged: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpReferencePicker',
      note: '引用另一筆資料。搜尋與結果由呼叫端提供。',
      build: (context) => KlpReferencePicker(
        title: '連結到',
        query: '',
        queryPlaceholder: '搜尋…',
        results: const [
          KlpReferenceOption(id: '1', label: 'ADR-0001'),
          KlpReferenceOption(id: '2', label: 'ADR-0002'),
        ],
        onQueryChanged: (_) {},
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpEntityPicker',
      note: '挑選實體。與 KlpReferencePicker 功能重疊，待合併。',
      build: (context) => KlpEntityPicker(
        title: '選擇項目',
        initialQuery: '',
        results: const [KlpEntityResultData(kind: 'spec', label: 'ADR-0001')],
        onQueryChanged: (_) {},
        onClear: () {},
        onApply: () {},
      ),
    ),
    Specimen(
      name: 'KlpPageChrome',
      note: '頁面的標題區：麵包屑與標題。',
      build: (context) =>
          const KlpPageChrome(breadcrumb: ['專案', '設定'], title: '一般'),
    ),
    Specimen(
      name: 'KlpPropertySummary',
      note: '屬性摘要列。',
      build: (context) => const KlpPropertySummary(
        badges: [KlpPropertyBadgeData(label: 'draft')],
        tags: ['design'],
        metadata: '最後更新 14:28',
      ),
    ),
    Specimen(
      name: 'KlpSaveStatusCard',
      note: '儲存狀態卡。',
      build: (context) => const KlpSaveStatusCard(
        savedAt: '14:28',
        messages: [KlpStatusMessageData(label: '本機變更已保存')],
      ),
    ),
  ],
);

class _InteractiveSliderSpecimen extends StatefulWidget {
  const _InteractiveSliderSpecimen();

  @override
  State<_InteractiveSliderSpecimen> createState() =>
      _InteractiveSliderSpecimenState();
}

class _InteractiveSliderSpecimenState
    extends State<_InteractiveSliderSpecimen> {
  double _value = 0.7;

  @override
  Widget build(BuildContext context) {
    return KlpSlider(
      label: 'Temperature',
      value: _value,
      displayValue: _value.toStringAsFixed(2),
      marks: const ['precise', 'balanced', 'creative'],
      onChanged: (val) => setState(() => _value = val),
    );
  }
}
