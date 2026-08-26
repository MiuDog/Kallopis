import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../foundation/klp_icon.dart';
import '../interaction/klp_pressable.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 導覽項目圖示格的識別鍵。
///
/// 圖示的**格子**與**字形**是兩個尺寸（見 `KlpSpacingTheme.iconGlyph`），
/// 版面測試必須能分別量到兩者——只找 `KlpIcon` 量到的是字形，不是格子。
const String klpNavigationIconBoxKey = 'klp-navigation-icon-box';

/// Primary Sidebar 內的全寬導覽按鈕。
///
/// 消費者只提供圖示、標籤、選取狀態與事件；高度、內距、圓角、圖示尺寸、
/// hover 與選取色全部由 Kallopis theme 決定。
class KlpSidebarNavigationButton extends StatefulWidget {
  const KlpSidebarNavigationButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.selected = false,
  });

  final String icon;
  final String label;
  final VoidCallback? onPressed;
  final bool selected;

  @override
  State<KlpSidebarNavigationButton> createState() =>
      _KlpSidebarNavigationButtonState();
}

class _KlpSidebarNavigationButtonState
    extends State<KlpSidebarNavigationButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final disabled = widget.onPressed == null;
    final active = !disabled && (_hovered || _focused);
    final background = widget.selected
        ? tokens.selectionBackground
        : active
        ? klp.selectionWash
        : tokens.clear;
    final foreground = disabled
        ? tokens.textFaint
        : widget.selected
        ? tokens.selectionForeground
        : tokens.textMuted;
    final radius = BorderRadius.circular(klp.shape.control);

    return Semantics(
      button: true,
      selected: widget.selected,
      enabled: !disabled,
      label: widget.label,
      excludeSemantics: true,
      child: KlpPressable(
        onPressed: widget.onPressed,
        onHover: (value) => setState(() => _hovered = value),
        onFocusChange: (value) => setState(() => _focused = value),
        hoverHighlight: false,
        borderRadius: radius,
        child: Container(
          height: klp.space.controlHeightSmall,
          padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
          decoration: BoxDecoration(color: background, borderRadius: radius),
          child: Row(
            children: [
              // 圖示佔一個 `icon` 見方的格子，字形本身用較小的 `iconGlyph`。
              // 兩者同大時圖示會頂滿格線，在一排文字旁顯得過重。
              SizedBox.square(
                key: const ValueKey(klpNavigationIconBoxKey),
                dimension: klp.space.icon,
                child: Center(
                  child: KlpIcon(
                    widget.icon,
                    size: klp.space.iconGlyph,
                    color: foreground,
                  ),
                ),
              ),
              SizedBox(width: klp.space.itemGap),
              Expanded(
                child: KlpText(
                  widget.label,
                  role: KlpTextRole.body,
                  color: foreground,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Primary Sidebar 的全寬導覽列群組。
///
/// 呼叫端只決定項目順序；Kallopis 統一管理相鄰列的垂直節奏。
class KlpSidebarNavigationGroup extends StatelessWidget {
  const KlpSidebarNavigationGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var index = 0; index < children.length; index++) ...[
          children[index],
          if (index < children.length - 1)
            SizedBox(height: context.klp.space.hairline),
        ],
      ],
    );
  }
}

/// 側邊欄分組標題，固定高度且左對齊、使用低對比的
/// [KlpTextRole.label] 樣式。
///
/// 固定高度是為了讓不同分組標題之間的垂直節奏一致，即使某個標題很短也不會
/// 讓上下間距看起來不一樣。
class KlpSidebarSectionLabel extends StatelessWidget {
  const KlpSidebarSectionLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.klp.space.loose,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: context.klp.space.tight),
          child: KlpText(
            label,
            role: KlpTextRole.label,
            tone: KlpTextTone.muted,
          ),
        ),
      ),
    );
  }
}

/// 一組動作按鈕的容器，寬度不足時自動換行，換行時保留與同一行相同的間距。
///
/// 只負責排版間距——按鈕本身的樣式、順序、是否停用都由 [children] 自行決定。
class KlpActionGroup extends StatelessWidget {
  const KlpActionGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.klp.space.tight,
      runSpacing: context.klp.space.tight,
      children: children,
    );
  }
}

/// 上一頁／頁碼／下一頁的簡易分頁控制項。
///
/// 頁碼從 1 開始（不是從 0）；在第一頁或最後一頁時對應按鈕會自動停用，
/// 呼叫端不需要自己判斷邊界。不提供跳頁輸入框或頁碼清單，適合頁數不多、
/// 只需要前後翻頁的場合。
class KlpPagination extends StatelessWidget {
  const KlpPagination({
    super.key,
    required this.page,
    required this.pageCount,
    required this.previousLabel,
    required this.nextLabel,
    required this.onPageChanged,
  });

  final int page;
  final int pageCount;
  final String previousLabel;
  final String nextLabel;
  final ValueChanged<int>? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        KlpButton(
          label: previousLabel,
          compact: true,
          onPressed: page <= 1 || onPageChanged == null
              ? null
              : () => onPageChanged!(page - 1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
          child: KlpText('$page / $pageCount', role: KlpTextRole.code),
        ),
        KlpButton(
          label: nextLabel,
          compact: true,
          onPressed: page >= pageCount || onPageChanged == null
              ? null
              : () => onPageChanged!(page + 1),
        ),
      ],
    );
  }
}

/// [KlpViewSwitcher] 裡的一個檢視選項：識別碼、顯示文字，以及選填的圖示。
@immutable
class KlpViewOption {
  const KlpViewOption({required this.id, required this.label, this.icon});

  final String id;
  final String label;
  final Widget? icon;
}

/// 同層級檢視切換器（例如「清單／看板」），以緊貼的膠囊按鈕組呈現，
/// 選中項會有底色標示。
///
/// 與 [KlpSegmentedControl] 的差異在於視覺重量更輕——[KlpViewSwitcher] 用
/// inset 表面搭配 hairline 間距，適合放在工具列這類次要控制的位置；需要更
/// 強調的主要切換時請用 [KlpSegmentedControl]。
class KlpViewSwitcher extends StatelessWidget {
  const KlpViewSwitcher({
    super.key,
    required this.options,
    required this.selectedId,
    required this.onSelected,
  });

  final List<KlpViewOption> options;
  final String selectedId;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.inset,
      radius: context.klp.shape.control,
      padding: EdgeInsets.all(context.klp.space.hairline),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var index = 0; index < options.length; index++) ...[
            _KlpViewChoice(
              option: options[index],
              selected: options[index].id == selectedId,
              onPressed: onSelected == null
                  ? null
                  : () => onSelected!(options[index].id),
            ),
            if (index < options.length - 1)
              SizedBox(width: context.klp.space.hairline),
          ],
        ],
      ),
    );
  }
}

class _KlpViewChoice extends StatelessWidget {
  const _KlpViewChoice({
    required this.option,
    required this.selected,
    required this.onPressed,
  });

  final KlpViewOption option;
  final bool selected;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: BoxConstraints(
          minHeight: context.klp.space.controlHeightSmall,
        ),
        padding: EdgeInsets.symmetric(horizontal: context.klp.space.compact),
        decoration: BoxDecoration(
          color: selected ? tokens.selection : null,
          borderRadius: BorderRadius.circular(context.klp.shape.control),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (option.icon != null) ...[
              option.icon!,
              SizedBox(width: context.klp.space.tight),
            ],
            KlpText(
              option.label,
              role: KlpTextRole.caption,
              color: selected ? tokens.onSelection : tokens.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
