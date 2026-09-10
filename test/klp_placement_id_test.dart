import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  test('equal structured identities share map and set membership', () {
    final first = KlpPlacementId(scope: ['router', 'entry'], localId: 'item');
    final second = KlpPlacementId(scope: ['router', 'entry'], localId: 'item');
    expect(first, second);
    expect(first.hashCode, second.hashCode);
    expect({first: 'resource'}[second], 'resource');
    expect({first, second}, hasLength(1));
  });

  test('scope is snapshotted and cannot change a map key after insertion', () {
    final scope = ['router', 'entry'];
    final identity = KlpPlacementId(scope: scope, localId: 'item');
    final values = {identity: 'resource'};
    scope[1] = 'replacement';
    expect(identity.scope, ['router', 'entry']);
    expect(
      values[KlpPlacementId(scope: ['router', 'entry'], localId: 'item')],
      'resource',
    );
    expect(() => identity.scope.clear(), throwsUnsupportedError);
  });

  test(
    'scope segments and local identifier never collapse across delimiters',
    () {
      final identities = [
        KlpPlacementId(scope: ['a/b'], localId: 'c'),
        KlpPlacementId(scope: ['a', 'b'], localId: 'c'),
        KlpPlacementId(scope: ['a'], localId: 'b/c'),
        KlpPlacementId(localId: 'a/b/c'),
      ];
      expect(identities.toSet(), hasLength(identities.length));
      for (var index = 0; index < identities.length; index++) {
        for (var other = index + 1; other < identities.length; other++) {
          expect(identities[index], isNot(identities[other]));
        }
      }
    },
  );

  test(
    'different scopes isolate equal local identifiers and preserve order',
    () {
      final first = KlpPlacementId(scope: ['first', 'second'], localId: 'same');
      final reversed = KlpPlacementId(
        scope: ['second', 'first'],
        localId: 'same',
      );
      final sibling = KlpPlacementId(
        scope: ['first', 'third'],
        localId: 'same',
      );
      expect({first, reversed, sibling}, hasLength(3));
    },
  );

  test(
    'identity preserves unicode whitespace and empty scope without normalization',
    () {
      final identity = KlpPlacementId(scope: ['頁面 / 一'], localId: ' 項目 ');
      expect(identity.scope, ['頁面 / 一']);
      expect(identity.localId, ' 項目 ');
      expect(identity, isNot(KlpPlacementId(scope: ['頁面 / 一'], localId: '項目')));
      expect(
        KlpPlacementId(localId: '項目'),
        KlpPlacementId(scope: [], localId: '項目'),
      );
      expect(KlpPlacementId(localId: '項目').scope, isEmpty);
    },
  );
}
