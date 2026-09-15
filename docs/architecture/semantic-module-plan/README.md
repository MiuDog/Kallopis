# SEM-V1-r1 語意驗證／解析契約

Execution complete；已完成 STYLE-V1-03／COMP-V1-05／RUN-V1-05，features 只配對直接呼叫。精確路徑見 path-map.json。

採用：兩個現有 resolver／immutable resolution 型別實體搬至 resolution 根層，仍為套件內 API；新增 `void validateKlpSemanticGraph(Iterable<KlpSemanticSchema> schemas)` 具名驗證入口，只委派既有 resolver constructor，不求值、不建立第二解析規則。composition registry 改呼叫此窄驗證函式；runtime 以具名 resolver 解析；其餘3個features呼叫與5個既有測試只改URI。

否決將所有呼叫者直接指向private實作或只新增export barrel掩蓋舊路徑。具名驗證操作分離composition需求與求值能力；錯誤代碼、循環/owner/型別驗證、schema/token順序、結果不可變性均保留。不變更public barrels、primitive/schema/semantic身份、theme或default。

各BUILD包只寫自己module；測試由獨立作者擁有。新guard先在舊基線觀察實際跨模組internal解析器依賴取得assertion Red，不能用缺新URI的compile error。新驗證函式用原既有合法/缺owner/循環schema測確定性錯誤；保留所有舊測試斷言。整合後語意、元件綁定/children/rail/frame/shadow及真實catalog/runtime檢查通過，每module真實scope PASS。

cold-start各包1k–4ktoken、5–25分鐘，測試2k–6ktoken/10–40分鐘；沿用主模型與D:/flutter/bin/flutter.bat。M1有限遷移、M2等價/scope與整合測試，超過1.5倍或越界即回報。外置簽署包在D:/Projects/Kallopis-v1-evidence/semantic；沒有token實測不造數。

[結案驗證](verification.md) 與 [實際執行紀錄](execution.json) 保存證據；全目標仍進行中。
