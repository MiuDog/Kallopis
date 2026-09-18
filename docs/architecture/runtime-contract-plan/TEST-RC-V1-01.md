# TEST-RC-V1-01 — 獨立測試任務包

角色：全新上下文的獨立 Test Author。契約 RC-V1-r1 READY。只寫 path-map.json 的 test_paths（21 個現有測試／fixture 與一個新 klp_runtime_contract_paths_test.dart），產品、架構、規格、設定均不可寫。

最小讀取：AGENTS.md、test-driven-development skill、personal-code-style、spec/module-architecture-v1.md 的 RC-V1-r1、runtime/features/application/composition architecture 的配對契約、本目錄 README/path-map、列出的 test_paths；既有 test/frontend_architecture_boundary_test.dart、test/lib_import_root_contract_test.dart、test/klp_closed_component_catalog_contract_test.dart、test/klp_application_router_session_test.dart、test/klp_application_review_test.dart 為唯讀檢查與慣例。可讀 lib 各 Dart 的 import/export/part directives 及所有 public library 達性、runtime 新舊目標存在性，原因是本風險為跨模組相依及公開邊界，不能只靠型別編譯保護。不得閱讀 implementation worker 推理。必要測試執行可讀 Flutter SDK 與既有 .dart_tool/package_config、pubspec/lock、analysis_options。

把既有 test_paths 的舊 runtime URI 依 path-map 換成新 URI，包含 verify_declarative_consumer 的禁止路徑 fixture；保留所有斷言、案例、fixture 行為，不弱化、不跳過、不增加例外。所有改動程式碼使用 tab 顯示寬度2、繁中註解；未碰的函式 body 不為 import 變更而重構。

新增最小 deterministic contract：lib 跨 module 不直接 import/export runtime internal，consumer public libraries 不可達 runtime contracts/entries；保護條件應能抓到有效編譯但違反邊界的 URI。可用暫存 fixture／純文字 directive 抽取驗證 guard 的負向分支，不需要發明產品 fixture 或測試實作演算法。新檢查先在派工基線執行，舊上層 internal import 應造成有效 assertion Red；禁止以缺新路徑造成 compile failure 充當 Red。新增檢查本身避免依賴尚不存在的新 Dart import。

交付：test diff／逐檔 SHA-256、精確 commands、Red 證據與現有測試完整案例保留證據。新路徑尚未提供時既有測試編譯失配記 integration-pending；先完成 test 保護，再由整合者複製精確 bytes，對實際整合來源執行同一檢查取 Green。不得自行提交或改整合 worktree；可由主 agent 執行 Green。最終變更路徑必須為 test_paths 子集，並核對 Git 差異與 hash。

估算 cold-start：4,000–10,000 token，15–60 分鐘；沿用父模型，Windows/PowerShell、D:/flutter/bin/flutter.bat。M1 發布邊界 assertion Red；M2 路徑遷移與 protected hashes。超過90分鐘或必要越界時回報有證據的 blocker。不做全庫測試、感官或 golden 評分；token 若工具未提供明示無法量測。
