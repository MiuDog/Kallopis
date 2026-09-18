# REND-HOST-V1-r1 渲染器宿主工作階段

REND-V1-05 complete。見 [驗證](verification.md) 與 [執行證據](execution.json)。

REND-HOST-V1-r1 接受 REND-V1-05 的兩個實作里程碑。R1：features 純 Dart typed failure 經既有 viewport sink 由 application 安裝，原始 error/stack 與 origin/phase 送既有 recovery；renderer local input/binding 以捕捉身分且冪等的 detach 在所有 interrupt 結果後 finally 釋放。R2：兩 WebView 使用 controller identity key 與固定 attachment，依上游既有 bind 排他規則只解除自己成功取得的 sender；每個 await 後檢驗存活。BlockNote 開啟成功立即標記，後續 flush/callback 失敗不得重播初始文件；Canva 去重且不新增自動重試或 UI。環境 late result/dispose 只有一次清理及回報。借用的 provider/controller 不 close/save，不新增正文、theme、environment、l10n 或全域 registry 權威。細部已接受 API、失敗歸屬與驗收由同版 path-map 決策定義。R1 只代表部分完成，R1/R2 與整合證據全部通過才完成 REND-V1-05。

[完整決策與精確路徑](path-map.json)、[獨立測試責任](test-packets.json)。

每個 BUILD packet 必須含乾淨 base_revision、真實 architecture SHA、單一 module 的精確 write paths 與 scope checker。R1 features 定义 → rendering/application 接線；R2 可在同版 typed contract 後獨立實作，最後一起整合。兩個 Test Author 分別擁有 R1 與 R2 paths，R1 另驗收跨模組／public 邊界。

冷啟動估計：R1 features/application 各1k–4k tokens、5–25min；R1 rendering 7k–13k、40–90min；R2 rendering 10k–18k、70–140min；作者各7k–16k、25–90min。假設同主模型、本地Flutter及plugin test factory可用；超過24k或180min回報可觀察阻礙。不得為時間或token調低驗收。

人工原生 Windows WebView、視覺與互動驗收未執行，獨立平台 fake 測試只能證明確定性生命週期。公開 library、content constructor、原文字 session/batch 與 upstream source 唯讀；不改實際 controller 的正文／undo／保存權威。
