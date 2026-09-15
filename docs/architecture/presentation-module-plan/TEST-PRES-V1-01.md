# TEST-PRES-V1-01 — independent Test Author

工作樹 D:/Projects/Klp-pres-test；基線由外置 plan-base.txt 固定。只讀 AGENTS.md、test-driven-development skill、此包、path-map、相關 module 契約、既有測試和表達來源邊界／公開契約所需的 Dart directives/型別宣告。不讀 BUILD worker 推理，不改產品或整合工作樹。

write_paths 僅 path-map.json 的 test_paths（16 檔）。13 個既有檔只更新搬移 URI 與加入各自需要的 presentation import，可移除因此未使用的 import；所有測試名稱、斷言、fixture、測試本文保持原文。不得改其他既有測試或設定。

新增三檔：
- klp_prepared_module_boundary_test.dart：掃描完整 foundation 的 import/export/part（含相對／條件 URI 正規化）不得指向 features/runtime/application/rendering 或 Krepis/BlockNote/Canva；synthetic guard 控制；所有 35 搬移檔唯一宣告歸屬、無舊 shim／跨 module part；consumer 所有 public barrels 不可達 prepared libraries。先在舊基線取得真正斷言 Red，缺少新 URI 不當 Red。
- klp_prepared_renderer_contract_test.dart：獨立列舉基線 26 concrete KlpBoundTemplate 變體（10 generic、6 editing、10 workspace）並核對 source declaration／renderer 分支完整性與明確非視覺變體。新基線 unknown abstract protocol 實作的 widget 實際 build 要拋 KlpContractError code unsupported_prepared_template，不能靜默空白。可利用既有目錄測試驗證真實 28 ID，不得只以新自造 registry 宣稱完整。
- klp_foundation_stable_toolbar_contract_test.dart：從 kallopis_foundation.dart 與 kallopis.dart 可達的 KlpSelectionToolbar／KlpSelectionAction 身分／constructor／既有 button callback 與語意控制保留；禁止公開 KlpButtonStyle 或任一 prepared 協定／紀錄。只測確定性行為與可達性，不作視覺評分。

新 URI／非 sealed 協定在舊基線不存在的 compile cases 留 integration-pending；先交付可在舊基線跑的邊界 Red，再凍結16檔與 SHA256。主整合者只複製 exact bytes 執行 Green，任何修正回到作者。

M1 邊界 Red 與必要 schema 確認；M2 保留既有本文、新測試及精確 scope／hash／命令簽署。冷啟動 4k–10k token，20–60 分鐘；超過1.5倍或越界回報 evidence；無實測 token 寫 unknown。不得 stage／commit。日誌與最終 test-author-final.json 位於 D:/Projects/Kallopis-v1-evidence/presentation。
