part of 'klp_editor_action_bars.dart';

/// 呈現搜尋輸入、結果位置與前後導覽動作。
class KlpSearchNavigator extends StatelessWidget {
	const KlpSearchNavigator({
		super.key,
		required this.initialQuery,
		required this.current,
		required this.total,
		required this.onPrevious,
		required this.onNext,
		required this.onClose,
		this.onQueryChanged,
	});

	final String initialQuery;
	final int current;
	final int total;
	final VoidCallback? onPrevious;
	final VoidCallback? onNext;
	final VoidCallback? onClose;
	final ValueChanged<String>? onQueryChanged;

	@override
	Widget build(BuildContext context) {
		final l10n = KlpLocalizations.of(context);

		return _KlpEditorActionSurface(
			child: KlpRow(
				children: [
					KlpExpanded(
						child: KlpTextField(
							initialValue: initialQuery,
							onChanged: onQueryChanged,
						),
					),
					const KlpGap.widthSize(KlpSpaceSize.contentInline),
					KlpText('$current/$total', role: KlpTextRole.code),
					const KlpGap.widthSize(KlpSpaceSize.tight),
					KlpRotate(
						turn: KlpQuarterTurn.half,
						child: KlpIconButton(
							icon: KlpIcons.chevronDown,
							label: l10n.searchPreviousResultLabel,
							onPressed: onPrevious,
						),
					),
					KlpIconButton(
						icon: KlpIcons.chevronDown,
						label: l10n.searchNextResultLabel,
						onPressed: onNext,
					),
					KlpIconButton(
						icon: KlpIcons.x,
						label: l10n.searchCloseLabel,
						onPressed: onClose,
					),
				],
			),
		);
	}
}
