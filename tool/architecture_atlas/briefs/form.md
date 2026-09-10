## 分析入口

根目錄多個檔案是相容匯出入口；`klp_form.dart` 將實作交給 `core/`。巢狀目錄分別持有 core 欄位框架、input 輸入元件、selection 選擇元件、structured 結構化欄位與 picker 參照選擇器；`internal/` 為共用內部支援。`KlpForm` 只排列外部提供的 sections、錯誤總覽與動作列，不管理資料或驗證。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 公開表單入口如何指向真正實作？ | export directives：lib/src/features/forms/klp_form.dart:1；`KlpForm`：lib/src/features/forms/core/klp_form.dart:9 |
| 標籤與欄位容器從哪裡讀？ | `KlpField`：lib/src/features/forms/core/klp_field.dart:14 |
| 一般輸入與重複結構在哪裡分開？ | `KlpNumberField`：lib/src/features/forms/input/klp_number_field.dart:9；`KlpRepeaterField`：lib/src/features/forms/structured/klp_repeater_field.dart:19 |

重要依賴：`core/klp_form.dart:1` 匯入 `internal/klp_form_dependencies.dart`；:26–38 的建構內容讀取 `context.klp.space` 並插入呼叫端的 widgets。barrel export 是可達性關係，與上述 build 組合應分開畫。
