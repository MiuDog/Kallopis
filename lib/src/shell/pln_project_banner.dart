import 'package:flutter/material.dart';

import '../foundation/pln_icon.dart';
import '../foundation/pln_icons.dart';
import '../foundation/pln_metrics.dart';
import '../theme/pln_theme.dart';
import '../typography/pln_text.dart';

class PlnProjectBanner extends StatelessWidget {
  const PlnProjectBanner({
    super.key,
    required this.name,
    required this.team,
    this.onPressed,
    this.trailing,
  });

  final String name;
  final String team;
  final VoidCallback? onPressed;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final tokens = context.plnTheme;
    final banner = SizedBox(
      height: PlnSize.projectBanner,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: PlnSpace.md),
        child: Row(
          children: [
            Container(
              width: PlnSize.projectAvatar,
              height: PlnSize.projectAvatar,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: tokens.component,
                borderRadius: BorderRadius.circular(PlnRadius.control),
              ),
              child: PlnIcon(
                PlnIcons.folder,
                size: PlnSize.iconSmall,
                color: tokens.text,
              ),
            ),
            const SizedBox(width: PlnSpace.sm),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PlnText(
                    name,
                    role: PlnTextRole.body,
                    tone: PlnTextTone.primary,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  PlnText(
                    team,
                    role: PlnTextRole.label,
                    tone: PlnTextTone.faint,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onPressed != null) ...[
              const SizedBox(width: PlnSpace.xs),
              PlnIcon(
                PlnIcons.chevronDown,
                size: PlnSize.iconSmall,
                color: tokens.textMuted,
              ),
            ],
          ],
        ),
      ),
    );

    return Material(
      color: onPressed == null
          ? tokens.surface.withValues(alpha: 0)
          : tokens.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(PlnRadius.control),
      ),
      child: InkWell(
        onTap: onPressed,
        hoverColor: tokens.hoverSurface,
        excludeFromSemantics: true,
        borderRadius: BorderRadius.circular(PlnRadius.control),
        child: Row(
          children: [
            Expanded(
              child: onPressed == null
                  ? banner
                  : Semantics(
                      button: true,
                      enabled: true,
                      label: '$name · $team',
                      child: ExcludeSemantics(child: banner),
                    ),
            ),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: PlnSpace.sm),
            ],
          ],
        ),
      ),
    );
  }
}
