part of 'klp_code_models.dart';

/// Diff 單行資料。
@immutable
class KlpDiffLine {
  const KlpDiffLine({
    this.oldNumber,
    this.newNumber,
    required this.content,
    this.type = KlpDiffLineType.unchanged,
    this.onApprove,
    this.onReject,
  });

  final int? oldNumber;
  final int? newNumber;
  final String content;
  final KlpDiffLineType type;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
}
