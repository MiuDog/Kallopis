# klp_toast_widget.dart：直接依賴與宣告架構

[回到目錄](README.md) · [來源檔案](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart)

## 範圍

核心是 `lib/src/features/feedback/toast/klp_toast_widget.dart`。主要視角為該檔案明寫的 import／export／part；輔助視角為本檔宣告及 extends／implements／with／on 關係。只展開一層外部邊界。

## 直接依賴圖

```mermaid
flowchart TD
	n0["klp_toast_widget.dart"]
	n1["../klp_toast.dart"]
	n0 -->|"part of"| n1
```

## 依賴證據

| 關係 | 原始 directive | 來源 |
|---|---|---|
| part of | <code>part of &#x27;../klp_toast.dart&#x27;;</code> | [lib/src/features/feedback/toast/klp_toast_widget.dart:1](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L1) |

## 宣告關係圖

本組節點是本檔宣告；沒有箭頭的宣告未在此圖主張互相依賴。

```mermaid
classDiagram
	class n0["KlpToast"]
```

```mermaid
classDiagram
	class n0["KlpToast"]
	class n1["StatelessWidget"]
	n0 --|> n1 : extends
```


## 宣告與成員證據

成員包含 public 與 private；簽章取自來源，省略函式本體與欄位初始值。`(inferred)` 表示來源未明寫型別；建構子只顯示參數部分，不含初始化列表。

### KlpToast

ClassDeclaration · public · [lib/src/features/feedback/toast/klp_toast_widget.dart:3](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L3)

<code>class KlpToast extends StatelessWidget</code>

來源註解摘要：短暫通知。**不負責排程與消失**——停留時間取自 `theme.motion.toastDwell`， 但實際的顯示與收起由呼叫端控制。

- `extends` → <code>StatelessWidget</code>：[lib/src/features/feedback/toast/klp_toast_widget.dart:5](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L5)

| 成員 | 可見性 | 簽章／型別 | 來源註解摘要 | 證據 |
|---|---|---|---|---|
| constructor <code>KlpToast</code> | public | <code>const KlpToast({ super.key, required this.title, this.message, this.tone = KlpFeedbackTone.info, this.actionLabel, this.onAction, this.onClose, this.closeLabel, })</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:6](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L6) |
| field <code>title</code> | public | <code>final String title</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:20](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L20) |
| field <code>message</code> | public | <code>final String? message</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:21](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L21) |
| field <code>tone</code> | public | <code>final KlpFeedbackTone tone</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:22](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L22) |
| field <code>actionLabel</code> | public | <code>final String? actionLabel</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:23](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L23) |
| field <code>onAction</code> | public | <code>final VoidCallback? onAction</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:24](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L24) |
| field <code>onClose</code> | public | <code>final VoidCallback? onClose</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:25](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L25) |
| field <code>closeLabel</code> | public | <code>final String? closeLabel</code> | 關閉鈕的文字。有 [onClose] 時必填——庫不替產品決定用什麼語言。 | [lib/src/features/feedback/toast/klp_toast_widget.dart:28](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L28) |
| method <code>build</code> | public | <code>Widget build(BuildContext context)</code> |  | [lib/src/features/feedback/toast/klp_toast_widget.dart:30](../../../../../../lib/src/features/feedback/toast/klp_toast_widget.dart#L30) |

## 閱讀說明與限制

箭頭只表示來源明寫的靜態關係；import 不等於呼叫。未分析動態呼叫、欄位的實際物件擁有權、狀態轉移或渲染流程；型別未進行語意解析，繼承目標保留原始型別拼寫。public／private 依 Dart 名稱前綴判斷；public 宣告不代表已由 `lib/kallopis.dart` 匯出。

本頁由 `tool/architecture_atlas` 產生；編輯來源或生成工具後重新產生，避免手改本頁。
