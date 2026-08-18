import 'package:flutter/widgets.dart';

import '../foundation/klp_metrics.dart';
import '../surface/klp_surface.dart';
import '../theme/klp_theme.dart';

class KlpRegion extends StatelessWidget {
  const KlpRegion({
    super.key,
    required this.content,
    this.header,
    this.footer,
    this.tone = KlpSurfaceTone.base,
    this.padding,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;
  final KlpSurfaceTone tone;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return KlpSurface(
      tone: tone,
      radius: context.klp.shape.panel,
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ?header,
          Expanded(child: content),
          ?footer,
        ],
      ),
    );
  }
}

typedef KlpPanel = KlpRegion;

class KlpSplitLayout extends StatelessWidget {
  const KlpSplitLayout({
    super.key,
    required this.leading,
    required this.trailing,
    this.leadingWidth = KlpSize.sidebar,
    this.gap,
  });

  final Widget leading;
  final Widget trailing;
  final double leadingWidth;
  final double? gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: leadingWidth, child: leading),
        SizedBox(width: gap ?? context.klp.space.base),
        Expanded(child: trailing),
      ],
    );
  }
}

class KlpResizablePane extends StatelessWidget {
  const KlpResizablePane({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}

class KlpResizeHandle extends StatelessWidget {
  const KlpResizeHandle({super.key, required this.onDelta, this.semanticLabel});

  final ValueChanged<double> onDelta;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: MouseRegion(
        cursor: SystemMouseCursors.resizeColumn,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onHorizontalDragUpdate: (details) => onDelta(details.delta.dx),
          child: SizedBox(width: context.klp.space.base),
        ),
      ),
    );
  }
}

class KlpScrollViewport extends StatelessWidget {
  const KlpScrollViewport({
    super.key,
    required this.child,
    this.controller,
    this.padding,
  });

  final Widget child;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: controller,
      padding: padding,
      child: child,
    );
  }
}

class KlpVirtualList extends StatelessWidget {
  const KlpVirtualList({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.controller,
    this.padding,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final ScrollController? controller;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: padding,
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}

class KlpVirtualGrid extends StatelessWidget {
  const KlpVirtualGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minimumItemWidth = 240,
    this.spacing,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minimumItemWidth;
  final double? spacing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / minimumItemWidth).floor().clamp(
          1,
          itemCount == 0 ? 1 : itemCount,
        );

        return GridView.builder(
          itemCount: itemCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: count,
            mainAxisSpacing: spacing ?? context.klp.space.base,
            crossAxisSpacing: spacing ?? context.klp.space.base,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

class KlpOverlayHost extends StatelessWidget {
  const KlpOverlayHost({super.key, required this.child, this.overlay});

  final Widget child;
  final Widget? overlay;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: child),
        if (overlay != null) Positioned.fill(child: overlay!),
      ],
    );
  }
}
