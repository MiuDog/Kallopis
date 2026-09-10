# klp_frame_lease.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart)

## 範圍

核心是 `lib/src/kernel/lifecycle/internal/klp_frame_lease.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_frame_lease.dart"]
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| 無 | 本檔未宣告 import／export／part | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:1](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpFrameLease"]
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpFrameLease

ClassDeclaration · public · [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:1](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L1)

<code>final class KlpFrameLease</code>

來源註解摘要：更新提交後撤銷舊畫面的操作資格，避免尚未卸載的按鈕執行過期回呼。


| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| field <code>_active</code> | private | <code>bool _active</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:3](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L3) |
| field <code>_parent</code> | private | <code>final KlpFrameLease? _parent</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:4](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L4) |
| field <code>_enabled</code> | private | <code>final bool _enabled</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:5](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L5) |
| constructor <code>KlpFrameLease</code> | public | <code>KlpFrameLease()</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:7](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L7) |
| constructor <code>_</code> | private | <code>KlpFrameLease._(this._parent, this._enabled)</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:8](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L8) |
| getter <code>isActive</code> | public | <code>bool get isActive</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:10](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L10) |
| method <code>derive</code> | public | <code>KlpFrameLease derive({required bool enabled})</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:11](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L11) |
| method <code>revoke</code> | public | <code>void revoke()</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:13](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L13) |
| method <code>run</code> | public | <code>void run(void Function() callback)</code> |  | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:14](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L14) |
| method <code>runAsync</code> | public | <code>Future&lt;void&gt; runAsync(Future&lt;void&gt; Function() callback)</code> | 非同步操作也必須在啟動當下檢查 lease；完成後由資源自行決定提交結果。 | [lib/src/kernel/lifecycle/internal/klp_frame_lease.dart:18](../../../../../../lib/src/kernel/lifecycle/internal/klp_frame_lease.dart#L18) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
