import 'package:flutter/widgets.dart';

import '../controls/klp_button.dart';
import '../surface/klp_surface.dart';
import '../typography/klp_text.dart';
import '../theme/klp_theme.dart';

/// 對話框內容。**不負責彈出**——呼叫端自行決定用 `showDialog` 或其他方式呈現。
/// `secondaryLabel` 為必填：庫不替產品決定用什麼語言說「取消」。
class KlpDialog extends StatelessWidget {
  const KlpDialog({
    super.key,
    required this.label,
    required this.title,
    required this.child,
    required this.primaryLabel,
    required this.onPrimary,
    required this.secondaryLabel,
    this.onSecondary,
  });

  final String label;
  final String title;
  final Widget child;
  final String primaryLabel;
  final VoidCallback onPrimary;

  /// 次要動作的文字。**沒有預設值是刻意的**——庫不替產品決定用什麼語言說「取消」。
  final String secondaryLabel;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: context.klp.geometry.layout.dialogMaximumWidth,
      ),
      child: KlpSurface(
        tone: KlpSurfaceTone.base,
        radius: context.klp.shape.panel,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.all(context.klp.space.comfortable),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KlpText(label.toUpperCase(), role: KlpTextRole.label),
                  SizedBox(height: context.klp.space.compact),
                  KlpText(title, role: KlpTextRole.title),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(context.klp.space.comfortable),
              child: child,
            ),
            Padding(
              padding: EdgeInsets.all(context.klp.space.base),
              child: Wrap(
                alignment: WrapAlignment.end,
                spacing: context.klp.space.compact,
                runSpacing: context.klp.space.compact,
                children: [
                  KlpButton(
                    label: secondaryLabel,
                    onPressed: onSecondary,
                    tone: KlpButtonTone.ghost,
                  ),
                  KlpButton(
                    label: primaryLabel,
                    onPressed: onPrimary,
                    tone: KlpButtonTone.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
