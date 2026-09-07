import '../internal/klp_form_dependencies.dart';

@immutable
class KlpReferenceOption {
	const KlpReferenceOption({
		required this.id,
		required this.label,
		this.kind,
		this.metadata,
		this.disabled = false,
	});

	final String id;
	final String label;
	final String? kind;
	final String? metadata;
	final bool disabled;
}
class KlpReferencePicker extends StatelessWidget {
	const KlpReferencePicker({
		super.key,
		required this.title,
		required this.query,
		required this.queryPlaceholder,
		required this.results,
		required this.onQueryChanged,
		required this.onSelected,
		this.loading = false,
	});

	final String title;
	final String query;
	final String queryPlaceholder;
	final List<KlpReferenceOption> results;
	final ValueChanged<String> onQueryChanged;
	final ValueChanged<String>? onSelected;
	final bool loading;

	@override
	Widget build(BuildContext context) {
		return KlpSurface(
			tone: KlpSurfaceTone.component,
			padding: EdgeInsets.all(context.klp.space.base),
			child: Column(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					KlpText(title.toUpperCase(), role: KlpTextRole.label),
					SizedBox(height: context.klp.space.contentStackGap),
					KlpTextField(
						initialValue: query,
						placeholder: queryPlaceholder,
						onChanged: onQueryChanged,
					),
					SizedBox(height: context.klp.space.contentStackGap),
					if (loading)
						const Center(child: KlpText('...'))
					else
						for (final result in results)
							GestureDetector(
								behavior: HitTestBehavior.opaque,
								onTap: result.disabled || onSelected == null
										? null
										: () => onSelected!(result.id),
								child: Container(
									constraints: BoxConstraints(
										minHeight: context.klp.space.controlHeight,
									),
									padding: EdgeInsets.symmetric(
										horizontal: context.klp.space.tight,
									),
									child: Row(
										children: [
											if (result.kind != null) ...[
												KlpBadge(label: result.kind!),
												SizedBox(width: context.klp.space.tight),
											],
											Expanded(
												child: KlpText(
													result.label,
													tone: result.disabled
															? KlpTextTone.faint
															: KlpTextTone.primary,
												),
											),
											if (result.metadata != null)
												KlpText(
													result.metadata!,
													role: KlpTextRole.caption,
													tone: KlpTextTone.faint,
												),
										],
									),
								),
							),
				],
			),
		);
	}
}
