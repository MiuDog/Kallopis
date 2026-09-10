## 分析入口

`routing/` 的單一檔案定義 KlpRoute、KlpRouter、scope 與 outlet。Router 維護路由 id 表與歷史，透過 ChangeNotifier 通知子樹；Outlet 直接呼叫目前 route 的 builder。此處不是 Flutter Navigator 的轉場配置，也沒有內建產品目的地。

| 想查的問題 | 符號與來源 |
| --- | --- |
| 目的地包含什麼？ | KlpRoute — `lib/src/features/navigation/legacy_router/klp_router.dart:8` |
| go／返回／重置如何更新？ | KlpRouter.go／goBack／reset — `lib/src/features/navigation/legacy_router/klp_router.dart:111`、`lib/src/features/navigation/legacy_router/klp_router.dart:119`、`lib/src/features/navigation/legacy_router/klp_router.dart:127` |
| 子樹如何取得 router？ | KlpRouterScope.of — `lib/src/features/navigation/legacy_router/klp_router.dart:161` |
| 實際頁面如何建構？ | KlpRouterOutlet.build — `lib/src/features/navigation/legacy_router/klp_router.dart:185` |

重要關係：

- `KlpRouter.go` → history 更新與 `notifyListeners`：未知 id 拋錯，同一 id 不重複入列（`lib/src/features/navigation/legacy_router/klp_router.dart:111`）。
- `KlpRouterScope` → `InheritedNotifier<KlpRouter>`：以 notifier 將變更提供給相依子樹（`lib/src/features/navigation/legacy_router/klp_router.dart:154`）。
- `KlpRouterOutlet.build` → `router.current.builder(context)`：直接呼叫目的地 builder（`lib/src/features/navigation/legacy_router/klp_router.dart:186`）。

此目錄無巢狀子目錄；import 圖只有型別依賴，不能代替 go → 通知 → 重建的行為閱讀。
