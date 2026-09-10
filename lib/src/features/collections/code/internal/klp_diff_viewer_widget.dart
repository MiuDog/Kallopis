part of '../klp_code_viewer.dart';

/// 程式碼差異檢視器。
class KlpDiffViewer extends StatelessWidget {
	const KlpDiffViewer({
		super.key,
		required this.filename,
		required this.lines,
		this.viewportLimit,
		this.onCopy,
	});

	final String filename;
	final List<KlpDiffLine> lines;
	final KlpCodeViewportLimit? viewportLimit;
	final VoidCallback? onCopy;

	@override
	Widget build(BuildContext context) {
		final style = _KlpCodeStyle.from(context);
		final labels = KlpLocalizations.of(context);

		return _KlpCodeFrame(
			kind: _KlpCodeFrameKind.outer,
			style: style,
			child: KlpColumn(
				crossAxisAlignment: CrossAxisAlignment.stretch,
				children: [
					_KlpCodeFrame(
						kind: _KlpCodeFrameKind.headerSymmetric,
						style: style,
						child: KlpRow(
							children: [
								KlpText(
									filename.toUpperCase(),
									role: KlpTextRole.code,
									tone: KlpTextTone.muted,
								),
								const KlpSpacer(),
								if (onCopy != null)
									_buildHeaderAction(labels.codeDataCopyLabel, onCopy, style),
							],
						),
					),
					_KlpCodeViewport(
						kind: _KlpCodeViewportKind.diff,
						style: style,
						limit: viewportLimit,
						child: KlpColumn(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								for (final line in lines)
									_KlpDiffLineRow(line: line, style: style),
							],
						),
					),
				],
			),
		);
	}

	Widget _buildHeaderAction(
		String label,
		VoidCallback? onPressed,
		_KlpCodeStyle style,
	) {
		return _KlpCodeActionFrame(
			kind: _KlpCodeActionKind.headerText,
			label: label,
			onPressed: onPressed == null ? null : (_) => onPressed(),
			style: style,
			builder: (_, foreground) =>
					KlpText(label, role: KlpTextRole.code, color: foreground),
		);
	}
}
