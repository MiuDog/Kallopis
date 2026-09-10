part of 'klp_view_states.dart';

class KlpErrorState extends StatelessWidget {
	const KlpErrorState({
		super.key,
		required this.title,
		required this.message,
		this.icon,
		this.retryLabel,
		this.onRetry,
	});

	final String title;
	final String message;
	final KlpIconData? icon;
	final String? retryLabel;
	final VoidCallback? onRetry;

	@override
	Widget build(BuildContext context) {
		return _KlpViewState(
			icon: icon,
			iconColor: context.klpColors.danger,
			title: title,
			message: message,
			action: retryLabel == null ? null : KlpButton(label: retryLabel!, tone: KlpButtonTone.primary, onPressed: onRetry),
		);
	}
}
