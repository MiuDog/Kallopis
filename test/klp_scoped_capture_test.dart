import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';
import 'package:kallopis/src/composition/nodes/internal/klp_scope_boundary.dart';
import 'package:kallopis/src/composition/validation/internal/klp_tree_capture.dart';

import 'klp_test_item.dart';

void main() {
  late KlpRegistry registry;
  setUp(
    () => registry = KlpRegistry([
      KlpDefinition<KlpTestItem>('item'),
      KlpScopeBoundary.contract,
    ]),
  );

  test(
    'different entry scopes retain the same consumer identifier independently',
    () {
      final first = KlpTestItem('same', 'item');
      final second = KlpTestItem('same', 'item');
      final root = KlpTestItem('root', 'item', [
        KlpScopeBoundary(id: 'first', child: first),
        KlpScopeBoundary(id: 'second', child: second),
      ]);
      final captured = captureKlpTree(registry, root);
      final firstId = KlpPlacementId(scope: ['first'], localId: 'same');
      final secondId = KlpPlacementId(scope: ['second'], localId: 'same');
      expect(captured.sources[firstId], same(first));
      expect(captured.sources[secondId], same(second));
      expect(
        captured.validation.nodes
            .where((node) => node.id == 'same')
            .map((node) => node.placementId),
        [firstId, secondId],
      );
      expect(
        captured.validation.rootPlacement,
        KlpPlacementId(localId: 'root'),
      );
    },
  );

  test('same scope duplicate placement still fails before installation', () {
    final root = KlpScopeBoundary(
      id: 'entry',
      child: KlpTestItem('root', 'item', [
        KlpTestItem('same', 'item'),
        KlpTestItem('same', 'item'),
      ]),
    );
    expect(
      () => registry.validate(root),
      throwsA(
        isA<KlpContractError>().having(
          (error) => error.code,
          'code',
          'duplicate_placement',
        ),
      ),
    );
  });

  test(
    'nested boundary segments cannot collide with delimiter containing identifiers',
    () {
      final root = KlpTestItem('root', 'item', [
        KlpScopeBoundary(id: 'a/b', child: KlpTestItem('c', 'item')),
        KlpScopeBoundary(
          id: 'a',
          child: KlpScopeBoundary(id: 'b', child: KlpTestItem('c', 'item')),
        ),
        KlpTestItem('a/b/c', 'item'),
      ]);
      final captured = captureKlpTree(registry, root);
      expect(
        captured.sources.keys,
        containsAll([
          KlpPlacementId(scope: ['a/b'], localId: 'c'),
          KlpPlacementId(scope: ['a', 'b'], localId: 'c'),
          KlpPlacementId(localId: 'a/b/c'),
        ]),
      );
    },
  );

  test(
    'ordinary node using internal definition id does not gain scope authority',
    () {
      final impostor = KlpTestItem('entry', KlpScopeBoundary.typeId, [
        KlpTestItem('child', 'item'),
      ]);
      expect(
        () => registry.validate(impostor),
        throwsA(
          isA<KlpContractError>().having(
            (error) => error.code,
            'code',
            'node_type_mismatch',
          ),
        ),
      );
    },
  );

  test('cycle remains invalid even when it crosses a scope boundary', () {
    final root = KlpTestItem('root', 'item');
    root.children.add(KlpScopeBoundary(id: 'entry', child: root));
    expect(
      () => registry.validate(root),
      throwsA(
        isA<KlpContractError>().having(
          (error) => error.code,
          'code',
          'node_cycle',
        ),
      ),
    );
  });

  test(
    'local snapshot accessors derive only from immutable full identities',
    () {
      final children = [
        KlpPlacementId(scope: ['entry'], localId: 'child'),
      ];
      final node = KlpValidatedNode.scoped(
        KlpPlacementId(scope: ['entry'], localId: 'parent'),
        'item',
        children,
      );
      children.clear();
      expect(node.id, 'parent');
      expect(node.childrenIds, ['child']);
      expect(node.childrenPlacements, [
        KlpPlacementId(scope: ['entry'], localId: 'child'),
      ]);
      expect(() => node.childrenPlacements.clear(), throwsUnsupportedError);
      expect(() => node.childrenIds.clear(), throwsUnsupportedError);
      final legacy = KlpValidatedNode('parent', 'item', ['child']);
      expect(legacy.placementId, KlpPlacementId(localId: 'parent'));
      expect(legacy.childrenPlacements, [KlpPlacementId(localId: 'child')]);
    },
  );
}
