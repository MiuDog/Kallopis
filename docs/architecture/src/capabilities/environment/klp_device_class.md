# klp_device_class.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../lib/src/capabilities/environment/klp_device_class.dart)

## 範圍

核心是 `lib/src/capabilities/environment/klp_device_class.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_device_class.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/environment/klp_device_class.dart:1](../../../../../lib/src/capabilities/environment/klp_device_class.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpDeviceClass"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpDeviceClass

EnumDeclaration · public · [lib/src/capabilities/environment/klp_device_class.dart:1](../../../../../lib/src/capabilities/environment/klp_device_class.dart#L1)

<code>enum KlpDeviceClass</code>

來源註解摘要：裝置形態類別（依設備尺寸與操作形態分類）。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| enum value <code>phone</code> | public | <code>phone</code> | 手機形態（緊湊窄螢幕，短邊 &lt; 600dp）。 | [lib/src/capabilities/environment/klp_device_class.dart:3](../../../../../lib/src/capabilities/environment/klp_device_class.dart#L3) |
| enum value <code>tablet</code> | public | <code>tablet</code> | 平板形態（如 iPad，中型螢幕，600dp &lt;= 短邊 &lt; 1024dp，或具備移動/觸控特徵）。 | [lib/src/capabilities/environment/klp_device_class.dart:6](../../../../../lib/src/capabilities/environment/klp_device_class.dart#L6) |
| enum value <code>desktop</code> | public | <code>desktop</code> | 桌面形態（寬螢幕工作站，滑鼠指標操作為主）。 | [lib/src/capabilities/environment/klp_device_class.dart:9](../../../../../lib/src/capabilities/environment/klp_device_class.dart#L9) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
