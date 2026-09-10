part of '../klp_code_viewer.dart';

class _KlpDiffLineRow extends StatelessWidget {
	const _KlpDiffLineRow({required this.line, required this.style});

	final KlpDiffLine line;
	final _KlpCodeStyle style;

	@override
	Widget build(BuildContext context) {
		final labels = KlpLocalizations.of(context);
		final prefix = switch (line.type) {
			KlpDiffLineType.added => '+',
			KlpDiffLineType.deleted => '-',
			KlpDiffLineType.unchanged => ' ',
		};
		final prefixColor = switch (line.type) {
			KlpDiffLineType.added => style.success,
			KlpDiffLineType.deleted => style.danger,
			KlpDiffLineType.unchanged => style.textFaint,
		};
		final frameKind = switch (line.type) {
			KlpDiffLineType.added => _KlpCodeFrameKind.addedLine,
			KlpDiffLineType.deleted => _KlpCodeFrameKind.deletedLine,
			KlpDiffLineType.unchanged => _KlpCodeFrameKind.unchangedLine,
		};

		return _KlpCodeFrame(
			kind: frameKind,
			style: style,
			child: KlpRow(
				children: [
					_buildNumber(line.oldNumber),
					const KlpGap.widthSize(KlpSpaceSize.tight),
					_buildNumber(line.newNumber),
					const KlpGap.widthSize(KlpSpaceSize.contentInline),
					_KlpCodeSlot(
						kind: _KlpCodeSlotKind.marker,
						style: style,
						child: KlpText(prefix, role: KlpTextRole.code, color: prefixColor),
					),
					KlpExpanded(child: KlpText(line.content, role: KlpTextRole.code)),
					if (line.onApprove != null || line.onReject != null) ...[
						const KlpGap.widthSize(KlpSpaceSize.contentInline),
						if (line.onApprove != null)
							_buildAction(
								_KlpCodeActionKind.success,
								labels.codeDiffApproveLabel,
								line.onApprove,
							),
						if (line.onApprove != null && line.onReject != null)
							const KlpGap.widthSize(KlpSpaceSize.tight),
						if (line.onReject != null)
							_buildAction(
								_KlpCodeActionKind.danger,
								labels.codeDiffRejectLabel,
								line.onReject,
							),
					],
				],
			),
		);
	}

	Widget _buildNumber(int? number) {
		return _KlpCodeSlot(
			kind: _KlpCodeSlotKind.gutterNumber,
			style: style,
			child: KlpText(
				number?.toString() ?? '',
				role: KlpTextRole.code,
				tone: KlpTextTone.faint,
				textAlign: TextAlign.end,
			),
		);
	}

	Widget _buildAction(
		_KlpCodeActionKind kind,
		String label,
		VoidCallback? onPressed,
	) {
		return _KlpCodeActionFrame(
			kind: kind,
			label: label,
			onPressed: onPressed == null ? null : (_) => onPressed(),
			style: style,
			builder: (_, foreground) =>
					KlpText(label, role: KlpTextRole.code, color: foreground),
		);
	}
}
