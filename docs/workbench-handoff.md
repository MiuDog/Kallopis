# Workbench 當前交接

2026-10-12，持續 goal ACTIVE。完整需求以 docs/architecture/workbench-stage-v1.md 及 spec/workbench-v1.md、spec/style-pack-v1.md、spec/interactive-docs-v1.md 為準。Flutter／React 同步交付、所有公開元件頁面互動、VS Code／Blockbench／Blender 各框架 GUI、可替換風格、docs與最終GitHub push均已授權，不重問。

## 現況與已驗證範圍

- Common STYLE-PACK-1／2完成：269原料、350四模式語意、118原文配方；catalog／四模式解析／原子覆寫，114checks、migration--check及scope通過。正式Markdown暫仍為值權威，JSON是逐項驗證遷移資料，尚未切換權威。
- REACT-STYLE-1完成2243c4a7：public pack／350catalog／scopedCSS與hook／ownedruntime；21checks、freshness、build、tarballconsumer通過；browser替換／拒絕／還原／dark／375px／fonts驗證。
- FLUTTER-STYLE-1完成17119f2b：public parser／四模式 resolver／原子覆寫／350native欄位及現有ThemeExtensions；19獨立checks＋41既有theme/accent checks、analyze／freshness／scope通過。stylePack與style互斥，pack不套舊透明度處理。
- LINEAR-GEOMETRY完成：React dcc15e4f、Flutter a8124a62；各21checks含極大有限數值、不足minimum、preferred／max／flex守恆，nativeanalyze／librarybuild／scope通過。共通契約docs/architecture/workbench-linear-contract.md。
- FLUTTER-LAYOUT-2完成273a0b4f：bounds／divider／Column alignment／root有效inset／內容槽裁切／naturalfallback與舊resizecallback相容；18獨立Widget checks＋4既有workspacechecks、analyze／scope、Catalog實際渲染通過。測試作者依原callback契約獨立修正自己的斷言，沒有弱化產品要求。
- REACT-LAYOUT-2完成6a2ca282：六個直接layout元件、元素量測／觀察器與有限px槽，9checks含獨立SSR→hydrateRoot（07a25d94）保留原input節點／編輯值，publicconsumerTypeScript／librarybuild／scope通過。
- REACT-LAYOUT-EXAMPLE-1完成920f0022：公開consumer有width/height/end/inset/gap控制；nativebrowser確認480×300 default120/8/336、160寬minimum各68、end留白、gap12、極大9999時零內容／可還原、native輸入保留、自然量測108=70+8+30；dark／375px无水平溢出、fontsloaded、error/warn空。視覺感官human-pending。Vite517KBchunk提示保留，網站bundle按需分割，不調高閾值。
- Docs現有27份來源及Flutter529canonical API／17modules／三surface generate／verify通過，15網站checks此前通過；React使用指南已包含新layout。尚無全部component-specific互動bundle，不能以總覽iframe宣稱完成。

- FLUTTER-DOCK-STATE-1完成69771496：WB-DOCK-STATE-r1公開schemaVersion1 codec／policy／restore diagnostics，7獨立checks、analyze／scope／protectedhash通過。未知version／欄位／identity／active／finite／capability整份拒絕；先驗證後reconcile，missing／available有序、result深層不可變，不動既有Dock model／Widget／storage。docs生成／verify及15網站checks通過，新增3公開API頁及保存契約。

## Git 與工作環境

唯一BUILD隔離checkout：C:/Users/ASUS_TUF/.codex/worktrees/workbench-v1/Kallopis，managed attached、detached commits。Main D:/Projects/Kallopis branch codex/productivity-reference-ecosystem 有先前搬移及未提交變更，index保留。保存基線3b5dda7be00d1be4760c6cc8c4ad38a3e7ed31de不是reviewed release。origin https://github.com/MiuDog/Kallopis.git，push尚未執行。
同步必須先讀main ignored build/workbench-last-sync.json的sourceRevision，逐路徑比較main=baseline或new後才複製，CRLF正規化；reference-api.json比較JSON值，Git maxBuffer100MB。同步前後cached diff byte/hash一致，禁止blindstage／reset。每個BUILD packet在main ignored build/task-packets/，必須newcleanbase；歷史scope證據於各自BUILD閉合commit，不拿後續owner/testauthor修改當worker違規。
本機Flutter D:/flutter/bin，3.44.2/Dart3.12.2；Node24、TS7（consumer直接檔案compile需--ignoreConfig）。
瀏覽器iab2：Reactlayout tab6 http://127.0.0.1:5182/ devsession89615；FlutterCatalog tab5 http://127.0.0.1:5191/ ttysession82480；舊Reactstyle tab4/5180/session51939可能仍在。使用前revalidatehandle，compaction後先cua.rewriteDocumentation。截圖main build/evidence/react-linear-layout.jpg及flutter-linear-layout.jpg，temporarytab標記handoff。

## 受保護測試與下一個動作

Common runtimehash CF5E9848E92BBE5A1A1057BE8B1D00CCA8E8A35A172287C766BEB46D725ECCA4；Reactstyle15EA38EC657834F2169FBC5792C9A05009AC949D6263D95BE38DD2BA8A3CA6A3；Flutterstyle15B43CF1A61888D208B32785716163BEFD4B101D8ED02FB3ABF7D985C4527129。
Flutterlinear26F406F0C231B0362C2C73760740117771B097C25043DCB8FE484A7D647A653F；ReactlinearAAE3EEF26F5530F4D5002BEA3698FF9F42B13722C547746021C58C9138145803。
Flutterwidget893CB1ABE6FE24C2F6CA54EA72769CC23EE91CD0C68B0909117DDAE5D63BBB75（flutter/test/workbench_layout_test.dart）；ReactwidgetD3547FAC11B6638E1F74C09E2E981ACFBEF610343136498D6656602BF8AC7495（react/test/workbench-layout.test.mjs）。獨立TestAuthor擁有上述檔，BUILD不得改測試。
Fluttercodec受保護tests flutter/test/dock_layout_codec_test.dart：129D62D2C11882215D2FB652A3DA99CCF64FBCBD547845270D7CACD0FDE9781C；author基線35332e86，BUILD scope在69771496閉合。手寫跨語言wire在該test首段；React下一個TestAuthor應採同樣wire成功／拒絕樣本，不用各端encode自我roundtrip代替格式驗證。
下一步PLAN React Dock state codec native types／公開wire API，接入WB-DOCK-STATE-r1；其後固定雙框架Dock UI有限style幾何／close／pinned／dirty／拖放分割縮放分頁契約，必要獨立tests先固定再BUILD。既有FlutterDock有UI但未補全部風格尺寸保護，codec不代表全部WB04～08完成。一般layout已完成不重做。
其後命令／快捷鍵註冊、chord／scope／衝突／重綁、所有specimen、VSCode/Blockbench/Blender各双框架GUI、typedrecipe／全部元件風格對齊、網站展示registry/bundle/coverage、權威切換／CI／精確提交push仍未完成。完整goal保持ACTIVE。
