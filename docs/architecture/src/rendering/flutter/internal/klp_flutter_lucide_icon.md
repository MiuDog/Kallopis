# klp_flutter_lucide_icon.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart)

## 範圍

核心是 `lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_flutter_lucide_icon.dart"]
	n1["package:flutter/widgets.dart"]
	n2["package:flutter_svg/flutter_svg.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:1](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L1) |
| import | <code>import &#x27;package:flutter_svg/flutter_svg.dart&#x27;;</code> | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:2](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L2) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFlutterLucideIcon"]
```

```mermaid
classDiagram
	class n0["KlpFlutterLucideIcon"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFlutterLucideIcon

ClassDeclaration · public · [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:4](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L4)

<code>final class KlpFlutterLucideIcon extends StatelessWidget</code>

來源註解摘要：工作區唯一 Lucide 載入點；尺寸與顏色由已解析語意傳入。

- `extends` → <code>StatelessWidget</code>：[lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:5](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>name</code> | public | <code>final String name</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:7](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L7) |
| field <code>size</code> | public | <code>final double size</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:8](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L8) |
| field <code>color</code> | public | <code>final Color color</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:9](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L9) |
| constructor <code>KlpFlutterLucideIcon</code> | public | <code>const KlpFlutterLucideIcon(this.name, {required this.size, required this.color, super.key})</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:10](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L10) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart:12](../../../../../../lib/src/rendering/flutter/internal/klp_flutter_lucide_icon.dart#L12) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
