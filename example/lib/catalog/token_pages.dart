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
  description: 'Hero Banner 超大標題至小組件標題（font-display 到 font-h4 與語意標題）。',
  icon: KlpIcons.pencil,
  specimens: const [],
  tokenView: (context) {
    final t = context.klp.type;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '大標題與視覺層級 (Display - H4)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TypeSample(
                role: KlpTextRole.display,
                sample: '64px Hero Banner 超大視覺標題',
                note: 'font-display · 64px (4.0rem) · 行高 72px (1.125) · Bold',
              ),
              TypeSample(
                role: KlpTextRole.h1,
                sample: '48px 頁面主要大標題 (H1)',
                note: 'font-h1 · 48px (3.0rem) · 行高 56px (1.166) · Bold',
              ),
              TypeSample(
                role: KlpTextRole.h2,
                sample: '36px 區塊主題標題 (H2)',
                note: 'font-h2 · 36px (2.25rem) · 行高 44px (1.222) · SemiBold',
              ),
              TypeSample(
                role: KlpTextRole.h3,
                sample: '28px 卡片/組件大標題 (H3)',
                note: 'font-h3 · 28px (1.75rem) · 行高 36px (1.285) · SemiBold',
              ),
              TypeSample(
                role: KlpTextRole.h4,
                sample: '22px 小組件標題/彈窗標題 (H4)',
                note: 'font-h4 · 22px (1.375rem) · 行高 28px (1.272) · SemiBold',
              ),
              TypeSample(
                role: KlpTextRole.title,
                sample: '48px 應用程式主標題 (Title)',
                note: 'title · 48px · 行高 56px · Bold',
              ),
              TypeSample(
                role: KlpTextRole.section,
                sample: '28px 區段大標題 (Section)',
                note: 'section · 28px · 行高 36px · SemiBold',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '標題字級與行高參數 (Typography Tokens)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'display (64px)', value: t.display),
              ScaleRow(name: 'h1 / title (48px)', value: t.h1),
              ScaleRow(name: 'h2 / heading (36px)', value: t.h2),
              ScaleRow(name: 'h3 / section (28px)', value: t.h3),
              ScaleRow(name: 'h4 / headingSmall (22px)', value: t.h4),
              ScaleRow(
                name: 'displayLeading',
                value: t.displayLeading,
                note: '行高比例 1.125',
              ),
              ScaleRow(
                name: 'h1Leading',
                value: t.h1Leading,
                note: '行高比例 1.166',
              ),
              ScaleRow(
                name: 'h2Leading',
                value: t.h2Leading,
                note: '行高比例 1.222',
              ),
              ScaleRow(
                name: 'h3Leading',
                value: t.h3Leading,
                note: '行高比例 1.285',
              ),
              ScaleRow(
                name: 'h4Leading',
                value: t.h4Leading,
                note: '行高比例 1.272',
              ),
              ScaleRow(
                name: 'displayTracking',
                value: t.displayTracking,
                note: '字距 -0.5',
              ),
            ],
          ),
        ),
      ],
    );
  },
);

