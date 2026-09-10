part of '../klp_approval_steps_field.dart';

/// 審批步驟資料。
@immutable
class KlpApprovalStepData {
  const KlpApprovalStepData({required this.id, required this.roleLabel});

  final String id;
  final String roleLabel;
}
