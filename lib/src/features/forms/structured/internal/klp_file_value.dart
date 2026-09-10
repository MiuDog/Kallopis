part of '../klp_file_field.dart';

/// [KlpFileField] 顯示的一個已選檔案：識別碼、檔名，與選填的中繼資料文字
/// （例如檔案大小或上傳時間，顯示格式由呼叫端自行組字串）。
@immutable
class KlpFileValue {
  const KlpFileValue({required this.id, required this.name, this.metadata});

  final String id;
  final String name;
  final String? metadata;
}
