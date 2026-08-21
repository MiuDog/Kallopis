import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_components.dart';
import '../catalog_model.dart';
import 'note_background_editor.dart';

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
    Specimen(
      name: 'KlpPageBackgroundEditor',
      note: '座標式 point／line 背景；點連預設吸附格線，按住 Shift 可暫停吸附。',
      build: (_) => const NoteBackgroundCustomEditor(),
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
