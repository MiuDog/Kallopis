/// Kallopis 專案模組。
library;

import 'package:flutter/foundation.dart';
import '../../feedback/klp_feedback_tone.dart';

/// 排程項目的視圖資料契約。
@immutable
class KlpScheduleItemData {
  const KlpScheduleItemData({
    this.id = '',
    required this.time,
    required this.title,
    this.tag,
    this.tone = KlpFeedbackTone.neutral,
  });

  final String id;
  final String time;
  final String title;
  final String? tag;
  final KlpFeedbackTone tone;

  String get label => title;
}
