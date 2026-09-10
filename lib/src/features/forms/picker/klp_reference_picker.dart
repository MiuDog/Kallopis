import '../internal/klp_form_dependencies.dart';
import '../../../foundation/layout/klp_center.dart';
import 'klp_reference_option.dart';

export 'klp_reference_option.dart';

part 'internal/klp_reference_option_row.dart';
part 'primitives/klp_reference_option_frame.dart';
part 'primitives/klp_reference_picker_frame.dart';

/// 以查詢、載入狀態與受控結果清單呈現通用參照選擇器。
class KlpReferencePicker extends StatelessWidget {
  const KlpReferencePicker({
    super.key,
    required this.title,
    required this.query,
    required this.queryPlaceholder,
    required this.results,
    required this.onQueryChanged,
    required this.onSelected,
    this.loading = false,
  });

  final String title;
  final String query;
  final String queryPlaceholder;
  final List<KlpReferenceOption> results;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String>? onSelected;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return _KlpReferencePickerFrame(
      child: KlpColumn(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(title.toUpperCase(), role: KlpTextRole.label),
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          KlpTextField(
            initialValue: query,
            placeholder: queryPlaceholder,
            onChanged: onQueryChanged,
          ),
          const KlpGap.heightSize(KlpSpaceSize.contentStack),
          if (loading)
            const KlpCenter(child: KlpText('...'))
          else
            for (final result in results)
              _KlpReferenceOptionRow(
                option: result,
                onPressed: result.disabled || onSelected == null
                    ? null
                    : () => onSelected!(result.id),
              ),
        ],
      ),
    );
  }
}
