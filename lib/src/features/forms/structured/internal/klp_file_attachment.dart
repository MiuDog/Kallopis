part of '../klp_file_dropzone_field.dart';

/// 檔案附件資料。包含檔名、檔案大小與可選的上傳進度 (0.0~1.0)。
@immutable
class KlpFileAttachment {
  const KlpFileAttachment({
    required this.name,
    required this.size,
    this.progress,
  });

  final String name;
  final String size;
  final double? progress;
}
