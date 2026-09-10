import '../internal/klp_form_dependencies.dart';
import 'models/klp_status_role.dart';

export 'models/klp_status_role.dart';

part 'primitives/klp_status_role_swatch_frame.dart';

/// 狀態色彩角色色票組。只提供語意角色選擇，不提供直接色碼選擇。
class KlpStatusRoleSwatches extends StatelessWidget {
  const KlpStatusRoleSwatches({
    super.key,
    required this.label,
    this.helper,
    this.selectedRole,
    this.onSelectRole,
  });

  final String label;
  final String? helper;
  final KlpStatusRole? selectedRole;
  final ValueChanged<KlpStatusRole>? onSelectRole;

  @override
  Widget build(BuildContext context) {
    return KlpColumn(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label, role: KlpTextRole.caption),
        if (helper != null) ...[
          const KlpGap.heightSize(KlpSpaceSize.tight),
          KlpText(helper!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
        const KlpGap.heightSize(KlpSpaceSize.tight),
        KlpWrap(
          spacingSize: KlpSpaceSize.base,
          runSpacingSize: KlpSpaceSize.contentStack,
          children: [
            for (final role in KlpStatusRole.values)
              KlpGestureRegion(
                behavior: HitTestBehavior.opaque,
                onTap: onSelectRole == null ? null : () => onSelectRole!(role),
                child: KlpRow(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _KlpStatusRoleSwatchFrame(role: role),
                    const KlpGap.widthSize(KlpSpaceSize.tight),
                    KlpText(
                      role.label,
                      role: KlpTextRole.code,
                      tone: selectedRole == role
                          ? KlpTextTone.primary
                          : KlpTextTone.muted,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
