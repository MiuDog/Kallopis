import 'package:flutter/material.dart';

import '../../../../../foundation/layout/klp_box_insets.dart';
import '../../../../../styling/legacy_theme/klp_theme.dart';

/// Structured form frame 解析後的完整風格。
class KlpStructuredFrameStyle {
	const KlpStructuredFrameStyle({
		required this.background,
		required this.radius,
		required this.insets,
		this.borderColor,
		this.borderWidth,
		this.height,
		this.alignment,
	});

	factory KlpStructuredFrameStyle.approvalRow(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.surfaceInset,
			radius: klp.shape.control,
			insets: KlpBoxInsets.directional(
				start: klp.space.contentInset,
				top: klp.space.tight,
				end: klp.space.contentInset,
				bottom: klp.space.tight,
			),
			borderColor: klp.color.border,
			borderWidth: klp.shape.hairline,
		);
	}

	factory KlpStructuredFrameStyle.approvalRole(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.component,
			radius: klp.shape.control,
			insets: KlpBoxInsets.directional(
				start: klp.space.controlInset,
				end: klp.space.controlInset,
			),
			height: klp.space.controlHeightSmall,
			alignment: Alignment.centerLeft,
		);
	}

	factory KlpStructuredFrameStyle.codeBody(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.surfaceInset,
			radius: klp.shape.card,
			insets: KlpBoxInsets.uniform(klp.space.base),
			borderColor: klp.color.border,
			borderWidth: klp.shape.hairline,
		);
	}

	factory KlpStructuredFrameStyle.codeFooter(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.component,
			radius: klp.shape.control,
			insets: KlpBoxInsets.directional(
				start: klp.space.contentInset,
				top: klp.space.tight,
				end: klp.space.contentInset,
				bottom: klp.space.tight,
			),
		);
	}

	factory KlpStructuredFrameStyle.dropzone(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.surfaceInset,
			radius: klp.shape.card,
			insets: KlpBoxInsets.uniform(klp.space.base),
			borderColor: klp.color.border,
			borderWidth: klp.shape.hairline,
		);
	}

	factory KlpStructuredFrameStyle.fileChoose(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.component,
			radius: klp.shape.control,
			insets: KlpBoxInsets.directional(
				start: klp.space.base,
				top: klp.space.controlInset,
				end: klp.space.base,
				bottom: klp.space.controlInset,
			),
			borderColor: klp.color.border,
			borderWidth: klp.shape.hairline,
		);
	}

	factory KlpStructuredFrameStyle.fileAttachment(BuildContext context) {
		final klp = context.klp;

		return KlpStructuredFrameStyle(
			background: klp.color.surfaceInset,
			radius: klp.shape.control,
			insets: KlpBoxInsets.directional(
				start: klp.space.base,
				top: klp.space.contentInset,
				end: klp.space.base,
				bottom: klp.space.contentInset,
			),
		);
	}

	final Color background;
	final double radius;
	final KlpBoxInsets insets;
	final Color? borderColor;
	final double? borderWidth;
	final double? height;
	final AlignmentGeometry? alignment;
}
