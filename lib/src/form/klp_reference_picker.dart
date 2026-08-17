import 'package:flutter/widgets.dart';

import '../controls/klp_text_field.dart';
import '../data/klp_badge.dart';
import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';

@immutable
class KlpReferenceOption {
  const KlpReferenceOption({
    required this.id,
    required this.label,
    this.kind,
    this.metadata,
    this.disabled = false,
  });

  final String id;
  final String label;
  final String? kind;
  final String? metadata;
  final bool disabled;
}

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
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: const EdgeInsets.all(KlpSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KlpText(title.toUpperCase(), role: KlpTextRole.label),
          const SizedBox(height: KlpSpace.sm),
          KlpTextField(
            initialValue: query,
            placeholder: queryPlaceholder,
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: KlpSpace.sm),
          if (loading)
            const Center(child: KlpText('...'))
          else
            for (final result in results)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: result.disabled || onSelected == null
                    ? null
                    : () => onSelected!(result.id),
                child: Container(
                  constraints: const BoxConstraints(minHeight: KlpSize.control),
                  padding: const EdgeInsets.symmetric(horizontal: KlpSpace.xs),
                  child: Row(
                    children: [
                      if (result.kind != null) ...[
                        KlpBadge(label: result.kind!),
                        const SizedBox(width: KlpSpace.xs),
                      ],
                      Expanded(
                        child: KlpText(
                          result.label,
                          tone: result.disabled
                              ? KlpTextTone.faint
                              : KlpTextTone.primary,
                        ),
                      ),
                      if (result.metadata != null)
                        KlpText(
                          result.metadata!,
                          role: KlpTextRole.caption,
                          tone: KlpTextTone.faint,
                        ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

typedef KlpPagePicker = KlpReferencePicker;
typedef KlpAssetPicker = KlpReferencePicker;
typedef KlpMemberPicker = KlpReferencePicker;
typedef KlpAgentPicker = KlpReferencePicker;
typedef KlpModelPicker = KlpReferencePicker;
typedef KlpToolPicker = KlpReferencePicker;
typedef KlpMcpPicker = KlpReferencePicker;
typedef KlpWorkflowPicker = KlpReferencePicker;
typedef KlpResultPicker = KlpReferencePicker;
typedef KlpPermissionPicker = KlpReferencePicker;
typedef KlpCredentialReferenceField = KlpReferencePicker;
typedef KlpResourcePicker = KlpReferencePicker;
