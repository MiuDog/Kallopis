# TEST-SEM-V1-01

全新context Test Author，讀AGENTS、test-driven-development skill、SEM-V1-r1 README/path-map與共通契約。只寫path-map.test_paths：5個既有檔僅改指定URI且保留全部assertions/fixtures；新增2檔負責source boundary及具名驗證函式error契約。可讀既有test/klp_semantic_contract_test.dart、runtime module boundary test慣例與schema/token公開套件內介面；lib Dart directives與public export graph是觀察本crossmodule邊界所必需。必要SDK/build config與既有依賴唯讀。不得讀worker推理，產品/architecture/settings及其他tests禁止修改。

M1先寫不依賴新URI的boundary guard，在舊基線assertion Red證明其他module不應import/export styling/resolution/internal；public consumer不能轉匯出resolution entries（可檢查transitive exports，不誤把僅implementation import當公開）。M2新graph function `void validateKlpSemanticGraph(Iterable<KlpSemanticSchema> schemas)` 以既有合法graph、缺semantic owner或循環graph保護其驗證委派（使用既有schema/test fixture慣例，勿鏡像算法）；新URI不存在時只integration-pending。5個既有tests的URI遷移禁止改assertions/測試名稱。tab繁中註解。

發布D:/Projects/Kallopis-v1-evidence/semantic/test-author-final.json含精確changed_paths、SHA256、Red/Green commands與驗證結果。不要提交/改integration/在integration跑Flutter；主agent依hash复制並跑Green。cold-start2k–6ktoken/10–40分鐘，超過1.5倍或必要越界回報。沒有provider usage明示unknown。
