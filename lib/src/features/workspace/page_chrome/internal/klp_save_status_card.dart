part of '../klp_page_chrome.dart';

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
		final klp = context.klp;

		return KlpBox(
			tone: KlpSurfaceTone.component,
			paddingSize: KlpSpaceSize.base,
			child: KlpColumn(
				children: [
					KlpText(
						KlpLocalizations.of(context).savedLabel(savedAt),
						role: KlpTextRole.code,
					),
					const KlpGap.stack(),
					for (final message in messages)
						KlpBox(
							insets: KlpBoxInsets.directional(
								top: klp.space.tight,
								bottom: klp.space.tight,
							),
							child: KlpText(
								message.label,
								role: KlpTextRole.code,
								color: message.tone.color(klp.color),
							),
						),
				],
			),
		);
	}
}
