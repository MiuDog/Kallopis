import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_components.dart';
import '../catalog_model.dart';
import 'note_background_editor.dart';
import 'note_docs_demo.dart';
import 'note_editor_demos.dart';

final noteDocsPage = CatalogPageData(
  label: 'Docs',
  title: 'Docs 區塊筆記',
  description: '以可選取的內容區塊組成線性文件；資料、排序與編輯流程由產品端保存。',
  icon: KlpIcons.edit,
  specimens: [
    Specimen(
      name: 'KlpBlock',
      note: '所有區塊共用 hover、clicked 與六點操作鈕；Catalog 只讀，不啟用區塊拖曳。',
      build: (_) => const NoteDocsDemo(),
    ),
    Specimen(
      name: 'KlpBlockCanvas',
      note: '自由定位的區塊容器；內容位置仍由消費端資料模型決定。',
      build: (_) => const NoteBlockCanvasDemo(),
    ),
  ],
);

final noteCanvaPage = CatalogPageData(
  label: 'Canva',
  title: 'Canva 互動筆記',
  description: '在無邊界畫布上建立、連接、選取與刪除節點，並支援座標吸附。',
  icon: KlpIcons.container,
  specimens: [
    Specimen(
      name: 'KlpPageBackgroundEditor',
      note: '點擊建立節點並連線；按住 Shift 可暫停吸附，工具可切換選取與刪除。',
      build: (_) => const NoteBackgroundCustomEditor(),
    ),
  ],
);

final noteSheetPage = CatalogPageData(
  label: 'Sheet',
  title: 'Sheet 無限表格',
  description: '以受控 cell 資料呈現表格；抵達右側或下方時繼續延伸虛擬軌道。',
  icon: KlpIcons.grid,
  specimens: [
    Specimen(
      name: 'KlpSheetGrid',
      note: '點擊選取、方向鍵移動，雙擊或 Enter 編輯；資料由消費端持有。',
      build: (_) => const NoteSheetDemo(),
    ),
  ],
);

final noteBackgroundsPage = CatalogPageData(
  label: 'Backgrounds',
  title: '筆記背景',
  description: '同一份內容可依頁面用途套用純色、橫線、點陣或方格背景；顏色與幾何皆跟隨目前主題。',
  icon: KlpIcons.grid,
  specimens: [
    Specimen(
      name: 'KlpPageBackground',
      note: '四種預設背景共用 pagePattern；下方可執行期調整 RGBA、主次軸、間距與縮放。',
      build: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _PageBackgroundGallery(),
          SizedBox(height: context.klp.space.section),
          const NoteBackgroundRuntimeEditor(),
        ],
      ),
    ),
  ],
);

class _PageBackgroundGallery extends StatelessWidget {
  const _PageBackgroundGallery();

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return CatalogGrid(
      children: [
        for (final style in KlpPageBackgroundStyle.values)
          CatalogSample(
            label: _label(style),
            description: _description(style),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(klp.shape.card),
              child: KlpPageBackground(
                style: style,
                child: SizedBox(height: klp.space.pageLarge * 2),
              ),
            ),
          ),
      ],
    );
  }

  String _label(KlpPageBackgroundStyle style) {
    return switch (style) {
      KlpPageBackgroundStyle.plain => 'Plain',
      KlpPageBackgroundStyle.ruled => 'Ruled',
      KlpPageBackgroundStyle.dots => 'Dots',
      KlpPageBackgroundStyle.grid => 'Grid',
    };
  }

  String _description(KlpPageBackgroundStyle style) {
    return switch (style) {
      KlpPageBackgroundStyle.plain => 'Docs 與長文閱讀',
      KlpPageBackgroundStyle.ruled => '手寫與逐行筆記',
      KlpPageBackgroundStyle.dots => 'Canva 自由排列',
      KlpPageBackgroundStyle.grid => 'Sheet 與精準對齊',
    };
  }
}
