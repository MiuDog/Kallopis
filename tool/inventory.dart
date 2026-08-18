// 由實際程式碼產生 `spec/component-inventory.md`。
//
// 元件樹必須從程式碼推導，不能手寫——手寫的架構圖會與程式碼分岔，而且分岔時
// 不會有任何徵兆。這支腳本解析每個型別的實作區段，找出它建構了哪些其他 `Klp*` 型別。
//
//   dart run tool/inventory.dart
//
// `--check` 只比對不寫入，供 CI 確認文件沒有過期。
import 'dart:convert';
import 'dart:io';

/// 由底層到上層。**後面的可以用前面的，反過來就是分層違規。**
///
/// 這個順序是設計意圖的宣告，不是觀察到的現況——把它排成剛好沒有違規等於用工具
/// 追認現狀，那樣這張圖就什麼也擋不住了。
const categoryOrder = <String>[
  'tokens',
  'theme',
  'foundation',
  'typography',
  'surface',
  'interaction',
  'layout',
  'overlay',
  'controls',
  'data',
  'form',
  'feedback',
  'navigation',
  'editor',
  'routing',
  'shell',
];

const categoryLabel = <String, String>{
  'tokens': 'tokens — primitive 層',
  'theme': 'theme — semantic 與 component token',
  'foundation': 'foundation — 圖示、色盤、度量',
  'typography': 'typography — 文字',
  'surface': 'surface — 表面與描邊',
  'layout': 'layout — 版面原語',
  'interaction': 'interaction — 互動',
  'controls': 'controls — 控制項',
  'form': 'form — 表單',
  'data': 'data — 資料呈現',
  'feedback': 'feedback — 狀態與回饋',
  'overlay': 'overlay — 浮層',
  'navigation': 'navigation — 導覽元件',
  'editor': 'editor — 編輯器周邊',
  'shell': 'shell — 應用外殼',
  'routing': 'routing — 分發',
};

final _declaration = RegExp(
  r'^(?:abstract final class|final class|class|enum)\s+(Klp[A-Za-z0-9]+)',
);
final _widget = RegExp(
  r'^class\s+Klp[A-Za-z0-9]+\s+extends\s+'
  r'(?:StatelessWidget|StatefulWidget|InheritedNotifier|CustomPainter)',
);
final _construction = RegExp(r'\b(Klp[A-Za-z0-9]+)\s*\(');

class Component {
  Component(this.name, this.category, this.loc, this.isWidget, this.composes);

  final String name;
  final String category;
  final int loc;
  final bool isWidget;
  final List<String> composes;
}

