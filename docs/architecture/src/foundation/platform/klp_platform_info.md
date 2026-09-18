# klp_platform_info.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/foundation/platform/klp_platform_info.dart)

## 範圍

核心是 `lib/src/foundation/platform/klp_platform_info.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart LR
	n0["klp_platform_info.dart"]
	n1["dart:ui"]
	n2["package:flutter/foundation.dart"]
	n3["package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart"]
	n4["klp_app_platform.dart"]
	n5["klp_device_class.dart"]
	n6["klp_display_mode.dart"]
	n7["klp_orientation.dart"]
	n0 -->|"import"| n1
	n0 -->|"import"| n2
	n0 -->|"import"| n3
	n0 -->|"import"| n4
	n0 -->|"import"| n5
	n0 -->|"import"| n6
	n0 -->|"import"| n7
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| import | <code>import &#x27;dart:ui&#x27; show Size;</code> | [lib/src/foundation/platform/klp_platform_info.dart:1](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L1) |
| import | <code>import &#x27;package:flutter/foundation.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:2](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L2) |
| import | <code>import &#x27;package:kallopis/src/capabilities/environment/klp_environment_snapshot.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:4](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L4) |
| import | <code>import &#x27;klp_app_platform.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:5](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L5) |
| import | <code>import &#x27;klp_device_class.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:6](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L6) |
| import | <code>import &#x27;klp_display_mode.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:7](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L7) |
| import | <code>import &#x27;klp_orientation.dart&#x27;;</code> | [lib/src/foundation/platform/klp_platform_info.dart:8](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L8) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpPlatformInfo"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpPlatformInfo

ClassDeclaration · public · [lib/src/foundation/platform/klp_platform_info.dart:10](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L10)

<code>class KlpPlatformInfo</code>

來源註解摘要：由 Kallopis 環境 scope 注入子樹的執行平台與自適應環境資訊。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>platform</code> | public | <code>final KlpAppPlatform platform</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:14](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L14) |
| field <code>deviceClass</code> | public | <code>final KlpDeviceClass deviceClass</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:15](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L15) |
| field <code>orientation</code> | public | <code>final KlpOrientation orientation</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:16](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L16) |
| field <code>displayMode</code> | public | <code>final KlpDisplayMode displayMode</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:17](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L17) |
| field <code>adaptiveMode</code> | public | <code>final String adaptiveMode</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:18](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L18) |
| constructor <code>KlpPlatformInfo</code> | public | <code>const KlpPlatformInfo({ required this.platform, this.deviceClass = KlpDeviceClass.desktop, this.orientation = KlpOrientation.landscape, this.displayMode = KlpDisplayMode.browser, this.adaptiveMode = &#x27;&#x27;, })</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:20](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L20) |
| constructor <code>current</code> | public | <code>factory KlpPlatformInfo.current({Size? viewportSize})</code> | 初始環境解析：支援 Web 尺寸、模擬參數與原生平台。 | [lib/src/foundation/platform/klp_platform_info.dart:28](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L28) |
| getter <code>_snapshot</code> | private | <code>KlpEnvironmentSnapshot get _snapshot</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:68](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L68) |
| getter <code>effectiveAdaptiveMode</code> | public | <code>String get effectiveAdaptiveMode</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:77](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L77) |
| getter <code>isAndroid</code> | public | <code>bool get isAndroid</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:78](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L78) |
| getter <code>isWindows</code> | public | <code>bool get isWindows</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:79](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L79) |
| getter <code>isDesktop</code> | public | <code>bool get isDesktop</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:80](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L80) |
| getter <code>isMobile</code> | public | <code>bool get isMobile</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:81](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L81) |
| getter <code>isTablet</code> | public | <code>bool get isTablet</code> |  | [lib/src/foundation/platform/klp_platform_info.dart:82](../../../../../lib/src/foundation/platform/klp_platform_info.dart#L82) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
