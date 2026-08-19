import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

import '../catalog_model.dart';

/// 給需要固定尺寸才看得出行為的元件用。
Widget _boxed(BuildContext context, double height, Widget child) => SizedBox(
  height: height,
  child: KlpSurface(
    tone: KlpSurfaceTone.inset,
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
      note: 'tone 決定語意強度。圓角、內距、高度與邊框皆取自 theme。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          runSpacing: klp.space.compact,
          children: [
            for (final tone in KlpButtonTone.values)
              KlpButton(label: tone.name, onPressed: () {}, tone: tone),
            KlpButton(label: 'disabled', onPressed: null),
            KlpButton(label: 'compact', onPressed: () {}, compact: true),
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
      note: '狀態標記。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          children: const [
            KlpBadge(label: 'draft'),
            KlpBadge(label: 'active', tone: KlpFeedbackTone.success),
            KlpBadge(label: 'blocked', tone: KlpFeedbackTone.danger),
          ],
        );
      },
    ),
    Specimen(
      name: 'KlpTag',
      note: '可移除的標籤。',
      build: (context) {
        final klp = context.klp;
        return Wrap(
          spacing: klp.space.compact,
          children: [
            const KlpTag(label: 'design'),
            KlpTag(label: 'token', onRemove: () {}),
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
      note: '鍵值清單。',
      build: (context) => const KlpKeyValueList(
        rows: [
          KlpKeyValueItem(
            id: 'created',
            label: '建立於',
            value: KlpText('2026-08-18'),
          ),
          KlpKeyValueItem(id: 'state', label: '狀態', value: KlpText('accepted')),
        ],
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
      note: '可排序的資料表。排序狀態由呼叫端持有。',
      build: (context) => const KlpDataTable(
        columns: [
          KlpDataColumn(id: 'name', label: '名稱'),
          KlpDataColumn(id: 'count', label: '數量'),
        ],
        rows: [
          KlpDataRow(id: 'a', cells: {'name': 'controls', 'count': '16'}),
          KlpDataRow(id: 'b', cells: {'name': 'data', 'count': '13'}),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTree',
      note: '樹狀清單。',
      build: (context) => const KlpTree(
        nodes: [
          KlpTreeNode(
            id: 'lib',
            label: 'lib',
            children: [KlpTreeNode(id: 'src', label: 'src')],
          ),
        ],
      ),
    ),
    Specimen(
      name: 'KlpTreeItem',
      note: '樹的單一節點。',
      build: (context) => const KlpTreeItem(
        node: KlpTreeNode(id: 'src', label: 'src'),
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
      note: '狀態點。',
      build: (context) => const KlpStatusIndicator(label: '已連線', active: true),
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
          KlpTimelineItemData(
            title: '核准',
            time: '14:00',
            highlighted: true,
          ),
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
      name: 'KlpSplitLayout',
      note: '左右分割。',
      build: (context) => _boxed(
        context,
        120,
        const KlpSplitLayout(
          leading: KlpText('leading'),
          trailing: KlpText('trailing'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpResizablePane',
      note: '可拖曳調寬的面板。',
      build: (context) => _boxed(
        context,
        100,
        const KlpResizablePane(width: 180, child: KlpText('pane')),
      ),
    ),
    Specimen(
      name: 'KlpResizeHandle',
      note: '拖曳把手。',
      build: (context) => _boxed(context, 80, KlpResizeHandle(onDelta: (_) {})),
    ),
    Specimen(
      name: 'KlpScrollViewport',
      note: '帶樣式捲軸的捲動區。',
      build: (context) => _boxed(
        context,
        120,
        KlpScrollViewport(
          child: Column(
            children: [for (var i = 0; i < 12; i++) KlpText('第 $i 列')],
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpVirtualList',
      note: '長清單的虛擬捲動。',
      build: (context) => _boxed(
        context,
        120,
        KlpVirtualList(
          itemCount: 500,
          itemBuilder: (context, index) => KlpText('項目 $index'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpVirtualGrid',
      note: '格狀的虛擬捲動。',
      build: (context) => _boxed(
        context,
        160,
        KlpVirtualGrid(
          itemCount: 200,
          itemBuilder: (context, index) => KlpSurface(
            tone: KlpSurfaceTone.component,
            child: Center(child: KlpText('$index')),
          ),
        ),
      ),
    ),
    Specimen(
      name: 'KlpOverlayHost',
      note: '浮層的掛載點。',
      build: (context) =>
          _boxed(context, 80, const KlpOverlayHost(child: KlpText('host'))),
    ),
    Specimen(
      name: 'KlpFilterBar',
      note: '篩選列。選項與選取狀態由呼叫端持有。',
      build: (context) => KlpFilterBar(
        filters: const [
          KlpFilterOption(id: 'all', label: '全部'),
          KlpFilterOption(id: 'open', label: '進行中'),
        ],
        selectedId: 'all',
        onSelected: (_) {},
      ),
    ),
    Specimen(
      name: 'KlpSelectionToolbar',
      note: '選取後浮現的工具列。',
      build: (context) => KlpSelectionToolbar(
        count: 3,
        countLabel: '已選取',
        actions: [KlpSelectionAction(id: 'del', label: '刪除', onPressed: () {})],
      ),
    ),
    Specimen(
      name: 'KlpShortcutHint',
      note: '鍵盤快捷提示。',
      build: (context) => const KlpShortcutHint(label: 'Ctrl+K'),
    ),
    Specimen(
      name: 'KlpPresenceIndicator',
      note: '協作者在線標記。',
      build: (context) =>
          const KlpPresenceIndicator(label: 'chiayu', active: true),
    ),
    Specimen(
      name: 'KlpSortControl',
      note: '排序切換。',
      build: (context) =>
          KlpSortControl(label: '名稱', ascending: true, onPressed: () {}),
    ),
    Specimen(
      name: 'KlpDragPreview',
      note: '拖曳時跟隨指標的預覽。',
      build: (context) => const KlpDragPreview(child: KlpText('拖曳中')),
    ),
    Specimen(
      name: 'KlpDropTarget',
      note: '可放置的目標區。',
      build: (context) => const SizedBox(
        height: 72,
        child: KlpDropTarget(
          active: true,
          child: Center(child: KlpText('放這裡')),
        ),
      ),
    ),
    Specimen(
      name: 'KlpDropIndicator',
      note: '插入位置的指示線。',
      build: (context) => const KlpDropIndicator(),
    ),
    Specimen(
      name: 'KlpAppScreen',
      note: '應用最外層。同時提供整個子樹所需的 Material 祖先。',
      build: (context) => _boxed(
        context,
        100,
        const KlpAppScreen(child: KlpText('app screen')),
      ),
    ),
    Specimen(
      name: 'KlpAppWindowHeader',
      note: '自訂視窗標題列。',
      build: (context) => const KlpAppWindowHeader(title: 'Kallopis'),
    ),
    Specimen(
      name: 'KlpWindowControls',
      note: '最小化／最大化／關閉。',
      build: (context) => KlpWindowControls(
        onMinimize: () {},
        onToggleMaximize: () {},
        onClose: () {},
      ),
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
          rail: SizedBox.shrink(),
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
        200,
        const KlpWorkbenchShell(
          primary: KlpText('primary'),
          stage: KlpText('stage'),
          secondary: KlpText('secondary'),
        ),
      ),
    ),
    Specimen(
      name: 'KlpPaneCollapseControl',
      note: '面板收合鈕。',
      build: (context) => KlpPaneCollapseControl(
        icon: KlpIcons.collapse,
        label: '收合',
        collapsed: false,
        onToggle: () {},
      ),
    ),
    Specimen(
      name: 'KlpResponsivePaneCoordinator',
      note: '依可用寬度在 wide／compact 之間切換。斷點是版面預設值，不隨風格改變。',
      build: (context) => _boxed(
        context,
        80,
        const KlpResponsivePaneCoordinator(
          wide: KlpText('wide'),
          compact: KlpText('compact'),
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
      note: '斜線填充表示待實作。label 與 kindLabel 由呼叫端決定。',
      build: (context) {
        final klp = context.klp;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const KlpRegionPlaceholder(label: 'inspector', kindLabel: 'panel'),
            SizedBox(height: klp.space.base),
            const KlpRegionPlaceholder(
              label: 'timeline',
              kindLabel: 'region',
              detail: '等待資料模型定案',
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
      name: 'KlpLoadingState',
      note: '載入中。',
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
        140,
        const KlpProgressOverlay(
          visible: true,
          label: '處理中',
          child: KlpText('底下的內容'),
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
