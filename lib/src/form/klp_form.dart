import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';
import '../theme/klp_theme_scope.dart';

/// 欄位可能處於的視覺／驗證狀態詞彙表，供消費端的表單狀態機使用。
///
/// 目前庫內元件不直接讀取這個列舉——[KlpField] 等元件是把 `error`／`status`
/// 這類已算好的字串當參數。它存在的目的是讓不同產品在描述「這個欄位現在算
/// dirty 還是 conflict」時用同一套語彙，而不是各自發明字串常數。
enum KlpFieldVisualState {
  pristine,
  dirty,
  touched,
  focused,
  validating,
  valid,
  invalid,
  disabled,
  readOnly,
  conflict,
}

/// 整份表單的最外層版面：錯誤總覽、各個區塊（[sections]）與底部動作列
/// 依序排列，各區塊之間插入固定間距。
///
/// 不管理欄位資料或驗證邏輯——[sections] 由呼叫端組好（通常是多個
/// [KlpFormSection]），[errorSummary] 通常放 [KlpFormErrorSummary]，
/// [actions] 通常放 [KlpFormActions]。三者皆為可選，缺席時不佔版位。
class KlpForm extends StatelessWidget {
  const KlpForm({
    super.key,
    required this.sections,
    this.errorSummary,
    this.actions,
  });

  final List<Widget> sections;
  final Widget? errorSummary;
  final Widget? actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (errorSummary != null) ...[
          errorSummary!,
          SizedBox(height: context.klp.space.base),
        ],
        for (var index = 0; index < sections.length; index++) ...[
          sections[index],
          if (index < sections.length - 1)
            SizedBox(height: context.klp.space.comfortable),
        ],
        if (actions != null) ...[
          SizedBox(height: context.klp.space.comfortable),
          actions!,
        ],
      ],
    );
  }
}

/// 表單中的一個可摺疊分組，帶標題、選填說明與一組欄位。
///
/// [collapsed] 與 [onToggle] 由呼叫端持有狀態——這個元件本身不記憶展開與否，
/// 純粹依 [collapsed] 決定要不要畫出 [children]。標題整列可點擊觸發
/// [onToggle]，即使 [onToggle] 為 null 也一樣可安全點擊（等同無反應）。
class KlpFormSection extends StatelessWidget {
  const KlpFormSection({
    super.key,
    required this.title,
    required this.children,
    this.description,
    this.collapsed = false,
    this.onToggle,
  });

  final String title;
  final String? description;
  final List<Widget> children;
  final bool collapsed;
  final VoidCallback? onToggle;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.all(context.klp.space.comfortable),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onToggle,
            child: KlpText(title, role: KlpTextRole.section),
          ),
          if (description != null) ...[
            SizedBox(height: context.klp.space.tight),
            KlpText(
              description!,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
          ],
          if (!collapsed)
            for (final child in children) ...[
              SizedBox(height: context.klp.space.base),
              child,
            ],
        ],
      ),
    );
  }
}

/// 單一表單欄位的完整外框：標籤、選填說明、輸入控制項（[child]），以及
/// 底部的錯誤／狀態／字數提示列。
///
/// [error]、[status]、[counter]、[errorCode] 共用同一列版面：底部提示列只在
/// 四者至少有一個非 null 時才出現；[error] 優先於 [status]（兩者同時給只顯示
/// error），[errorCode]／[counter] 則各自靠右並存，通常放系統層級的診斷代碼
/// （例如後端回傳的驗證錯誤碼）供支援排查用，不是給一般使用者讀的文案。
/// 實際的驗證邏輯、何時算 required 都由呼叫端決定，這個元件只負責排版。
class KlpField extends StatelessWidget {
  const KlpField({
    super.key,
    required this.label,
    required this.child,
    this.description,
    this.error,
    this.errorCode,
    this.requirement,
    this.required = false,
    this.status,
    this.counter,
  });

