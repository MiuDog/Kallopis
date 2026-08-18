import 'dart:convert';
import 'dart:io';

/// 領域分類與標籤對應
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

/// 純容器型別：這些元件即使是本專案元件，也視為結構容器，不中斷展開
const pureContainers = <String>{
  'KlpSurface',
  'KlpStrokeFrame',
  'KlpRegion',
  'KlpScrollViewport',
  'KlpOverlayHost',
  'KlpPanelFrame',
  'KlpSidebarFrame',
  'KlpStageFrame',
  'KlpSplitLayout',
  'KlpWorkbenchShell',
};

class WidgetDoc {
  WidgetDoc({
    required this.name,
    required this.category,
    required this.filePath,
    required this.startLine,
    required this.endLine,
    required this.description,
    required this.isStateful,
    required this.fullFileContent,
  });

  final String name;
  final String category;
  final String filePath;
  final int startLine;
  final int endLine;
  final String description;
  final bool isStateful;
  final String fullFileContent;
}

void main() {
  final files = Directory('lib/src')
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .map((f) => f.path.replaceAll(r'\', '/'))
      .toList()
    ..sort();

  final widgetDeclRegex = RegExp(
    r'^(?:abstract\s+)?class\s+(Klp[A-Za-z0-9]+)\s+extends\s+(StatelessWidget|StatefulWidget|InheritedNotifier|InheritedWidget|CustomPainter)',
  );

  final widgets = <WidgetDoc>[];
  final widgetCategoryMap = <String, String>{};
  final widgetFileNameMap = <String, String>{};

  // 1. 蒐集所有 Widget 宣告
  for (final path in files) {
    final parts = path.split('/');
    final category = parts[2];
    final fullText = File(path).readAsStringSync();
    final lines = const LineSplitter().convert(fullText);

    for (var i = 0; i < lines.length; i++) {
      final match = widgetDeclRegex.firstMatch(lines[i]);
      if (match != null) {
        final name = match.group(1)!;
        final baseType = match.group(2)!;
        final isStateful = baseType == 'StatefulWidget';

        // 尋找 dartdoc
        final docLines = <String>[];
        var d = i - 1;
        while (d >= 0 && lines[d].trim().startsWith('///')) {
          docLines.insert(0, lines[d].trim().replaceFirst(RegExp(r'^\/\/\/\s?'), ''));
          d--;
        }
        final doc = docLines.join(' ').trim();

        widgetCategoryMap[name] = category;
        final fileBase = _toSnakeCase(name);
        widgetFileNameMap[name] = fileBase;

        widgets.add(WidgetDoc(
          name: name,
          category: category,
          filePath: path,
          startLine: i + 1,
          endLine: lines.length,
          description: doc.isNotEmpty ? doc : 'Kallopis $name 元件',
          isStateful: isStateful,
          fullFileContent: fullText,
        ));
      }
    }
  }

  stdout.writeln('找到 ${widgets.length} 個 Widget 元件。開始產生精確元件樹與架構文件...');

  // 2. 建立目錄
  final baseDir = Directory('docs/architecture/components');
  if (!baseDir.existsSync()) {
    baseDir.createSync(recursive: true);
  }

  for (final cat in categoryLabel.keys) {
    final catDir = Directory('docs/architecture/components/$cat');
    if (!catDir.existsSync()) {
      catDir.createSync(recursive: true);
    }
  }

  // 3. 逐一產生各 Widget 的文件
  for (final w in widgets) {
    _generateWidgetDoc(w, widgetCategoryMap, widgetFileNameMap);
  }

  // 4. 產生總覽 README.md
  _generateIndexDoc(widgets, widgetCategoryMap, widgetFileNameMap);

  stdout.writeln('全部架構文件生成完成！已輸出至 docs/architecture/components/');
}

String _toSnakeCase(String str) {
  return str
      .replaceAllMapped(RegExp(r'([A-Z])'), (m) => '_${m.group(1)!.toLowerCase()}')
      .replaceFirst(RegExp(r'^_'), '');
}

void _generateWidgetDoc(
  WidgetDoc w,
  Map<String, String> widgetCategoryMap,
  Map<String, String> widgetFileNameMap,
) {
  final widgetSource = _extractCompleteWidgetAndState(w);
  final parsedTree = _analyzeWidgetTree(w.name, widgetSource, widgetCategoryMap);

  final targetFileName = '${widgetFileNameMap[w.name]!}.md';
  final targetPath = 'docs/architecture/components/${w.category}/$targetFileName';

  final buffer = StringBuffer();
  buffer.writeln('# ${w.name}：元件樹架構');
  buffer.writeln();
  buffer.writeln('## 範圍');
  buffer.writeln();
  buffer.writeln('- **核心元件**：`${w.name}`');
  buffer.writeln('- **所屬領域**：`${categoryLabel[w.category] ?? w.category}`');
  buffer.writeln('- **核心職責**：${w.description}');
  buffer.writeln('- **包含範圍**：`build()` 內部建構的完整 Widget 樹（展開 Flutter 原生元件與純容器）');
  buffer.writeln('- **外部引用**：本專案其他非純容器元件（遇引用即停下並鏈結）');
  buffer.writeln();
  buffer.writeln('## 架構圖');
  buffer.writeln();
  buffer.writeln('```mermaid');
  buffer.writeln(parsedTree.mermaidDiagram);
  buffer.writeln('```');
  buffer.writeln();
  buffer.writeln('## 外部元件引用');
  buffer.writeln();
  if (parsedTree.externalReferences.isEmpty) {
    buffer.writeln('- （無外部元件引用，皆由 Flutter 原生原語或純容器構成）');
  } else {
    for (final ref in parsedTree.externalReferences) {
      final refCat = widgetCategoryMap[ref];
      final isPure = pureContainers.contains(ref);
      if (refCat != null) {
        final refFileName = widgetFileNameMap[ref]!;
        final relPath = refCat == w.category ? './$refFileName.md' : '../$refCat/$refFileName.md';
        final containerNote = isPure ? ' *(純容器，已繼續向下展開)*' : '';
        buffer.writeln('- [`$ref`]($relPath) — `${categoryLabel[refCat] ?? refCat}`$containerNote');
      } else {
        buffer.writeln('- `$ref`');
      }
    }
  }
  buffer.writeln();
  buffer.writeln('## 程式碼證據');
  buffer.writeln();
  buffer.writeln('- 檔案路徑：[`${w.filePath}`](../../../../${w.filePath}#L${w.startLine})');
  buffer.writeln('- 宣告型態：`${w.isStateful ? 'StatefulWidget' : 'StatelessWidget'}`');
  buffer.writeln();
  buffer.writeln('## 閱讀說明');
  buffer.writeln();
  buffer.writeln('- **實線節點**：Flutter 原生元件或本元件自身節點。');
  buffer.writeln('- **容器節點（圓角/綠框）**：本專案之純容器元件（如 `KlpSurface` 等），已持續向下展開其子樹。');
  buffer.writeln('- **虛線/引號節點（黃框/:::reference）**：本專案其他功能性元件，依規則停止展開並提供文件引用。');
  buffer.writeln('- **插槽節點（橘框/:::slot）**：外部傳入之 `child`、`builder` 或內容參數。');
  buffer.writeln();

  File(targetPath).writeAsStringSync(buffer.toString());
}

String _extractCompleteWidgetAndState(WidgetDoc w) {
  final text = w.fullFileContent;
  final b = StringBuffer();

  // 擷取 class KlpX
  final classPos = text.indexOf(RegExp('class\\s+${w.name}\\b'));
  if (classPos != -1) {
    b.writeln(_extractClassBody(text, classPos));
  }

  // 擷取 class _KlpXState
  final statePos = text.indexOf(RegExp('class\\s+_${w.name}State\\b'));
  if (statePos != -1) {
    b.writeln(_extractClassBody(text, statePos));
  }

  if (b.isEmpty) {
    return text;
  }
  return b.toString();
}

String _extractClassBody(String fullText, int startPos) {
  final braceStart = fullText.indexOf('{', startPos);
  if (braceStart == -1) return '';

  var braceCount = 0;
  for (var i = braceStart; i < fullText.length; i++) {
    if (fullText[i] == '{') braceCount++;
    if (fullText[i] == '}') {
      braceCount--;
      if (braceCount == 0) {
        return fullText.substring(startPos, i + 1);
      }
    }
  }
  return fullText.substring(startPos);
}

class ParsedTreeResult {
  ParsedTreeResult(this.mermaidDiagram, this.externalReferences);
  final String mermaidDiagram;
  final List<String> externalReferences;
}

ParsedTreeResult _analyzeWidgetTree(
  String widgetName,
  String source,
  Map<String, String> widgetCategoryMap,
) {
  final externalRefs = <String>{};
  
  // 尋找本元件調用的所有 Klp*
  final klpConstructRegex = RegExp(r'\b(Klp[A-Za-z0-9]+)\s*(?:<[^>]+>)?\s*\(');
  for (final m in klpConstructRegex.allMatches(source)) {
    final name = m.group(1)!;
    if (name != widgetName && !name.startsWith('KlpScale') && !_isNonWidgetHelper(name)) {
      if (widgetCategoryMap.containsKey(name) || pureContainers.contains(name)) {
        externalRefs.add(name);
      }
    }
  }

  final b = StringBuffer();
  b.writeln('flowchart TD');
  b.writeln('  classDef default fill:#1E222B,stroke:#4C566A,stroke-width:1px,color:#ECEFF4;');
  b.writeln('  classDef root fill:#2E3440,stroke:#88C0D0,stroke-width:2px,color:#ECEFF4,font-weight:bold;');
  b.writeln('  classDef reference fill:#3B4252,stroke:#EBCB8B,stroke-width:1.5px,stroke-dasharray: 4 3,color:#EBCB8B;');
  b.writeln('  classDef container fill:#2E3440,stroke:#A3BE8C,stroke-width:1.5px,color:#A3BE8C;');
  b.writeln('  classDef slot fill:#2E3440,stroke:#D08770,stroke-width:1px,stroke-dasharray: 2 2,color:#D08770;');
  b.writeln();

  final treeNodes = _buildDetailedMermaidTree(widgetName, source, externalRefs, widgetCategoryMap);
  b.write(treeNodes);

  return ParsedTreeResult(b.toString().trimRight(), externalRefs.toList()..sort());
}

String _buildDetailedMermaidTree(
  String rootName,
  String source,
  Set<String> externalRefs,
  Map<String, String> widgetCategoryMap,
) {
  final b = StringBuffer();
  b.writeln('  root["$rootName"]:::root');

  final callMatches = _extractBuildTreeHierarchy(source, rootName, widgetCategoryMap);

  if (callMatches.isEmpty) {
    b.writeln('  root --> leaf["Widget (原生客製佈局)"]');
    return b.toString();
  }

  var nodeIndex = 1;
  final parentStack = <String>['root'];

  for (final item in callMatches) {
    final nodeId = 'n$nodeIndex';
    nodeIndex++;

    final parent = parentStack.isNotEmpty ? parentStack.last : 'root';

    if (item.isReference) {
      b.writeln('  $nodeId["${item.label}"]:::reference');
      b.writeln('  $parent --> $nodeId');
    } else if (item.isPureContainer) {
      b.writeln('  $nodeId["${item.label}"]:::container');
      b.writeln('  $parent --> $nodeId');
      if (item.hasChild) {
        parentStack.add(nodeId);
      }
    } else if (item.isSlot) {
      b.writeln('  $nodeId["${item.label}"]:::slot');
      b.writeln('  $parent --> $nodeId');
    } else {
      b.writeln('  $nodeId["${item.label}"]');
      b.writeln('  $parent --> $nodeId');
      if (item.hasChild) {
        parentStack.add(nodeId);
      }
    }
  }

  return b.toString();
}

class CallItem {
  CallItem(this.label, {this.isReference = false, this.isPureContainer = false, this.isSlot = false, this.hasChild = false});
  final String label;
  final bool isReference;
  final bool isPureContainer;
  final bool isSlot;
  final bool hasChild;
}

List<CallItem> _extractBuildTreeHierarchy(
  String source,
  String rootName,
  Map<String, String> widgetCategoryMap,
) {
  final list = <CallItem>[];
  final seen = <String>{};

  // 抓取所有 build 或 _build* 方法主體
  final buildMethodBodies = _extractAllMethodBodies(source);
  final combinedBody = buildMethodBodies.isNotEmpty ? buildMethodBodies.join('\n') : source;

  final callRegex = RegExp(r'\b([A-Z][A-Za-z0-9]+)\s*(?:<[^>]+>)?\s*\(');
  for (final m in callRegex.allMatches(combinedBody)) {
    final name = m.group(1)!;

    if (name == rootName || _isNonWidgetHelper(name)) {
      continue;
    }

    if (seen.contains(name)) continue;
    seen.add(name);

    if (pureContainers.contains(name)) {
      list.add(CallItem(name, isPureContainer: true, hasChild: true));
    } else if (name.startsWith('Klp') && (widgetCategoryMap.containsKey(name) || externalWidgetNames.contains(name))) {
      list.add(CallItem(name, isReference: true, hasChild: false));
    } else if (_isFlutterWidget(name)) {
      final hasChild = _canHaveChildren(name);
      list.add(CallItem(name, hasChild: hasChild));
    }
  }

  if (combinedBody.contains('leading') && !seen.contains('leading')) {
    list.add(CallItem('leading (slot)', isSlot: true));
  }
  if (combinedBody.contains('trailing') && !seen.contains('trailing')) {
    list.add(CallItem('trailing (slot)', isSlot: true));
  }
  if ((combinedBody.contains('child:') || combinedBody.contains('builder:') || combinedBody.contains('itemBuilder:')) && !seen.contains('child_slot')) {
    list.add(CallItem('child / slot', isSlot: true));
  }

  return list;
}

List<String> _extractAllMethodBodies(String source) {
  final bodies = <String>[];
  final methodPattern = RegExp(r'Widget\s+(?:build|_[A-Za-z0-9]+)\s*\([^)]*\)\s*\{');
  for (final match in methodPattern.allMatches(source)) {
    final startPos = match.end - 1;
    final body = _extractBalancedBlock(source, startPos);
    if (body.isNotEmpty) {
      bodies.add(body);
    }
  }
  return bodies;
}

String _extractBalancedBlock(String text, int openBracePos) {
  var count = 0;
  for (var i = openBracePos; i < text.length; i++) {
    if (text[i] == '{') count++;
    if (text[i] == '}') {
      count--;
      if (count == 0) {
        return text.substring(openBracePos + 1, i);
      }
    }
  }
  return text.substring(openBracePos + 1);
}

const externalWidgetNames = {
  'KlpButton', 'KlpIconButton', 'KlpCheckbox', 'KlpTextField', 'KlpSelect',
  'KlpSlider', 'KlpSwitch', 'KlpToggle', 'KlpToggleIndicator', 'KlpSegmentedControl',
  'KlpSlidingSelection', 'KlpTriStateToggle', 'KlpRadioGroup', 'KlpCompactSwitch',
  'KlpBadge', 'KlpCard', 'KlpTag', 'KlpProgress', 'KlpListTile', 'KlpKeyValueTable',
  'KlpKeyValueList', 'KlpDataTable', 'KlpTree', 'KlpTreeItem', 'KlpJsonTree',
  'KlpCodeViewer', 'KlpFilePreview', 'KlpEmptyState', 'KlpLoadingState', 'KlpErrorState',
  'KlpPermissionState', 'KlpInlineNotice', 'KlpProgressOverlay', 'KlpRegionPlaceholder',
  'KlpSkeletonLine', 'KlpToast', 'KlpToastStack', 'KlpPressable', 'KlpFilterBar',
  'KlpPresenceIndicator', 'KlpSelectionToolbar', 'KlpShortcutHint', 'KlpBreadcrumb',
  'KlpPagination', 'KlpTabs', 'KlpRailItem', 'KlpSidebarSectionLabel', 'KlpViewSwitcher',
  'KlpDialog', 'KlpMenu', 'KlpMenuItem', 'KlpTooltip', 'KlpTooltipSurface',
  'KlpText', 'KlpRichText', 'KlpIcon', 'KlpAvatar', 'KlpAvatarGroup', 'KlpBlock',
  'KlpBlockCanvas', 'KlpDragPreview', 'KlpDropTarget', 'KlpDropIndicator', 'KlpPopover',
  'KlpSortControl', 'KlpStatusIndicator', 'KlpThemeToggle', 'KlpSection', 'KlpDivider',
  'KlpDashedDivider', 'KlpDashedBorder', 'KlpAppScreen', 'KlpAppWindowHeader',
  'KlpPaneCollapseControl', 'KlpPanelHeader', 'KlpResponsivePaneCoordinator',
  'KlpStatusBar', 'KlpThemePreviewTile', 'KlpWindowControls', 'KlpCommandMenu',
  'KlpEditorToolbar', 'KlpBulkActionBar', 'KlpEntityPicker', 'KlpPageChrome',
  'KlpPropertySummary', 'KlpSaveStatusCard', 'KlpSearchNavigator', 'KlpForm',
  'KlpFormSection', 'KlpFormActions', 'KlpFormErrorSummary', 'KlpField',
  'KlpFieldGroup', 'KlpFieldLabel', 'KlpFieldDescription', 'KlpFieldError',
  'KlpSelectField', 'KlpDateField', 'KlpNumberField', 'KlpPasswordField',
  'KlpTextArea', 'KlpCodeField', 'KlpFileField', 'KlpColorRoleField',
  'KlpRepeaterField', 'KlpKeyValueEditor', 'KlpMultiSelectField', 'KlpReferencePicker',
  'KlpConditionalFieldRegion', 'KlpRouter', 'KlpRouteNotFound', 'KlpRouterScope',
  'KlpRouterOutlet', 'KlpResizablePane', 'KlpResizeHandle', 'KlpVirtualList', 'KlpVirtualGrid',
};

bool _isNonWidgetHelper(String name) {
  return name.endsWith('State') ||
      name.endsWith('Theme') ||
      name.endsWith('Style') ||
      name.endsWith('Data') ||
      name.endsWith('Border') ||
      name.endsWith('Decoration') ||
      name.endsWith('EdgeInsets') ||
      name.endsWith('Color') ||
      name.endsWith('Duration') ||
      name.endsWith('Radius') ||
      name.endsWith('Curve') ||
      name.endsWith('Alignment') ||
      name.endsWith('Key') ||
      name.endsWith('Metrics') ||
      name.endsWith('Tone') ||
      name.endsWith('Role') ||
      name.endsWith('Option') ||
      name.endsWith('Span') ||
      name.endsWith('Details') ||
      name.endsWith('Separator') ||
      name.endsWith('Type') ||
      name.endsWith('Action');
}

bool _isFlutterWidget(String name) {
  const common = {
    'Container', 'Padding', 'Row', 'Column', 'Stack', 'Positioned', 'Expanded',
    'Flexible', 'GestureDetector', 'MouseRegion', 'Focus', 'AnimatedContainer',
    'AnimatedOpacity', 'DecoratedBox', 'CustomPaint', 'ClipRRect', 'SingleChildScrollView',
    'ListView', 'Align', 'Center', 'Opacity', 'ColoredBox', 'Transform', 'Semantics',
    'ConstrainedBox', 'FittedBox', 'SizedBox', 'Text', 'RichText', 'DefaultTextStyle',
    'Icon', 'Image', 'SvgPicture', 'Offstage', 'RepaintBoundary', 'KeyedSubtree',
    'Builder', 'StatefulBuilder', 'LayoutBuilder', 'AnimatedBuilder', 'Listener',
    'AbsorbPointer', 'IgnorePointer', 'Wrap', 'Spacer', 'IntrinsicWidth', 'IntrinsicHeight',
    'Overlay', 'Portal', 'Table', 'TableRow', 'TableCell', 'FractionallySizedBox',
    'Material', 'InkWell', 'InkResponse', 'Card', 'PhysicalModel', 'BackdropFilter',
    'ValueListenableBuilder', 'Scrollbar', 'NotificationListener',
  };
  return common.contains(name);
}

bool _canHaveChildren(String name) {
  const containers = {
    'Container', 'Padding', 'Row', 'Column', 'Stack', 'GestureDetector',
    'MouseRegion', 'AnimatedContainer', 'DecoratedBox', 'Center', 'Align',
    'SizedBox', 'SingleChildScrollView', 'Focus', 'Semantics', 'Expanded',
    'Flexible', 'Material', 'ClipRRect', 'Card', 'Transform', 'ColoredBox',
    'ConstrainedBox', 'FittedBox', 'IntrinsicWidth', 'IntrinsicHeight',
  };
  return containers.contains(name);
}

void _generateIndexDoc(
  List<WidgetDoc> widgets,
  Map<String, String> widgetCategoryMap,
  Map<String, String> widgetFileNameMap,
) {
  final b = StringBuffer();
  b.writeln('# Kallopis 元件樹架構全覽');
  b.writeln();
  b.writeln('> 本目錄遵循 `/focused-architecture-diagram` 規範，繪製 Kallopis 所有元件之內部 Widget Tree 架構。');
  b.writeln();
  b.writeln('## 分類與規範原則');
  b.writeln();
  b.writeln('1. **同構分類**：嚴格依照 `lib/src/` 領域目錄進行分類。');
  b.writeln('2. **原生展開**：Flutter 原生元件（如 `Container`, `Row`, `Column`, `Padding`, `Material` 等）持續向下繪製到底。');
  b.writeln('3. **純容器中繼**：`KlpSurface`、`KlpStrokeFrame` 等純容器元件不中斷，持續展開其內部 child。');
  b.writeln('4. **引用停步**：遇到本專案之其他非純容器元件（如 `KlpButton`, `KlpTextField`, `KlpIcon` 等）即刻停下，並提供文件超連結引用。');
  b.writeln();
  b.writeln('## 領域分類索引');
  b.writeln();

  for (final cat in categoryLabel.keys) {
    final catWidgets = widgets.where((w) => w.category == cat).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (catWidgets.isEmpty) continue;

    b.writeln('- [${categoryLabel[cat]} (${catWidgets.length})](#${catWidgets.first.category})');
  }
  b.writeln();

  for (final cat in categoryLabel.keys) {
    final catWidgets = widgets.where((w) => w.category == cat).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    if (catWidgets.isEmpty) continue;

    b.writeln('<a id="$cat"></a>');
    b.writeln('### ${categoryLabel[cat]} (${catWidgets.length})');
    b.writeln();
    b.writeln('| 元件名稱 | 類型 | 說明 | 架構文件 |');
    b.writeln('|---|---|---|---|');
    for (final w in catWidgets) {
      final fileName = widgetFileNameMap[w.name]!;
      final docLink = '[$fileName.md](./$cat/$fileName.md)';
      final type = w.isStateful ? 'Stateful' : 'Stateless';
      b.writeln('| `${w.name}` | `$type` | ${w.description} | $docLink |');
    }
    b.writeln();
  }

  File('docs/architecture/components/README.md').writeAsStringSync(b.toString());
}
