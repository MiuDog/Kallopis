part of '../klp_entity_picker.dart';

class KlpEntityPicker extends StatelessWidget {
	const KlpEntityPicker({
		super.key,
		required this.title,
		required this.initialQuery,
		required this.results,
		required this.onQueryChanged,
		required this.onClear,
		required this.onApply,
		this.onResultSelected,
	});

	final String title;
	final String initialQuery;
	final List<KlpEntityResultData> results;
	final ValueChanged<String> onQueryChanged;
	final VoidCallback onClear;
	final VoidCallback onApply;
	final ValueChanged<int>? onResultSelected;

	@override
	Widget build(BuildContext context) {
		final l10n = KlpLocalizations.of(context);

		return KlpBox(
			tone: KlpSurfaceTone.component,
			paddingSize: KlpSpaceSize.base,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpText(title.toUpperCase(), role: KlpTextRole.label),
					const KlpGap.stack(),
					KlpTextField(initialValue: initialQuery, onChanged: onQueryChanged),
					const KlpGap.stack(),
					for (var index = 0; index < results.length; index++)
						_KlpEntityResult(
							data: results[index],
							onPressed: onResultSelected == null
								? null
								: () => onResultSelected!(index),
						),
					const KlpGap.stack(),
					KlpRow(
						mainAxisAlignment: MainAxisAlignment.end,
						children: [
							KlpButton(
								label: l10n.entityPickerRemoveLabel,
								onPressed: onClear,
								tone: KlpButtonTone.ghost,
								compact: true,
							),
							const KlpGap.inline(),
							KlpButton(
								label: l10n.entityPickerApplyLabel,
								onPressed: onApply,
								tone: KlpButtonTone.primary,
								compact: true,
							),
						],
					),
				],
			),
		);
	}
}
