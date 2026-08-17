import 'package:flutter/widgets.dart';

import '../foundation/klp_icons.dart';
import '../theme/klp_theme.dart';

enum KlpFeedbackTone { info, success, warning, danger, neutral }

extension KlpFeedbackToneStyle on KlpFeedbackTone {
  Color color(KlpThemeData tokens) {
    return switch (this) {
      KlpFeedbackTone.info => tokens.info,
      KlpFeedbackTone.success => tokens.success,
      KlpFeedbackTone.warning => tokens.warning,
      KlpFeedbackTone.danger => tokens.danger,
      KlpFeedbackTone.neutral => tokens.textMuted,
    };
  }

  String get icon => switch (this) {
    KlpFeedbackTone.info => KlpIcons.infoSquare,
    KlpFeedbackTone.success => KlpIcons.checkSquare,
    KlpFeedbackTone.warning => KlpIcons.alertSquare,
    KlpFeedbackTone.danger => KlpIcons.xSquare,
    KlpFeedbackTone.neutral => KlpIcons.minus,
  };

  String get label => switch (this) {
    KlpFeedbackTone.info => 'INFO',
    KlpFeedbackTone.success => 'DONE',
    KlpFeedbackTone.warning => 'CHECK',
    KlpFeedbackTone.danger => 'FAILED',
    KlpFeedbackTone.neutral => 'NOTE',
  };
}
