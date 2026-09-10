# KLP-0019：Kallopis 宣告式功能框架遷移

命名決策：保留 Kallopis 品牌、kallopis package 與既有資料夾／GitHub 名稱，宣告式 API 統一為 Klp 前綴，入口為 kallopis_declarative.dart。

## 狀態

Implementing（2026-09-09）。使用者已核准方向並要求開始；尚未完成全部實作，不能標記 Accepted。

## 決策與適用邊界

新 Klp API 以唯一結構樹組裝，容器限定插槽介面；同一元件可具多資格。消費端不建立 Widget、不提供 BuildContext／renderer callback。註冊定義固定於應用根，功能注入後由本庫建立預設資源。

Primitive schema 由本庫固定，消費端只能整套替換值；自訂元件以可檢查 semantic 參照補充用途，本庫控制解析與呈現所有權。Features 可包含筆記、畫布及節點編排，產品可借用公開部件。這取代 KLP-0001 的至少兩產品與 primitive 不可替換規則，以及 KLP-0003 對新功能層的筆記 UI 禁令。

舊視覺 API 保留目前行為直到對應遷移完成；舊入口與 kallopis_declarative.dart 不互相匯出。來源隔離以 library 可達性判定，不依相同的 Klp 前綴。既有風格與 golden 不是本次新設計；資料 transaction、undo、persistence 仍保留原權威。P8 收斂識別字與入口，不更改 package；名稱收斂不代表架構遷移完成。

## 推導依據與否決方案

使用者已確認 [架構與遷移計畫](../../docs/architecture/restructure-migration-plan.md)。否決：直接搬 869 檔再逐步修正、任意 Widget 轉接、以全域可變 registry 安裝，以及永久保留兩套同義組裝入口。

## 首批範圍與代價

先交付 P0 完整工作備份、P1 契約界線、P2 結構及註冊驗證、P3 的純資料生命週期基礎。首批不宣稱提供新畫面、完整風格 schema、平台矩陣或 Flutter renderer。型別與原料模型需經完整流程驗證後再穩定。

## 閘門

新模型純 Dart；註冊衝突／依賴循環／重複放置／型別不符須拒絕。狀態只准一個寫入權威，controller 不代為釋放借用來源。安装先完整驗證再建立資源，取消訂閱與 dispose 有測試。舊 frontend boundary 持續執行；新契約另以正負案例驗證，不擴大 allowlist。

## 已知欠債與移除條件

舊公開入口仍能輸入 Widget／覆寫風格，僅限舊路徑，不得透過新入口繞回。P9 移除舊路徑後才能宣稱消費端全數受控。既有 Verify 基線失敗另見查核紀錄；不因新測試通過宣稱全庫通過。
