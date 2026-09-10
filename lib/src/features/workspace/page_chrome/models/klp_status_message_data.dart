part of '../klp_page_chrome.dart';

/// [KlpSaveStatusCard] 裡的一則狀態訊息，例如「已同步」「有欄位驗證失敗」。
/// [tone] 為 [KlpFeedbackTone.neutral] 時走低對比的靜音文字色，其餘 tone 才
/// 使用對應的狀態色。
@immutable
class KlpStatusMessageData {
  const KlpStatusMessageData({
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
  });

  final String label;
  final KlpFeedbackTone tone;
}
