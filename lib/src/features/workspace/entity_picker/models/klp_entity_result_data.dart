part of '../klp_entity_picker.dart';

@immutable
class KlpEntityResultData {
  const KlpEntityResultData({
    required this.kind,
    required this.label,
    this.trailing,
    this.selected = false,
  });

  final String kind;
  final String label;
  final String? trailing;
  final bool selected;
}
