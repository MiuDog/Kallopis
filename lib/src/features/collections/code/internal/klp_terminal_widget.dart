part of '../klp_code_viewer.dart';

/// 終端機模擬與指令執行檢視器。
class KlpTerminal extends StatelessWidget {
	const KlpTerminal({
		super.key,
		this.title = 'terminal',
		required this.lines,
		this.viewportLimit,
		this.onCopy,
		this.onClear,
	});

	final String title;
	final List<String> lines;
	final KlpCodeViewportLimit? viewportLimit;
	final VoidCallback? onCopy;
	final VoidCallback? onClear;

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
								_KlpTerminalMark(style: style),
								const KlpGap.widthSize(KlpSpaceSize.contentInline),
								KlpText(title, role: KlpTextRole.code, tone: KlpTextTone.muted),
								const KlpSpacer(),
								if (onClear != null)
									_buildHeaderAction(
										labels.codeTerminalClearLabel,
										onClear,
										style,
									),
								if (onCopy != null)
									_buildHeaderAction(labels.codeDataCopyLabel, onCopy, style),
							],
						),
					),
					_KlpCodeViewport(
						kind: _KlpCodeViewportKind.terminal,
						style: style,
						limit: viewportLimit,
						child: KlpColumn(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: [
								for (final line in lines) KlpText(line, role: KlpTextRole.code),
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