final bodyCopyPage = CatalogPageData(
  label: 'Body copy',
  title: '內文與附註',
  description: '重點引言、預設正文、次要說明、附註與極小徽章（font-lead 到 font-micro）。',
  icon: KlpIcons.pencil,
  specimens: const [],
  tokenView: (context) {
    final t = context.klp.type;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '正文與輔助層級 (Lead - Micro)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TypeSample(
                role: KlpTextRole.lead,
                sample: '18px 引言、重點強調文字。規劃、協作並追蹤可驗證的成果。',
                note: 'font-lead · 18px (1.125rem) · 行高 28px (1.555) · Medium',
              ),
              TypeSample(
                role: KlpTextRole.body,
                sample:
                    '16px 預設內文、表單輸入文字（基準）。The quick brown fox jumps over the lazy dog.',
                note: 'font-body · 16px (1.0rem) · 行高 24px (1.500) · Regular',
              ),
              TypeSample(
                role: KlpTextRole.bodyStrong,
                sample: '16px 強調正文文字。用於列表項目主要文字與面板副標。',
                note: 'bodyStrong · 16px (1.0rem) · 行高 24px (1.500) · SemiBold',
              ),
              TypeSample(
                role: KlpTextRole.sub,
                sample: '14px 次要說明、表格內文、標籤文字。',
                note: 'font-sub · 14px (0.875rem) · 行高 20px (1.428) · Regular',
              ),
              TypeSample(
                role: KlpTextRole.caption,
                sample: '12px 附註文字、時間戳記、提示警語。',
                note:
                    'font-caption · 12px (0.75rem) · 行高 16px (1.333) · Regular',
              ),
              TypeSample(
                role: KlpTextRole.micro,
                sample: '10px 徽章數字 (BADGE)、極小 TAG',
                note: 'font-micro · 10px (0.625rem) · 行高 12px (1.200) · Medium',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '正文字級與行高參數 (Typography Tokens)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(name: 'lead (18px)', value: t.lead),
              ScaleRow(name: 'body (16px)', value: t.body),
              ScaleRow(name: 'sub (14px)', value: t.sub),
              ScaleRow(name: 'caption (12px)', value: t.caption),
              ScaleRow(name: 'micro (10px)', value: t.micro),
              ScaleRow(
                name: 'leadLeading',
                value: t.leadLeading,
                note: '行高比例 1.555',
              ),
              ScaleRow(
                name: 'bodyLeading',
                value: t.bodyLeading,
                note: '行高比例 1.500',
              ),
              ScaleRow(
                name: 'subLeading',
                value: t.subLeading,
                note: '行高比例 1.428',
              ),
              ScaleRow(
                name: 'captionLeading',
                value: t.captionLeading,
                note: '行高比例 1.333',
              ),
              ScaleRow(
                name: 'microLeading',
                value: t.microLeading,
                note: '行高比例 1.200',
              ),
              ScaleRow(
                name: 'readingLeading',
                value: t.readingLeading,
                note: '行高比例 1.650',
              ),
            ],
          ),
        ),
      ],
    );
  },
);

final monospacePage = CatalogPageData(
  label: 'Monospace (data & logs)',
  title: '等寬',
  description: '程式碼、路徑、識別碼與 log。等寬的用途是讓字元對齊，不是風格選擇。',
  icon: KlpIcons.cpu,
  specimens: [
    Specimen(
      name: 'KlpCodeViewer',
      note: '程式碼檢視（支援程式碼展開/收合、行號、語言切換與複製）。',
      build: (context) => const KlpCodeViewer(
        code:
            '{\n'
            '  "id": "node_01",\n'
            '  "type": "task",\n'
            '  "status": "running"\n'
            '}',
        language: 'json',
        showLineNumbers: true,
        expandable: true,
      ),
    ),
    Specimen(
      name: 'KlpDiffViewer',
      note: '程式碼差異檢視（支援雙欄行號、新增/刪除色彩區分與行動作）。',
      build: (context) => KlpDiffViewer(
        filename: 'node.schema.json',
        lines: [
          const KlpDiffLine(oldNumber: 1, newNumber: 1, content: '{'),
          const KlpDiffLine(
            oldNumber: 2,
            newNumber: 2,
            content: '  "id": "string",',
          ),
          KlpDiffLine(
            oldNumber: 3,
            content: '  "type": "task" | "note",',
            type: KlpDiffLineType.deleted,
            onApprove: () {},
            onReject: () {},
          ),
          KlpDiffLine(
            newNumber: 3,
            content: '  "type": "task" | "note" | "group",',
            type: KlpDiffLineType.added,
            onApprove: () {},
            onReject: () {},
          ),
          KlpDiffLine(
            newNumber: 4,
            content: '  "schemaVersion": 2,',
            type: KlpDiffLineType.added,
            onApprove: () {},
            onReject: () {},
          ),
          const KlpDiffLine(oldNumber: 4, newNumber: 5, content: '}'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTerminal',
      note: '終端機檢視（具備整體實線細邊框、頂部三點標記與 stage 底色）。',
      build: (context) => const KlpTerminal(
        title: 'bash',
        lines: [
          '\$ flutter build windows --release',
          'Building Windows application...',
          '√ Built build/windows/x64/runner/Release/kallopis_catalog.exe (18.4s)',
        ],
      ),
    ),
    Specimen(
      name: 'KlpJsonTree',
      note: '可展開的 JSON 檢視。',
      build: (context) => const KlpJsonTree(
        value: {
          'id': 'run_4a92',
          'input': {'mode': 'strict', 'target': 'catalog'},
          'output': {'status': 'success', 'code': 0},
        },
      ),
    ),
  ],
  tokenView: (context) {
    final t = context.klp.type;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '等寬角色',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
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
              TypeSample(
                role: KlpTextRole.label,
                sample: 'SECTION LABEL · STATUS ACTIVE',
                note: '徽章與標記走等寬以齊視覺節奏',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '等寬參數 (Monospace Tokens)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'codeLeading',
                value: t.codeLeading,
                note: '行高比例 1.400',
              ),
              ScaleRow(
                name: 'labelLeading',
                value: t.labelLeading,
                note: '行高比例 1.200',
              ),
              ScaleRow(
                name: 'labelTracking',
                value: t.labelTracking,
                note: '字距 1.2',
              ),
            ],
          ),
        ),
      ],
    );
  },
);

