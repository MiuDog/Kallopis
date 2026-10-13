# 公開佈局模板文件

本 module 擁有 docs/templates/ 的消費端入口；本 stage 只有 modern-productivity-layout，依 ../../spec/modern-productivity-layout-v1.md 及 ../architecture/modern-productivity-layout-contract.md r2。PLAN READY。

文件引用共通契約與可執行 starter 來源，提供用途、公開接入、調整參數／semantic 對照、預覽與版本限制。不另定 token、不手寫第二套可執行範例，不把未實作型別寫成現行可用 API。網站 module 只負責登錄與 render，此 module 擁有正文。

MODERN-PRODUCTIVITY-TEMPLATE-DOCS-1：BUILD exact modern-productivity-layout.md，其餘 architecture／規範／元件／example／site／tests 唯讀。前置條件為雙框架 core 與 starter／preview 已完成。M1 更新已觀察接入與版本限制，檢查 public imports／來源連結與參數對照，模板設定片段重套用證據由 preview owner 提供；網站 generate／verify 由 site slice 接續。估 1k–3k tokens／10–20 分鐘，cold-start 參照 DOCS-STAGE-1；4k／30 分鐘或需要新增元件能力回 PLAN。感官 human-pending，不新增文案鏡像測試。
