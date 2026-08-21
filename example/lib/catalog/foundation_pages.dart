import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

/// 給需要固定尺寸才看得出行為的元件用。
Widget _boxed(BuildContext context, double height, Widget child) => SizedBox(
  height: height,
  child: KlpSurface(
    tone: KlpSurfaceTone.transparent,
    padding: EdgeInsets.all(context.klp.space.compact),
    child: child,
  ),
);

final actionsNavigationPage = CatalogPageData(
  label: 'Actions & Navigation',
  title: '動作與導覽',
  description: '觸發動作與切換位置。庫提供元件，不決定有哪些動作與哪些位置。',
  icon: KlpIcons.switchVertical,
  specimens: [
    Specimen(
      name: 'KlpButton',
      note: 'tone 決定語意強度，size 支援 SM (32px), MD (40px), LG (48px), XL (56px)。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          runSpacing: klp.space.compact,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final tone in KlpButtonTone.values)
              KlpButton(label: tone.name, onPressed: () {}, tone: tone),
            KlpButton(label: 'disabled', onPressed: null),
            KlpButton(
              label: 'SM (32px)',
              size: KlpControlSize.sm,
              onPressed: () {},
            ),
            KlpButton(
              label: 'MD (40px)',
              size: KlpControlSize.md,
              onPressed: () {},
            ),
            KlpButton(
              label: 'LG (48px)',
              size: KlpControlSize.lg,
              onPressed: () {},
            ),
            KlpButton(
              label: 'XL (56px)',
              size: KlpControlSize.xl,
              onPressed: () {},
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpIconButton',
      note: 'label 必填且用於無障礙標註——沒有 label 的圖示按鈕對螢幕閱讀器等於不存在。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          children: [
            KlpIconButton(icon: KlpIcons.check, label: '確認', onPressed: () {}),
            KlpIconButton(
              icon: KlpIcons.trash,
              label: '刪除',
              onPressed: () {},
              selected: true,
            ),
            KlpIconButton(icon: KlpIcons.edit, label: '編輯', onPressed: null),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpActionGroup',
      note: '一組相鄰的動作。',
      build: (context) => KlpActionGroup(
        children: [
          KlpButton(label: '取消', onPressed: () {}),
          KlpButton(label: '套用', onPressed: () {}, tone: KlpButtonTone.primary),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTabs',
      note: '分頁列。不持有狀態。',
      build: (context) => KlpTabs(
        tabs: const ['總覽', '設定', '記錄'],
        selected: 0,
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpBreadcrumb',
      note: '路徑。層級由呼叫端給定。',
      build: (context) =>
          KlpBreadcrumb(segments: const ['專案', '模組', '檔案'], onSelected: (_) {}),
    ),
    Specimen(
      name: 'KlpPagination',
      note: '分頁切換。標籤必填——庫不決定用什麼語言說「上一頁」。',
      build: (context) => KlpPagination(
        page: 2,
        pageCount: 9,
        previousLabel: '上一頁',
        nextLabel: '下一頁',
        onPageChanged: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpViewSwitcher',
      note: '檢視模式切換。',
      build: (context) => KlpViewSwitcher(
        options: const [
          KlpViewOption(id: 'list', label: '清單'),
          KlpViewOption(id: 'grid', label: '格狀'),
        ],
        selectedId: 'list',
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpRailItem',
      note: '側邊軌上的一項。',
      build: (context) => SizedBox(
        width: 200,
        child: KlpRailItem(
          icon: KlpIcons.folder,
          label: '檔案',
          onPressed: () {},
        ),
      ),
    ),
    Specimen(
      name: 'KlpSidebarSectionLabel',
      note: '側邊欄的分組標題。',
      build: (context) => const KlpSidebarSectionLabel(label: 'PINNED'),
    ),
    Specimen(
      name: 'KlpMenu',
      note: '選單面板。彈出時機由呼叫端決定。',
      build: (context) => SizedBox(
        width: 220,
        child: KlpMenu(
          label: '動作',
          items: [
            KlpMenuItemData(label: '重新命名', onPressed: () {}),
            KlpMenuItemData(label: '複製', onPressed: () {}),
            KlpMenuItemData(label: '刪除', onPressed: () {}),
          ],
        ),
      ),
    ),
    Specimen(
      name: 'KlpMenuItem',
      note: '選單的單一項目。',
      build: (context) => SizedBox(
        width: 220,
        child: KlpMenuItem(
          data: KlpMenuItemData(
            label: '重新命名',
            icon: KlpIcons.edit,
            onPressed: () {},
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpCommandMenu',
      note: '指令面板。分組與項目由呼叫端提供。',
      build: (context) => SizedBox(
        width: 320,
        child: KlpCommandMenu(
          sections: [
            KlpCommandSectionData(
              label: '最近',
              items: [
                KlpCommandItemData(label: '開啟檔案', shortcut: 'Ctrl+O'),
                KlpCommandItemData(label: '搜尋', shortcut: 'Ctrl+F'),
              ],
            ),
          ],
        ),
      ),
    ),
    Specimen(
      name: 'KlpEditorToolbar',
      note: '編輯器工具列。',
      build: (context) => KlpEditorToolbar(
        actions: [
          KlpEditorActionData(label: '粗體', onPressed: () {}),
          KlpEditorActionData(label: '斜體', onPressed: () {}),
        ],
      ),
    ),
    Specimen(
      name: 'KlpBulkActionBar',
      note: '多選後的批次動作列。',
      build: (context) => KlpBulkActionBar(
        label: '已選取 3 項',
        actions: [KlpEditorActionData(label: '刪除', onPressed: () {})],
      ),
    ),
    Specimen(
      name: 'KlpSearchNavigator',
      note: '搜尋結果的上一筆／下一筆。',
      build: (context) => KlpSearchNavigator(
        initialQuery: 'token',
        current: 2,
        total: 14,
        onPrevious: () {},
        onNext: () {},
        onClose: () {},
      ),
    ),
    Specimen(
      name: 'KlpRouterOutlet',
      note: '渲染 router 目前的目的地。需要 KlpRouterScope 才能運作，因此不在此展示。',
    ),
  ],
);

final dataDisplayPage = CatalogPageData(
  label: 'Data Display',
  title: '資料呈現',
  description: '把資料畫出來。這些元件不知道資料從哪來，也不決定它的意義。',
  icon: KlpIcons.grid,
  specimens: [
    Specimen(
      name: 'KlpIcon',
      note: '隨套件散佈的 SVG。size 為 null 時沿用 theme 的圖示尺寸。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.base,
          children: [
            for (final icon in const [
              KlpIcons.archive,
              KlpIcons.bookmark,
              KlpIcons.box,
              KlpIcons.calendar,
              KlpIcons.clipboard,
              KlpIcons.container,
              KlpIcons.cpu,
              KlpIcons.edit,
              KlpIcons.eye,
              KlpIcons.folder,
              KlpIcons.grid,
              KlpIcons.inbox,
              KlpIcons.pencil,
              KlpIcons.search,
              KlpIcons.settings,
              KlpIcons.sparkles,
              KlpIcons.infoSquare,
              KlpIcons.trash,
            ])
              KlpIcon(icon),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpBadge',
      note: '狀態標記（支援 filled、outline、solid 與語意色）。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: const [
            KlpBadge(label: 'draft', variant: KlpBadgeVariant.outline),
            KlpBadge(
              label: 'accepted',
              tone: KlpFeedbackTone.success,
              variant: KlpBadgeVariant.outline,
            ),
            KlpBadge(
              label: 'rejected',
              tone: KlpFeedbackTone.danger,
              variant: KlpBadgeVariant.outline,
            ),
            KlpBadge(label: '3', variant: KlpBadgeVariant.solid),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpTag',
      note: '可移除或分類標籤（支援 # 前綴符號）。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          children: [
            KlpTag(label: 'backend', prefix: '#', onRemove: () {}),
            KlpTag(label: 'schema', prefix: '#', onRemove: () {}),
            const KlpTag(label: 'design'),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpListTile',
      note: '清單的一列。',
      build: (context) => const KlpListTile(
        title: '設計 token',
        subtitle: '三層繼承樹',
        icon: KlpIcons.container,
      ),
    ),
    Specimen(
      name: 'KlpKeyValueList',
      note: '鍵值清單（支援等寬字型、複製按鈕與自訂寬度）。',
      build: (context) => KlpKeyValueList(
        rows: const [
          KlpKeyValueItem(
            id: 'res_id',
            label: 'Resource ID',
            value: KlpText('page_9f3ac221', role: KlpTextRole.code),
            verbatim: true,
          ),
          KlpKeyValueItem(
            id: 'created',
            label: 'Created',
            value: KlpText('2026-06-30 14:02'),
          ),
          KlpKeyValueItem(
            id: 'author',
            label: 'Author',
            value: KlpText('Kevin Eng'),
          ),
          KlpKeyValueItem(
            id: 'checksum',
            label: 'Checksum',
            value: KlpText('sha256 9f3a4b...c221', role: KlpTextRole.code),
            verbatim: true,
            copyable: true,
          ),
        ],
        onCopy: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpKeyValueTable',
      note: '鍵值表，可標記 verbatim（等寬）與可複製。',
      build: (context) => const KlpKeyValueTable(
        rows: [
          KlpKeyValueRowData(label: '路徑', value: 'lib/src'),
          KlpKeyValueRowData(label: '負責人', value: 'chiayu'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpDataTable',
      note: '資料表（支援複選框、首列表頭、排序箭頭與等寬識別碼）。',
      build: (context) => KlpDataTable(
        selectable: true,
        selectedIds: const {},
        sort: const KlpDataSort(
          columnId: 'result',
          direction: KlpSortDirection.ascending,
        ),
        columns: const [
          KlpDataColumn(id: 'result', label: 'RESULT', sortable: true),
          KlpDataColumn(id: 'status', label: 'STATUS'),
          KlpDataColumn(id: 'run', label: 'RUN', verbatim: true),
        ],
        rows: const [
          KlpDataRow(
            id: '1',
            cells: {
              'result': 'Schema validation',
              'status': '✓ SUCCESS',
              'run': 'run_4a91',
            },
          ),
          KlpDataRow(
            id: '2',
            cells: {
              'result': 'Connector round-trip',
              'status': '✕ FAILURE',
              'run': 'run_4a92',
            },
          ),
          KlpDataRow(
            id: '3',
            cells: {
              'result': 'Diff approval',
              'status': '↻ WAITING',
              'run': 'run_4a93',
            },
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTree',
      note: '樹狀清單（支援虛線選取外框、展開/收合與劃線刪除標記）。',
      build: (context) => const KlpTree(
        nodes: [
          KlpTreeNode(
            id: 'eng',
            label: 'Engineering',
            expanded: true,
            children: [
              KlpTreeNode(
                id: 'arch',
                label: 'Architecture decisio...',
                selected: true,
              ),
              KlpTreeNode(id: 'api', label: 'API schema draft'),
              KlpTreeNode(id: 'dep', label: 'Deprecated notes', deleted: true),
            ],
          ),
          KlpTreeNode(
            id: 'meet',
            label: 'Meetings',
            expanded: false,
            children: [KlpTreeNode(id: 'sync', label: 'Weekly sync')],
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTreeItem',
      note: '樹的單一節點（含選取高亮與語意標籤）。',
      build: (context) => const KlpTreeItem(
        node: KlpTreeNode(
          id: 'item',
          label: '匯入報告加上逐...',
          icon: KlpIcons.checkSquare,
          badge: 'STALE',
          tone: KlpFeedbackTone.info,
          selected: true,
        ),
      ),
    ),
    Specimen(
      name: 'KlpFilePreview',
      note: '檔案預覽卡。',
      build: (context) => const KlpFilePreview(
        name: 'inventory.md',
        metadata: '18 KB · markdown',
      ),
    ),
    Specimen(
      name: 'KlpProgress',
      note: '進度條。',
      build: (context) => const KlpProgress(value: 0.62),
    ),
    Specimen(
      name: 'KlpSegmentedProgress',
      note: '分段進度。',
      build: (context) => const KlpSegmentedProgress(value: 3, segments: 5),
    ),
    Specimen(
      name: 'KlpAvatar',
      note: '頭像。沒有圖片時以文字縮寫呈現。',
      build: (context) => const KlpAvatar(label: 'CY'),
    ),
    Specimen(
      name: 'KlpAvatarGroup',
      note: '一組重疊的頭像。',
      build: (context) => const KlpAvatarGroup(
        avatars: [
          KlpAvatarData(id: 'a', label: 'CY'),
          KlpAvatarData(id: 'b', label: 'MD'),
        ],
      ),
    ),
    Specimen(
      name: 'KlpStatusIndicator',
      note: '狀態指示符（支援 running, success, failure, waiting, idle 與語意符號）。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.comfortable,
          children: const [
            KlpStatusIndicator(label: 'RUNNING', kind: KlpStatusKind.running),
            KlpStatusIndicator(label: 'SUCCESS', kind: KlpStatusKind.check),
            KlpStatusIndicator(label: 'FAILURE', kind: KlpStatusKind.cross),
            KlpStatusIndicator(label: 'WAITING', kind: KlpStatusKind.waiting),
            KlpStatusIndicator(label: 'IDLE', kind: KlpStatusKind.circle),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpMetricCard',
      note: '核心指標卡片（支援數值趨勢、違規告警紅框與自訂進度）。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.base,
          runSpacing: klp.space.base,
          children: [
            const SizedBox(
              width: 160,
              child: KlpMetricCard(
                label: 'PASS RATE',
                value: '98.2',
                unit: '%',
                trend: '↑',
                subtitle: 'Threshold 95%',
              ),
            ),
            const SizedBox(
              width: 160,
              child: KlpMetricCard(
                label: 'P95 LATENCY',
                value: '1420',
                unit: 'ms',
                trend: '↑',
                subtitle: 'Breached · threshold 800ms',
                tone: KlpFeedbackTone.danger,
              ),
            ),
            SizedBox(
              width: 160,
              child: KlpMetricCard(
                label: 'COVERAGE',
                child: Container(
                  height: 18,
                  decoration: BoxDecoration(
                    color: context.klpColors.surfaceInset,
                    borderRadius: BorderRadius.circular(klp.shape.control),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpAccordion',
      note: '可摺疊的內容區。預設單開；multiple 時各項互不影響。',
      build: (context) => KlpAccordion(
        items: [
          KlpAccordionItemData(
            id: 'scope',
            title: '範圍',
            subtitle: '這一版涵蓋什麼',
            child: const KlpText('三個資料呈現元件：accordion、stepper、timeline。'),
          ),
          KlpAccordionItemData(
            id: 'rules',
            title: '規則',
            child: const KlpText('顏色、間距、圓角一律取自 context.klp。'),
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpStepper',
      note: '步驟流程指示。已完成／進行中／未開始三態由 currentIndex 推導。',
      build: (context) => const KlpStepper(
        steps: [
          KlpStepData(label: '建立'),
          KlpStepData(label: '審核', description: '待負責人確認'),
          KlpStepData(label: '完成'),
        ],
        currentIndex: 1,
      ),
    ),
    Specimen(
      name: 'KlpTimeline',
      note: '事件依序排列，每項有標記、標題、時間、可選內容。',
      build: (context) => const KlpTimeline(
        items: [
          KlpTimelineItemData(title: '建立草稿', time: '09:00'),
          KlpTimelineItemData(title: '送出審核', time: '10:30'),
          KlpTimelineItemData(title: '核准', time: '14:00', highlighted: true),
        ],
      ),
    ),
  ],
);

final layoutInteractionPage = CatalogPageData(
  label: 'Layout & Interaction',
  title: '版面與互動',
  description: '外殼、分割、捲動與指標行為。',
  icon: KlpIcons.collapse,
  specimens: [
    Specimen(
      name: 'KlpPressable',
      note: '所有可點擊元件的互動基底。hover 與 pressed 的色彩混合比例來自 theme。',
      build: (context) => KlpPressable(
        onPressed: () {},
        child: KlpSurface(
          tone: KlpSurfaceTone.component,
          padding: EdgeInsets.all(context.klp.space.base),
          child: const KlpText('hover 我'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpTooltip',
      note: '停留提示。等待時間取自 theme 的 motion.tooltipDelay。',
      build: (context) => const KlpTooltip(
        message: '這是提示',
        child: KlpBadge(label: 'hover'),
      ),
    ),
    Specimen(
      name: 'KlpTooltipSurface',
      note: 'tooltip 的表面本身。',
      build: (context) => const KlpTooltipSurface(message: '提示內容'),
    ),
    Specimen(
      name: 'KlpPopover',
      note: '浮出的內容容器。',
      build: (context) => const KlpPopover(child: KlpText('popover 內容')),
    ),
    Specimen(
      name: 'KlpDialog',
      note: '對話框內容。不負責彈出——呼叫端自行決定呈現方式。',
      build: (context) => SizedBox(
        width: 380,
        child: KlpDialog(
          label: 'CONFIRM',
          title: '刪除這個區塊？',
          primaryLabel: '刪除',
          secondaryLabel: '取消',
          onPrimary: () {},
          child: const KlpText('這個動作無法復原。'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpDrawer',
      note:
          '從邊緣滑入的面板；bottom 方向即一般所稱的 sheet。不負責彈出——呼叫端持有 '
          'open 狀態並決定用什麼容器承載，本元件只負責滑入動畫、遮罩與點遮罩關閉。',
      build: (context) => _boxed(
        context,
        160,
        ClipRect(
          child: KlpDrawer(
            open: true,
            edge: KlpDrawerEdge.right,
            size: 200,
            onScrimTap: () {},
            child: Padding(
              padding: EdgeInsets.all(context.klp.space.compact),
              child: const KlpText('面板內容'),
            ),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpContextMenu',
      note: '右鍵選單。掛在任意子樹上，右鍵或觸控長按於指標位置彈出。選單本體重用 KlpMenu。',
      build: (context) => KlpContextMenu(
        label: '動作',
        items: [
          KlpMenuItemData(label: '重新命名', onPressed: () {}),
          KlpMenuItemData(label: '刪除', onPressed: () {}),
        ],
        child: KlpSurface(
          tone: KlpSurfaceTone.component,
          padding: EdgeInsets.all(context.klp.space.base),
          child: const KlpText('右鍵點擊我'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpSplitLayout',
      note: '三欄分割與拖曳虛線分隔線。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpText(
              'PLNSPLITLAYOUT · DRAG THE DIVIDERS (KEYBOARD: FOCUS + ARROWS)',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
            SizedBox(height: klp.space.compact),
            KlpSurface(
              tone: KlpSurfaceTone.inset,
              border: Border.all(
                color: klp.color.divider,
                width: klp.shape.hairline,
              ),
              padding: EdgeInsets.all(klp.space.compact),
              child: SizedBox(
                height: 140,
                child: KlpSplitLayout(
                  leadingWidth: 90,
                  trailingWidth: 90,
                  showDashedDivider: true,
                  leading: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(
                        'navigation',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.tight),
                      const KlpText('Page tree'),
                    ],
                  ),
                  center: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(
                        'stage',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.tight),
                      const KlpText('Resource surface'),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KlpText(
                        'inspector',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.tight),
                      const KlpText('Selection projection'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpResizablePane',
      note: '可調整大小的側邊或底部面版。',
      build: (context) => Container(
        height: 80,
        alignment: Alignment.center,
        color: context.klp.color.surfaceInset,
        child: const KlpText('Resizable Content Area'),
      ),
    ),
    Specimen(
      name: 'KlpResizeHandle',
      note: '分割面板拖曳調整把手。',
      build: (context) => Container(
        height: 24,
        alignment: Alignment.center,
        child: const KlpText('╌╌╌╌╌╌', role: KlpTextRole.code),
      ),
    ),
    Specimen(
      name: 'KlpScrollViewport',
      note: '捲動視口與滾動條容器。',
      build: (context) => SizedBox(
        height: 80,
        child: SingleChildScrollView(
          child: Column(
            children: List.generate(
              5,
              (i) => KlpText('Scroll row $i', role: KlpTextRole.caption),
            ),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpFilterBar',
      note: '篩選列。',
      build: (context) => KlpFilterBar(
        filters: const [
          KlpFilterOption(
            id: 'status',
            label: 'status',
            value: 'failed',
            removable: true,
          ),
        ],
        selectedId: 'status',
        onSelected: (_) {},
        onRemove: (_) {},
        onAddFilter: () {},
        onClearAll: () {},
      ),
    ),
    Specimen(
      name: 'KlpSelectionToolbar',
      note: '批次選取操作列。',
      build: (context) => KlpSelectionToolbar(
        count: 3,
        countLabel: '3 results selected',
        actions: [
          KlpSelectionAction(
            id: 'assign',
            label: 'Assign reviewer',
            onPressed: () {},
          ),
          KlpSelectionAction(id: 'approve', label: 'Approve', onPressed: () {}),
          KlpSelectionAction(
            id: 'trash',
            label: 'Trash',
            danger: true,
            onPressed: () {},
          ),
        ],
        onClear: () {},
        clearLabel: 'Clear',
      ),
    ),
    Specimen(
      name: 'KlpSortControl',
      note: '排序控制項。',
      build: (context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.klp.space.compact,
          vertical: context.klp.space.tight,
        ),
        decoration: BoxDecoration(
          color: context.klp.color.surfaceInset,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          border: Border.all(
            color: context.klp.color.divider,
            width: context.klp.shape.hairline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const KlpText('Last updated ▾', role: KlpTextRole.caption),
            SizedBox(width: context.klp.space.tight),
            const KlpText('↓', role: KlpTextRole.code),
          ],
        ),
      ),
    ),
    Specimen(
      name: 'KlpVirtualList',
      note: '長清單虛擬捲動 (10,000 ROWS)。',
      build: (context) {
        final klp = context.klp;
        return SizedBox(
          height: 120,
          child: KlpVirtualList(
            itemCount: 10000,
            itemBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${index.toString().padLeft(5, '0')} ',
                      style: TextStyle(color: klp.color.textMuted),
                    ),
                    const TextSpan(text: 'event.node.completed'),
                  ],
                ),
                style: TextStyle(
                  fontFamily: klp.type.monoFamily,
                  fontFamilyFallback: klp.type.monoFallback,
                  fontSize: klp.type.caption,
                ),
              ),
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpVirtualGrid',
      note: '九欄虛擬格狀佈局。',
      build: (context) {
        final klp = context.klp;
        return SizedBox(
          height: 120,
          child: KlpVirtualGrid(
            itemCount: 18,
            crossAxisCount: 9,
            spacing: klp.space.tight,
            itemBuilder: (context, index) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: klp.color.surfaceMuted,
                borderRadius: BorderRadius.circular(klp.shape.control),
              ),
              child: KlpText(
                '$index',
                role: KlpTextRole.code,
                tone: KlpTextTone.muted,
              ),
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpDragPreview',
      note: '拖曳預覽卡片。',
      build: (context) => KlpSurface(
        tone: KlpSurfaceTone.component,
        padding: EdgeInsets.symmetric(
          horizontal: context.klp.space.compact,
          vertical: context.klp.space.tight,
        ),
        radius: context.klp.shape.control,
        child: const KlpText(
          'Architecture decisions +2',
          role: KlpTextRole.caption,
        ),
      ),
    ),
    Specimen(
      name: 'KlpDropTarget',
      note: '拖曳放置目標區。',
      build: (context) => SizedBox(
        width: 180,
        height: 64,
        child: KlpDashedBorder(
          radius: context.klp.shape.card,
          child: Container(
            color: context.klp.color.surfaceInset,
            alignment: Alignment.center,
            child: const KlpText(
              'Asset upload zone',
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpDropIndicator',
      note: '放置位置指示線。',
      build: (context) => Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: context.klp.color.text,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(child: Container(height: 2, color: context.klp.color.text)),
        ],
      ),
    ),
    Specimen(
      name: 'KlpPresenceIndicator',
      note: '多人協同在線狀態指示點與標記。',
      build: (context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: context.klp.color.success,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: context.klp.space.tight),
          const KlpText(
            'RT SL 1 editing',
            role: KlpTextRole.code,
            tone: KlpTextTone.muted,
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpShortcutHint',
      note: '快捷鍵提示標籤。',
      build: (context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.klp.space.tight,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: context.klp.color.surfaceInset,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
          border: Border.all(
            color: context.klp.color.divider,
            width: context.klp.shape.hairline,
          ),
        ),
        child: const KlpText('⌘K', role: KlpTextRole.code),
      ),
    ),
    Specimen(
      name: 'KlpOverlayHost',
      note: '浮層頂層掛載宿主。',
      build: (context) => const SizedBox.shrink(),
    ),
    Specimen(
      name: 'KlpApp',
      note:
          '消費者的接入點：包住 MaterialApp，套好亮暗兩套 theme 與 router，'
          '並把主題過場關成 Duration.zero。這裡巢狀示範一個最小的 KlpApp。',
      build: (context) => _boxed(
        context,
        120,
        const KlpApp(
          home: KlpAppScreen(child: Center(child: KlpText('KlpApp'))),
        ),
      ),
    ),
    Specimen(
      name: 'KlpAppScreen',
      note: '應用最外層。同時提供整個子樹所需的 Material 祖先。',
      build: (context) => _boxed(
        context,
        120,
        const KlpAppScreen(
          child: KlpPanelFrame(
            header: KlpPanelHeader(title: '應用外殼'),
            content: Center(child: KlpText('app screen')),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpAppWindowHeader',
      note: '自訂視窗標題列。',
      build: (context) => const KlpAppWindowHeader(title: 'Kallopis'),
    ),
    Specimen(
      name: 'KlpWindowControls',
      note: '最小化／最大化／視窗化（向下還原）／關閉。支援 isMaximized 切換還原與最大化圖示。',
      build: (context) {
        var isMaximized = false;
        return StatefulBuilder(
          builder: (context, setState) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              KlpWindowControls(
                isMaximized: isMaximized,
                onMinimize: () {},
                onToggleMaximize: () =>
                    setState(() => isMaximized = !isMaximized),
                onClose: () {},
              ),
              const SizedBox(width: 32),
              KlpWindowControls(
                isMaximized: true,
                onMinimize: () {},
                onToggleMaximize: () {},
                onClose: () {},
              ),
            ],
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpWindowHeader',
      note: '自帶視窗標題列（支援 Windows 左側圖示/標題與 macOS 置中標題/左側控制鈕）。',
      build: (context) {
        final klp = context.klp;
        return Column(
          children: [
            KlpWindowHeader(
              titleText: 'Planist (Windows)',
              platform: TargetPlatform.windows,
              appIcon: const FlutterLogo(size: 14.0),
              onMinimize: () {},
              onToggleMaximize: () {},
              onClose: () {},
            ),
            SizedBox(height: klp.space.compact),
            KlpWindowHeader(
              titleText: 'Planist (macOS)',
              platform: TargetPlatform.macOS,
              appIcon: const FlutterLogo(size: 14.0),
              onMinimize: () {},
              onToggleMaximize: () {},
              onClose: () {},
            ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpPanelHeader',
      note: '面板標題列。',
      build: (context) => const KlpPanelHeader(title: '面板'),
    ),
    Specimen(
      name: 'KlpPanelFrame',
      note: '通用面板：header 與 content，高度預設沿用 theme 的外殼密度。',
      build: (context) => _boxed(
        context,
        140,
        const KlpPanelFrame(
          header: KlpPanelHeader(title: '面板'),
          content: KlpText('內容'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpStageFrame',
      note: '舞台區：header、content、選用的 status 列。',
      build: (context) => _boxed(
        context,
        140,
        const KlpStageFrame(
          header: KlpPanelHeader(title: '舞台'),
          content: KlpText('內容'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpSidebarFrame',
      note: '側邊欄：header、rail、content。',
      build: (context) => _boxed(
        context,
        160,
        const KlpSidebarFrame(
          header: KlpPanelHeader(title: '導覽'),
          rail: Column(
            children: [
              KlpIcon(KlpIcons.folder),
              SizedBox(height: 8),
              KlpIcon(KlpIcons.box),
            ],
          ),
          content: KlpText('內容'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpStatusBar',
      note: '底部狀態列。',
      build: (context) =>
          const KlpStatusBar(leading: 'ready', trailing: 'UTF-8'),
    ),
    Specimen(
      name: 'KlpWorkbenchShell',
      note: '三欄工作區外殼，兩側可拖曳並依斷點自動收合。',
      build: (context) => _boxed(
        context,
        240,
        const KlpWorkbenchShell(
          primary: KlpPanelFrame(
            header: KlpPanelHeader(title: '導覽'),
            content: Center(child: KlpText('primary')),
          ),
          stage: KlpStageFrame(
            header: KlpPanelHeader(title: '舞台'),
            content: Center(child: KlpText('stage')),
          ),
          secondary: KlpPanelFrame(
            header: KlpPanelHeader(title: '屬性'),
            content: Center(child: KlpText('secondary')),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpPaneCollapseControl',
      note: '面板與側邊欄收合切換鈕，支援各向版面圖示與 Hover 狀態。',
      build: (context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          KlpPaneCollapseControl(
            icon: KlpIcons.panelLeft,
            label: '左側面板',
            collapsed: false,
            onToggle: () {},
          ),
          const SizedBox(width: 8),
          KlpPaneCollapseControl(
            icon: KlpIcons.panelSplit,
            label: '分割面板',
            collapsed: false,
            onToggle: () {},
          ),
          const SizedBox(width: 8),
          KlpPaneCollapseControl(
            icon: KlpIcons.panelBottom,
            label: '底部面板',
            collapsed: false,
            onToggle: () {},
          ),
          const SizedBox(width: 8),
          KlpPaneCollapseControl(
            icon: KlpIcons.panelRight,
            label: '右側面板',
            collapsed: false,
            onToggle: () {},
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpResponsivePaneCoordinator',
      note: '依可用寬度在 wide／compact 之間切換。斷點是版面預設值，不隨風格改變。',
      build: (context) => _boxed(
        context,
        160,
        const KlpResponsivePaneCoordinator(
          wide: KlpPanelFrame(
            header: KlpPanelHeader(title: '寬版面'),
            content: Center(child: KlpText('wide')),
          ),
          compact: KlpPanelFrame(
            header: KlpPanelHeader(title: '窄版面'),
            content: Center(child: KlpText('compact')),
          ),
        ),
      ),
    ),
  ],
);

final regionPlaceholderPage = CatalogPageData(
  label: 'Region placeholder',
  title: '區域佔位',
  description: '尚未實作的區域。它必須看起來就是「還沒做」，不能像壞掉。',
  icon: KlpIcons.slash,
  specimens: [
    Specimen(
      name: 'KlpRegionPlaceholder',
      note: '包含斜線填充、動作按鈕、狀態標記與無斜線純色四種狀態。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KlpText(
              'IN A SESSION PANEL — BELOW THE LIVE STREAM',
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
            SizedBox(height: klp.space.compact),
            KlpSurface(
              tone: KlpSurfaceTone.inset,
              border: Border.all(
                color: klp.color.divider,
                width: klp.shape.hairline,
              ),
              padding: EdgeInsets.all(klp.space.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KlpText(
                    '# LIVE EXECUTION',
                    role: KlpTextRole.code,
                    tone: KlpTextTone.muted,
                  ),
                  SizedBox(height: klp.space.compact),
                  KlpSurface(
                    tone: KlpSurfaceTone.component,
                    border: Border.all(
                      color: klp.color.divider,
                      width: klp.shape.hairline,
                    ),
                    padding: EdgeInsets.all(klp.space.base),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KlpText(
                          'agent> reading 42 files in src/components',
                          role: KlpTextRole.code,
                        ),
                        SizedBox(height: klp.space.tight),
                        KlpText(
                          'agent> applying codemod react-19-upgrade',
                          role: KlpTextRole.code,
                        ),
                        SizedBox(height: klp.space.tight),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '+218 ',
                                style: TextStyle(
                                  color: klp.color.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: '-96 ',
                                style: TextStyle(
                                  color: klp.color.danger,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: 'across 42 files',
                                style: TextStyle(color: klp.color.textMuted),
                              ),
                            ],
                          ),
                          style: TextStyle(
                            fontFamily: klp.type.monoFamily,
                            fontFamilyFallback: klp.type.monoFallback,
                            fontSize: klp.type.caption,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: klp.space.base),
                  const KlpRegionPlaceholder(
                    label: 'stream view',
                    kindLabel: 'placeholder',
                    minHeight: 140,
                  ),
                ],
              ),
            ),
            SizedBox(height: klp.space.section),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KlpText(
                        'PENDING',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.compact),
                      const KlpRegionPlaceholder(
                        tone: KlpRegionPlaceholderTone.pending,
                        label: 'diff view',
                        kindLabel: 'pending',
                        detail: 'Waiting for the first frame from the run.',
                        minHeight: 140,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: klp.space.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KlpText(
                        'WITH AN ACTION',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.compact),
                      KlpRegionPlaceholder(
                        tone: KlpRegionPlaceholderTone.neutral,
                        label: 'chart slot',
                        kindLabel: 'placeholder',
                        detail: 'No series bound to this panel yet.',
                        actionLabel: 'Bind a query',
                        onAction: () {},
                        minHeight: 140,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: klp.space.base),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      KlpText(
                        'FLAT — NO HATCH',
                        role: KlpTextRole.code,
                        tone: KlpTextTone.muted,
                      ),
                      SizedBox(height: klp.space.compact),
                      const KlpRegionPlaceholder(
                        hatched: false,
                        label: 'preview',
                        kindLabel: 'reserved',
                        minHeight: 140,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ),
  ],
);

final viewStatesPage = CatalogPageData(
  label: 'View States & Feedback',
  title: '檢視狀態與回饋',
  description: '載入、空、錯誤、無權限，以及短暫通知。文案一律由呼叫端提供。',
  icon: KlpIcons.infoSquare,
  specimens: [
    Specimen(
      name: 'KlpGeometricSpinner',
      note: '幾何圖案載入動畫。具備現代科技感與精確的幾何對稱律動。',
      build: (context) => const KlpGeometricSpinner(),
    ),
    Specimen(
      name: 'KlpLoadingState',
      note: '載入中狀態。使用幾何圖案動畫。',
      build: (context) => const KlpLoadingState(label: '載入中'),
    ),
    Specimen(
      name: 'KlpEmptyState',
      note: '空集合。',
      build: (context) => const KlpEmptyState(
        icon: KlpIcons.inbox,
        title: '沒有項目',
        message: '建立第一個項目後會出現在這裡。',
      ),
    ),
    Specimen(
      name: 'KlpErrorState',
      note: '錯誤。',
      build: (context) =>
          const KlpErrorState(title: '載入失敗', message: '連線逾時，請稍後再試。'),
    ),
    Specimen(
      name: 'KlpPermissionState',
      note: '無權限。',
      build: (context) =>
          const KlpPermissionState(title: '沒有存取權', message: '請向擁有者要求權限。'),
    ),
    Specimen(
      name: 'KlpSkeletonLine',
      note: '載入骨架。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const KlpSkeletonLine(),
            SizedBox(height: klp.space.tight),
            const KlpSkeletonLine(width: 220),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpProgressOverlay',
      note: '覆蓋在內容上的進度遮罩。',
      build: (context) => _boxed(
        context,
        160,
        const KlpProgressOverlay(
          visible: true,
          label: '處理中',
          child: KlpRegion(content: Center(child: KlpText('底下的內容'))),
        ),
      ),
    ),
    Specimen(
      name: 'KlpInlineNotice',
      note: '行內提示。tone 決定語意色。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final tone in KlpFeedbackTone.values)
              Padding(
                padding: EdgeInsets.only(bottom: klp.space.compact),
                child: KlpInlineNotice(title: tone.name, tone: tone),
              ),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpToast',
      note: '短暫通知。停留時間取自 theme，但顯示與收起由呼叫端控制。',
      build: (context) => KlpToast(
        title: '已儲存',
        message: '變更已寫入本機。',
        closeLabel: '關閉',
        onClose: () {},
      ),
    ),
    Specimen(
      name: 'KlpToastStack',
      note: '一疊 toast。',
      build: (context) => const KlpToastStack(
        children: [
          KlpToast(title: '第一則'),
          KlpToast(title: '第二則', tone: KlpFeedbackTone.warning),
        ],
      ),
    ),
  ],
);

final fileExplorerPage = CatalogPageData(
  label: 'File Explorer',
  title: '檔案總管',
  description: '樹狀檔案導航結構，支援分類折疊、資料夾樹狀層級與檔案選取。',
  icon: KlpIcons.folder,
  specimens: [
    Specimen(
      name: 'KlpFileExplorer',
      note: '檔案總管／筆記導航元件（含分類折疊、資料夾樹狀展開與檔案選取）。',
      build: (context) {
        var selectedId = 'adr-0001';
        return StatefulBuilder(
          builder: (context, setState) => SizedBox(
            width: 280,
            child: KlpFileExplorer(
              selectedId: selectedId,
              onItemSelected: (id) => setState(() => selectedId = id),
              sections: const [
                KlpFileExplorerSection(
                  id: 'pinned',
                  title: '釘選',
                  items: [
                    KlpFileExplorerItem(
                      id: 'pin-0001',
                      label: 'ADR-0001 : Page-first 的 P...',
                    ),
                    KlpFileExplorerItem(
                      id: 'pin-0002',
                      label: 'ADR-0002 : 保留 Project As...',
                    ),
                  ],
                ),
                KlpFileExplorerSection(
                  id: 'notes',
                  title: '筆記',
                  items: [
                    KlpFileExplorerItem(
                      id: 'spec-folder',
                      label: '規格文件 (Spec)',
                      children: [
                        KlpFileExplorerItem(
                          id: 'adr-0001',
                          label: 'ADR-0001 : Page-first 的 P...',
                        ),
                        KlpFileExplorerItem(
                          id: 'adr-0002',
                          label: 'ADR-0002 : 保留 Project As...',
                        ),
                        KlpFileExplorerItem(
                          id: 'adr-0003',
                          label: 'ADR-0003 : 團隊導向 Project...',
                        ),
                      ],
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0004',
                      label: 'ADR-0004 : Live Page 定義...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0005',
                      label: 'ADR-0005 : 背景與無邊界區塊...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0006',
                      label: 'ADR-0006 : 分層色塊與終端機...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0007',
                      label: 'ADR-0007 : 產品入口與本機狀...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0008',
                      label: 'ADR-0008 : 以分流守則治理 AI...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0009',
                      label: 'ADR-0009 : Plan Document ...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0010',
                      label: 'ADR-0010 : Plan Document ...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0011',
                      label: 'ADR-0011 : Plan Composabl...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0012',
                      label: 'ADR-0012 : Plan Page Meta...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0013',
                      label: 'ADR-0013 : Primary Sideba...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0014',
                      label: 'ADR-0014 : 選取色與自訂主題...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0015',
                      label: 'ADR-0015 : 中央專案面板與跨...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0016',
                      label: 'ADR-0016 : Plan Markdown ...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0017',
                      label: 'ADR-0017 : Plan Markdown ...',
                    ),
                    KlpFileExplorerItem(
                      id: 'adr-0018',
                      label: 'ADR-0018 : 專案資源統一由側...',
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    ),
    Specimen(
      name: 'KlpFileExplorerSectionView',
      note: '檔案瀏覽器分類分組視圖。',
      build: (context) => SizedBox(
        width: 280,
        child: KlpFileExplorerSectionView(
          section: const KlpFileExplorerSection(
            id: 'sample',
            title: '分類',
            items: [KlpFileExplorerItem(id: '1', label: 'README.md')],
          ),
          isExpanded: true,
          expandedItemIds: const {},
          selectedId: '1',
          onToggle: () {},
          onItemToggle: (_) {},
          onItemSelected: (_) {},
          indent: 16.0,
        ),
      ),
    ),
    Specimen(
      name: 'KlpFileExplorerFolderView',
      note: '檔案瀏覽器可折疊資料夾節點視圖。',
      build: (context) => SizedBox(
        width: 280,
        child: KlpFileExplorerFolderView(
          item: const KlpFileExplorerItem(
            id: 'docs',
            label: '文件目錄',
            children: [KlpFileExplorerItem(id: 'doc-1', label: '指南.md')],
          ),
          level: 0,
          isExpanded: true,
          isSelected: false,
          onToggle: () {},
          onTap: () {},
          indent: 16.0,
        ),
      ),
    ),
    Specimen(
      name: 'KlpFileExplorerItemView',
      note: '檔案瀏覽器一般檔案項目視圖。',
      build: (context) => SizedBox(
        width: 280,
        child: KlpFileExplorerItemView(
          item: const KlpFileExplorerItem(
            id: 'file-1',
            label: 'ADR-0001 : Page-first 的 P...',
          ),
          level: 0,
          isSelected: true,
          onTap: () {},
          indent: 16.0,
        ),
      ),
    ),
  ],
);
