import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

import 'support/klp_rail_compile_cases.dart';
import 'support/klp_rail_test_item.dart';
import 'klp_test_item.dart';
import 'klp_test_menu_item.dart';

void main() {
  test('rail freezes each group and ordered children snapshot', () {
    final a = KlpRailTestItem('a');
    final b = KlpRailTestItem('b');
    final c = KlpRailTestItem('c');
    final top = <KlpRailItem>[a];
    final center = <KlpRailItem>[b];
    final bottom = <KlpRailItem>[c];
    final rail = KlpRail(id: 'rail', top: top, center: center, bottom: bottom);
    final snapshot = rail.children;
    top.clear();
    center.add(a);
    bottom.clear();
    expect(rail.top, [a]);
    expect(rail.center, [b]);
    expect(rail.bottom, [c]);
    expect(rail.children, [a, b, c]);
    expect(rail.children, same(snapshot));
    for (final group in [rail.top, rail.center, rail.bottom]) {
      expect(() => group.clear(), throwsUnsupportedError);
    }
    expect(() => rail.children.assignments.clear(), throwsUnsupportedError);
  });

  test('empty rail declares stable definition identity', () {
    final rail = KlpRail(id: 'rail');
    expect(rail.definitionId, KlpRail.typeId);
    expect(KlpRail.typeId, 'kallopis.rail');
    expect(rail.children, isEmpty);
    expect(rail.onSelected, isNull);
  });

  test('selection callback is retained without automatic invocation', () {
    final values = <String>[];
    final callback = values.add;
    final rail = KlpRail(id: 'rail', onSelected: callback);
    expect(rail.onSelected, same(callback));
    expect(values, isEmpty);
    rail.onSelected!('selected');
    expect(values, ['selected']);
  });

  test(
    'external item supports multiple interfaces and injected data callback',
    () {
      var presses = 0;
      void callback() => presses++;
      final action = KlpCallbackAction(callback);
      final item = KlpRailTestItem(
        'custom',
        accessibilityLabel: 'Open notes',
        action: action,
      );
      final rail = KlpRail(id: 'rail', center: [item]);
      final menu = <KlpTestMenuItem>[item];
      expect(menu.single, same(rail.center.single));
      expect(rail.center.single.accessibilityLabel, 'Open notes');
      expect(item.action, same(action));
      expect(presses, 0);
      callback();
      expect(presses, 1);
    },
  );

  test('registry validates rail and custom item in group order', () {
    final registry = KlpRegistry([
      KlpDefinition<KlpRail>(
        KlpRail.typeId,
        slots: [KlpRail.topSlot, KlpRail.centerSlot, KlpRail.bottomSlot],
      ),
      KlpDefinition<KlpRailTestItem>('custom.railItem'),
    ]);
    final rail = KlpRail(
      id: 'rail',
      top: [KlpRailTestItem('a')],
      center: [KlpRailTestItem('b')],
      bottom: [KlpRailTestItem('c')],
    );
    expect(registry.validate(rail).nodes.map((node) => node.id), [
      'rail',
      'a',
      'b',
      'c',
    ]);
  });

  test('registry rejects duplicate identity across different groups', () {
    final registry = KlpRegistry([
      KlpDefinition<KlpRail>(
        KlpRail.typeId,
        slots: [KlpRail.topSlot, KlpRail.centerSlot, KlpRail.bottomSlot],
      ),
      KlpDefinition<KlpRailTestItem>('custom.railItem'),
    ]);
    final rail = KlpRail(
      id: 'rail',
      top: [KlpRailTestItem('same')],
      bottom: [KlpRailTestItem('same')],
    );
    final failure = isA<KlpContractError>().having(
      (error) => error.code,
      'code',
      'duplicate_placement',
    );
    expect(() => registry.validate(rail), throwsA(failure));
  });

  test('dynamic input cannot smuggle ordinary nodes into typed slots', () {
    final dynamic nodes = <KlpNode>[KlpTestItem('plain', 'plain')];
    expect(() => KlpRail(id: 'rail', top: nodes), throwsA(isA<TypeError>()));
  });

  registerKlpRailCompileCases();
}
