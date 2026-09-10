## 分析入口

此目錄集中資料的視覺呈現元件，包括表格、樹、訊息、日期與進度；入口應依呈現類型選擇。`KlpDataTable` 與 `KlpTree` 共置於 advanced data 檔，不能將一個檔案誤畫成一個類別。此目錄目前沒有巢狀子目錄。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 表格列與欄的資料形狀在哪裡？ | `KlpDataColumn`、`KlpDataRow`：lib/src/features/collections/klp_advanced_data.dart:21、64 |
| 表格與樹各自從哪裡建構？ | `KlpDataTable`、`KlpTree`：lib/src/features/collections/klp_advanced_data.dart:76、316 |
| 訊息容器與單則訊息如何分工？ | `KlpMessageThread`、`KlpMessageBubble`：lib/src/features/collections/klp_message_thread.dart:68、11 |

重要依賴：`klp_message_thread.dart:3` 匯入 `KlpButton` 所在模組；同檔 :4、:6 匯入 surface 與 typography。這些證據表示靜態來源依賴，不代表資料載入或執行時呼叫順序。
