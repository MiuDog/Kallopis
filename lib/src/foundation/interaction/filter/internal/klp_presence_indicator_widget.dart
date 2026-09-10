part of '../klp_presence_indicator.dart';

/// 協作者在線／連線狀態標記。
class KlpPresenceIndicator extends StatelessWidget {
	const KlpPresenceIndicator({
		super.key,
		required this.label,
		required this.active,
	});

	final String label;
	final bool active;

	@override
	Widget build(BuildContext context) {
		return KlpRow(
			mainAxisSize: MainAxisSize.min,
			children: [
				_KlpPresenceMarker(active: active),
				const KlpGap.widthSize(KlpSpaceSize.tight),
				_KlpPresenceLabel(label: label, active: active),
			],
		);
	}
}
