import 'package:flutter/widgets.dart';

import '../foundation/pln_metrics.dart';
import '../surface/pln_surface.dart';

class PlnRegion extends StatelessWidget {
  const PlnRegion({
    super.key,
    required this.content,
    this.header,
    this.footer,
    this.tone = PlnSurfaceTone.base,
    this.padding,
  });

  final Widget? header;
  final Widget content;
  final Widget? footer;
  final PlnSurfaceTone tone;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return PlnSurface(
      tone: tone,
      radius: PlnRadius.panel,
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

typedef PlnPanel = PlnRegion;

class PlnSplitLayout extends StatelessWidget {
  const PlnSplitLayout({
    super.key,
    required this.leading,
    required this.trailing,
    this.leadingWidth = PlnSize.sidebar,
    this.gap = PlnLayoutGap.lg,
  });

  final Widget leading;
  final Widget trailing;
  final double leadingWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(width: leadingWidth, child: leading),
        SizedBox(width: gap),
        Expanded(child: trailing),
      ],
    );
  }
}

class PlnResizablePane extends StatelessWidget {
  const PlnResizablePane({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, child: child);
  }
}

class PlnResizeHandle extends StatelessWidget {
  const PlnResizeHandle({super.key, required this.onDelta, this.semanticLabel});

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
          child: const SizedBox(width: PlnLayoutGap.lg),
        ),
      ),
    );
  }
}

class PlnScrollViewport extends StatelessWidget {
  const PlnScrollViewport({
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

class PlnVirtualList extends StatelessWidget {
  const PlnVirtualList({
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

class PlnVirtualGrid extends StatelessWidget {
  const PlnVirtualGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.minimumItemWidth = 240,
    this.spacing = PlnLayoutGap.lg,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final double minimumItemWidth;
  final double spacing;

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
            mainAxisSpacing: spacing,
            crossAxisSpacing: spacing,
          ),
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}

class PlnOverlayHost extends StatelessWidget {
  const PlnOverlayHost({super.key, required this.child, this.overlay});

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
