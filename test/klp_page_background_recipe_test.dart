import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis.dart';

void main() {
  group('KlpPageBackgroundViewport', () {
    test('round trips between page and viewport coordinates', () {
      final viewport = KlpPageBackgroundViewport(
        origin: const Offset(20, 30),
        scale: 2,
      );

      const pagePosition = Offset(35, 50);
      final viewportPosition = viewport.pageToViewport(pagePosition);

      expect(viewportPosition, const Offset(30, 40));
      expect(viewport.viewportToPage(viewportPosition), pagePosition);
    });

    test('rejects invalid scale and origin values', () {
      expect(() => KlpPageBackgroundViewport(scale: 0), throwsArgumentError);
      expect(
        () =>
            KlpPageBackgroundViewport(origin: const Offset(double.infinity, 0)),
        throwsArgumentError,
      );
    });
  });

  group('periodic background recipes', () {
    test('derive minor spacing from major spacing and internal axes', () {
      final dots = KlpDotsPageBackgroundRecipe(
        majorSpacing: 40,
        minorAxisCount: 3,
      );
      final grid = KlpGridPageBackgroundRecipe(
        majorSpacing: 40,
        minorAxisCount: 3,
      );

      expect(dots.minorSpacing, 10);
      expect(grid.minorSpacing, 10);
    });

    test('axis appearances can change independently', () {
      final recipe = KlpGridPageBackgroundRecipe(
        majorSpacing: 40,
        minorAxisCount: 3,
        minorAxis: KlpPageBackgroundAxisStyle(
          color: const Color(0xFF102030),
          width: 1,
        ),
        majorAxis: KlpPageBackgroundAxisStyle(
          color: const Color(0xFF405060),
          width: 3,
        ),
      );

      expect(recipe.minorAxis.color, const Color(0xFF102030));
      expect(recipe.minorAxis.width, 1);
      expect(recipe.majorAxis.color, const Color(0xFF405060));
      expect(recipe.majorAxis.width, 3);
      expect(recipe.copyWith(majorSpacing: 80).minorSpacing, 20);
    });

    test('rejects invalid geometry', () {
      expect(
        () => KlpDotsPageBackgroundRecipe(majorSpacing: 0),
        throwsArgumentError,
      );
      expect(
        () => KlpGridPageBackgroundRecipe(minorAxisCount: -1),
        throwsArgumentError,
      );
      expect(
        () => KlpPageBackgroundAxisStyle(width: double.nan),
        throwsArgumentError,
      );
    });
  });

  group('KlpCustomPageBackgroundRecipe', () {
    test('deleting a point also removes connected lines', () {
      final recipe = KlpCustomPageBackgroundRecipe(
        snapSpacing: 10,
        points: const [
          KlpPageBackgroundPoint(id: 1, position: Offset(10, 10)),
          KlpPageBackgroundPoint(id: 2, position: Offset(20, 20)),
          KlpPageBackgroundPoint(id: 3, position: Offset(30, 30)),
        ],
        lines: const [
          KlpPageBackgroundLine(id: 1, startPointId: 1, endPointId: 2),
          KlpPageBackgroundLine(id: 2, startPointId: 2, endPointId: 3),
        ],
      );

      final changed = recipe.removePoint(2);

      expect(changed.points.map((point) => point.id), [1, 3]);
      expect(changed.lines, isEmpty);
    });

    test('rejects duplicate ids and missing line endpoints', () {
      expect(
        () => KlpCustomPageBackgroundRecipe(
          points: const [
            KlpPageBackgroundPoint(id: 1, position: Offset.zero),
            KlpPageBackgroundPoint(id: 1, position: Offset(10, 10)),
          ],
        ),
        throwsArgumentError,
      );
      expect(
        () => KlpCustomPageBackgroundRecipe(
          points: const [KlpPageBackgroundPoint(id: 1, position: Offset.zero)],
          lines: const [
            KlpPageBackgroundLine(id: 1, startPointId: 1, endPointId: 2),
          ],
        ),
        throwsArgumentError,
      );
    });
  });
}
