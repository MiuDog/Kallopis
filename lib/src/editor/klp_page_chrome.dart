import 'package:flutter/widgets.dart';

import '../data/klp_badge.dart';
import '../feedback/klp_feedback_tone.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';
import '../typography/klp_text.dart';

/// 頁面頂部的識別區塊：麵包屑導覽、選填的狀態文字與協作者標記，以及頁面
/// 大標題。
///
/// [breadcrumb] 以 `/` 串接顯示，不提供逐段可點擊的導覽——需要可點擊麵包屑
/// 請改用 [KlpBreadcrumb]。[status] 與 [collaborator] 都是單一文字，若要顯示
/// 多位協作者或多筆狀態，需自行組合字串或改用其他元件。
class KlpPageChrome extends StatelessWidget {
  const KlpPageChrome({
    super.key,
    required this.breadcrumb,
    required this.title,
    this.status,
    this.collaborator,
  });

  final List<String> breadcrumb;
  final String title;
  final String? status;
  final String? collaborator;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.all(context.klp.space.comfortable),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: context.klp.space.tight,
            runSpacing: context.klp.space.tight,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              KlpText(
                breadcrumb.join(' / '),
                role: KlpTextRole.code,
                tone: KlpTextTone.muted,
              ),
              if (status != null) ...[
                KlpText('•', color: tokens.text),
                KlpText(
                  status!,
                  role: KlpTextRole.caption,
                  tone: KlpTextTone.muted,
                ),
              ],
              if (collaborator != null) KlpBadge(label: collaborator!),
            ],
          ),
          SizedBox(height: context.klp.space.base),
          KlpText(title, role: KlpTextRole.display),
        ],
      ),
    );
  }
}

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

/// 顯示最後儲存時間與一組相關狀態訊息的卡片，用於編輯器頁面告知使用者
/// 目前的儲存／同步狀況。
///
/// [savedAt] 是已經格式化好的顯示文字（例如「2 分鐘前」），這個元件不處理
/// 時間格式化或相對時間更新。
class KlpSaveStatusCard extends StatelessWidget {
  const KlpSaveStatusCard({
    super.key,
    required this.savedAt,
    required this.messages,
  });

  final String savedAt;
  final List<KlpStatusMessageData> messages;

  @override
  Widget build(BuildContext context) {
    final tokens = context.klpColors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.component,
        borderRadius: BorderRadius.circular(context.klp.shape.card),
      ),
      child: Padding(
        padding: EdgeInsets.all(context.klp.space.base),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            KlpText('Saved $savedAt', role: KlpTextRole.code),
            SizedBox(height: context.klp.space.compact),
            for (final message in messages)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: context.klp.space.tight,
                ),
                child: KlpText(
                  message.label,
                  role: KlpTextRole.code,
                  color: message.tone == KlpFeedbackTone.neutral
                      ? tokens.textMuted
                      : message.tone.color(tokens),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// 實體的屬性摘要卡片：一排狀態徽章、一排標籤，再加一行中繼資料文字，
/// 依序垂直排列。
///
/// 三段固定按這個順序（badges → tags → metadata）呈現，不是各自獨立可
/// 重排的插槽；若版面需要不同順序或省略某一段，請直接組合
/// [KlpBadge]／[KlpTag]／[KlpText] 而不是硬塞空清單進來。
class KlpPropertySummary extends StatelessWidget {
  const KlpPropertySummary({
    super.key,
    required this.badges,
    required this.tags,
    required this.metadata,
  });

  final List<KlpPropertyBadgeData> badges;
  final List<String> tags;
  final String metadata;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: KlpSurfaceTone.component,
      padding: EdgeInsets.all(context.klp.space.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: context.klp.space.tight,
            runSpacing: context.klp.space.tight,
            children: [
              for (final badge in badges)
                KlpBadge(label: badge.label, tone: badge.tone, dot: badge.dot),
            ],
          ),
          SizedBox(height: context.klp.space.compact),
          Wrap(
            spacing: context.klp.space.tight,
            runSpacing: context.klp.space.tight,
            children: [for (final tag in tags) KlpTag(label: tag)],
          ),
          SizedBox(height: context.klp.space.compact),
          KlpText(metadata, role: KlpTextRole.caption, tone: KlpTextTone.muted),
        ],
      ),
    );
  }
}

/// [KlpPropertySummary.badges] 的一筆徽章資料，直接對應 [KlpBadge] 的
/// `label`／`tone`／`dot` 參數。
@immutable
class KlpPropertyBadgeData {
  const KlpPropertyBadgeData({
    required this.label,
    this.tone = KlpFeedbackTone.neutral,
    this.dot = false,
  });

  final String label;
  final KlpFeedbackTone tone;
  final bool dot;
}