  final String label;
  final String? description;
  final String? error;
  final String? errorCode;
  final String? requirement;
  final bool required;
  final String? status;
  final String? counter;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  KlpFieldLabel(label: label),
                  if (required) ...[
                    SizedBox(width: klp.space.tight),
                    const KlpText(
                      '*',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.danger,
                    ),
                  ],
                ],
              ),
            ),
            if (requirement != null)
              KlpText(
                requirement!,
                role: KlpTextRole.caption,
                tone: KlpTextTone.faint,
              ),
          ],
        ),
        if (description != null) ...[
          SizedBox(height: klp.space.tight),
          KlpFieldDescription(description: description!),
        ],
        SizedBox(height: klp.space.tight),
        child,
        if (error != null || status != null || counter != null) ...[
          SizedBox(height: klp.space.tight),
          Row(
            children: [
              if (error != null)
                Expanded(
                  child: Row(
                    children: [
                      const KlpText(
                        '× ',
                        role: KlpTextRole.caption,
                        tone: KlpTextTone.danger,
                      ),
                      Expanded(
                        child: KlpText(
                          error!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.danger,
                        ),
                      ),
                    ],
                  ),
                )
              else if (status != null)
                Expanded(
                  child: KlpText(
                    status!,
                    role: KlpTextRole.caption,
                    tone: KlpTextTone.muted,
                  ),
                )
              else
                const Spacer(),
              if (errorCode != null) ...[
                SizedBox(width: klp.space.compact),
                KlpText(
                  errorCode!,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.danger,
                ),
              ],
              if (counter != null) ...[
                SizedBox(width: klp.space.compact),
                KlpText(
                  counter!,
                  role: KlpTextRole.code,
                  tone: KlpTextTone.faint,
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }
}

/// 欄位標籤文字，統一使用 [KlpTextRole.caption] 樣式。
///
/// [KlpField] 內部就是用它畫標籤——需要在 [KlpField] 版面之外單獨放一個
/// 樣式一致的欄位標籤時（例如自訂版面）才需要直接用它。
class KlpFieldLabel extends StatelessWidget {
  const KlpFieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return KlpText(label, role: KlpTextRole.caption);
  }
}

/// 欄位輔助說明文字，統一使用低對比（[KlpTextTone.muted]）的
/// [KlpTextRole.caption] 樣式。
///
/// [KlpField] 內部就是用它畫 `description`——需要在 [KlpField] 版面之外
/// 單獨放一段樣式一致的欄位說明時才需要直接用它。
class KlpFieldDescription extends StatelessWidget {
  const KlpFieldDescription({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    return KlpText(
      description,
      role: KlpTextRole.caption,
      tone: KlpTextTone.muted,
    );
  }
}

/// 單獨呈現的欄位錯誤文字，包了 `Semantics(liveRegion: true)`，讓螢幕
/// 報讀器在錯誤出現時主動唸出來，不需要使用者手動聚焦。
///
/// [KlpField] 的內建錯誤列沒有這層 live region 包裝；需要非同步驗證結果
/// 出現時立即被報讀器感知，才需要在 [KlpField] 之外單獨用它。
class KlpFieldError extends StatelessWidget {
  const KlpFieldError({super.key, required this.error});

  final String error;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: KlpText(
        error,
        role: KlpTextRole.caption,
        tone: KlpTextTone.danger,
      ),
    );
  }
}

/// 表單頂部的錯誤總覽卡片，把所有驗證失敗的欄位集中列成清單。
///
/// [errors] 的 key 是欄位識別碼、value 是要顯示的錯誤文字；點擊某一項會透過
/// [onSelected] 回報該欄位的 key，呼叫端通常用它把焦點捲動或移到對應欄位。
/// 不會反查欄位在畫面上的位置——[KlpForm] 之類的容器也不知道每個欄位的
/// GlobalKey，捲動與聚焦的實作留給呼叫端。
class KlpFormErrorSummary extends StatelessWidget {
  const KlpFormErrorSummary({
    super.key,
    required this.title,
    required this.errors,
    this.onSelected,
  });

  final String title;
  final Map<String, String> errors;
  final ValueChanged<String>? onSelected;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.all(context.klp.space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(
            title,
            role: KlpTextRole.bodyStrong,
            tone: KlpTextTone.danger,
          ),
          SizedBox(height: context.klp.space.tight),
          for (final error in errors.entries)
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onSelected == null ? null : () => onSelected!(error.key),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.klp.space.tight,
                ),
                child: KlpText(
                  error.value,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.danger,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 表單底部的動作列：送出／取消／重設按鈕，靠右對齊並在寬度不足時自動換行。
///
/// [cancelLabel]／[resetLabel] 為 null 時對應按鈕不會出現，[submitLabel] 與
/// [onSubmit] 恆為必填——表單至少要能送出。[submitting] 為 true 時三個按鈕
/// 一併停用，避免送出過程中使用者重複觸發或誤按取消／重設。
class KlpFormActions extends StatelessWidget {
  const KlpFormActions({
    super.key,
    required this.submitLabel,
    required this.onSubmit,
    this.cancelLabel,
    this.onCancel,
    this.resetLabel,
    this.onReset,
    this.submitting = false,
  });

  final String submitLabel;
  final VoidCallback? onSubmit;
  final String? cancelLabel;
  final VoidCallback? onCancel;
  final String? resetLabel;
  final VoidCallback? onReset;
  final bool submitting;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: context.klp.space.compact,
      runSpacing: context.klp.space.compact,
      children: [
        if (resetLabel != null)
          KlpButton(
            label: resetLabel!,
            tone: KlpButtonTone.ghost,
            onPressed: submitting ? null : onReset,
          ),
        if (cancelLabel != null)
          KlpButton(
            label: cancelLabel!,
            onPressed: submitting ? null : onCancel,
          ),
        KlpButton(
          label: submitLabel,
          tone: KlpButtonTone.primary,
          onPressed: submitting ? null : onSubmit,
        ),
      ],
    );
  }
}

/// 把多個相關輸入（例如一組 checkbox）當成單一 [KlpField] 呈現，用
/// [legend] 取代單一欄位的 `label`。
///
/// 內部直接委派給 [KlpField]，因此標籤／錯誤的排版與單一欄位完全一致；
/// 差別只在 `child` 換成 [children] 這組垂直排列的子項目。
class KlpFieldGroup extends StatelessWidget {
  const KlpFieldGroup({
    super.key,
    required this.legend,
    required this.children,
    this.error,
  });

  final String legend;
  final List<Widget> children;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return KlpField(
      label: legend,
      error: error,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

/// 依條件顯示／隱藏一段欄位，並用 [AnimatedSize] 補間高度變化，避免表單
/// 其他欄位因為突然增減內容而跳動。
///
/// [visible] 為 false 時 [child] 會被整個換成 [SizedBox.shrink]，因此
/// child 的 widget 狀態不會保留——若 child 內有輸入控制項且需要在重新顯示時
/// 保住使用者輸入，請自行在 child 上加 [GlobalKey] 或改用其他方式保存資料。
class KlpConditionalFieldRegion extends StatelessWidget {
  const KlpConditionalFieldRegion({
    super.key,
    required this.visible,
    required this.child,
  });

  final bool visible;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: context.klp.motion.stateTransition,
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}
