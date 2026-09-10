part of '../klp_stepper.dart';

/// 步驟流程中的一步。
@immutable
class KlpStepData {
  const KlpStepData({required this.label, this.description});

  final String label;
  final String? description;
}
