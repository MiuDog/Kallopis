# klp_application.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/application/structure/klp_application.dart)

## 範圍

核心是 `lib/src/application/structure/klp_application.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_application.dart"]
	n1["package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart"]
	n2["package:kallopis/src/foundation/localization/klp_localizations.dart"]
	n3["dart:async"]
	n4["package:kallopis/src/capabilities/actions/klp_pick_file_action.dart"]
	n5["package:kallopis/src/capabilities/files/klp_file_selection.dart"]
	n6["package:kallopis/src/application/environment/klp_file_selection_adapter.dart"]
	n7["package:flutter/widgets.dart"]
	n8["package:flutter/foundation.dart"]
	n9["package:flutter/services.dart"]
	n10["package:kallopis/src/capabilities/state/klp_state.dart"]
	n11["package:kallopis/src/capabilities/state/klp_subscription.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_application.dart"]
	n1["package:kallopis/src/capabilities/actions/klp_action.dart"]
	n2["package:kallopis/src/capabilities/actions/klp_action_activation.dart"]
	n3["package:kallopis/src/capabilities/actions/klp_action_handler.dart"]
	n4["package:kallopis/src/capabilities/navigation/klp_destination.dart"]
	n5["package:kallopis/src/capabilities/navigation/klp_location.dart"]
	n6["package:kallopis/src/capabilities/navigation/klp_navigation_decision.dart"]
	n7["package:kallopis/src/capabilities/navigation/klp_navigation_entry.dart"]
	n8["package:kallopis/src/capabilities/navigation/klp_navigation_ticket.dart"]
	n9["package:kallopis/src/capabilities/navigation/klp_navigation_transition.dart"]
	n10["package:kallopis/src/capabilities/navigation/klp_route_policy.dart"]
	n11["package:kallopis/src/capabilities/navigation/engine/klp_navigation_machine.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_application.dart"]
	n1["package:kallopis/src/capabilities/navigation/engine/klp_navigation_commit_exception.dart"]
	n2["package:kallopis/src/capabilities/navigation/klp_navigation_cancellation.dart"]
	n3["package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart"]
	n4["package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart"]
	n5["package:kallopis/src/capabilities/navigation/klp_navigation_restoration.dart"]
	n6["package:kallopis/src/capabilities/navigation/klp_route_uri.dart"]
	n7["package:kallopis/src/composition/nodes/klp_scope_boundary.dart"]
	n8["package:kallopis/src/composition/nodes/klp_platform_strategy.dart"]
	n9["package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart"]
	n10["package:kallopis/src/capabilities/environment/klp_app_platform.dart"]
	n11["package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_application.dart"]
	n1["package:kallopis/src/foundation/platform/klp_id_scope.dart"]
	n2["package:kallopis/src/kernel/lifecycle/klp_run_lifecycle_actions.dart"]
	n3["package:kallopis/src/kernel/identity/klp_id.dart"]
	n4["package:kallopis/src/kernel/identity/klp_placement_id.dart"]
	n5["package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart"]
	n6["package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart"]
	n7["package:kallopis/src/runtime/compilation/klp_tree_runtime.dart"]
	n8["package:kallopis/src/runtime/contracts/klp_runtime_frame.dart"]
	n9["package:kallopis/src/runtime/contracts/klp_installation_exception.dart"]
	n10["package:kallopis/src/styling/primitives/klp_primitive_set.dart"]
	n11["package:kallopis/src/styling/primitives/klp_style_value.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
	n0 -->|"import"| n8
	n0 -->|"import"| n9
	n0 -->|"import"| n10
	n0 -->|"import"| n11
```

```mermaid
flowchart LR
	n0["klp_application.dart"]
	n1["package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart"]
	n2["klp_screen.dart"]
	n3["internal/klp_retained_screens.dart"]
	n4["../routing/klp_router.dart"]
	n5["../routing/klp_route.dart"]
	n6["../routing/klp_route_input.dart"]
	n7["../environment/klp_application_environment.dart"]
	n8["../environment/klp_application_environment_observer.dart"]
	n9["../bootstrap/run_klp_app.dart"]
	n10["../bootstrap/internal/klp_application_host.dart"]
	n11["../bootstrap/internal/klp_application_host_state.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"part"| n4
	n0 -->|"part"| n5
	n0 -->|"part"| n6
	n0 -->|"part"| n7
	n0 -->|"part"| n8
	n0 -->|"part"| n9
	n0 -->|"part"| n10
	n0 -->|"part"| n11
```

