import '../internal/klp_form_dependencies.dart';
import 'klp_choice_option.dart';

part 'primitives/klp_multi_select_field_frame.dart';
part 'primitives/klp_multi_select_option_frame.dart';

/// 多選欄位：所有選項以可切換的標籤形式平鋪展示。
///
/// [selectedIds] 由呼叫端持有；點擊選項只透過 [onChanged] 回報下一個集合。
class KlpMultiSelectField extends StatelessWidget {
  const KlpMultiSelectField({
    super.key,
    required this.label,
    required this.options,
    required this.selectedIds,
    required this.onChanged,
    this.enabled = true,
    this.readOnly = false,
    this.error,
  });

  final String label;
  final List<KlpChoiceOption> options;
  final Set<String> selectedIds;
  final ValueChanged<Set<String>>? onChanged;
  final bool enabled;
  final bool readOnly;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && !readOnly && onChanged != null;

    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        const KlpGap.heightSize(KlpSpaceSize.tight),
        _KlpMultiSelectFieldFrame(
          label: label,
          enabled: enabled,
          readOnly: readOnly,
          hasError: error != null,
          child: KlpWrap(
            spacingSize: KlpSpaceSize.tight,
            runSpacingSize: KlpSpaceSize.tight,
            children: [
              for (final option in options)
                _KlpMultiSelectOptionFrame(
                  label: option.label,
                  selected: selectedIds.contains(option.id),
                  visuallyEnabled: enabled && !option.disabled,
                  onPressed: !interactive || option.disabled
                      ? null
                      : () {
                          final next = Set<String>.from(selectedIds);
                          if (!next.remove(option.id)) {
                            next.add(option.id);
                          }
                          onChanged!(next);
                        },
                ),
            ],
          ),
        ),
        if (error != null) ...[
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(error!, role: KlpTextRole.caption, tone: KlpTextTone.danger),
        ],
      ],
    );
  }
}