void main(List<String> args) {
  final files =
      Directory('lib/src')
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .map((f) => f.path.replaceAll(r'\', '/'))
          .toList()
        ..sort();

  final components = <Component>[];
  final categoryOf = <String, String>{};

  for (final path in files) {
    final category = path.split('/')[2];
    final lines = const LineSplitter().convert(File(path).readAsStringSync());

    final marks = <(int, String, bool)>[];
    for (var i = 0; i < lines.length; i++) {
      final match = _declaration.firstMatch(lines[i]);
      if (match != null) {
        marks.add((i, match.group(1)!, _widget.hasMatch(lines[i])));
      }
    }

    for (var m = 0; m < marks.length; m++) {
      final (start, name, isWidget) = marks[m];
      final end = m + 1 < marks.length ? marks[m + 1].$1 : lines.length;
      // 排除 dartdoc：範例程式碼不是實際的組合關係。
      final body = lines
          .sublist(start, end)
          .where((l) => !l.trimLeft().startsWith('///'))
          .join('\n');
      final uses =
          _construction
              .allMatches(body)
              .map((x) => x.group(1)!)
              .where((u) => u != name && !u.startsWith('KlpScale'))
              .toSet()
              .toList()
            ..sort();
      categoryOf[name] = category;
      components.add(Component(name, category, end - start, isWidget, uses));
    }
  }

  final known = categoryOf.keys.toSet();
  for (final c in components) {
    c.composes.removeWhere((u) => !known.contains(u));
  }

  final rendered = _render(components, categoryOf);
  final target = File('spec/component-inventory.md');

  if (args.contains('--check')) {
    final current = target.existsSync() ? target.readAsStringSync() : '';
    if (current.replaceAll('\r\n', '\n') != rendered) {
      stderr.writeln(
        'spec/component-inventory.md 已過期。請跑 `dart run tool/inventory.dart`。',
      );
      exit(1);
    }
    stdout.writeln('component-inventory.md 是最新的。');
    return;
  }

  target.writeAsStringSync(rendered);
  final widgets = components.where((c) => c.isWidget).length;
  stdout.writeln(
    '已寫入 ${target.path}：${components.length} 個型別，其中 $widgets 個 widget。',
  );
}

String _render(List<Component> components, Map<String, String> categoryOf) {
  final b = StringBuffer();
  final widgets = components.where((c) => c.isWidget).toList();

  b.writeln('# 元件清單與組合關係');
  b.writeln();
  b.writeln('> 本檔由 `dart run tool/inventory.dart` 從實際程式碼產生，不是手寫的。');
  b.writeln('> 元件樹是**真的**組合關係——解析每個型別實作區段內出現的其他 `Klp*` 建構');
  b.writeln('> 呼叫，因此它不會與程式碼分岔；手寫的架構圖會，而且分岔時沒有任何徵兆。');
  b.writeln();
  b.writeln('## 總覽');
  b.writeln();
  b.writeln(
    '- 公開型別 **${components.length}** 個，其中 widget **${widgets.length}** 個',
  );
  b.writeln('- 分為 **${categoryOrder.length}** 個領域');
  b.writeln();
  b.writeln('### 領域之間的依賴方向');
  b.writeln();
  b.writeln('箭頭是「用到」，數字是引用次數。這張圖唯一該有的形狀是**單向**——');
  b.writeln('`controls` 可以用 `surface`，`surface` 不可以用 `controls`。');
  b.writeln('出現回頭的箭頭就代表分層破了。');
  b.writeln();
  b.writeln('```mermaid');
  b.writeln('graph TD');

  final edges = <String, int>{};
  for (final c in components) {
    for (final u in c.composes) {
      final from = c.category;
      final to = categoryOf[u]!;
      if (from != to) {
        edges['$from|$to'] = (edges['$from|$to'] ?? 0) + 1;
      }
    }
  }
  for (final cat in categoryOrder) {
    if (components.any((c) => c.category == cat)) {
      b.writeln('  $cat["${categoryLabel[cat]}"]');
    }
  }
  final sortedEdges = edges.entries.toList()
    ..sort((x, y) {
      final byCount = y.value.compareTo(x.value);
      return byCount != 0 ? byCount : x.key.compareTo(y.key);
    });
  for (final e in sortedEdges) {
    final parts = e.key.split('|');
    b.writeln('  ${parts[0]} -->|${e.value}| ${parts[1]}');
  }
  b.writeln('```');
  b.writeln();

  // 回頭邊：底層領域用到了上層領域。
  final violations = <String>[];
  for (final c in components) {
    for (final u in c.composes) {
      final from = categoryOrder.indexOf(c.category);
      final to = categoryOrder.indexOf(categoryOf[u]!);
      if (from >= 0 && to >= 0 && from < to) {
        violations.add('${c.category}/${c.name} → ${categoryOf[u]}/$u');
      }
    }
  }
  violations.sort();

  b.writeln('### 分層違規');
  b.writeln();
  if (violations.isEmpty) {
    b.writeln('無。每一條組合關係都是由上層指向下層。');
  } else {
    b.writeln('以下型別用到了比自己更上層的領域。**這些不是待辦事項清單，是設計債**');
    b.writeln('——一個底層元件依賴上層，代表它被歸錯領域，或它其實不屬於這個庫。');
    b.writeln();
    for (final v in violations.toSet().toList()..sort()) {
      b.writeln('- `$v`');
    }
  }
  b.writeln();

  b.writeln('## 各領域的元件樹');
  b.writeln();
  for (final cat in categoryOrder) {
    final members = components.where((c) => c.category == cat).toList()
      ..sort((x, y) => x.name.compareTo(y.name));
    if (members.isEmpty) continue;
    final catWidgets = members.where((c) => c.isWidget).length;

    b.writeln('### ${categoryLabel[cat]}');
    b.writeln();
    b.writeln('型別 ${members.length} 個，widget $catWidgets 個。');
    b.writeln();
    b.writeln('| 型別 | 行數 | 組成 |');
    b.writeln('|---|---|---|');
    for (final c in members) {
      final composes = c.composes.isEmpty
          ? '（葉節點）'
          : c.composes.map((u) => '`$u`').join('、');
      b.writeln('| `${c.name}` | ${c.loc} | $composes |');
    }
    b.writeln();

    final relations = <String>{};
    for (final c in members) {
      for (final u in c.composes) {
        relations.add('${c.name}|$u');
      }
    }
    if (relations.isNotEmpty) {
      final sorted = relations.toList()..sort();
      final nodes = <String>{};
      for (final r in sorted) {
        nodes.addAll(r.split('|'));
      }
      b.writeln('```mermaid');
      b.writeln('graph LR');
      for (final n in nodes.toList()..sort()) {
        final external = categoryOf[n] != cat ? ':::external' : '';
        b.writeln('  $n["$n"]$external');
      }
      for (final r in sorted) {
        final parts = r.split('|');
        b.writeln('  ${parts[0]} --> ${parts[1]}');
      }
      b.writeln('  classDef external stroke-dasharray: 4 3;');
      b.writeln('```');
      b.writeln();
      b.writeln('虛線框是其他領域的型別。');
      b.writeln();
    }
  }

  b.writeln('## 葉節點');
  b.writeln();
  b.writeln('不組合任何其他 Kallopis 型別的 widget。它們是這套視覺語言的**詞根**——');
  b.writeln('每一個都直接對應一個不可再分的視覺概念。');
  b.writeln();
  final leaves =
      widgets.where((c) => c.composes.isEmpty).map((c) => c.name).toList()
        ..sort();
  b.writeln(leaves.map((n) => '`$n`').join('、'));
  b.writeln();

  b.writeln('## 被最多型別使用的');
  b.writeln();
  b.writeln('改動這些的影響面最大。');
  b.writeln();
  final used = <String, int>{};
  for (final c in components) {
    for (final u in c.composes) {
      used[u] = (used[u] ?? 0) + 1;
    }
  }
  final top = used.entries.toList()
    ..sort((x, y) {
      final byCount = y.value.compareTo(x.value);
      return byCount != 0 ? byCount : x.key.compareTo(y.key);
    });
  b.writeln('| 型別 | 被幾個型別使用 |');
  b.writeln('|---|---|');
  for (final e in top.take(15)) {
    b.writeln('| `${e.key}` | ${e.value} |');
  }
  b.writeln();

  return b.toString();
}
