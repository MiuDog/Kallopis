import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

/// 一格色票。顯示角色名、實際色值，以及在該底色上的前景對比。
class Swatch extends StatelessWidget {
  const Swatch({
    super.key,
    required this.role,
    required this.color,
    this.note,
    this.onColor,
  });

  final String role;
  final Color color;
  final String? note;
  final Color? onColor;

  String get _hex =>
      '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final foreground = onColor ?? KlpThemeContrast.foregroundFor(color);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(klp.space.compact),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(klp.shape.card),
            border: Border.all(
              color: klp.color.divider,
              width: klp.shape.hairline,
            ),
          ),
          child: KlpText(_hex, role: KlpTextRole.code, color: foreground),
        ),
        SizedBox(height: klp.space.tight),
        KlpText(role, role: KlpTextRole.caption),
        if (note != null)
          KlpText(note!, role: KlpTextRole.caption, tone: KlpTextTone.faint),
      ],
    );
  }
}

/// 一格數值 token。顯示名稱、數值，以及該數值的實際長度。
class ScaleRow extends StatelessWidget {
  const ScaleRow({
    super.key,
    required this.name,
    required this.value,
    this.note,
  });

  final String name;
  final double value;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: klp.space.tight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 180, child: KlpText(name, role: KlpTextRole.code)),
          SizedBox(
            width: 56,
            child: KlpText(
              value.toStringAsFixed(value % 1 == 0 ? 0 : 2),
              role: KlpTextRole.code,
              tone: KlpTextTone.muted,
            ),
          ),
          Container(
            height: 10,
            width: value.clamp(1, 320),
            decoration: BoxDecoration(
              color: klp.color.accent,
              borderRadius: BorderRadius.circular(klp.shape.control),
            ),
          ),
          if (note != null) ...[
            SizedBox(width: klp.space.base),
            Expanded(
              child: KlpText(
                note!,
                role: KlpTextRole.caption,
                tone: KlpTextTone.faint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// 一格圓角 token。直接畫出該圓角的方塊。
class RadiusSample extends StatelessWidget {
  const RadiusSample({super.key, required this.name, required this.value});

  final String name;
  final double value;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          decoration: BoxDecoration(
            color: klp.color.surfaceInset,
            borderRadius: BorderRadius.circular(value),
            border: Border.all(
              color: klp.color.divider,
              width: klp.shape.hairline,
            ),
          ),
        ),
        SizedBox(height: klp.space.tight),
        KlpText(name, role: KlpTextRole.caption),
        KlpText(
          value.toStringAsFixed(0),
          role: KlpTextRole.code,
          tone: KlpTextTone.faint,
        ),
      ],
    );
  }
}

/// 一段示範文字，附上它實際解析到的字級與行高。
class TypeSample extends StatelessWidget {
  const TypeSample({
    super.key,
    required this.role,
    required this.sample,
    this.note,
  });

  final KlpTextRole role;
  final String sample;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final definition = KlpTextStyles.definitionOf(role, klp.type);

    return Padding(
      padding: EdgeInsets.only(bottom: klp.space.loose),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              KlpText(role.name, role: KlpTextRole.label),
              SizedBox(width: klp.space.compact),
              KlpText(
                '${definition.fontSize.toStringAsFixed(0)}pt · '
                'leading ${definition.lineHeight.toStringAsFixed(2)} · '
                'w${definition.fontWeight.value}',
                role: KlpTextRole.code,
                tone: KlpTextTone.faint,
              ),
            ],
          ),
          SizedBox(height: klp.space.tight),
          KlpText(sample, role: role),
          if (note != null) ...[
            SizedBox(height: klp.space.tight),
            KlpText(note!, role: KlpTextRole.caption, tone: KlpTextTone.muted),
          ],
        ],
      ),
    );
  }
}
