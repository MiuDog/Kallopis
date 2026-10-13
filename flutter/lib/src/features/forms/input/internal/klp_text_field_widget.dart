part of '../klp_text_field.dart';

/// 單行或多行文字輸入。底層輸入能力由 Kallopis primitive 提供，消費者不需要
/// 額外準備 `Material` 祖先。
class KlpTextField extends StatefulWidget {
  const KlpTextField({
    super.key,
    this.label,
    this.placeholder,
    this.helper,
    this.error,
    this.leadingIcon,
    this.leadingIconWeight = KlpIconWeight.regular,
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
    this.minLines,
    this.maxLines,
    this.unboundedLines = false,
    this.outlined = false,
    this.suffixText,
    this.obscureText = false,
    this.trailingActionIcon,
    this.trailingActionIconWeight = KlpIconWeight.regular,
    this.trailingActionLabel,
    this.onTrailingActionPressed,
    this.stepper = false,
    this.clearable = false,
    this.conflict = false,
    this.readOnly = false,
    this.onClear,
    this.onStepUp,
    this.onStepDown,
  }) : assert(maxLength == null || maxLength > 0),
       assert(minLines == null || minLines > 0),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || maxLines == null || minLines <= maxLines),
       assert(!obscureText || !multiline),
       assert(
         (trailingActionIcon == null) == (trailingActionLabel == null),
         'trailingActionIcon 與 trailingActionLabel 必須同時提供。',
       ),
       assert(
         trailingActionIcon == null || (!clearable && !stepper),
         '自訂尾端動作不能與 clearable 或 stepper 同時使用。',
       ),
       assert(
         controller == null || initialValue == null,
         'controller 與 initialValue 互斥——給了 controller 就由它掌控文字內容。',
       );

  final String? label;
  final String? placeholder;
  final String? helper;
  final String? error;
  final KlpIconData? leadingIcon;
  final KlpIconWeight leadingIconWeight;
  final String? initialValue;

  /// 外部持有的文字控制器。沒有給時本元件用 [initialValue] 自行管理；給了
  /// [controller] 就由呼叫端全權掌控文字內容，兩者互斥。
  final TextEditingController? controller;
  final int? maxLength;
  final KlpControlSize size;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FocusNode? focusNode;
  final bool autofocus;
  final bool enabled;
  final bool multiline;
  final int? minLines;
  final int? maxLines;
  final bool unboundedLines;
  final bool outlined;
  final String? suffixText;
  final bool obscureText;
  final KlpIconData? trailingActionIcon;
  final KlpIconWeight trailingActionIconWeight;
  final String? trailingActionLabel;
  final VoidCallback? onTrailingActionPressed;
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
