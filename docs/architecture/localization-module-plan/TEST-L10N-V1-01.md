# TEST-L10N-V1-01 — independent Test Author

工作樹 D:/Projects/Klp-l10n-test，clean基線見 D:/Projects/Kallopis-v1-evidence/localization/plan-base.txt。讀 AGENTS.md、test-driven-development skill、此包/path-map、四個module契約、受影響測試；只為表達公開契約與來源邊界按需讀 directives/宣告，不讀 BUILD 推理。

write_paths 只 path-map 的6檔（r2）：
- test/l10n_discipline_test.dart：只將 application/localization 唯一來源排除路徑與註解精確換成 foundation/localization，其他斷言/allowlist/空集合不得變。
- test/frontend_architecture_boundary_test.dart：只替換單一既有 l10n 掃描目錄；所有其他斷言、fixture與測試本文完全保留。
- test/klp_localization_module_boundary_test.dart：新AST/等價可靠guard驗完整features/rendering不依賴application，含relative/conditional/import/export/part與public barrel旁路，synthetic負控制；三檔實體唯一foundation所有權，無舊shim、沒有第二l10n/defaultSavedLabel宣告。
- test/klp_localization_contract_test.dart：新defaults/savedLabel/delegate load/shouldReload/isSupported/fallback、同型別Stable/umbrella可達性（新路徑測試可integration-pending）。既有 app consumer override要求不能弱化；不得把只比較新實作自身當基線保護，核對原字串與方法行為。
- test/klp_application_localization_test.dart：新宣告式宿主實際 Localizations.of<KlpLocalizations> 非空，預設值及host重建保持；用既有 host test 的構造方式與可觀察descendant context，不新增consumer Widget API。舊基線應真正觀察缺少scope而Red，不能只測 KlpLocalizations.of fallback。既有 host test 可讀可執行但不可修改；app_contract 依 r2 限定修復。

M1：可在舊基線跑的完整module違規斷言與actualhost Red；缺新URI的compile case明列integration-pending。M2：兩existing精確path-only保留證據、app_contract 四個過期建構參數移除證據，三新測試/guard自驗，凍結6檔SHA256與命令。最終JSON放 D:/Projects/Kallopis-v1-evidence/localization/test-author-final.json。不要stage/commit/改產品或整合；root只copy exact bytes，test修正回作者。

獨立fresh角色，cold-start 3k–7k token／15–45min，無usage寫unknown，超1.5倍有證據回報。只驗deterministic結果，不做感官評分。

## r2 — 已重現的舊測試建構失敗

root 已在 original 舊基線執行 app_contract_test，四個 `showWindowHeader: false,` 參數皆不在現行 KlpApp constructor，與本次URI遷移無關。日誌 `D:/Projects/Kallopis-v1-evidence/localization/legacy-app-baseline-failure.log`。授權獨立作者只從 test/klp_app_contract_test.dart 移除這四行，保留其餘fixture／名稱／所有斷言（含 consumer l10n override）；不得重新引入產品的舊公開參數。先在作者舊產品基線跑修復後四測試，再交exact bytes／hash。r2 其餘5檔範圍與要求不变。

## r3 — 保留零新增字串／圖示上限並修復註解誤判

L10N-V1-r2 修復已重現的舊 discipline 失敗：BlockNote 兩個 renderer 檔的七段原始使用者文案納入既有 KlpLocalizations，七個可選 String constructor 欄位及對應 final 欄位預設完全沿用原文，加入 equality/hashCode 使覆寫可触發delegate reload。這是相容的既有字串契約補齊，接替 r1「不加 public API」在這七個可選欄位的限制；其餘70既有字串、constructor用法、預設畫面、重試與中斷／WebView生命週期不變，不建第二來源。renderer的錯誤Widget只由 KlpLocalizations.of(context) 取字串，不改branch/controller/callback。獨立作者修 discipline scanner 的註解誤判：兩個 metric card 的單引號箭頭範例是註解而非 literal，必須加入synthetic正負控制，只忽略comments、不忽略真字串，保留Chinese零及icon上限15和下限13，不增加豁免。

允許六檔集合不變。l10n_discipline_test.dart 可新增可靠的 comment 排除步驟（保留位置／行號，字串中的comment-like文字不可移除）與 synthetic controls，保留原 developer-message排除語意、所有threshold／無例外要求。現有annotation引用等別因path變更增加豁免。localization_contract_test 新增七個精確原預設、七個override的equality/hashCode/delegate reload，及 KlpBlockNoteLoadError 實際覆寫/retry/interrupted Widget行為；WebView環境失敗文案分支只需 source/directive＋既有預設精確保護，若能最小deterministiccase則補。其他檔保留凍結bytes。r3舊基線仍可取得七中文字串真正Red；comment-only假glyph必須消除而15上限仍可擋16真glyph。新七欄位oldbaseline compile case integration-pending不當Red。先給修復後scanner Red證據，再凍結六檔與新hash（舊manifest改名保留）。
