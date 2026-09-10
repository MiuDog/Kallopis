import 'package:flutter/widgets.dart';

import '../../../foundation/binding/internal/klp_bound_template.dart';
import '../../../kernel/identity/klp_placement_id.dart';
import 'klp_flutter_renderer.dart';

/// 同一頁保留相同元素與焦點範圍；只有目前頁參與互動。
final class KlpFlutterRetainedStack extends StatefulWidget {
  final KlpBoundRetainedStack content;

  const KlpFlutterRetainedStack({required this.content, super.key});

  @override
  State<KlpFlutterRetainedStack> createState() =>
      _KlpFlutterRetainedStackState();
}

final class _KlpFlutterRetainedStackState
    extends State<KlpFlutterRetainedStack> {
  final Map<KlpPlacementId, FocusScopeNode> _scopes = {};
  final Map<KlpPlacementId, FocusNode> _remembered = {};
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _updateScopes(true);
  }

  @override
  void didUpdateWidget(KlpFlutterRetainedStack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateScopes(oldWidget.content.activeId != widget.content.activeId);
  }

  void _updateScopes(bool changed) {
    // 步驟 1：停用舊頁前保存仍有效的焦點，移除的頁面釋放自有範圍。
    final primary = FocusManager.instance.primaryFocus;
    for (final entry in _scopes.entries) {
      if (primary != null && primary.ancestors.contains(entry.value)) {
        _remembered[entry.key] = primary;
      }
    }
    final retained = widget.content.pages.map((page) => page.id).toSet();
    for (final id
        in _scopes.keys.where((id) => !retained.contains(id)).toList()) {
      _remembered.remove(id);
      _scopes.remove(id)!.dispose();
    }
    for (final id in retained) {
      _scopes.putIfAbsent(id, () => FocusScopeNode(debugLabel: 'Retained $id'));
    }

    // 步驟 2：先關閉所有非目前頁，再要求新頁焦點，覆蓋尚未落地的舊要求。
    final activeId = widget.content.activeId;
    for (final entry in _scopes.entries) {
      final active = entry.key == activeId;
      entry.value.descendantsAreFocusable = active;
      entry.value.descendantsAreTraversable = active;
      entry.value.canRequestFocus = active;
    }
    if (!changed) return;

    final generation = ++_generation;
    final scope = _scopes[activeId]!;
    scope.requestFocus();

    // 元素掛載完成後才恢復葉節點，過期切換不再改寫焦點。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _generation ||
          widget.content.activeId != activeId) {
        return;
      }

      final previous = _remembered[activeId];
      if (previous != null &&
          previous.context?.mounted == true &&
          previous.canRequestFocus &&
          previous.ancestors.contains(scope)) {
        previous.requestFocus();
      } else {
        scope.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _generation++;
    for (final scope in _scopes.values) {
      scope.dispose();
    }
    _scopes.clear();
    _remembered.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 所有頁保留固定祖先形狀；可見性不改動既有頁面的風格或內容。
    return Stack(
      fit: StackFit.expand,
      children: [for (final page in widget.content.pages) _page(page)],
    );
  }

  Widget _page(KlpBoundPlacement page) {
    final active = page.id == widget.content.activeId;
    final focus = FocusScope.withExternalFocusNode(
      focusScopeNode: _scopes[page.id]!,
      child: KlpFlutterRenderer(content: page),
    );
    final input = IgnorePointer(ignoring: !active, child: focus);
    final semantics = ExcludeSemantics(excluding: !active, child: input);
    final ticker = TickerMode(enabled: active, child: semantics);
    return Offstage(key: ValueKey(page.id), offstage: !active, child: ticker);
  }
}
