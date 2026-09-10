import 'package:flutter/widgets.dart';

import '../surface/klp_surface.dart';
import 'klp_gap.dart';
import 'klp_box_insets.dart';
import 'klp_space_size.dart';

/// 基礎尺寸與邊距容器排版原語。取代 Container 與 SizedBox。
/// 支援風格介面、風格枚舉（KlpSpaceSize）與傳統尺寸邊距設定。
class KlpBox extends StatelessWidget {
	const KlpBox({
	  super.key,
	  this.width,
	  this.height,
	  this.widthSize,
	  this.heightSize,
	  this.padding,
	  this.margin,
		this.insets,
		this.marginInsets,
	  this.paddingSize,
	  this.marginSize,
	  this.tone,
	  this.radius,
	  this.child,
	});

	const KlpBox.shrink({super.key})
	    : width = 0.0,
	      height = 0.0,
	      widthSize = null,
	      heightSize = null,
	      padding = null,
	      margin = null,
				insets = null,
				marginInsets = null,
	      paddingSize = null,
	      marginSize = null,
	      tone = null,
	      radius = null,
	      child = null;

	const KlpBox.expand({super.key, this.child})
	    : width = double.infinity,
	      height = double.infinity,
	      widthSize = null,
	      heightSize = null,
	      padding = null,
	      margin = null,
				insets = null,
				marginInsets = null,
	      paddingSize = null,
	      marginSize = null,
	      tone = null,
	      radius = null;

	const KlpBox.square({super.key, required double dimension, this.child})
	    : width = dimension,
	      height = dimension,
	      widthSize = null,
	      heightSize = null,
	      padding = null,
	      margin = null,
				insets = null,
				marginInsets = null,
	      paddingSize = null,
	      marginSize = null,
	      tone = null,
	      radius = null;

	final double? width;
	final double? height;
	final KlpSpaceSize? widthSize;
	final KlpSpaceSize? heightSize;
	final EdgeInsetsGeometry? padding;
	final EdgeInsetsGeometry? margin;
	final KlpBoxInsets? insets;
	final KlpBoxInsets? marginInsets;
	final KlpSpaceSize? paddingSize;
	final KlpSpaceSize? marginSize;
	final KlpSurfaceTone? tone;
	final double? radius;
	final Widget? child;

	@override
	Widget build(BuildContext context) {
	  Widget content = child ?? const SizedBox.shrink();

		final resolvedPadding = insets?.edgeInsets ?? padding ??
	      (paddingSize != null
	          ? EdgeInsets.all(KlpGap.resolveSpace(context, paddingSize!))
	          : null);

	  if (resolvedPadding != null) {
	    content = Padding(padding: resolvedPadding, child: content);
	  }

	  if (tone != null) {
	    content = KlpSurface(
	      tone: tone!,
	      radius: radius,
	      child: content,
	    );
	  }

	  final resolvedWidth = width ??
	      (widthSize != null ? KlpGap.resolveSpace(context, widthSize!) : null);
	  final resolvedHeight = height ??
	      (heightSize != null ? KlpGap.resolveSpace(context, heightSize!) : null);

	  if (resolvedWidth != null || resolvedHeight != null) {
	    content = SizedBox(width: resolvedWidth, height: resolvedHeight, child: content);
	  }

		final resolvedMargin = marginInsets?.edgeInsets ?? margin ??
	      (marginSize != null
	          ? EdgeInsets.all(KlpGap.resolveSpace(context, marginSize!))
	          : null);

	  if (resolvedMargin != null) {
	    content = Padding(padding: resolvedMargin, child: content);
	  }

	  return content;
	}
}