// ── Spacing ───────────────────────────────────────────────────────────────

final scalePage = CatalogPageData(
  label: 'Scale',
  title: '間距與尺寸',
  description:
      '10 段精確間距階梯 (space-0.5 到 space-24)、10 段語意間距與 4 段標準控制項尺寸 (SM, MD, LG, XL)。',
  icon: KlpIcons.grid,
  specimens: const [],
  tokenView: (context) {
    final s = context.klp.space;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '10 段精確間距階梯 (Spacing Tokens)',
          description: '以 4px 為基準格，包含極微小貼合到主視覺區塊間距。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'space-0.5 (2px / 0.125rem)',
                value: s.space0_5,
                note: '極微小貼合（如 Focus 外框）',
              ),
              ScaleRow(
                name: 'space-1 (4px / 0.25rem)',
                value: s.space1,
                note: '圖示與文字微小間距、Badge 內邊距',
              ),
              ScaleRow(
                name: 'space-2 (8px / 0.5rem)',
                value: s.space2,
                note: '按鈕內元件間距、小卡片 Padding',
              ),
              ScaleRow(
                name: 'space-3 (12px / 0.75rem)',
                value: s.space3,
                note: '表單內部 Padding、清單間距',
              ),
              ScaleRow(
                name: 'space-4 (16px / 1.0rem)',
                value: s.space4,
                note: '卡片預設 Padding、一般 Gap',
              ),
              ScaleRow(
                name: 'space-6 (24px / 1.5rem)',
                value: s.space6,
                note: '卡片間距、大型 Popover 邊距',
              ),
              ScaleRow(
                name: 'space-8 (32px / 2.0rem)',
                value: s.space8,
                note: '區塊 (Section) 內部垂直 Padding',
              ),
              ScaleRow(
                name: 'space-12 (48px / 3.0rem)',
                value: s.space12,
                note: '大區塊之間的垂直差距',
              ),
              ScaleRow(
                name: 'space-16 (64px / 4.0rem)',
                value: s.space16,
                note: '頁面級別大間距',
              ),
              ScaleRow(
                name: 'space-24 (96px / 6.0rem)',
                value: s.space24,
                note: 'Landing Page 主視覺區塊間距',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '10 段通用語意階梯 (Semantic Spacing Ladder)',
          description: '依據排版意圖命名的語意間距階梯。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'hairline (2px)',
                value: s.hairline,
                note: '極窄微邊距',
              ),
              ScaleRow(name: 'tight (4px)', value: s.tight, note: '緊湊元件內部間距'),
              ScaleRow(
                name: 'compact (8px)',
                value: s.compact,
                note: '緊密相鄰元件間距',
              ),
              ScaleRow(name: 'base (16px)', value: s.base, note: '標準內邊距與間隔'),
              ScaleRow(
                name: 'comfortable (24px)',
                value: s.comfortable,
                note: '舒適留白區塊間距',
              ),
              ScaleRow(name: 'loose (32px)', value: s.loose, note: '寬鬆大區塊間距'),
              ScaleRow(
                name: 'section (32px)',
                value: s.section,
                note: '內容分段標準邊距',
              ),
              ScaleRow(
                name: 'sectionLarge (48px)',
                value: s.sectionLarge,
                note: '大型分段垂直間隔',
              ),
              ScaleRow(name: 'page (64px)', value: s.page, note: '頁面主要留白'),
              ScaleRow(
                name: 'pageLarge (96px)',
                value: s.pageLarge,
                note: '寬螢幕與 Landing 留白',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '元件 4 段尺寸規範 (Component Sizing)',
          description: '標準按鈕與輸入框高度、橫向內邊距與搭配字級。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'Small (SM) - 32px 高度',
                value: s.controlHeightSmall,
                note: '搭配 14px 字級、12px Padding X',
              ),
              ScaleRow(
                name: 'Medium (MD) - 40px 高度',
                value: s.controlHeight,
                note: '預設標準，搭配 16px 字級、16px Padding X',
              ),
              ScaleRow(
                name: 'Large (LG) - 48px 高度',
                value: s.controlHeightLarge,
                note: '主要 CTA，搭配 16/18px 字級、24px Padding X',
              ),
              ScaleRow(
                name: 'XLarge (XL) - 56px 高度',
                value: s.controlHeightXLarge,
                note: 'Hero 試用鈕，搭配 18px 字級、32px Padding X',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '元件尺寸實際範例 (Buttons & Inputs)',
          description: '四段高度 (SM, MD, LG, XL) 按鈕與輸入框的實際對照。文字顏色自動依據背景色階適應。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KlpText('按鈕範例 (Primary & Secondary)', role: KlpTextRole.sub),
              SizedBox(height: s.space2),
              Wrap(
                spacing: s.space4,
                runSpacing: s.space4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  KlpButton(
                    label: 'Primary (SM)',
                    size: KlpControlSize.sm,
                    tone: KlpButtonTone.primary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Primary (MD)',
                    size: KlpControlSize.md,
                    tone: KlpButtonTone.primary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Primary (LG)',
                    size: KlpControlSize.lg,
                    tone: KlpButtonTone.primary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Primary (XL)',
                    size: KlpControlSize.xl,
                    tone: KlpButtonTone.primary,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: s.space3),
              Wrap(
                spacing: s.space4,
                runSpacing: s.space4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  KlpButton(
                    label: 'Secondary (SM)',
                    size: KlpControlSize.sm,
                    tone: KlpButtonTone.secondary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Secondary (MD)',
                    size: KlpControlSize.md,
                    tone: KlpButtonTone.secondary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Secondary (LG)',
                    size: KlpControlSize.lg,
                    tone: KlpButtonTone.secondary,
                    onPressed: () {},
                  ),
                  KlpButton(
                    label: 'Secondary (XL)',
                    size: KlpControlSize.xl,
                    tone: KlpButtonTone.secondary,
                    onPressed: () {},
                  ),
                ],
              ),
              SizedBox(height: s.space6),
              KlpText('輸入框範例 (TextField)', role: KlpTextRole.sub),
              SizedBox(height: s.space2),
              Wrap(
                spacing: s.space4,
                runSpacing: s.space4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  SizedBox(
                    width: 180,
                    child: KlpTextField(
                      placeholder: 'Small (32px)',
                      size: KlpControlSize.sm,
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: KlpTextField(
                      placeholder: 'Medium (40px)',
                      size: KlpControlSize.md,
                    ),
                  ),
                  SizedBox(
                    width: 220,
                    child: KlpTextField(
                      placeholder: 'Large (48px)',
                      size: KlpControlSize.lg,
                    ),
                  ),
                  SizedBox(
                    width: 240,
                    child: KlpTextField(
                      placeholder: 'XLarge (56px)',
                      size: KlpControlSize.xl,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '內距與間隔規範 (Padding & Gap Tokens)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'controlPaddingXSmall',
                value: s.controlPaddingXSmall,
                note: 'SM 橫向內距 12px',
              ),
              ScaleRow(
                name: 'controlPaddingX',
                value: s.controlPaddingX,
                note: 'MD 橫向內距 16px',
              ),
              ScaleRow(
                name: 'controlPaddingXLarge',
                value: s.controlPaddingXLarge,
                note: 'LG 橫向內距 24px',
              ),
              ScaleRow(
                name: 'controlPaddingXXLarge',
                value: s.controlPaddingXXLarge,
                note: 'XL 橫向內距 32px',
              ),
              ScaleRow(
                name: 'controlPaddingY',
                value: s.controlPaddingY,
                note: '垂直內距 8px',
              ),
              ScaleRow(
                name: 'containerPadding',
                value: s.containerPadding,
                note: '容器預設內距 16px',
              ),
              ScaleRow(name: 'itemGap', value: s.itemGap, note: '項目間距 12px'),
              ScaleRow(name: 'groupGap', value: s.groupGap, note: '分組間距 16px'),
            ],
          ),
        ),
        CatalogSample(
          label: '5 段圖示尺寸 (Icon Sizes)',
          description: '依使用場景對齊文字與按鈕比例。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'icon-sm (14px)',
                value: s.iconSmall,
                note: '搭配 12px/14px 次要文字',
              ),
              ScaleRow(
                name: 'icon-base (16px)',
                value: s.iconBase,
                note: '與 16px 內文 1:1 對齊',
              ),
              ScaleRow(name: 'icon-md (20px)', value: s.icon, note: '標準按鈕圖示'),
              ScaleRow(
                name: 'icon-medium (24px)',
                value: s.iconMedium,
                note: '導覽列選單圖示',
              ),
              ScaleRow(
                name: 'icon-lg (32px)',
                value: s.iconLarge,
                note: '功能特色卡片主要圖示',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '外殼與 Chrome 尺寸 (Chrome Dimensions)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'chromeHeader',
                value: s.chromeHeader,
                note: '標題列高度 60px',
              ),
              ScaleRow(
                name: 'chromeStatusBar',
                value: s.chromeStatusBar,
                note: '狀態列高度 30px',
              ),
              ScaleRow(
                name: 'chromeRail',
                value: s.chromeRail,
                note: '側邊導覽軌寬度 56px',
              ),
              ScaleRow(
                name: 'chromeTab',
                value: s.chromeTab,
                note: '分頁高度 32px',
              ),
              ScaleRow(
                name: 'iconButton',
                value: s.iconButton,
                note: '圖示按鈕寬高 32px',
              ),
            ],
          ),
        ),
      ],
    );
  },
);

