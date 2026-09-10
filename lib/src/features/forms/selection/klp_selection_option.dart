import 'package:flutter/foundation.dart';

import '../../../foundation/klp_icon.dart';
import 'klp_selection_tone.dart';

@immutable
class KlpSelectionOption {
  const KlpSelectionOption({required this.icon, required this.tone});

  final KlpIconData icon;
  final KlpSelectionTone tone;
}
