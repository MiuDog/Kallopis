import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../controls/klp_icon_button.dart';
import '../data/klp_badge.dart';
import '../form/klp_form_controls.dart';
import '../foundation/klp_icons.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';

/// 帶有範圍標籤、附件動作與提交動作的多行訊息輸入器。
class KlpMessageComposer extends StatelessWidget {
  const KlpMessageComposer({
    super.key,
    required this.placeholder,
    required this.sendLabel,
    required this.attachLabel,
    required this.onSend,
    required this.onAttach,
    this.tags = const [],
    this.value,
    this.onChanged,
  });

  final String placeholder;
  final String sendLabel;
  final String attachLabel;
  final VoidCallback? onSend;
  final VoidCallback? onAttach;
  final List<String> tags;
  final String? value;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final space = context.klp.space;

    return KlpSurface(
      tone: KlpSurfaceTone.muted,
      padding: EdgeInsets.all(space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (tags.isNotEmpty) ...[
            Wrap(
              spacing: space.compact,
              runSpacing: space.tight,
              children: [for (final tag in tags) KlpBadge(label: tag)],
            ),
            SizedBox(height: space.compact),
          ],
          KlpTextArea(
            value: value,
            placeholder: placeholder,
            onChanged: onChanged,
          ),
          SizedBox(height: space.compact),
          Row(
            children: [
              KlpIconButton(
                icon: KlpIcons.folderPlus,
                label: attachLabel,
                onPressed: onAttach,
              ),
              const Spacer(),
              KlpButton(label: sendLabel, compact: true, onPressed: onSend),
            ],
          ),
        ],
      ),
    );
  }
}
