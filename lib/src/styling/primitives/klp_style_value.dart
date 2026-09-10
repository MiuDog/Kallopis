import '../../kernel/diagnostics/klp_contract_error.dart';

part 'klp_distance.dart';
part 'klp_radius.dart';
part 'klp_stroke_width.dart';
part 'klp_font_size.dart';
part 'klp_font_weight.dart';
part 'klp_line_height.dart';
part 'klp_letter_spacing.dart';
part 'klp_duration.dart';
part 'klp_color.dart';
part 'klp_font_family.dart';
part 'klp_curve.dart';

/// 封閉的中立風格值集合，不允許外部加入新種類。
sealed class KlpStyleValue {
  const KlpStyleValue();
}
