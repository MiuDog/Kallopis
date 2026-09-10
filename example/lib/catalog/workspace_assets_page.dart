import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

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
				children: const [
					KlpPreviewCard(
						title: '白板拍照.png',
						metadata: ['圖片', '今天'],
						preview: KlpCenter(
							child: KlpText(
								'IMAGE',
								role: KlpTextRole.code,
								tone: KlpTextTone.faint,
							),
						),
					),
					KlpPreviewCard(
						title: '訪談逐字稿.md',
						metadata: ['文字', '41 KB'],
						previewSize: KlpPreviewCardSize.standard,
						preview: KlpCenter(
							child: KlpText(
								'TEXT',
								role: KlpTextRole.code,
								tone: KlpTextTone.faint,
							),
						),
					),
					KlpPreviewCard(
						title: '競品截圖合輯.png',
						metadata: ['圖片', '7.8 MB'],
						previewSize: KlpPreviewCardSize.large,
						preview: KlpCenter(
							child: KlpText(
								'IMAGE',
								role: KlpTextRole.code,
								tone: KlpTextTone.faint,
							),
						),
					),
					KlpPreviewCard(
						title: '月結表.csv',
						metadata: ['表格', '82 KB'],
						previewSize: KlpPreviewCardSize.compact,
						preview: KlpCenter(
							child: KlpText(
								'SHEET',
								role: KlpTextRole.code,
								tone: KlpTextTone.faint,
							),
						),
					),
				],
			),
		),
		Specimen(
			name: 'KlpPreviewCard',
			note: '預覽區、標題與中繼資訊的內容卡片。',
			build: (context) => const KlpPreviewCard(
				title: '產品架構草圖.svg',
				metadata: ['向量', '214 KB', '昨天'],
				preview: KlpCenter(
					child: KlpText(
						'VECTOR',
						role: KlpTextRole.code,
						tone: KlpTextTone.faint,
					),
				),
			),
		),
	],
);
