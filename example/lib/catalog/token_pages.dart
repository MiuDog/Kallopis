import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_components.dart';
import '../catalog_model.dart';
import 'token_views.dart';

// ── Colors ────────────────────────────────────────────────────────────────

final brandPage = CatalogPageData(
  label: 'Brand',
  title: '品牌色',
  description: '強調色與互動色。這是每個產品最先覆寫的一層。',
  icon: KlpIcons.sparkles,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: 'accent / interaction',
          description: '產品覆寫品牌色時只需要改這兩個角色；其餘的色階由它們推導。',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              Swatch(role: 'accent', color: klp.color.accent),
              Swatch(role: 'accentSoft', color: klp.color.accentSoft),
              Swatch(role: 'interaction', color: klp.color.interaction),
              Swatch(role: 'interactionSoft', color: klp.color.interactionSoft),
              Swatch(
                role: 'onInteraction',
                color: klp.color.onInteraction,
                offRamp: '對比前景',
                note: '在 interaction 色上自動取對比較高的一端',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '內建強調色',
          description: 'KlpAccent 的每一個值都在明暗兩態下通過 AA 對比。',
          child: CatalogGrid(
            minItemWidth: 140,
            children: [
              for (final accent in KlpAccent.values)
                Swatch(
                  role: accent.name,
                  offRamp: '彩色',
                  color: accent.resolve(
                    klp.color.app.computeLuminance() > 0.5
                        ? Brightness.light
                        : Brightness.dark,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  },
);

final surfacesPage = CatalogPageData(
  label: 'Light vs Dark surfaces',
  title: '表面階層',
  description: '同一組角色在明暗兩態下的落點。階層順序在兩態下必須一致。',
  icon: KlpIcons.container,
  specimens: const [],
  tokenView: (context) {
    Widget column(String title, KlpThemeData tokens) => CatalogSample(
      label: title,
      child: CatalogGrid(
        minItemWidth: 150,
        children: [
          Swatch(role: 'app', color: tokens.app, note: '視窗底'),
          Swatch(role: 'surface', color: tokens.surface, note: '面板'),
          Swatch(role: 'surfaceInset', color: tokens.surfaceInset, note: '凹陷'),
          Swatch(role: 'surfaceMuted', color: tokens.surfaceMuted, note: '選取'),
          Swatch(
            role: 'surfaceRaised',
            color: tokens.surfaceRaised,
            note: '次級內容',
          ),
          Swatch(role: 'component', color: tokens.component, note: '控制項底'),
          Swatch(role: 'stageSurface', color: tokens.stageSurface, note: '舞台'),
          Swatch(role: 'overlay', color: tokens.overlay, note: '浮層'),
        ],
      ),
    );

    return CatalogCanvas(
      children: [
        column('light', KlpThemeData.light),
        column('dark', KlpThemeData.dark),
        column('ultraDark', KlpThemeData.ultraDark),
      ],
    );
  },
);

final neutralsPage = CatalogPageData(
  label: 'Neutrals (Ink/Stone)',
  title: '中性色',
  description: '文字三階與線條。三階文字承擔了絕大部分的視覺層級，語意色不參與。',
  icon: KlpIcons.pencil,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '文字三階',
          description: '層級由對比度表達，不由顏色表達——這是深淺兩態都成立的唯一做法。',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              Swatch(role: 'text', color: klp.color.text, note: '主要'),
              Swatch(role: 'textMuted', color: klp.color.textMuted, note: '次要'),
              Swatch(role: 'textFaint', color: klp.color.textFaint, note: '輔助'),
            ],
          ),
        ),
        CatalogSample(
          label: '線條與參考線',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              Swatch(role: 'divider', color: klp.color.divider),
              Swatch(role: 'guide', color: klp.color.guide, note: '虛線／佔位'),
              Swatch(
                role: 'border',
                offRamp: '透明',
                color: klp.color.border,
                note: '結構表面靠 tone 分層，不靠描邊',
              ),
              Swatch(
                role: 'borderStrong',
                offRamp: '透明',
                color: klp.color.borderStrong,
              ),
              Swatch(
                role: 'modalScrim',
                offRamp: 'ink950 @ 60%',
                color: klp.color.modalScrim,
              ),
            ],
          ),
        ),
      ],
    );
  },
);

