import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  testWidgets(
    'platform subscriptions ignore equal values and rebuild for platform changes',
    (tester) async {
      var builds = 0;
      KlpPlatformInfo? observed;
      final child = Builder(
        builder: (context) {
          builds++;
          observed = KlpEnvironmentScope.of(context);
          expect(KlpEnvironmentScope.maybeOf(context), same(observed));
          expect(context.klpPlatform, same(observed));
          return const SizedBox.shrink();
        },
      );

      // 固定同一個 child，排除一般父層替換 widget 造成的重建。
      final first = KlpPlatformInfo(platform: KlpAppPlatform.windows);
      await tester.pumpWidget(
        KlpEnvironmentScope(platform: first, child: child),
      );
      expect(builds, 1);
      expect(observed!.platform, KlpAppPlatform.windows);
      final equalValue = KlpPlatformInfo(platform: KlpAppPlatform.windows);
      expect(identical(first, equalValue), isFalse);
      await tester.pumpWidget(
        KlpEnvironmentScope(platform: equalValue, child: child),
      );
      expect(builds, 1);
      await tester.pumpWidget(
        KlpEnvironmentScope(
          platform: const KlpPlatformInfo(platform: KlpAppPlatform.android),
          child: child,
        ),
      );
      expect(builds, 2);
      expect(observed!.platform, KlpAppPlatform.android);
    },
  );

  testWidgets(
    'nearest environment scope isolates subscriptions from outer changes',
    (tester) async {
      var builds = 0;
      KlpAppPlatform? observed;
      final leaf = Builder(
        builder: (context) {
          builds++;
          observed = context.klpPlatform.platform;
          return const SizedBox.shrink();
        },
      );
      final inner = KlpEnvironmentScope(
        platform: const KlpPlatformInfo(platform: KlpAppPlatform.android),
        child: leaf,
      );
      await tester.pumpWidget(
        KlpEnvironmentScope(
          platform: const KlpPlatformInfo(platform: KlpAppPlatform.windows),
          child: inner,
        ),
      );
      expect(observed, KlpAppPlatform.android);
      await tester.pumpWidget(
        KlpEnvironmentScope(
          platform: const KlpPlatformInfo(platform: KlpAppPlatform.linux),
          child: inner,
        ),
      );
      expect(builds, 1);
      expect(observed, KlpAppPlatform.android);
    },
  );

  testWidgets(
    'missing environment is nullable through maybeOf and explicit through of',
    (tester) async {
      await tester.pumpWidget(
        Builder(
          builder: (context) {
            expect(KlpEnvironmentScope.maybeOf(context), isNull);
            expect(() => KlpEnvironmentScope.of(context), throwsStateError);
            expect(() => context.klpPlatform, throwsStateError);
            return const SizedBox.shrink();
          },
        ),
      );
    },
  );
}
