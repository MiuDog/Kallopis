import 'package:flutter/widgets.dart';

import 'package:kallopis/kallopis.dart';

class CatalogCanvas extends StatelessWidget {
  const CatalogCanvas({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(KlpSpace.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var index = 0; index < children.length; index++) ...[
            children[index],
            if (index < children.length - 1)
              const SizedBox(height: KlpSpace.xxl),
          ],
        ],
      ),
    );
  }
}

class CatalogGrid extends StatelessWidget {
  const CatalogGrid({
    super.key,
    required this.children,
    this.minItemWidth = 280,
  });

  final List<Widget> children;
  final double minItemWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / minItemWidth).floor().clamp(
          1,
          children.length,
        );
        final width =
            (constraints.maxWidth - KlpSpace.md * (count - 1)) / count;

        return Wrap(
          spacing: KlpSpace.md,
          runSpacing: KlpSpace.md,
          children: [
            for (final child in children) SizedBox(width: width, child: child),
          ],
        );
      },
    );
  }
}

class CatalogSample extends StatelessWidget {
  const CatalogSample({
    super.key,
    required this.label,
    required this.child,
    this.description,
  });

  final String label;
  final String? description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        KlpText(label.toUpperCase(), role: KlpTextRole.label),
        if (description != null) ...[
          const SizedBox(height: KlpSpace.xs),
          KlpText(
            description!,
            role: KlpTextRole.caption,
            tone: KlpTextTone.muted,
          ),
        ],
        const SizedBox(height: KlpSpace.lg),
        child,
      ],
    );
  }
}
