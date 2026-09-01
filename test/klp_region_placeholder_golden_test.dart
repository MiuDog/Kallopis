import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

import 'support/load_test_fonts.dart';

void main() {
  setUpAll(loadKlpTestFonts);

  testWidgets('Region Placeholder 固定呈現 hatch、pending、action 與 flat', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(900, 318);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const _RegionPlaceholderSpecimen());
    await tester.pumpAndSettle();

    expect(find.byType(KlpRegionPlaceholder), findsNWidgets(4));
    expect(
      KlpPlaceholderMetrics.hatchStrokeWidth,
      KlpPlaceholderMetrics.hatchBand,
    );
    expect(find.text('STREAM VIEW · PLACEHOLDER'), findsOneWidget);
    expect(find.text('DIFF VIEW · PENDING'), findsOneWidget);
    expect(find.text('BIND A QUERY'), findsOneWidget);

    await expectLater(
      find.byKey(const ValueKey('region-placeholder-golden')),
      matchesGoldenFile('goldens/klp_region_placeholder_light.png'),
    );
  });

  testWidgets('Region Placeholder 在深色模式維持低對比斜線層級', (tester) async {
    tester.view.physicalSize = const Size(900, 318);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      const _RegionPlaceholderSpecimen(brightness: Brightness.dark),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byKey(const ValueKey('region-placeholder-golden')),
      matchesGoldenFile('goldens/klp_region_placeholder_dark.png'),
    );
  });

  testWidgets('Region Placeholder action 保留可操作語意', (tester) async {
    var invoked = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKlpTheme(Brightness.light),
        home: KlpRegionPlaceholder(
          label: 'Chart slot',
          kindLabel: 'Placeholder',
          detail: 'No series bound.',
          actionLabel: 'Bind a query',
          onAction: () => invoked = true,
        ),
      ),
    );

    expect(
      find.bySemanticsLabel('Chart slot. Placeholder. No series bound.'),
      findsOneWidget,
    );
    await tester.tap(find.text('BIND A QUERY'));
    expect(invoked, isTrue);
  });
}

class _RegionPlaceholderSpecimen extends StatelessWidget {
  const _RegionPlaceholderSpecimen({this.brightness = Brightness.light});

  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildKlpTheme(brightness),
      home: Scaffold(
        body: RepaintBoundary(
          key: const ValueKey('region-placeholder-golden'),
          child: ColoredBox(
            color: brightness == Brightness.light
                ? KlpThemeData.light.app
                : KlpThemeData.dark.app,
            child: const Padding(
              padding: EdgeInsets.all(KlpSpace.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  KlpRegionPlaceholder(
                    label: 'Stream view',
                    kindLabel: 'Placeholder',
                    minHeight: 140,
                  ),
                  SizedBox(height: KlpSpace.lg),
                  SizedBox(
                    height: 130,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: KlpRegionPlaceholder(
                            label: 'Diff view',
                            kindLabel: 'Pending',
                            detail: 'Waiting for the first frame from the run.',
                            tone: KlpRegionPlaceholderTone.pending,
                          ),
                        ),
                        SizedBox(width: KlpSpace.lg),
                        Expanded(
                          child: KlpRegionPlaceholder(
                            label: 'Chart slot',
                            kindLabel: 'Placeholder',
                            detail: 'No series bound to this panel yet.',
                            actionLabel: 'Bind a query',
                            onAction: _noop,
                          ),
                        ),
                        SizedBox(width: KlpSpace.lg),
                        Expanded(
                          child: KlpRegionPlaceholder(
                            label: 'Preview',
                            kindLabel: 'Reserved',
                            hatched: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _noop() {}
