# AD-V1-r1 驗證

完成 COMP-V1-03/04、RUN-V1-04、CAP-V1-04、FND-V1-06。application 只同步來源；APP-V1-05/06 尚有其他待辦。全目標目前30/50個切片標complete，仍須完成其餘切片與逐項完成稽核，任務保持active。

- 兩個 adaptive 實作移至 runtime；composition 保留節點、策略、擷取且不再匯入 runtime/foundation。
- 三個純 enum 由 capabilities/environment 擁有；foundation 舊路徑只轉匯出相同型別，完整 enum 次序、值與身分保留。
- 原有 public barrels、28個目錄身分、adapter順序、策略行為與host來源未改。
- 五個獨立 module 包均通過實際基線scope檢查；沒有越界修改產品或測試。

## 實測

| 群組 | 結果 |
| --- | --- |
| adaptive、catalog、runtime、scope、root URI、runtime boundary | 28 passed，exit0 |
| 獨立 composition boundary／enum type與identity | 5 passed，exit0 |
| frontend／module architecture | 158 passed，exit0 |

在 D:/Projects/Kallopis-v1-integration 使用 D:/flutter/bin/flutter.bat，全部 --no-pub --reporter expanded。精確檔案：

```powershell
& 'D:/flutter/bin/flutter.bat' test test/klp_adaptive_declarative_test.dart test/klp_application_catalog_contract_test.dart test/klp_tree_runtime_test.dart test/klp_scope_activation_test.dart test/lib_import_root_contract_test.dart test/klp_runtime_contract_paths_test.dart --no-pub --reporter expanded
& 'D:/flutter/bin/flutter.bat' test test/klp_adaptive_module_boundary_test.dart test/klp_environment_alias_contract_test.dart --no-pub --reporter expanded
& 'D:/flutter/bin/flutter.bat' test test/frontend_architecture_boundary_test.dart test/module_architecture_contract_test.dart --no-pub --reporter expanded
```

獨立作者先在PLAN基線得到實際10條違規邊的assertion Red，控制測試正常；enum新來源尚未存在時明示integration-pending，不假裝compile錯誤為Red。兩個新增測試以作者SHA256整合，既有測試未改。完整收據與保護hash見 [execution.json](execution.json)。

原工作樹逐檔基線核對後才回寫；保留原HEAD/index與其他變更。未重建歷史生成式圖集，未跑全庫測試或感官／引擎保存驗收；下一組為styling語意驗證介面，完整狀態見 [全切片追蹤](../module-completion.md)。