final radiiPage = CatalogPageData(
  label: 'Radii',
  title: '圓角系統',
  description:
      '0px (none)、2px (sm)、8px (control/card)、16px (panel) 與 9999px (pill)。',
  icon: KlpIcons.box,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '完整圓角規範 (Border Radius)',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              RadiusSample(name: 'radius-none (0px)', value: klp.shape.none),
              RadiusSample(name: 'radius-sm (2px)', value: klp.shape.sm),
              RadiusSample(
                name: 'radius-control (8px)',
                value: klp.shape.control,
              ),
              RadiusSample(name: 'radius-card (8px)', value: klp.shape.card),
              RadiusSample(name: 'radius-panel (16px)', value: klp.shape.panel),
              RadiusSample(name: 'radius-pill (9999px)', value: klp.shape.pill),
            ],
          ),
        ),
        CatalogSample(
          label: '適用元件對照',
          description:
              '2px: Checkbox / 極小標籤\n8px: 標準按鈕 / Input / 卡片\n16px: Modal 彈窗 / 大卡片容器\n9999px: Pill 按鈕 / Avatar / 圓形 Badge',
          child: Wrap(
            spacing: klp.space.base,
            runSpacing: klp.space.base,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KlpCheckbox(
                value: true,
                label: '2px Checkbox',
                onChanged: (_) {},
              ),
              KlpButton(label: '8px 按鈕', onPressed: () {}),
              const KlpBadge(label: '9999px Badge'),
            ],
          ),
        ),
        CatalogSample(
          label: '線寬與虛線 (Stroke & Dashed)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ScaleRow(
                name: 'hairline (1px)',
                value: klp.shape.hairline,
                note: '標準細邊線',
              ),
              ScaleRow(
                name: 'stroke (2px)',
                value: klp.shape.stroke,
                note: '加粗邊框與焦點框',
              ),
              ScaleRow(
                name: 'dashedLength (3px)',
                value: klp.shape.dashedLength,
                note: '虛線每段長度',
              ),
              ScaleRow(
                name: 'dashedGap (2px)',
                value: klp.shape.dashedGap,
                note: '虛線間隔',
              ),
              ScaleRow(
                name: 'dashedOpacity',
                value: klp.shape.dashedOpacity * 100,
                note: '虛線不透明度 (%)',
              ),
            ],
          ),
        ),
      ],
    );
  },
);

