import 'package:flutter/widgets.dart';
import 'package:kallopis/kallopis.dart';

/// ink 色梯，由階名對應到色值。
///
/// 用來**反查**某個語意角色落在梯上的哪一階。反查而不是手寫標籤：手寫的標籤會與
/// 實際映射分岔，而分岔時畫面看起來完全正常。
const Map<String, Color> inkRamp = {
  'ink50': KlpPalette.ink50,
  'ink100': KlpPalette.ink100,
  'ink150': KlpPalette.ink150,
  'ink200': KlpPalette.ink200,
  'ink250': KlpPalette.ink250,
  'ink300': KlpPalette.ink300,
  'ink350': KlpPalette.ink350,
  'ink400': KlpPalette.ink400,
  'ink450': KlpPalette.ink450,
  'ink500': KlpPalette.ink500,
  'ink550': KlpPalette.ink550,
  'ink600': KlpPalette.ink600,
  'ink650': KlpPalette.ink650,
  'ink700': KlpPalette.ink700,
  'ink750': KlpPalette.ink750,
  'ink800': KlpPalette.ink800,
  'ink850': KlpPalette.ink850,
  'ink900': KlpPalette.ink900,
  'ink950': KlpPalette.ink950,
};

/// 這個顏色落在色梯的哪一階；不在梯上時回傳 `null`。
String? inkStepOf(Color color) {
  for (final entry in inkRamp.entries) {
    if (entry.value.toARGB32() == color.toARGB32()) return entry.key;
  }
  return null;
}

/// 一格色票。
///
/// **只顯示語意角色與它落在色梯的哪一階，不顯示色碼。** 目錄一旦印出 hex，就等於在
/// 邀請人把那串數字複製到自己的程式碼裡——那正是整個 token 架構要防的事。
/// 要知道實際色值，看 `KlpPalette` 的定義，那裡的權威格式是 oklch。
///
/// 階名是**反查**出來的，因此不在梯上的欄位會直接顯示為「梯外」——
/// 這讓「所有欄位都必須上梯」在畫面上就看得出來，不必等測試。
class Swatch extends StatelessWidget {
  const Swatch({
    super.key,
    required this.role,
    required this.color,
    this.note,
    this.onColor,
    this.offRamp,
  });

  /// 語意角色，例如 `surface`。
  final String role;

  final Color color;
  final String? note;
  final Color? onColor;

  /// 這個角色**本來就不在中性色梯上**時，說明它是什麼。
  ///
  /// 彩色強調色與對比前景都不該在梯上，每格都標「梯外」只是雜訊。
  /// 留空表示它應該在梯上——那時顯示「梯外」才是有意義的警告。
  final String? offRamp;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final foreground =
        onColor ??
        (color == KlpPalette.transparent || color.a == 0
            ? klp.color.text
            : KlpThemeContrast.foregroundFor(color));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 56,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: klp.space.compact),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(klp.shape.card),
            border: Border.all(
              color: klp.color.divider,
              width: klp.shape.hairline,
            ),
          ),
          child: KlpText(
            inkStepOf(color) ?? offRamp ?? '梯外',
            role: KlpTextRole.body,
            color: foreground,
          ),
        ),
        SizedBox(height: klp.space.tight),
        KlpText(role, role: KlpTextRole.body),
        if (note != null)
          KlpText(note!, role: KlpTextRole.sub, tone: KlpTextTone.muted),
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
          SizedBox(width: 180, child: KlpText(name, role: KlpTextRole.body)),
          SizedBox(
            width: 56,
            child: KlpText(
              value.toStringAsFixed(value % 1 == 0 ? 0 : 2),
              role: KlpTextRole.body,
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
                role: KlpTextRole.sub,
                tone: KlpTextTone.muted,
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
        KlpText(name, role: KlpTextRole.body),
        KlpText(
          value.toStringAsFixed(0),
          role: KlpTextRole.sub,
          tone: KlpTextTone.muted,
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
              KlpText(role.name, role: KlpTextRole.body),
              SizedBox(width: klp.space.compact),
              KlpText(
                '${definition.fontSize.toStringAsFixed(0)}pt · '
                'leading ${definition.lineHeight.toStringAsFixed(2)} · '
                'w${definition.fontWeight.value}',
                role: KlpTextRole.sub,
                tone: KlpTextTone.muted,
              ),
            ],
          ),
          SizedBox(height: klp.space.tight),
          KlpText(sample, role: role),
          if (note != null) ...[
            SizedBox(height: klp.space.tight),
            KlpText(note!, role: KlpTextRole.sub, tone: KlpTextTone.muted),
          ],
        ],
      ),
    );
  }
}

/// 一格時長 token。
class DurationRow extends StatelessWidget {
  const DurationRow({
    super.key,
    required this.name,
    required this.duration,
    this.note,
  });

  final String name;
  final Duration duration;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;
    final ms = duration.inMilliseconds.toDouble();

    return Padding(
      padding: EdgeInsets.symmetric(vertical: klp.space.tight),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: 180, child: KlpText(name, role: KlpTextRole.body)),
          SizedBox(
            width: 72,
            child: KlpText(
              '${duration.inMilliseconds}ms',
              role: KlpTextRole.body,
              tone: KlpTextTone.muted,
            ),
          ),
          Container(
            height: 10,
            width: (ms / 2).clamp(1, 320),
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
                role: KlpTextRole.sub,
                tone: KlpTextTone.muted,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
