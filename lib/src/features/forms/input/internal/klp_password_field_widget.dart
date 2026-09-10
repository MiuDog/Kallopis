part of '../klp_password_field.dart';

/// 密碼輸入控制項。支援顯示／隱藏密碼切換與密碼強度／規則檢核清單。
class KlpPasswordField extends StatefulWidget {
  const KlpPasswordField({
    super.key,
    required this.label,
    this.value,
    this.placeholder,
    this.error,
    this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.required = false,
    this.requirements,
  });

  final String label;
  final String? value;
  final String? placeholder;
  final String? error;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool readOnly;
  final bool required;
  final List<KlpPasswordRequirement>? requirements;

  @override
  State<KlpPasswordField> createState() => _KlpPasswordFieldState();
}
