import 'package:flutter/material.dart';

import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_icon.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 階段選項資料。包含選項值、文字標籤或圖示，與啟用時的語意色調。
@immutable
class KlpPhaseOption<T> {
  const KlpPhaseOption({
    required this.value,
    this.label,
    this.icon,
    this.activeTone,
    this.activeColor,
  }) : assert(label != null || icon != null, 'Must provide label or icon');

  final T value;
  final String? label;
  final String? icon;
  final KlpFeedbackTone? activeTone;
  final Color? activeColor;
}

/// 階段／多態切換按鈕組 (Phase Toggle)。
///
/// 邊框軌道、正方形分段，寬度隨選項數量延展。支援二態、三態與多選項目。
class KlpPhaseToggle<T> extends StatelessWidget {
  const KlpPhaseToggle({
    super.key,
    required this.options,
    required this.selected,
    this.onSelected,
    this.enabled = true,
  });

  final List<KlpPhaseOption<T>> options;
  final T? selected;
  final ValueChanged<T>? onSelected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final size = klp.space.controlHeightSmall;
    final padding = klp.space.hairline * 2;
    final border = klp.shape.hairline * 2;
    final totalWidth = size * options.length + padding * 2 + border;
    final totalHeight = size + padding * 2 + border;
    final selectedIndex = options.indexWhere((o) => o.value == selected);

    // 未指定語意色時，選取態用中性表面而不是前景色。
    //
    // 準則第 5 條：accent 只用於主要 CTA、文字連結、鍵盤焦點與明確可執行的操作，
    // **不得用於 selected**。先前這裡預設 `tokens.text`（亮態近黑），讓模式切換的
    // 選取格變成一塊高對比黑，和「這是主要動作」用同一個視覺語言說話。
    //
    // 帶語意色的選項（成功／警告／危險／資訊）是另一回事：那是在陳述狀態，
    // 不是在標示選取，因此保留。
    Color activeBg;
    if (!enabled) {
      activeBg = tokens.text.withValues(alpha: klp.surface.statusFillOpacity);
    } else if (selectedIndex >= 0) {
      final selectedOption = options[selectedIndex];
      if (selectedOption.activeColor != null) {
        activeBg = selectedOption.activeColor!;
      } else if (selectedOption.activeTone != null) {
        activeBg = switch (selectedOption.activeTone!) {
          KlpFeedbackTone.success => tokens.success,
          KlpFeedbackTone.warning => tokens.warning,
          KlpFeedbackTone.danger => tokens.danger,
          KlpFeedbackTone.info => tokens.info,
          KlpFeedbackTone.neutral => klp.selectedSurface,
        };
      } else {
        activeBg = klp.selectedSurface;
      }
    } else {
      activeBg = klp.selectedSurface;
    }

    return Container(
      width: totalWidth,
      height: totalHeight,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: tokens.surfaceInset,
        borderRadius: BorderRadius.circular(klp.shape.control),
        border: Border.all(color: tokens.border, width: klp.shape.hairline),
      ),
      child: Stack(
        children: [
          if (selectedIndex >= 0)
            AnimatedPositioned(
              duration: klp.motion.stateTransition,
              curve: Curves.easeOutCubic,
              left: selectedIndex * size,
              top: 0,
              width: size,
              height: size,
              child: AnimatedContainer(
                duration: klp.motion.styleTransition,
                decoration: BoxDecoration(
                  color: activeBg,
                  borderRadius: BorderRadius.circular(klp.shape.controlInner),
                ),
              ),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < options.length; index++)
                _KlpPhaseSegment<T>(
                  option: options[index],
                  selected: selected == options[index].value,
                  enabled: enabled,
                  size: size,
                  onTap: enabled && onSelected != null
                      ? () => onSelected!(options[index].value)
                      : null,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KlpPhaseSegment<T> extends StatelessWidget {
  const _KlpPhaseSegment({
    required this.option,
    required this.selected,
    required this.enabled,
    required this.size,
    required this.onTap,
  });

  final KlpPhaseOption<T> option;
  final bool selected;
  final bool enabled;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final tokens = context.klpColors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color activeFg;
    if (!enabled) {
      activeFg = tokens.textFaint;
    } else if (option.activeColor != null) {
      activeFg = tokens.onBackground(option.activeColor!).text;
    } else if (option.activeTone != null) {
      activeFg = switch (option.activeTone!) {
        KlpFeedbackTone.success => isDark ? tokens.text : tokens.surface,
        KlpFeedbackTone.danger => isDark ? tokens.text : tokens.surface,
        KlpFeedbackTone.info => isDark ? tokens.text : tokens.surface,
        KlpFeedbackTone.warning => isDark ? tokens.surface : tokens.text,
        // 中性選取的底色是中性表面，前景就維持一般文字色並升到 primary——
        // 那是準則 §2.1 要求的第二個訊號（選取不能只靠顏色）。
        KlpFeedbackTone.neutral => tokens.text,
      };
    } else {
      activeFg = tokens.text;
    }

    final fg = !enabled
        ? tokens.textFaint
        : (selected
              ? activeFg
              : (option.activeTone == KlpFeedbackTone.danger
                    ? tokens.danger
                    : (option.activeTone == KlpFeedbackTone.success
                          ? tokens.success
                          : tokens.textMuted)));

    Widget content;
    if (option.icon != null) {
      // 依 Notist 設計稿為 16px。用 iconSmall（14px）會讓模式切換的圖示
      // 明顯小於相鄰的工具列按鈕，兩者並排時看起來像不同層級的控制項。
      content = KlpIcon(option.icon!, size: klp.space.iconBase, color: fg);
    } else {
      content = KlpText(option.label ?? '', role: KlpTextRole.code, color: fg);
    }

    return Semantics(
      button: true,
      selected: selected,
      enabled: enabled,
      label: option.label,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(child: content),
        ),
      ),
    );
  }
}
