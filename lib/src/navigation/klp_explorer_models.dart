import 'package:flutter/foundation.dart';

import '../feedback/klp_feedback_tone.dart';
import '../foundation/klp_icon.dart';

/// Explorer 元素節點的資料類型。
enum KlpExplorerNodeKind { folder, file }

/// Explorer 的分類資料模型。
///
/// 分類只負責命名一組節點與宣告是否可收合；尺寸、內距與
/// 排版由 `KlpExplorer` 統一管理。
@immutable
class KlpExplorerCategory {
  const KlpExplorerCategory({
    required this.id,
    required this.label,
    this.nodes = const [],
    this.expanded = true,
    this.collapsible = true,
  });

  final String id;
  final String label;
  final List<KlpExplorerNode> nodes;
  final bool expanded;
  final bool collapsible;
}

/// Explorer 的單一元素節點。
///
/// 資料夾與檔案共用同一種節點模型；是否呈現遞迴階層，由
/// `KlpExplorer.allowNesting` 決定，不由產品自行編排 Widget。
@immutable
class KlpExplorerNode {
  const KlpExplorerNode({
    required this.id,
    required this.label,
    required this.kind,
    this.icon,
    this.children = const [],
    this.expanded = false,
    this.selected = false,
    this.badge,
    this.tone,
    this.data,
  });

  final String id;
  final String label;
  final KlpExplorerNodeKind kind;
  final KlpIconData? icon;

  /// 子節點；只有 [KlpExplorerNodeKind.folder] 會呈現其內容。
  final List<KlpExplorerNode> children;
  final bool expanded;
  final bool selected;
  final String? badge;
  final KlpFeedbackTone? tone;
  final Object? data;

  bool get isFolder => kind == KlpExplorerNodeKind.folder;
}
