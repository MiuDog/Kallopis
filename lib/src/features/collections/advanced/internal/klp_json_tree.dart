part of '../klp_advanced_data.dart';

/// 任意 JSON 相容值的可展開檢視器。
class KlpJsonTree extends StatelessWidget {
	const KlpJsonTree({
		super.key,
		required this.value,
		this.defaultDepth = 1,
		this.expandedPaths = const {},
		this.loading = false,
		this.invalid = false,
		this.onCopyPath,
	});

	final Object? value;
	final int defaultDepth;
	final Set<String> expandedPaths;
	final bool loading;
	final bool invalid;
	final ValueChanged<String>? onCopyPath;

	@override
	Widget build(BuildContext context) {
		final labels = KlpLocalizations.of(context);
		Widget content;
		if (loading) {
			content = KlpText(
				labels.jsonTreeLoadingLabel,
				role: KlpTextRole.code,
				tone: KlpTextTone.muted,
			);
		} else if (invalid) {
			content = KlpText(
				labels.jsonTreeInvalidLabel,
				role: KlpTextRole.code,
				tone: KlpTextTone.danger,
			);
		} else {
			content = _KlpJsonNode(
				value: value,
				path: r'$',
				depth: 0,
				defaultDepth: defaultDepth,
				expandedPaths: expandedPaths,
				onCopyPath: onCopyPath,
			);
		}

		return KlpBox(
			paddingSize: KlpSpaceSize.base,
			tone: KlpSurfaceTone.component,
			child: content,
		);
	}
}
