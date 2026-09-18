import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_declarative.dart';

void main() {
  group('KlpId 樹狀命名空間與享元唯一性測試', () {
    test('root 與 child 衍生路徑正確', () {
      final root = KlpId.root('planist');
      expect(root.segments, equals(['planist']));
      expect(root.value, equals('planist'));
      expect(root.segment, equals('planist'));
      expect(root.scope, isEmpty);

      final workspace = root.child('workspace');
      expect(workspace.segments, equals(['planist', 'workspace']));
      expect(workspace.value, equals('planist.workspace'));
      expect(workspace.segment, equals('workspace'));
      expect(workspace.scope, equals(['planist']));
    });

    test('多處建立相同 id 時自動查詢樹狀快取並回傳相同物件實例 (Canonical Flyweight)', () {
      // 1. 相同 root
      final root1 = KlpId.root('app_unique');
      final root2 = KlpId.root('app_unique');
      expect(identical(root1, root2), isTrue);

      // 2. 相同 child
      final child1 = root1.child('router');
      final child2 = root2.child('router');
      final child3 = root1 / 'router';
      final child4 = KlpId.of(root1, 'router');
      expect(identical(child1, child2), isTrue);
      expect(identical(child1, child3), isTrue);
      expect(identical(child1, child4), isTrue);

      // 3. from 與 parse
      final fromSegments = KlpId.from(['app_unique', 'router']);
      final fromParse = KlpId.parse('app_unique.router');
      expect(identical(child1, fromSegments), isTrue);
      expect(identical(child1, fromParse), isTrue);
    });

    test('樹狀結構導覽與關聯正確 (parent, rootNode, ancestors, directChildren)', () {
      final root = KlpId.root('tree_root');
      final level1 = KlpId.of(root, 'level1');
      final level2 = level1 / 'level2';

      expect(level2.parent, same(level1));
      expect(level1.parent, same(root));
      expect(root.parent, isNull);
      expect(root.isRoot, isTrue);
      expect(level2.isRoot, isFalse);

      expect(level2.rootNode, same(root));
      expect(level1.rootNode, same(root));
      expect(root.rootNode, same(root));

      expect(level2.ancestors, equals([level1, root]));
      expect(root.directChildren, contains(level1));
    });

    test('/ 運算子串接支援', () {
      final root = KlpId.root('app');
      final sidebar = root / 'dashboard' / 'sidebar';
      expect(sidebar.value, equals('app.dashboard.sidebar'));
      expect(sidebar.segment, equals('sidebar'));
      expect(sidebar.scope, equals(['app', 'dashboard']));
    });

    test('相等性與 HashCode 正確性', () {
      final a = KlpId.root('a') / 'b' / 'c';
      final b = KlpId.from(['a', 'b', 'c']);
      final c = KlpId.root('a') / 'b' / 'd';

      expect(a, equals(b));
      expect(identical(a, b), isTrue);
      expect(a.hashCode, equals(b.hashCode));
      expect(a, isNot(equals(c)));
    });

    test('轉換為內部 KlpPlacementId 正確無誤', () {
      final id = KlpId.root('screen') / 'item';
      final placement = id.toPlacementId();
      expect(placement.scope, equals(['screen']));
      expect(placement.localId, equals('item'));
    });

    test('拒絕空段輸入防呆', () {
      expect(() => KlpId.from([]), throwsArgumentError);
      expect(() => KlpId.from(['']), throwsArgumentError);
      expect(() => KlpId.root('a').child(' '), throwsArgumentError);
      expect(() => KlpId.root(' '), throwsArgumentError);
      expect(() => KlpId.parse(' '), throwsArgumentError);
    });
  });
}
