import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final workspaceAgendaPage = CatalogPageData(
  label: 'Agenda',
  title: '日期、待辦與排程',
  description: '工作區的日期概覽與行動清單；元件只呈現資料，不擁有日曆或任務規則。',
  icon: KlpIcons.calendar,
  specimens: [
    Specimen(
      name: 'KlpDateGrid',
      note: '固定七欄的日期概覽；選取與每格內容由呼叫端提供。',
      build: (context) => KlpDateGrid(
        onSelected: (_) {},
        items: const [
          KlpDateGridItem(label: '17', lines: ['週報草稿', '訪談 · 14:00']),
          KlpDateGridItem(label: '18', lines: ['每日回顧'], selected: true),
          KlpDateGridItem(label: '19'),
          KlpDateGridItem(label: '20'),
          KlpDateGridItem(label: '21'),
          KlpDateGridItem(label: '22'),
          KlpDateGridItem(label: '23', lines: ['月結整理']),
          KlpDateGridItem(label: '24'),
          KlpDateGridItem(label: '25'),
          KlpDateGridItem(label: '26', lines: ['Flow 匯出']),
          KlpDateGridItem(label: '27'),
          KlpDateGridItem(label: '28'),
          KlpDateGridItem(label: '29'),
          KlpDateGridItem(label: '30'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTaskList',
      note: '待辦文字與狀態說明的受控清單。',
      build: (context) => KlpTaskList(
        onChanged: (_, _) {},
        items: const [
          KlpTaskItemData(title: '整理八月讀書筆記', detail: '筆記 · 今天'),
          KlpTaskItemData(title: '把訪談逐字稿轉成 Flow', detail: 'Flow · 今天 14:00'),
          KlpTaskItemData(title: '補上月結的缺漏項', detail: '逾期 2 天'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpScheduleList',
      note: '固定時間欄、標題與選填標籤的排程列。',
      build: (context) => const KlpScheduleList(
        items: [
          KlpScheduleItemData(time: '09:30', title: '每日回顧', tag: '重複'),
          KlpScheduleItemData(time: '11:00', title: '讀書筆記整理', tag: '提醒'),
          KlpScheduleItemData(time: '14:00', title: '訪談 · 產品團隊', tag: '行事曆'),
        ],
      ),
    ),
  ],
);
