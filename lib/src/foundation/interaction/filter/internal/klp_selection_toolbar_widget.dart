part of '../klp_selection_toolbar.dart';

/// 批次選取浮動／固定操作列。
class KlpSelectionToolbar extends StatelessWidget {
	const KlpSelectionToolbar({
		super.key,
		required this.count,
		required this.countLabel,
		required this.actions,
		this.onClear,
		this.clearLabel = 'Clear',
		this.dashed = true,
	});

	final int count;
	final String countLabel;
	final List<KlpSelectionAction> actions;
	final VoidCallback? onClear;
	final String? clearLabel;
	final bool dashed;

	@override
	Widget build(BuildContext context) {
		final content = KlpSurface(
			tone: KlpSurfaceTone.component,
			child: KlpBox(
				insets: KlpBoxInsets.directional(
					start: context.klp.space.base,
					top: context.klp.space.controlInset,
					end: context.klp.space.base,
					bottom: context.klp.space.controlInset,
				),
				child: KlpRow(
					children: [
						KlpText(
							countLabel,
							role: KlpTextRole.caption,
							tone: KlpTextTone.muted,
						),
						const KlpGap.widthSize(KlpSpaceSize.base),
						for (final action in actions) ...[
							KlpButton(
								label: action.label,
								compact: true,
								tone: action.danger
										? KlpButtonTone.danger
										: KlpButtonTone.ghost,
								onPressed: action.onPressed,
							),
							const KlpGap.widthSize(KlpSpaceSize.action),
						],
						const KlpSpacer(),
						if (onClear != null && clearLabel != null)
							KlpActionRegion(
								label: clearLabel!,
								onPressed: onClear,
								shape: KlpActionRegionShape.control,
								builder: (context, style) => KlpBox(
									insets: KlpBoxInsets.directional(
										start: context.klp.space.controlInset,
										top: context.klp.space.hairline,
										end: context.klp.space.controlInset,
										bottom: context.klp.space.hairline,
									),
									child: KlpText(
										clearLabel!,
										role: KlpTextRole.caption,
										color: style.foreground,
									),
								),
							),
					],
				),
			),
		);

		return dashed
				? _KlpSelectionToolbarDashedFrame(child: content)
				: content;
	}
}
