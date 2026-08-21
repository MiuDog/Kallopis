import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

final blockLayoutPage = CatalogPageData(
  label: 'Block Layout & Theme',
  title: '區塊與主題',
  description: '所有內容都坐在某個表面上。表面的階層由 tone 表達，不由邊框表達。',
  icon: KlpIcons.container,
  specimens: [
    Specimen(
      name: 'KlpSurface',
      note: '所有區塊的基底。tone 指定它在表面階層中的位置，色值與圓角由 theme 決定。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.base,
          children: [
            for (final tone in KlpSurfaceTone.values)
              SizedBox(
                width: 150,
                child: KlpSurface(
                  tone: tone,
                  padding: EdgeInsets.all(klp.space.base),
                  child: KlpText(tone.name, role: KlpTextRole.caption),
                ),
              ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpSection',
      note: '帶標題的內容分段。label 是標題上方的分類文字。',
      build: (context) => const KlpSection(
        label: 'GROUP',
        title: '區段標題',
        child: KlpText('區段內容'),
      ),
    ),
    Specimen(
      name: 'KlpRegion',
      note:
          '面板內的一塊區域，自帶 tone 與內距。**它會撐滿可用高度**，'
          '因此必須放在有界高度的容器裡。',
      build: (context) => const SizedBox(
        height: 120,
        child: KlpRegion(content: KlpText('region content')),
      ),
    ),
    Specimen(
      name: 'KlpCard',
      note: '有標題的內容卡。',
      build: (context) => const KlpCard(title: '卡片標題', child: KlpText('卡片內容')),
    ),
    Specimen(
      name: 'KlpBlock',
      note: '可選取的內容塊，編輯器的基本單位。',
      build: (context) => const KlpBlock(child: KlpText('block')),
    ),
    Specimen(
      name: 'KlpBlockCanvas',
      note: '一疊 block 的容器。',
      build: (context) => const KlpBlockCanvas(
        children: [
          KlpBlock(child: KlpText('第一塊')),
          KlpBlock(selected: true, child: KlpText('選取中')),
        ],
      ),
    ),
    Specimen(
      name: 'KlpThemePreviewTile',
      note: '主題預覽磚。用插圖模擬視窗，不是真的渲染一個 app。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.base,
          children: [
            for (final mode in KlpThemePreviewMode.values)
              KlpThemePreviewTile(
                mode: mode,
                label: mode.name,
                description: '預覽',
                selected: mode == KlpThemePreviewMode.light,
              ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpTokenOverride',
      note:
          '用一組覆寫過的色彩 token 包住子樹。KlpSurface 與各種 frame 都靠它讓內容'
          '自動取得適合該表面的文字色；消費者自訂表面時也用它。',
      build: (context) {
        final klp = context.klp;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpSurface(
              tone: KlpSurfaceTone.accent,
              padding: EdgeInsets.all(klp.space.base),
              child: const KlpText('表面上的文字自動反白'),
            ),
            SizedBox(width: klp.space.base),
            KlpTokenOverride(
              colors: klp.color.onBackground(klp.color.accent),
              child: Padding(
                padding: EdgeInsets.all(klp.space.base),
                child: const KlpText('同一組 token，未上底色'),
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpThemeToggle',
      note: '明暗切換。',
      build: (context) =>
          KlpThemeToggle(label: '深色主題', dark: false, onChanged: (_) {}),
    ),
  ],
);

final prosePage = CatalogPageData(
  label: 'Prose / Text',
  title: '文字與長文',
  description: '角色決定樣式，語氣決定色階。兩者互不干涉。',
  icon: KlpIcons.pencil,
  specimens: [
    Specimen(
      name: 'KlpText',
      note: '以角色指定樣式，不指定字級與家族——實際值由 theme 的 typography 層決定。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final tone in KlpTextTone.values)
              Padding(
                padding: EdgeInsets.only(bottom: klp.space.tight),
                child: KlpText('tone.${tone.name}', tone: tone),
              ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpRichText',
      note: '行內混排：強調、程式碼、連結。節點由呼叫端組出，庫不解析 markdown。',
      build: (context) => const KlpRichText(
        nodes: [
          KlpRichTextNode(text: '一般文字，接著是 '),
          KlpRichTextNode(text: '強調', kind: KlpRichTextKind.strong),
          KlpRichTextNode(text: ' 與 '),
          KlpRichTextNode(text: 'inline code', kind: KlpRichTextKind.code),
          KlpRichTextNode(text: '。'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpInlineCode',
      note: '行內程式碼片段。帶有圓角背景與等寬字體。',
      build: (context) => const Wrap(
        spacing: 8,
        children: [
          KlpInlineCode('flutter test'),
          KlpInlineCode('git commit -m "feat: inline code"'),
          KlpInlineCode('context.klp.color.text'),
        ],
      ),
    ),
  ],
);

final strokeLanguagePage = CatalogPageData(
  label: 'Stroke Language',
  title: '線條語言',
  description: '一條線，一種意義。實線是結構，虛線是待填，無線是可操作。',
  icon: KlpIcons.slash,
  specimens: [
    Specimen(
      name: 'KlpStrokeFrame',
      note: 'role 決定線條的意義。structure 不畫線——結構表面靠 tone 分層，不靠描邊。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.base,
          children: [
            for (final role in KlpStrokeRole.values)
              SizedBox(
                width: 200,
                height: 64,
                child: KlpStrokeFrame(
                  role: role,
                  child: Center(
                    child: KlpText(role.name, role: KlpTextRole.caption),
                  ),
                ),
              ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpDashedBorder',
      note: '待填區域與外框。支援自訂粗細、圓角、顏色與虛線疏密。',
      build: (context) {
        final klp = context.klp;
        return Column(
          children: [
            const SizedBox(
              height: 56,
              child: KlpDashedBorder(child: Center(child: KlpText('預設輔助線外框'))),
            ),
            SizedBox(height: klp.space.base),
            SizedBox(
              height: 56,
              child: KlpDashedBorder(
                width: klp.shape.stroke,
                color: klp.color.accent,
                radius: klp.shape.card,
                dashLength: 8,
                gapLength: 4,
                child: const Center(child: KlpText('強調色粗虛線外框')),
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpDashedDivider',
      note: '虛線分隔。支援水平與垂直方向，以及自訂粗細與顏色。',
      build: (context) {
        final klp = context.klp;
        return Column(
          children: [
            const KlpDashedDivider(),
            SizedBox(height: klp.space.base),
            KlpDashedDivider(
              width: klp.shape.stroke,
              color: klp.color.accent,
              dashLength: 8,
              gapLength: 4,
            ),
            SizedBox(height: klp.space.base),
            SizedBox(
              height: 48,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const KlpText('區塊 A'),
                  const KlpDashedDivider(vertical: true),
                  const KlpText('區塊 B'),
                  KlpDashedDivider(
                    vertical: true,
                    width: klp.shape.stroke,
                    color: klp.color.accent,
                  ),
                  const KlpText('區塊 C'),
                ],
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpDivider',
      note: '實線分隔。取自 theme 的 divider 色與 hairline 寬。',
      build: (context) => const KlpDivider(),
    ),
  ],
);
