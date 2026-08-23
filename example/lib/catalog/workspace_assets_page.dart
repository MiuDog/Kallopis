import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

Widget _preview(String label) => Center(
  child: KlpText(label, role: KlpTextRole.code, tone: KlpTextTone.faint),
);

final workspaceAssetsPage = CatalogPageData(
  label: 'Masonry',
  title: '瀑布流與預覽卡',
  description: '高度不同的預覽內容以自適應多欄排列；檔案型別與資料來源不屬於元件。',
  icon: KlpIcons.grid,
  specimens: [
    Specimen(
      name: 'KlpMasonryGrid',
      note: '依可用寬度建立多欄，內容按順序分配至各欄。',
      build: (context) => KlpMasonryGrid(
        children: [
          KlpPreviewCard(
            title: '白板拍照.png',
            metadata: const ['圖片', '今天'],
            preview: _preview('IMAGE'),
          ),
          KlpPreviewCard(
            title: '訪談逐字稿.md',
            metadata: const ['文字', '41 KB'],
            previewHeight: context.klp.space.pageLarge,
            preview: _preview('TEXT'),
          ),
          KlpPreviewCard(
            title: '競品截圖合輯.png',
            metadata: const ['圖片', '7.8 MB'],
            previewHeight: context.klp.space.pageLarge * 2,
            preview: _preview('IMAGE'),
          ),
          KlpPreviewCard(
            title: '月結表.csv',
            metadata: const ['表格', '82 KB'],
            previewHeight: context.klp.space.page,
            preview: _preview('SHEET'),
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpPreviewCard',
      note: '預覽區、標題與中繼資訊的內容卡片。',
      build: (context) => KlpPreviewCard(
        title: '產品架構草圖.svg',
        metadata: const ['向量', '214 KB', '昨天'],
        preview: _preview('VECTOR'),
      ),
    ),
  ],
);
