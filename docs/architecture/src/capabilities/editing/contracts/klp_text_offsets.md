# klp_text_offsets.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart)

## 範圍

核心是 `lib/src/capabilities/editing/contracts/klp_text_offsets.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_text_offsets.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpTextOffsets"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpTextOffsets

ClassDeclaration · public · [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:1](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L1)

<code>final class KlpTextOffsets</code>

來源註解摘要：同一份文字的 Unicode 邊界映射，不負責字素導覽或文件編輯。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>text</code> | public | <code>final String text</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:4](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L4) |
| field <code>_utf16</code> | private | <code>final List&lt;int&gt; _utf16</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:5](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L5) |
| field <code>_utf8</code> | private | <code>final List&lt;int&gt; _utf8</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:6](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L6) |
| constructor <code>_</code> | private | <code>KlpTextOffsets._(this.text, this._utf16, this._utf8)</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:8](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L8) |
| constructor <code>KlpTextOffsets</code> | public | <code>factory KlpTextOffsets(String text)</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:10](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L10) |
| getter <code>utf8Length</code> | public | <code>int get utf8Length</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:48](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L48) |
| getter <code>utf16Length</code> | public | <code>int get utf16Length</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:49](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L49) |
| method <code>toUtf8</code> | public | <code>int toUtf8(int utf16Offset)</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:51](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L51) |
| method <code>toUtf16</code> | public | <code>int toUtf16(int utf8Offset)</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:52](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L52) |
| method <code>_boundary</code> | private | <code>int _boundary(List&lt;int&gt; offsets, int requested)</code> |  | [lib/src/capabilities/editing/contracts/klp_text_offsets.dart:54](../../../../../../lib/src/capabilities/editing/contracts/klp_text_offsets.dart#L54) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
