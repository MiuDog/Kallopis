import 'package:kallopis/src/foundation/localization/klp_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:kallopis/src/features/feedback/klp_feedback_tone.dart';
import 'package:kallopis/src/features/feedback/klp_inline_notice.dart';
import 'package:kallopis/src/features/feedback/view_states/klp_view_states.dart';
import 'package:kallopis/src/foundation/layout/klp_layout.dart';
import 'package:kallopis/src/foundation/surface/klp_surface.dart';

import 'klp_block_note_web_session_loader.dart';

/// 固定的 BlockNote 載入失敗呈現，不開放 consumer 置換內容或風格。
final class KlpBlockNoteLoadError extends StatelessWidget {
	final bool canRetry;
	final VoidCallback onRetry;
	const KlpBlockNoteLoadError({required this.canRetry, required this.onRetry, super.key});

	@override
	Widget build(BuildContext context) {
		final l10n = KlpLocalizations.of(context);
		if (canRetry) {
			return KlpErrorState(
				title: l10n.editorLoadFailedTitle,
				message: l10n.editorLoadFailedMessage,
				retryLabel: l10n.editorRetryLabel,
				onRetry: onRetry,
			);
		}
		return KlpInlineNotice(
			title: l10n.editorInterruptedTitle,
			message: l10n.editorInterruptedMessage,
			tone: KlpFeedbackTone.danger,
		);
	}
}

/// 疊加載入狀態並持續保留同一個 WebView child，避免卸載尚未儲存的正文。
final class KlpBlockNoteLoadSurface extends StatelessWidget {
	final KlpBlockNoteWebSessionLoader loader;
	final Widget child;
	final VoidCallback onRetry;
	const KlpBlockNoteLoadSurface({required this.loader, required this.child, required this.onRetry, super.key});

	@override
	Widget build(BuildContext context) {
		final error = loader.error;
		return KlpStack(
			fit: StackFit.expand,
			children: [
				child,
				if (error != null && loader.canRetry)
					KlpPositioned.fill(
						child: KlpSurface(
							tone: KlpSurfaceTone.component,
							child: KlpCenter(
								child: KlpBox(
									marginSize: KlpSpaceSize.base,
									child: KlpBlockNoteLoadError(canRetry: true, onRetry: onRetry),
								),
							),
						),
					)
				else if (error != null)
					KlpPositioned(
						left: 0,
						right: 0,
						bottom: 0,
						child: KlpBox(
							marginSize: KlpSpaceSize.base,
							child: KlpBlockNoteLoadError(canRetry: false, onRetry: onRetry),
						),
					),
			],
		);
	}
}
