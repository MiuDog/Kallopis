# METRICS-V1-r1 驗證

FND-V1-05 已完成；全目標 44/50，六切片與最終稽核仍 active。

Styling 擁有原14檔metrics library／part，foundation只保留單一相容export；原13類型與150個公開常數、列表、Duration及package字型保持相同。兩theme呼叫端向下使用，沒有第二份值來源。全九模組指令圖已無循環，完整styling禁止foundation邊由獨立測試保護。

| 證據 | 結果 |
| --- | --- |
| 獨立 metrics 契約 | 8 項通過，原150值／13類型身分／宣告快照／唯一library與part／完整styling邊界。 |
| 既有 theme 行為 | 初次混合執行中33項theme檢查通過；token閘門失敗分開記錄，不宣稱初次全Green。 |
| 原 token 閘門修復 | 9 項全通過；原上限45與下限30保持，未文件化95降至45。 |
| 既有 frontend 邊界 | 155 項通過。 |
| Source／scope／analysis | 原14移動檔＋2caller正文與directive身分等價；兩module scope與局部分析通過。 |
| 文件修復 | capabilities/features各25宣告；兩scope PASS，刪除新增註解精確還原各worker原bytes。 |
| Atlas | 1196 source、278 folder、3713 diagrams；1475 files freshness逐byte通過。 |

原工作樹亦重現95個型別缺文件，不是調整測試baseline解決。METRICS-DOC-r1僅補既有provider/workspace/prepared/asset用途與責任，未改runtime、API或資料權威。原度量純正文等價與新增dartdoc修復分開保存，避免混稱所有來源逐byte不變。

新測試初版把既有不同library的同名KlpRadius判成重複來源；由獨立作者修正型別／library辨識，保留禁止複製legacy度量與既有值／身分要求。Module文件更新後的三項契約檢查及所有命令、hash與限制見 [執行紀錄](execution.json)。未執行全庫測試或感官驗收；P9與六個其他切片仍未結案。
