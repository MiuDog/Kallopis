# AI 產品開發閱讀路徑

1. 選擇 [Flutter](../reference/flutter/quickstart.md) 或 [React](../reference/react/quickstart.md) 接入。
2. 以 [Reference 機器索引](../reference/manifest.json) 找到能力，讀對應單頁與必要關聯型別。
3. 組合畫面時參考 [範例](../examples/README.md)，確認其審閱狀態；草稿不可當作已接受的視覺規範。
4. 需要調整共用視覺時讀 [正式 token 規範](../design-tokens/KALLOPIS-DESIGN-MAP.md)。

人與 AI 使用同一份 Reference，不維護另一套 AI API 文件。產品擁有業務資料、畫面與流程；本庫擁有共用元件內部視覺及互動。只從各平台公開入口 import，不引用 private 實作，不建立第二份 theme。

跨元件操作流程：[Flutter](product-usage.md)、[React](react-usage.md)。擴充新風格與精選展示元件流程：[風格設計師 Agent 工作流程](style-designer-workflow.md)。要修改本庫時，再讀對應 module 的 architecture；驗證及交接紀錄不等於目前 API 契約。
