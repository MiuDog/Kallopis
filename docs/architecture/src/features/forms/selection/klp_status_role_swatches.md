# klp_status_role_swatches.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart)

## 範圍

核心是 `lib/src/features/forms/selection/klp_status_role_swatches.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_status_role_swatches.dart"]
	n1["../internal/klp_form_dependencies.dart"]
	n2["models/klp_status_role.dart"]
	n3["models/klp_status_role.dart"]
	n4["primitives/klp_status_role_swatch_frame.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"export"| n3
	n0 -->|"part"| n4
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;../internal/klp_form_dependencies.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_status_role_swatches.dart:1](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L1) |
| import | <code>import &#x27;models/klp_status_role.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_status_role_swatches.dart:2](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L2) |
| export | <code>export &#x27;models/klp_status_role.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_status_role_swatches.dart:4](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L4) |
| part | <code>part &#x27;primitives/klp_status_role_swatch_frame.dart&#x27;;</code> | [lib/src/features/forms/selection/klp_status_role_swatches.dart:6](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L6) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpStatusRoleSwatches"]
```

```mermaid
classDiagram
	class n0["KlpStatusRoleSwatches"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpStatusRoleSwatches

ClassDeclaration · public · [lib/src/features/forms/selection/klp_status_role_swatches.dart:8](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L8)

<code>class KlpStatusRoleSwatches extends StatelessWidget</code>

來源註解摘要：狀態色彩角色色票組。只提供語意角色選擇，不提供直接色碼選擇。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/forms/selection/klp_status_role_swatches.dart:9](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L9)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpStatusRoleSwatches</code> | public | <code>const KlpStatusRoleSwatches({ super.key, required this.label, this.helper, this.selectedRole, this.onSelectRole, })</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:10](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L10) |
| field <code>label</code> | public | <code>final String label</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:18](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L18) |
| field <code>helper</code> | public | <code>final String? helper</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:19](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L19) |
| field <code>selectedRole</code> | public | <code>final KlpStatusRole? selectedRole</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:20](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L20) |
| field <code>onSelectRole</code> | public | <code>final ValueChanged&lt;KlpStatusRole&gt;? onSelectRole</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:21](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L21) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/forms/selection/klp_status_role_swatches.dart:23](../../../../../../lib/src/features/forms/selection/klp_status_role_swatches.dart#L23) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
