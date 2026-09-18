# METRICS-V1-r1 舊度量唯一來源配對

Execution complete。

METRICS-V1-r1：FND-V1-05 配對 styling，14 個原 library／part 檔整體歸 lib/src/styling/legacy_metrics/，13 個 abstract final metrics 類型與全部 static 常數／list／Duration／字型 package 名稱、順序與型別完全保留。原 foundation/klp_metrics.dart 僅留單一相容 export 指向新唯一 library，13 個舊 part 刪除。此 export 是原切片明定 P9 前相容入口，非第二實作；根 Stable kallopis_foundation.dart 保持原 export，所有公開 barrel 可達性／型別身分不變。兩個 styling legacy_theme source 改用新下層權威；完整 styling 不得再 import/export/part 到 foundation，包含條件／相對／named part／barrel 旁路，不禁止正常同模組 private helper。part 與 part-of 仍在同 library/module。沒有第二 theme／environment／l10n 或新增 consumer API；只移動權責不重設預設值。

[精確路徑](path-map.json)。Styling source creation／theme imports 與 foundation compatibility／old parts retirement 各自 module Task Packet、乾淨 base_revision、scope checker。Architecture Steward 改共通規格與本文件；獨立 Test Author 寫唯一新測試，BUILD 不改測試／fixtures。

M1：styling 唯一 library 完整搬移；M2：foundation 相容 export 與舊 part 清除，兩 module scope、正文等價；M3：全 styling 向下依賴、Stable13類型／值、既有 theme/token 行為驗證、atlas freshness，再回存原樹。

每 module cold-start 1,000–4,000 token／5–25 分鐘，作者 3,000–8,000 token／10–35 分鐘；以 LOWER/PRES 類似工作估計但無逐任務量測，沿用主模型與既有 Windows Flutter/Node/Python。越界或超過 12,000 token／60 分鐘記錄異常。自動接受原契約內可逆實體遷移，公開行為不變。

原 token discipline 先作唯讀既有 check，不預先改 allowlist 或豁免。若有實際位置耦合失敗，再交 Test Author 以新明確唯一入口等價處理，不能放寬閾值。未完成其他 v1 切片與 P9。

## 已重現文件閘門修復

METRICS-DOC-r1 修復：原工作樹與本批皆重現 token_discipline 未文件化型別 95 > 45。保留原 baseline 45 與其他全部斷言不動；補 50 個既有 provider 與 workspace／prepared／asset 契約型別的繁體中文 dartdoc（25 capabilities、25 features）。每項說明真實用途及不擁有的責任；prepared 仍為套件內部呈現值，不誤宣稱 consumer API。只插入 declaration 前的 /// 行，移除新增行後逐 byte 還原原 source。禁止改 modifier、member、constructor、export、值或分支。本批 degree migration 的純正文等價證據須與這項單獨 comments-only 修復分列；不藉此完成 CAP-V1-03 或 FEAT-V1-07。原 token 閘門及局部分析驗證即可，不新增或修改測試。

精確型別清冊與原 Red 保存於外置 metrics/doc-recovery-targets.json、token-original-baseline.log。兩個 module 各需 clean-base scope packet；列於 path-map recovery_writes。

[驗證](verification.md) 與 [執行證據](execution.json) 保存本批結果與已重現修復。
