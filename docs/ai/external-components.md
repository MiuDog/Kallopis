# 元件能力與庫內擴充

Kallopis 宣告式架構採封閉的庫擁有元件目錄。Consumer 只能從 `package:kallopis/kallopis_declarative.dart` 選用已公開的元件、受限插槽、資料與語意事件；不能定義或註冊新的 component type。

## Consumer 可組裝的內容

- 建立 `KlpApplication`、`KlpRouter`、`KlpScreen` 與已公開的 feature node。
- 將業務資料轉成元件建構子接受的不可變資料。
- 在命名插槽內放入符合資格的已公開元件。
- 傳入 `KlpAction` 或語意 callback，收到結果後更新 application 資料來源。
- 以完整 `KlpPrimitiveSet` 替換整套 primitive 值。

Consumer 不可提供 `KlpComponentDefinition`、`KlpDefinition`、`KlpRegistry`、template、semantic schema／key／reference、action handler、rail item、adapter、compiler、renderer、Widget、`BuildContext`、painter、局部 style 或任意平台 session。Dart 可以直接 import `lib/src` 並不代表該路徑是受支援 API；完整層級見[宣告式公開面清冊](../architecture/declarative-public-surface.md)。

## 現有元件不足時

先記錄下列內容，交由 Kallopis 模組擁有者新增庫內能力：

1. 元件的產品無關語意與使用場景。
2. 輸入資料、輸出事件與狀態權威。
3. 每個 child 插槽的名稱、資格與 cardinality。
4. 需要的 semantic style、無障礙與鍵盤契約。
5. 跨平台差異、錯誤行為與資源生命週期。

庫內新增元件必須同時具備唯一 definition identity、公開 node/data/event 決策、庫擁有 adapter、完整 renderer 分支與確定性契約證據。只新增 consumer definition 或 Flutter Widget 不構成可用能力。

## 遷移狀態

舊版實驗 API 曾允許 `KlpApplication.components` 與 consumer `KlpComponentDefinition`。該設計已由 [KLP-0019](../../spec/decisions/KLP-0019-declarative-framework-migration.md) 的新版契約取代；公開匯出、Application 輸入與 consumer 範例已退役舊式用法，runtime 的相容 compiler seam 已由 `RUN-V1-03` 與 `FND-V1-02` 配對退役，見[封閉目錄驗證](../architecture/closed-catalog-plan/verification.md)。不要新增或複製舊式用法。
