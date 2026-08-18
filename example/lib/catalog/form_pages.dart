import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final formControlsPage = CatalogPageData(
  label: 'Form Controls',
  title: '表單控制項',
  description: '單一輸入。它們不知道自己在哪個表單裡，也不負責驗證。',
  icon: KlpIcons.edit,
  specimens: [
    Specimen(
      name: 'KlpTextField',
      note: '單行或多行。內部使用 TextFormField，所需的 Material 祖先由本元件自行提供。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const KlpTextField(label: '名稱', placeholder: '輸入名稱'),
            SizedBox(height: klp.space.base),
            const KlpTextField(
              label: '含說明',
              initialValue: 'token',
              helper: '會出現在所有產品裡',
            ),
            SizedBox(height: klp.space.base),
            const KlpTextField(label: '錯誤狀態', error: '這個名稱已經被使用'),
            SizedBox(height: klp.space.base),
            const KlpTextField(label: '停用', enabled: false),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpTextArea',
      note: '多行輸入。',
      build: (context) => const KlpTextArea(label: '描述', placeholder: '多行輸入'),
    ),
    Specimen(
      name: 'KlpNumberField',
      note: '數值輸入。',
      build: (context) =>
          KlpNumberField(label: '數量', value: 3, onChanged: (_) {}),
    ),
    Specimen(
      name: 'KlpPasswordField',
      note: '密碼輸入。',
      build: (context) => const KlpPasswordField(label: '密碼'),
    ),
    Specimen(
      name: 'KlpDateField',
      note: '日期輸入。',
      build: (context) =>
          KlpDateField(label: '截止日', value: '2026-08-18', onChanged: (_) {}),
    ),
    Specimen(
      name: 'KlpCheckbox',
      note: '核取方塊。label 必填，用於無障礙。',
      build: (context) =>
          KlpCheckbox(value: true, label: '包含子項目', onChanged: (_) {}),
    ),
    Specimen(
      name: 'KlpToggle',
      note: '開關。',
      build: (context) =>
          KlpToggle(value: true, label: '啟用同步', onChanged: (_) {}),
    ),
    Specimen(
      name: 'KlpCompactSwitch',
      note: '緊湊版開關，用於清單列。',
      build: (context) =>
          KlpCompactSwitch(value: false, label: '顯示隱藏檔', onChanged: (_) {}),
    ),
    Specimen(
      name: 'KlpTriStateToggle',
      note: '三態：開、關、未決定。',
      build: (context) => KlpTriStateToggle(
        value: KlpTriState.mixed,
        label: '部分選取',
        onChanged: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpToggleIndicator',
      note: '只有指示器，沒有互動——用於唯讀狀態的呈現。',
      build: (context) => const KlpToggleIndicator(value: true),
    ),
    Specimen(
      name: 'KlpSegmentedControl',
      note: '分段選擇。',
      build: (context) => KlpSegmentedControl(
        items: const ['清單', '格狀', '時間軸'],
        selected: 0,
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpSlidingSelection',
      note: '滑動式選擇，用於少量互斥選項。',
      build: (context) => KlpSlidingSelection(
        label: '密度',
        selectedIndex: 1,
        options: const [
          KlpSelectionOption(icon: KlpIcons.grid, color: Color(0xFF66733E)),
          KlpSelectionOption(
            icon: KlpIcons.container,
            color: Color(0xFF546F95),
          ),
        ],
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpSelect',
      note: '下拉觸發器。它只顯示目前的值並觸發 onPressed，選單本身由呼叫端開。',
      build: (context) =>
          KlpSelect(label: '排序', value: '最近修改', onPressed: () {}),
    ),
    Specimen(
      name: 'KlpSlider',
      note: '連續數值。',
      build: (context) =>
          KlpSlider(label: '不透明度', value: 0.62, onChanged: (_) {}),
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
      build: (context) => KlpColorRoleField(
        label: '強調色',
        roles: const [
          KlpChoiceOption(id: 'accent', label: 'accent'),
          KlpChoiceOption(id: 'success', label: 'success'),
          KlpChoiceOption(id: 'danger', label: 'danger'),
        ],
        selectedId: 'accent',
        onSelected: (_) {},
      ),
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
      note: '鍵值對編輯。',
      build: (context) => KlpKeyValueEditor(
        label: '中繼資料',
        entries: const [
          KlpKeyValueEntry(id: '1', keyText: 'owner', value: 'chiayu'),
        ],
        onChanged: (_) {},
      ),
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
