import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

/// 把同一組元件在兩套風格下各算一張圖。
///
/// 這是整個 token 架構唯一的**視覺**驗收：`visual_style_test` 只能證明 token 的值不同，
/// 證明不了那些值真的抵達了畫面。這裡的兩張圖若看起來一樣，代表元件根本沒讀 token。
///
/// Kallopis 只出貨 `modern` 一套風格，因此對照組由這裡就地組出——出貨的 preset 少一套
/// 不代表這道驗收可以省略，省略了就沒有任何東西會發現元件退回硬編碼。
final _contrasting = KlpVisualStyle.modern.copyWith(
  name: 'contrasting',
  colors: KlpThemeData.ultraDark,
  typography: KlpTypographyTheme.proportional.copyWith(
    uiFamily: KlpTypographyTheme.proportional.monoFamily,
    bodyFamily: KlpTypographyTheme.proportional.monoFamily,
    bodyLeading: 1.4,
    headingLeading: 1.3,
    captionLeading: 1.3,
    labelTracking: 0,
  ),
  spacing: KlpSpacingTheme.comfortableDensity.copyWith(
    tight: 2,
    compact: 4,
    base: 8,
    comfortable: 8,
    section: 16,
    controlPaddingX: 8,
    controlPaddingY: 2,
    containerPadding: 8,
    controlHeight: 24,
  ),
  shape: KlpShapeTheme.standardShape.copyWith(
    control: 0,
    card: 0,
    panel: 0,
    pill: 0,
  ),
  motion: KlpMotionTheme.standardMotion.copyWith(
    stateTransition: Duration.zero,
    overlayEnter: Duration.zero,
  ),
  surface: KlpSurfaceTheme.elevated.copyWith(
    separation: KlpSurfaceSeparation.outline,
    overlayShadowOpacity: 0,
  ),
  components: KlpComponentTheme.inherited.copyWith(
    buttonRadius: 0,
    fieldRadius: 0,
    cardRadius: 0,
    badgeRadius: 0,
  ),
);

void main() {
  setUpAll(() async {
    if (KlpTypographyTheme.proportional.sansFamily.isNotEmpty) {
      final sans = FontLoader(KlpTypographyTheme.proportional.sansFamily)
        ..addFont(
          rootBundle.load(
            'packages/kallopis/assets/fonts/IBMPlexSansTC-Regular.ttf',
          ),
        );
      await sans.load();
    }
    if (KlpTypographyTheme.proportional.monoFamily.isNotEmpty) {
      final mono = FontLoader(KlpTypographyTheme.proportional.monoFamily)
        ..addFont(
          rootBundle.load(
            'packages/kallopis/assets/fonts/IBMPlexMono-Regular.ttf',
          ),
        );
      await mono.load();
    }
  });

  Future<void> pumpSpecimen(
    WidgetTester tester,
    KlpVisualStyle style,
    Brightness brightness,
  ) async {
    tester.view.physicalSize = const Size(720, 460);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: buildKlpTheme(brightness, style: style),
        home: const Material(child: _Specimen()),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('modern', (tester) async {
    await pumpSpecimen(tester, KlpVisualStyle.modern, Brightness.light);
    await expectLater(
      find.byType(_Specimen),
      matchesGoldenFile('goldens/style_modern.png'),
    );
  });

  testWidgets('contrasting', (tester) async {
    await pumpSpecimen(tester, _contrasting, Brightness.dark);
    await expectLater(
      find.byType(_Specimen),
      matchesGoldenFile('goldens/style_contrasting.png'),
    );
  });
}

class _Specimen extends StatelessWidget {
  const _Specimen();

  @override
  Widget build(BuildContext context) {
    final klp = context.klp;

    return ColoredBox(
      color: klp.color.app,
      child: Padding(
        padding: EdgeInsets.all(klp.space.section),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            KlpText('Kallopis', role: KlpTextRole.title),
            SizedBox(height: klp.space.base),
            SizedBox(
              width: 420,
              child: KlpSurface(
                tone: KlpSurfaceTone.raised,
                padding: EdgeInsets.all(klp.cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KlpText(
                      'The quick brown fox jumps over the lazy dog',
                      role: KlpTextRole.body,
                    ),
                    SizedBox(height: klp.space.base),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        KlpButton(
                          label: 'Primary',
                          onPressed: () {},
                          tone: KlpButtonTone.primary,
                        ),
                        SizedBox(width: klp.space.compact),
                        KlpButton(label: 'Secondary', onPressed: () {}),
                      ],
                    ),
                    SizedBox(height: klp.space.base),
                    const KlpTextField(label: 'Field', initialValue: 'value'),
                    SizedBox(height: klp.space.base),
                    const KlpBadge(label: 'badge'),
                    SizedBox(height: klp.space.base),
                    KlpToggle(value: true, label: 'toggle', onChanged: (_) {}),
                    SizedBox(height: klp.space.tight),
                    KlpCheckbox(value: true, label: 'check', onChanged: (_) {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
