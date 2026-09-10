part of '../klp_settings_navigation.dart';

/// Settings 搜尋欄的標準組合；查詢與過濾由產品層處理。
class KlpSettingsSearchField extends StatelessWidget {
  const KlpSettingsSearchField({
    super.key,
    required this.placeholder,
    this.controller,
    this.onChanged,
    this.onSubmitted,
  });

  final String placeholder;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return KlpTextField(
      controller: controller,
      placeholder: placeholder,
      leadingIcon: KlpIcons.search,
      size: KlpControlSize.sm,
      outlined: true,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
    );
  }
}
