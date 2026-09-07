## 分析入口

此目錄提供文件、畫布、訊息編輯等無產品語意的高階組合元件。可從 `KlpDocumentField` 與 `KlpCanvasViewport` 追蹤欄位和畫布容器。Requirement／Proposal 等產品工作流程已移至 Notist。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 文件欄位如何接到表單視覺？ | `KlpDocumentField`：lib/src/editor/artifact_workspace/klp_artifact_workspace.dart:67 |
| 畫布容器與選取覆層在哪裡？ | `KlpCanvasViewport`、`KlpCanvasSelectionOverlay`：lib/src/editor/canvas_workspace/klp_canvas_workspace.dart:11、55 |

重要依賴：artifact workspace 只組合 Kallopis form、tabs 與 feedback；這是來源依賴分類，不能畫成提交、保存或 AI 執行鏈。
