import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../foundation/klp_oklch_color.dart';
import '../../../foundation/interaction/klp_exclude_semantics.dart';
import '../../../foundation/interaction/klp_semantic_region.dart';
import '../../../foundation/layout/klp_layout.dart';
import '../../../application/localization/klp_localizations.dart';
import '../../../styling/legacy_theme/klp_theme.dart';
import '../../../foundation/content/klp_text.dart';
import 'klp_oklch_chroma_range.dart';
import 'klp_oklch_color_editor.dart';

part 'internal/klp_oklch_color_picker_content.dart';
part 'internal/klp_oklch_color_picker_style.dart';
part 'internal/klp_oklch_color_picker_widget.dart';
part 'internal/klp_oklch_plane.dart';
part 'internal/klp_oklch_plane_kind.dart';
part 'internal/klp_oklch_plane_section.dart';
part 'internal/klp_oklch_plane_state.dart';
part 'internal/klp_oklch_plane_style.dart';
part 'internal/klp_oklch_preview.dart';
part 'primitives/klp_oklch_plane_extent_frame.dart';
part 'primitives/klp_oklch_plane_frame.dart';
part 'primitives/klp_oklch_plane_painter.dart';
part 'primitives/klp_oklch_preview_frame.dart';
part 'primitives/klp_oklch_section_frame.dart';