final semanticStatusPage = CatalogPageData(
  label: 'Semantic Status',
  title: '語意狀態色',
  description: '成功、警告、危險、資訊。只用於狀態，不用於裝飾或層級。',
  icon: KlpIcons.infoSquare,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '四個語意角色',
          description: '狀態色不參與視覺層級——層級由中性色的三階負責。',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              Swatch(role: 'success', offRamp: '語意', color: klp.color.success),
              Swatch(role: 'warning', offRamp: '語意', color: klp.color.warning),
              Swatch(role: 'danger', offRamp: '語意', color: klp.color.danger),
              Swatch(role: 'info', offRamp: '語意', color: klp.color.info),
              Swatch(
                role: 'onStatus',
                offRamp: '對比前景',
                color: klp.color.onStatus,
              ),
            ],
          ),
        ),
        CatalogSample(
          label: 'KlpFeedbackTone',
          description: '回饋元件用 tone 而不是直接指定顏色。',
          child: CatalogGrid(
            minItemWidth: 220,
            children: [
              for (final tone in KlpFeedbackTone.values)
                KlpInlineNotice(title: tone.name, tone: tone),
            ],
          ),
        ),
      ],
    );
  },
);

// ── Type ──────────────────────────────────────────────────────────────────

final displayHeadingsPage = CatalogPageData(
  label: 'Display / Headings',
  title: '標題層級',
  description: 'display 到 section 的四階。字級由 theme 的 typography 層決定。',
  icon: KlpIcons.pencil,
  specimens: const [],
  tokenView: (context) => const CatalogCanvas(
    children: [
      CatalogSample(
        label: '標題階層',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeSample(role: KlpTextRole.display, sample: '專案控制台'),
            TypeSample(role: KlpTextRole.title, sample: '執行結果與驗證'),
            TypeSample(role: KlpTextRole.section, sample: '背景與基底區塊'),
            TypeSample(
              role: KlpTextRole.bodyStrong,
              sample: '一條線，一種意義',
              note: '段落內的強調，不是標題',
            ),
          ],
        ),
      ),
    ],
  ),
);

final bodyCopyPage = CatalogPageData(
  label: 'Body copy',
  title: '內文',
  description: '正文、編輯器內容、說明與標籤。行高是這一組最關鍵的參數。',
  icon: KlpIcons.pencil,
  specimens: const [],
  tokenView: (context) => const CatalogCanvas(
    children: [
      CatalogSample(
        label: '內文角色',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeSample(
              role: KlpTextRole.body,
              sample:
                  '規劃、協作並追蹤可驗證的專案成果。The quick brown fox '
                  'jumps over the lazy dog.',
            ),
            TypeSample(
              role: KlpTextRole.editor,
              sample: '編輯器內容使用比例字體以利長文閱讀，行高比一般內文再寬一些。',
            ),
            TypeSample(
              role: KlpTextRole.caption,
              sample: '輔助說明。小字需要更緊的行距才不會顯得鬆散。',
            ),
            TypeSample(
              role: KlpTextRole.label,
              sample: 'SECTION LABEL',
              note: '字距放寬，通常單行',
            ),
          ],
        ),
      ),
    ],
  ),
);

final monospacePage = CatalogPageData(
  label: 'Monospace (data & logs)',
  title: '等寬',
  description: '程式碼、路徑、識別碼與 log。等寬的用途是讓字元對齊，不是風格選擇。',
  icon: KlpIcons.cpu,
  specimens: [
    Specimen(
      name: 'KlpCodeViewer',
      note: '程式碼檢視。語言清單與行號由呼叫端決定。',
      build: (context) => const KlpCodeViewer(
        code:
            'void main() {\n'
            '  runApp(const MyApp());\n'
            '}',
        language: 'dart',
      ),
    ),
    Specimen(
      name: 'KlpJsonTree',
      note: '可展開的 JSON 檢視。',
      build: (context) => const KlpJsonTree(
        value: {
          'id': 'run_04',
          'status': 'accepted',
          'metrics': {'duration': 1284, 'retries': 0},
        },
      ),
    ),
  ],
  tokenView: (context) => const CatalogCanvas(
    children: [
      CatalogSample(
        label: '等寬角色',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TypeSample(
              role: KlpTextRole.code,
              sample: 'run_04 / result.accepted',
              note: '識別碼、路徑、鍵名',
            ),
            TypeSample(
              role: KlpTextRole.terminal,
              sample: r'$ flutter test --reporter compact',
              note: '指令與 log 輸出',
            ),
          ],
        ),
      ),
    ],
  ),
);

// ── Spacing ───────────────────────────────────────────────────────────────