```mermaid
flowchart TD
	n0["klp_application.dart"]
	n1["../bootstrap/internal/klp_application_session.dart"]
	n2["../bootstrap/internal/klp_application_session_commit.dart"]
	n3["../bootstrap/internal/klp_application_session_actions.dart"]
	n0 -->|"part"| n1
	n0 -->|"part"| n2
	n0 -->|"part"| n3
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;package:kallopis/src/features/editing/contracts/klp_editing_host_failure.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:1](../../../../../lib/src/application/structure/klp_application.dart#L1) |
| import | <code>import &#x27;package:kallopis/src/foundation/localization/klp_localizations.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:2](../../../../../lib/src/application/structure/klp_application.dart#L2) |
| import | <code>import &#x27;dart:async&#x27;;</code> | [lib/src/application/structure/klp_application.dart:3](../../../../../lib/src/application/structure/klp_application.dart#L3) |
| import | <code>import &#x27;package:kallopis/src/capabilities/actions/klp_pick_file_action.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:4](../../../../../lib/src/application/structure/klp_application.dart#L4) |
| import | <code>import &#x27;package:kallopis/src/capabilities/files/klp_file_selection.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:5](../../../../../lib/src/application/structure/klp_application.dart#L5) |
| import | <code>import &#x27;package:kallopis/src/application/environment/klp_file_selection_adapter.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:6](../../../../../lib/src/application/structure/klp_application.dart#L6) |
| import | <code>import &#x27;package:flutter/widgets.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:8](../../../../../lib/src/application/structure/klp_application.dart#L8) |
| import | <code>import &#x27;package:flutter/foundation.dart&#x27; show kIsWeb, defaultTargetPlatform, TargetPlatform;</code> | [lib/src/application/structure/klp_application.dart:9](../../../../../lib/src/application/structure/klp_application.dart#L9) |
| import | <code>import &#x27;package:flutter/services.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:10](../../../../../lib/src/application/structure/klp_application.dart#L10) |
| import | <code>import &#x27;package:kallopis/src/capabilities/state/klp_state.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:12](../../../../../lib/src/application/structure/klp_application.dart#L12) |
| import | <code>import &#x27;package:kallopis/src/capabilities/state/klp_subscription.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:13](../../../../../lib/src/application/structure/klp_application.dart#L13) |
| import | <code>import &#x27;package:kallopis/src/capabilities/actions/klp_action.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:14](../../../../../lib/src/application/structure/klp_application.dart#L14) |
| import | <code>import &#x27;package:kallopis/src/capabilities/actions/klp_action_activation.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:15](../../../../../lib/src/application/structure/klp_application.dart#L15) |
| import | <code>import &#x27;package:kallopis/src/capabilities/actions/klp_action_handler.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:16](../../../../../lib/src/application/structure/klp_application.dart#L16) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_destination.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:17](../../../../../lib/src/application/structure/klp_application.dart#L17) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_location.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:18](../../../../../lib/src/application/structure/klp_application.dart#L18) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_decision.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:19](../../../../../lib/src/application/structure/klp_application.dart#L19) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_entry.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:20](../../../../../lib/src/application/structure/klp_application.dart#L20) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_ticket.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:21](../../../../../lib/src/application/structure/klp_application.dart#L21) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_transition.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:22](../../../../../lib/src/application/structure/klp_application.dart#L22) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_route_policy.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:23](../../../../../lib/src/application/structure/klp_application.dart#L23) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/engine/klp_navigation_machine.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:24](../../../../../lib/src/application/structure/klp_application.dart#L24) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/engine/klp_navigation_commit_exception.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:25](../../../../../lib/src/application/structure/klp_application.dart#L25) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_cancellation.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:26](../../../../../lib/src/application/structure/klp_application.dart#L26) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_outcome.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:27](../../../../../lib/src/application/structure/klp_application.dart#L27) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_snapshot.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:28](../../../../../lib/src/application/structure/klp_application.dart#L28) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_navigation_restoration.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:29](../../../../../lib/src/application/structure/klp_application.dart#L29) |
| import | <code>import &#x27;package:kallopis/src/capabilities/navigation/klp_route_uri.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:30](../../../../../lib/src/application/structure/klp_application.dart#L30) |
| import | <code>import &#x27;package:kallopis/src/composition/nodes/klp_scope_boundary.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:31](../../../../../lib/src/application/structure/klp_application.dart#L31) |
| import | <code>import &#x27;package:kallopis/src/composition/nodes/klp_platform_strategy.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:32](../../../../../lib/src/application/structure/klp_application.dart#L32) |
| import | <code>import &#x27;package:kallopis/src/foundation/binding/contracts/klp_bound_template.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:33](../../../../../lib/src/application/structure/klp_application.dart#L33) |
| import | <code>import &#x27;package:kallopis/src/capabilities/environment/klp_app_platform.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:34](../../../../../lib/src/application/structure/klp_application.dart#L34) |
| import | <code>import &#x27;package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:35](../../../../../lib/src/application/structure/klp_application.dart#L35) |
| import | <code>import &#x27;package:kallopis/src/foundation/platform/klp_id_scope.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:36](../../../../../lib/src/application/structure/klp_application.dart#L36) |
| import | <code>import &#x27;package:kallopis/src/kernel/lifecycle/klp_run_lifecycle_actions.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:37](../../../../../lib/src/application/structure/klp_application.dart#L37) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_id.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:38](../../../../../lib/src/application/structure/klp_application.dart#L38) |
| import | <code>import &#x27;package:kallopis/src/kernel/identity/klp_placement_id.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:39](../../../../../lib/src/application/structure/klp_application.dart#L39) |
| import | <code>import &#x27;package:kallopis/src/rendering/flutter/klp_flutter_renderer.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:40](../../../../../lib/src/application/structure/klp_application.dart#L40) |
| import | <code>import &#x27;package:kallopis/src/rendering/flutter/klp_viewport_capabilities.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:41](../../../../../lib/src/application/structure/klp_application.dart#L41) |
| import | <code>import &#x27;package:kallopis/src/runtime/compilation/klp_tree_runtime.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:42](../../../../../lib/src/application/structure/klp_application.dart#L42) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_runtime_frame.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:43](../../../../../lib/src/application/structure/klp_application.dart#L43) |
| import | <code>import &#x27;package:kallopis/src/runtime/contracts/klp_installation_exception.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:44](../../../../../lib/src/application/structure/klp_application.dart#L44) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_primitive_set.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:45](../../../../../lib/src/application/structure/klp_application.dart#L45) |
| import | <code>import &#x27;package:kallopis/src/styling/primitives/klp_style_value.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:46](../../../../../lib/src/application/structure/klp_application.dart#L46) |
| import | <code>import &#x27;package:kallopis/src/application/bootstrap/internal/klp_application_adapters.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:47](../../../../../lib/src/application/structure/klp_application.dart#L47) |
| import | <code>import &#x27;klp_screen.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:48](../../../../../lib/src/application/structure/klp_application.dart#L48) |
| import | <code>import &#x27;internal/klp_retained_screens.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:49](../../../../../lib/src/application/structure/klp_application.dart#L49) |
| part | <code>part &#x27;../routing/klp_router.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:51](../../../../../lib/src/application/structure/klp_application.dart#L51) |
| part | <code>part &#x27;../routing/klp_route.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:52](../../../../../lib/src/application/structure/klp_application.dart#L52) |
| part | <code>part &#x27;../routing/klp_route_input.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:53](../../../../../lib/src/application/structure/klp_application.dart#L53) |
| part | <code>part &#x27;../environment/klp_application_environment.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:54](../../../../../lib/src/application/structure/klp_application.dart#L54) |
| part | <code>part &#x27;../environment/klp_application_environment_observer.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:55](../../../../../lib/src/application/structure/klp_application.dart#L55) |
| part | <code>part &#x27;../bootstrap/run_klp_app.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:56](../../../../../lib/src/application/structure/klp_application.dart#L56) |
| part | <code>part &#x27;../bootstrap/internal/klp_application_host.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:57](../../../../../lib/src/application/structure/klp_application.dart#L57) |
| part | <code>part &#x27;../bootstrap/internal/klp_application_host_state.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:58](../../../../../lib/src/application/structure/klp_application.dart#L58) |
| part | <code>part &#x27;../bootstrap/internal/klp_application_session.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:59](../../../../../lib/src/application/structure/klp_application.dart#L59) |
| part | <code>part &#x27;../bootstrap/internal/klp_application_session_commit.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:60](../../../../../lib/src/application/structure/klp_application.dart#L60) |
| part | <code>part &#x27;../bootstrap/internal/klp_application_session_actions.dart&#x27;;</code> | [lib/src/application/structure/klp_application.dart:61](../../../../../lib/src/application/structure/klp_application.dart#L61) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpApplication"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpApplication

ClassDeclaration · public · [lib/src/application/structure/klp_application.dart:63](../../../../../lib/src/application/structure/klp_application.dart#L63)

<code>final class KlpApplication</code>

來源註解摘要：整份應用宣告；外部只更新此資料，不負責掛載功能資源。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/application/structure/klp_application.dart:66](../../../../../lib/src/application/structure/klp_application.dart#L66) |
| field <code>primitives</code> | public | <code>final KlpPrimitiveSet primitives</code> |  | [lib/src/application/structure/klp_application.dart:67](../../../../../lib/src/application/structure/klp_application.dart#L67) |
| field <code>router</code> | public | <code>final KlpRouter router</code> |  | [lib/src/application/structure/klp_application.dart:68](../../../../../lib/src/application/structure/klp_application.dart#L68) |
| field <code>onNavigationRestorationChanged</code> | public | <code>final void Function(KlpNavigationRestoration restoration)? onNavigationRestorationChanged</code> |  | [lib/src/application/structure/klp_application.dart:69](../../../../../lib/src/application/structure/klp_application.dart#L69) |
| constructor <code>KlpApplication</code> | public | <code>KlpApplication({ required this.title, required this.primitives, required this.router, this.onNavigationRestorationChanged, })</code> |  | [lib/src/application/structure/klp_application.dart:71](../../../../../lib/src/application/structure/klp_application.dart#L71) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
