# TEST-AD-V1-01

獨立 Test Author；僅寫 test/klp_adaptive_module_boundary_test.dart、test/klp_environment_alias_contract_test.dart。讀 AGENTS、test-driven-development skill、AD-V1-r1 共通規格與 README/path-map、capabilities/composition/runtime/foundation architecture；既有 test/klp_adaptive_declarative_test.dart、test/klp_application_catalog_contract_test.dart、test/klp_runtime_contract_paths_test.dart 作唯讀慣例與驗收。可讀 composition/capabilities/foundation/runtime Dart directives 及三個既有 enum 宣告，原因是要觀察模組邊界與相容型別身分；不讀 worker 推理，不修改產品/架構/現有tests或settings。

新增最小跨模組 assertion：composition 不 import/export runtime/foundation；先在基線重現有效 Red，不能因尚缺新import造成compile錯誤而宣稱Red。獨立另一檔使用新 capabilities 與舊 foundation 前綴匯入，驗證三個 enum 完整values/ordering、同型別可賦值及同一identity；這個檔基線未有新檔時只記integration-pending，保留必需正向control。

既有adaptive命中策略與真實host測試，以及catalog/transaction檢查由主agent在完整整合後執行；不複製其大量fixture。新增測試全部tab縮排、繁中註解。M1 邊界有效Red；M2 精確SHA256/changed_paths/commands/範圍證據，存D:/Projects/Kallopis-v1-evidence/adaptive/test-author-final.json；不得提交或修改integration工作樹。cold-start2k–6ktokens、10–40min，超過1.5倍或越界需要立即回報。工具D:/flutter/bin/flutter.bat，已安裝相依；不要自行在integration執行Flutter。
