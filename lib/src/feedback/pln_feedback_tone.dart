import 'package:flutter/widgets.dart';

import '../foundation/pln_icons.dart';
import '../theme/pln_theme.dart';

enum PlnFeedbackTone { info, success, warning, danger, neutral }

extension PlnFeedbackToneStyle on PlnFeedbackTone {
  Color color(PlnThemeData tokens) {
    return switch (this) {
      PlnFeedbackTone.info => tokens.info,
      PlnFeedbackTone.success => tokens.success,
      PlnFeedbackTone.warning => tokens.warning,
      PlnFeedbackTone.danger => tokens.danger,
      PlnFeedbackTone.neutral => tokens.textMuted,
    };
  }

  String get icon => switch (this) {
    PlnFeedbackTone.info => PlnIcons.infoSquare,
    PlnFeedbackTone.success => PlnIcons.checkSquare,
    PlnFeedbackTone.warning => PlnIcons.alertSquare,
    PlnFeedbackTone.danger => PlnIcons.xSquare,
    PlnFeedbackTone.neutral => PlnIcons.minus,
  };

  String get label => switch (this) {
    PlnFeedbackTone.info => 'INFO',
    PlnFeedbackTone.success => 'DONE',
    PlnFeedbackTone.warning => 'CHECK',
    PlnFeedbackTone.danger => 'FAILED',
    PlnFeedbackTone.neutral => 'NOTE',
  };
}