final elevationPage = CatalogPageData(
  label: 'Elevation & Surface Effects',
  title: '分層與表面視覺手法',
  description: '不單純依賴陰影。實作單調特殊顏色、結構邊框、霧化透明（毛玻璃）與多種原生 Box 效果。',
  icon: KlpIcons.container,
  specimens: const [],
  tokenView: (context) {
    final klp = context.klp;
    final m = klp.motion;
    return CatalogCanvas(
      children: [
        CatalogSample(
          label: '1. 單調特殊顏色分層 (Monochrome & Toned Surfaces)',
          description: '純粹依靠表面色階明度差或特定語意色塊建立層次，不使用任何邊框與陰影，視覺極簡純粹。',
          child: CatalogGrid(
            minItemWidth: 150,
            children: [
              KlpSurface(
                tone: KlpSurfaceTone.base,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('surface (Base)', role: KlpTextRole.sub),
                      KlpText(
                        '標準面板基底',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.inset,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('surfaceInset', role: KlpTextRole.sub),
                      KlpText(
                        '凹陷輸入／背景區',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.muted,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('surfaceMuted', role: KlpTextRole.sub),
                      KlpText(
                        '選取／次級表面',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.raised,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('surfaceRaised', role: KlpTextRole.sub),
                      KlpText(
                        '浮凸／卡片次級內容',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.stage,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('stageSurface', role: KlpTextRole.sub),
                      KlpText(
                        '舞台展示背景',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.accentSoft,
                radius: klp.shape.card,
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('accentSoft', role: KlpTextRole.sub),
                      KlpText(
                        '柔和強調提示色塊',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '2. 結構邊框手法 (Outline & Stroke Language)',
          description: '利用線寬、顏色對比與方向性線條界定區塊邊界，現代 UI 最推薦的清晰結構手法。',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              KlpSurface(
                tone: KlpSurfaceTone.base,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.divider,
                  width: klp.shape.hairline,
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Hairline Border', role: KlpTextRole.sub),
                      KlpText(
                        '1px 細邊線分層',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.base,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.borderStrong,
                  width: klp.shape.stroke,
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Strong Stroke', role: KlpTextRole.sub),
                      KlpText(
                        '2px 強調結構實線框',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.base,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.divider,
                  width: klp.shape.hairline,
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Row(
                    children: [
                      Container(
                        width: 3,
                        height: 24,
                        decoration: BoxDecoration(
                          color: klp.color.interaction,
                          borderRadius: BorderRadius.circular(klp.shape.pill),
                        ),
                      ),
                      SizedBox(width: klp.space.compact),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            KlpText(
                              'Accent Inset Indicator',
                              role: KlpTextRole.sub,
                            ),
                            KlpText(
                              '內縮浮動強調標記',
                              role: KlpTextRole.caption,
                              tone: KlpTextTone.muted,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.component,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.interaction,
                  width: klp.shape.stroke,
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 72,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Focus Ring Outline', role: KlpTextRole.sub),
                      KlpText(
                        '焦點與選取邊框',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '3. 霧化透明／毛玻璃 (Frosted Glass & Clear Blur)',
          description:
              '利用 BackdropFilter 高斯模糊配合無色彩、低能見度的極輕覆層（alpha 0.12~0.14），呈現通透自然的無色毛玻璃。',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(klp.shape.panel),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(klp.shape.panel),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    klp.color.text.withValues(alpha: 0.16),
                    klp.color.text.withValues(alpha: 0.06),
                    klp.color.text.withValues(alpha: 0.20),
                  ],
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(klp.space.base),
                child: CatalogGrid(
                  minItemWidth: 170,
                  children: [
                    KlpSurface(
                      frosted: true,
                      blurSigma: 12.0,
                      tone: KlpSurfaceTone.transparent,
                      radius: klp.shape.control,
                      border: Border.all(
                        color: klp.color.border.withValues(alpha: 0.12),
                        width: klp.shape.hairline,
                      ),
                      padding: EdgeInsets.all(klp.space.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          KlpText('Clear Glass', role: KlpTextRole.bodyStrong),
                          KlpText(
                            '無色毛玻璃浮層 (12px)',
                            role: KlpTextRole.caption,
                            tone: KlpTextTone.muted,
                          ),
                        ],
                      ),
                    ),
                    KlpSurface(
                      frosted: true,
                      blurSigma: 18.0,
                      tone: KlpSurfaceTone.transparent,
                      radius: klp.shape.control,
                      border: Border.all(
                        color: klp.color.border.withValues(alpha: 0.12),
                        width: klp.shape.hairline,
                      ),
                      padding: EdgeInsets.all(klp.space.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          KlpText(
                            'Subtle Acrylic',
                            role: KlpTextRole.bodyStrong,
                          ),
                          KlpText(
                            '低能見度無色壓克力 (18px)',
                            role: KlpTextRole.caption,
                            tone: KlpTextTone.muted,
                          ),
                        ],
                      ),
                    ),
                    KlpSurface(
                      frosted: true,
                      blurSigma: 24.0,
                      tone: KlpSurfaceTone.transparent,
                      radius: klp.shape.control,
                      border: Border.all(
                        color: klp.color.border.withValues(alpha: 0.12),
                        width: klp.shape.hairline,
                      ),
                      padding: EdgeInsets.all(klp.space.base),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          KlpText(
                            'Deep Blur Glass',
                            role: KlpTextRole.bodyStrong,
                          ),
                          KlpText(
                            '純透深度模糊 (24px)',
                            role: KlpTextRole.caption,
                            tone: KlpTextTone.muted,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        CatalogSample(
          label:
              '4. 原生 Box 進階視覺效果 (Native Box Effects: Gradient, Sheen & Glow)',
          description:
              '運用 Flutter 原生 BoxDecoration 特性：微漸層 (LinearGradient)、頂部微光反射 (Inner Sheen) 與品牌外發光 (Outer Glow)。',
          child: CatalogGrid(
            minItemWidth: 160,
            children: [
              KlpSurface(
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.divider,
                  width: klp.shape.hairline,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [klp.color.surface, klp.color.surfaceInset],
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Subtle Gradient', role: KlpTextRole.sub),
                      KlpText(
                        '自然垂直微漸層表面',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.component,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.divider,
                  width: klp.shape.hairline,
                ),
                shadows: [
                  BoxShadow(
                    color: klp.color.text.withValues(alpha: 0.08),
                    offset: const Offset(0, 1),
                    blurRadius: 0,
                  ),
                ],
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Top Sheen / Bevel', role: KlpTextRole.sub),
                      KlpText(
                        '頂部微光與實體倒角感',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                tone: KlpSurfaceTone.component,
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.interaction,
                  width: klp.shape.hairline,
                ),
                shadows: [
                  BoxShadow(
                    color: klp.color.interaction.withValues(alpha: 0.28),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Interactive Glow', role: KlpTextRole.sub),
                      KlpText(
                        '互動外發光光暈環',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
              KlpSurface(
                radius: klp.shape.card,
                border: Border.all(
                  color: klp.color.borderStrong,
                  width: klp.shape.hairline,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [klp.color.surfaceRaised, klp.color.surface],
                ),
                padding: EdgeInsets.all(klp.space.base),
                child: SizedBox(
                  height: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      KlpText('Composite Card', role: KlpTextRole.sub),
                      KlpText(
                        '對角微漸層 + 結構邊框',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.muted,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '傳統陰影手法（相容性保留，最不推薦）',
          description:
              '目前分層模式：${klp.surface.separation.name}。陰影在暗黑模式易混濁且缺乏明確結構邊界，建議優先採用上方 4 種現代分層手法。',
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
                name: 'scrimOpacity',
                value: klp.surface.scrimOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'selectionWashOpacity',
                value: klp.surface.selectionWashOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'statusFillOpacity',
                value: klp.surface.statusFillOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'pressProgressOpacity',
                value: klp.surface.pressProgressOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'diffFillOpacity',
                value: klp.surface.diffFillOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'gridLineOpacity',
                value: klp.surface.gridLineOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'veilOpacity',
                value: klp.surface.veilOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'frostedOpacity',
                value: klp.surface.frostedOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'frostedVeilOpacity',
                value: klp.surface.frostedVeilOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'statusRowOpacity',
                value: klp.surface.statusRowOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'statusRowSelectedOpacity',
                value: klp.surface.statusRowSelectedOpacity * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'statusRowOpacityDark',
                value: klp.surface.statusRowOpacityDark * 100,
                note: '百分比',
              ),
              ScaleRow(
                name: 'statusRowSelectedOpacityDark',
                value: klp.surface.statusRowSelectedOpacityDark * 100,
                note: '百分比',
              ),
            ],
          ),
        ),
        CatalogSample(
          label: '動畫與時長 (Motion Tokens)',
          description: '全專案統一的動畫時長階梯與狀態轉換時間。',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DurationRow(
                name: 'stateTransition',
                duration: m.stateTransition,
                note: '狀態變化 (hover/focus/pressed) 過場時長 (140ms)',
              ),
              DurationRow(
                name: 'overlayEnter',
                duration: m.overlayEnter,
                note: '選單/浮層/對話框進場時長 (140ms)',
              ),
              DurationRow(
                name: 'overlayExit',
                duration: m.overlayExit,
                note: '選單/浮層/對話框退場時長 (120ms)',
              ),
              DurationRow(
                name: 'toastDwell',
                duration: m.toastDwell,
                note: 'Toast 提示停留時長 (500ms)',
              ),
              DurationRow(
                name: 'tooltipDelay',
                duration: m.tooltipDelay,
                note: 'Tooltip 懸停延遲時長 (450ms)',
              ),
              DurationRow(
                name: 'longPressThreshold',
                duration: m.longPressThreshold,
                note: '長按判定門檻時長 (500ms)',
              ),
            ],
          ),
        ),
      ],
    );
  },
);
