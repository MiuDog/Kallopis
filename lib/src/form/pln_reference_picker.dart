import 'package:flutter/widgets.dart';

import '../controls/pln_text_field.dart';
import '../data/pln_badge.dart';
import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';
import '../typography/pln_text.dart';

@immutable
class PlnReferenceOption {
  const PlnReferenceOption({
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

class PlnReferencePicker extends StatelessWidget {
  const PlnReferencePicker({
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
  final List<PlnReferenceOption> results;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<String>? onSelected;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: PlnSurfaceTone.component,
      padding: const EdgeInsets.all(PlnSpace.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PlnText(title.toUpperCase(), role: PlnTextRole.label),
          const SizedBox(height: PlnSpace.sm),
          PlnTextField(
            initialValue: query,
            placeholder: queryPlaceholder,
            onChanged: onQueryChanged,
          ),
          const SizedBox(height: PlnSpace.sm),
          if (loading)
            const Center(child: PlnText('...'))
          else
            for (final result in results)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: result.disabled || onSelected == null
                    ? null
                    : () => onSelected!(result.id),
                child: Container(
                  constraints: const BoxConstraints(minHeight: PlnSize.control),
                  padding: const EdgeInsets.symmetric(horizontal: PlnSpace.xs),
                  child: Row(
                    children: [
                      if (result.kind != null) ...[
                        PlnBadge(label: result.kind!),
                        const SizedBox(width: PlnSpace.xs),
                      ],
                      Expanded(
                        child: PlnText(
                          result.label,
                          tone: result.disabled
                              ? PlnTextTone.faint
                              : PlnTextTone.primary,
                        ),
                      ),
                      if (result.metadata != null)
                        PlnText(
                          result.metadata!,
                          role: PlnTextRole.caption,
                          tone: PlnTextTone.faint,
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

typedef PlnPagePicker = PlnReferencePicker;
typedef PlnAssetPicker = PlnReferencePicker;
typedef PlnMemberPicker = PlnReferencePicker;
typedef PlnAgentPicker = PlnReferencePicker;
typedef PlnModelPicker = PlnReferencePicker;
typedef PlnToolPicker = PlnReferencePicker;
typedef PlnMcpPicker = PlnReferencePicker;
typedef PlnWorkflowPicker = PlnReferencePicker;
typedef PlnResultPicker = PlnReferencePicker;
typedef PlnPermissionPicker = PlnReferencePicker;
typedef PlnCredentialReferenceField = PlnReferencePicker;
typedef PlnResourcePicker = PlnReferencePicker;
