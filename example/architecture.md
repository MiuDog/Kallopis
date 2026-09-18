# Explorer Catalog

## EXP-V1-r3 箭頭與後代收合

依 EXP-17～19，PLAN／BUILD 已完成，局部驗證通過；EXP-V1-r3 Catalog 外觀與互動已由使用者於 2026-09-15 回覆「同意」接受。分類一律顯示箭頭，可收合空分類可切換；一般節點仍需有子項。兩種箭頭使用 disclosureIconExtent（distance i3，12px），命中及一般圖示保持 20px。KlpExplorerData.expandedIdsAfter(KlpId id, bool expanded, {bool collapseDescendants = false}) 回傳該項所屬樹的不可變完整展開集合，不提交資料；遞迴模式移除所有後代含隱藏後代，其他樹與選取不變。未知項或不可切換項拋 explorer_invalid_expansion。既有 onExpandedChanged(id, bool) 保持。 本 slice 只寫 lib/explorer_catalog.dart、lib/catalog/explorer_preview.dart；增加空分類與遞迴收合切換，回呼使用公開集合計算方法。Catalog 是庫內展示，不是產品設定畫面；EXP-V1-r3 視覺與互動已由使用者接受。

