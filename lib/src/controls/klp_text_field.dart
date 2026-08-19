import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/klp_icon.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_dashed_border.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';
import 'klp_control_size.dart';

/// 單行或多行文字輸入。內部使用 `TextFormField`，所需的 `Material` 祖先由本元件
/// 自行提供，消費者不需要另外包一層。
class KlpTextField extends StatefulWidget {
  const KlpTextField({
    super.key,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.leadingIcon,
    this.initialValue,
    this.controller,
    this.maxLength,
    this.size = KlpControlSize.md,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.autofocus = false,
    this.enabled = true,
    this.multiline = false,
    this.suffixText,
    this.stepper = false,
    this.clearable = false,
    this.conflict = false,
    this.readOnly = false,
    this.onClear,
    this.onStepUp,
    this.onStepDown,
  }) : assert(maxLength == null || maxLength > 0),
       assert(
         controller == null || initialValue == null,
         'controller 與 initialValue 互斥——給了 controller 就由它掌控文字內容。',
       );

  final String? label;
  final String? placeholder;
  final String? helper;
  final String? error;
  final String? leadingIcon;
  final String? initialValue;

  /// 外部持有的文字控制器。多數呼叫端不需要——沒有給時本元件用 `initialValue`
  /// 自行管理，這是既有行為。給了 [controller] 就由呼叫端全權掌控文字內容
  /// （例如 `KlpCombobox` 需要在使用者選定選項後改寫欄位文字），
  /// 兩者互斥，與 `TextFormField` 的限制一致。
  final TextEditingController? controller;
  final int? maxLength;
  final KlpControlSize size;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool multiline;
  final String? suffixText;
  final bool stepper;
  final bool clearable;
  final bool conflict;
  final bool readOnly;
  final VoidCallback? onClear;
  final VoidCallback? onStepUp;
  final VoidCallback? onStepDown;

  @override
  State<KlpTextField> createState() => _KlpTextFieldState();
}

class _KlpTextFieldState extends State<KlpTextField> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;
    final klp = context.klp;
    final hasError = widget.error != null;
    final (fieldHeight, fontSize, paddingX) = switch (widget.size) {
      KlpControlSize.sm => (
        klp.space.controlHeightSmall,
        klp.type.sub,
        klp.space.tight,
      ),
      KlpControlSize.md => (
        klp.space.controlHeight,
        klp.type.body,
        klp.space.compact,
      ),
      KlpControlSize.lg => (
        klp.space.controlHeightLarge,
        klp.type.lead,
        klp.space.base,
      ),
      KlpControlSize.xl => (
        klp.space.controlHeightXLarge,
        klp.type.lead,
        klp.space.comfortable,
      ),
    };

    Widget? suffixWidget;
    if (widget.clearable) {
      suffixWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onClear,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
          child: KlpIcon(
            KlpIcons.x,
            size: klp.space.iconSmall,
            color: tokens.textMuted,
          ),
        ),
      );
    } else if (widget.stepper || widget.suffixText != null) {
      suffixWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.suffixText != null) ...[
            KlpText(
              widget.suffixText!,
              role: KlpTextRole.caption,
              tone: KlpTextTone.muted,
            ),
            SizedBox(width: klp.space.tight),
          ],
          if (widget.stepper)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onStepUp,
                  child: SizedBox(
                    height: fieldHeight * 0.4,
                    child: const KlpText(
                      '⌃',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: widget.onStepDown,
                  child: SizedBox(
                    height: fieldHeight * 0.4,
                    child: const KlpText(
                      '⌄',
                      role: KlpTextRole.caption,
                      tone: KlpTextTone.muted,
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(width: klp.space.tight),
        ],
      );
    }

    final isInvalid = hasError || widget.conflict;
    final fillColor = KlpFieldStyle.inputFill(tokens, error: isInvalid);

    Widget fieldWidget = Container(
      height: widget.multiline ? null : fieldHeight,
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(klp.shape.control),
      ),
      alignment: widget.multiline ? Alignment.topLeft : Alignment.centerLeft,
      child: Material(
        type: MaterialType.transparency,
        child: Focus(
          onFocusChange: (focused) => setState(() => _focused = focused),
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.controller == null
                ? widget.initialValue
                : null,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            textAlignVertical: widget.multiline
                ? TextAlignVertical.top
                : TextAlignVertical.center,
            inputFormatters: widget.maxLength == null
                ? null
                : [LengthLimitingTextInputFormatter(widget.maxLength)],
            onChanged: widget.onChanged,
            onFieldSubmitted: widget.onSubmitted,
            minLines: widget.multiline ? 4 : 1,
            maxLines: widget.multiline ? 8 : 1,
            style: TextStyle(
              color: !widget.enabled ? tokens.textFaint : tokens.text,
              fontSize: fontSize,
              height: klp.type.captionLeading,
              fontFamily: klp.type.uiFamily,
              fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
            ),
            cursorColor: tokens.interaction,
            decoration: InputDecoration(
              isDense: true,
              hintText: widget.placeholder,
              hintStyle: TextStyle(
                color: tokens.textFaint,
                fontSize: fontSize,
                fontFamily: klp.type.uiFamily,
                fontFamilyFallback: klp.type.fallbackFor(klp.type.uiFamily),
              ),
              prefixIcon: widget.leadingIcon == null
                  ? null
                  : Padding(
                      padding: EdgeInsets.all(klp.space.compact),
                      child: KlpIcon(
                        widget.leadingIcon!,
                        color: tokens.textMuted,
                      ),
                    ),
              prefixIconConstraints: BoxConstraints(
                minWidth: fieldHeight,
                minHeight: fieldHeight,
              ),
              suffixIcon: suffixWidget,
              suffixIconConstraints: BoxConstraints(minHeight: fieldHeight),
              filled: false,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: paddingX,
                vertical: widget.multiline
                    ? klp.space.controlPaddingY
                    : (fieldHeight - fontSize * 1.3) / 2,
              ),
            ),
          ),
        ),
      ),
    );

    if ((_hovered || _focused) && widget.enabled) {
      fieldWidget = KlpDashedBorder(
        color: klp.hoverBorder,
        radius: klp.shape.control,
        child: fieldWidget,
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.label != null) ...[
            KlpText(widget.label!, role: KlpTextRole.caption),
            SizedBox(height: klp.space.tight),
          ],
          fieldWidget,
          if (hasError || widget.helper != null) ...[
            SizedBox(height: klp.space.tight),
            KlpText(
              widget.error ?? widget.helper!,
              role: KlpTextRole.caption,
              tone: hasError ? KlpTextTone.danger : KlpTextTone.muted,
            ),
          ],
        ],
      ),
    );
  }
}
