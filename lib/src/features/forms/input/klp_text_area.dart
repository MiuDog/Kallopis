import '../internal/klp_form_dependencies.dart';

/// 多行文字輸入欄位，是 [KlpTextField] 的薄封裝——固定 `multiline: true`，
/// 其餘外觀與行為完全繼承自 [KlpTextField]。
class KlpTextArea extends StatelessWidget {
  const KlpTextArea({
    super.key,
    this.label,
    this.value,
    this.placeholder,
    this.error,
    this.onChanged,
    this.enabled = true,
    this.minLines,
    this.maxLines,
    this.unboundedLines = false,
    this.outlined = false,
  });

  final String? label;
  final String? value;
  final String? placeholder;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? minLines;
  final int? maxLines;
  final bool unboundedLines;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      label: label,
      initialValue: value,
      placeholder: placeholder,
      error: error,
      onChanged: onChanged,
      enabled: enabled,
      multiline: true,
      minLines: minLines,
      maxLines: maxLines,
      unboundedLines: unboundedLines,
      outlined: outlined,
    );
  }
}