final scalePage = CatalogPageData(
  label: 'Scale',
  title: '間距階梯',
  description: '角色化的間距。元件讀角色，不讀尺寸——這樣換密度時整體會一起變。',
  icon: KlpIcons.grid,
  specimens: const [],
  tokenView: (context) {
    final s = context.klp.space;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '通用階梯',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'hairline', value: s.hairline),
              ScaleRow(name: 'tight', value: s.tight),
              ScaleRow(name: 'compact', value: s.compact),
              ScaleRow(name: 'base', value: s.base, note: '預設間距'),
              ScaleRow(name: 'comfortable', value: s.comfortable),
              ScaleRow(name: 'loose', value: s.loose),
              ScaleRow(name: 'section', value: s.section),
              ScaleRow(name: 'page', value: s.page),
            ],
          ),
        ),
        CatalogSample(
          label: '組合值',
          description: '元件直接讀這些，不自己從階梯算。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'controlPaddingX', value: s.controlPaddingX),
              ScaleRow(name: 'controlPaddingY', value: s.controlPaddingY),
              ScaleRow(name: 'containerPadding', value: s.containerPadding),
              ScaleRow(name: 'itemGap', value: s.itemGap),
              ScaleRow(name: 'groupGap', value: s.groupGap),
            ],
          ),
        ),
        CatalogSample(
          label: '密度',
          description: '控制項高度與圖示尺寸是「緊湊 vs 寬鬆」最直接的體現。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'controlHeightSmall', value: s.controlHeightSmall),
              ScaleRow(name: 'controlHeight', value: s.controlHeight),
              ScaleRow(name: 'controlHeightLarge', value: s.controlHeightLarge),
              ScaleRow(name: 'iconSmall', value: s.iconSmall),
              ScaleRow(name: 'icon', value: s.icon),
              ScaleRow(name: 'iconLarge', value: s.iconLarge),
              ScaleRow(name: 'iconButton', value: s.iconButton),
            ],
          ),
        ),
        CatalogSample(
          label: '外殼高度',
          description: '這些隨風格改變，不是版面常數。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'chromeHeader', value: s.chromeHeader),
              ScaleRow(name: 'chromeStatusBar', value: s.chromeStatusBar),
              ScaleRow(name: 'chromeRail', value: s.chromeRail),
              ScaleRow(name: 'chromeTab', value: s.chromeTab),
            ],
          ),
        ),
      ],
    );
  },
);

final radiiPage = CatalogPageData(
  label: 'Radii',
  title: '圓角',
  description: '以使用位置的角色命名，不以尺寸命名。改 control 時所有控制項一起變。',
  icon: KlpIcons.box,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: 'semantic 圓角',
          child: CatalogGrid(
            minItemWidth: 140,
            children: [
              RadiusSample(name: 'none', value: klp.shape.none),
              RadiusSample(name: 'control', value: klp.shape.control),
              RadiusSample(name: 'card', value: klp.shape.card),
              RadiusSample(name: 'panel', value: klp.shape.panel),
              RadiusSample(name: 'pill', value: klp.shape.pill),
            ],
          ),
        ),
        CatalogSample(
          label: '已解析的 component 圓角',
          description: 'component 層沒有覆寫時，這些等於上面的 semantic 值。',
          child: CatalogGrid(
            minItemWidth: 140,
            children: [
              RadiusSample(name: 'buttonRadius', value: klp.buttonRadius),
              RadiusSample(name: 'fieldRadius', value: klp.fieldRadius),
              RadiusSample(name: 'menuRadius', value: klp.menuRadius),
              RadiusSample(name: 'cardRadius', value: klp.cardRadius),
              RadiusSample(name: 'badgeRadius', value: klp.badgeRadius),
            ],
          ),
        ),
        CatalogSample(
          label: '線寬',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'hairline', value: klp.shape.hairline),
              ScaleRow(name: 'stroke', value: klp.shape.stroke),
              ScaleRow(name: 'dashedLength', value: klp.shape.dashedLength),
              ScaleRow(name: 'dashedGap', value: klp.shape.dashedGap),
            ],
          ),
        ),
      ],
    );
  },
);

final elevationPage = CatalogPageData(
  label: 'Elevation',
  title: '分層手法',
  description: '用陰影還是用邊框。兩者互斥，由 KlpSurfaceSeparation 決定。',
  icon: KlpIcons.container,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '目前的分層手法',
          description:
              '${klp.surface.separation.name} — '
              '做成 enum 是為了讓「陰影開著又畫滿實線框」從型別上就不可能出現。',
          child: CatalogGrid(
            minItemWidth: 220,
            children: [
              Container(
                height: 96,
                decoration: BoxDecoration(
                  color: klp.color.overlay,
                  borderRadius: BorderRadius.circular(klp.shape.panel),
                  boxShadow: klp.overlayShadow,
                  border: klp.surface.usesShadow
                      ? null
                      : Border.all(
                          color: klp.color.divider,
                          width: klp.shape.hairline,
                        ),
                ),
                alignment: Alignment.center,
                child: const KlpText('overlay'),
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '陰影參數',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'overlayBlur', value: klp.surface.overlayBlur),
              ScaleRow(name: 'overlaySpread', value: klp.surface.overlaySpread),
              ScaleRow(
                name: 'overlayOffsetY',
                value: klp.surface.overlayOffsetY,
              ),
              ScaleRow(
                name: 'overlayShadowOpacity',
                value: klp.surface.overlayShadowOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'hoverContrastMix',
                value: klp.surface.hoverContrastMix * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'scrimOpacity',
                value: klp.surface.scrimOpacity * 100,
                note: '百分比',
              ),
            ],
          ),
        ),
      ],
    );
  },
);
