## 分析入口

此目錄提供通用表面、線條、區段與頁面背景；背景入口拆為 widget、recipe、painter 與 editor。`internal/` 的 recipe core／periodic／custom 歸 recipe library，paint operations 歸 painter library；不是獨立服務。若問題是背景如何畫出來，應沿 widget 建構 painter 的實際路徑閱讀。

| 想回答的問題 | 精確符號與來源 |
| --- | --- |
| 一般表面與語意 tone 在哪裡？ | `KlpSurface`、`KlpSurfaceTone`：lib/src/surface/klp_surface.dart:25、9 |
| 背景如何接上 CustomPainter？ | `KlpPageBackground.build`：lib/src/surface/klp_page_background.dart:37；`KlpPageBackgroundPainter`：lib/src/surface/klp_page_background_painter.dart:40 |
| recipe 與 painter 的內部所有權在哪裡？ | part directives：lib/src/surface/klp_page_background_recipe.dart:5；lib/src/surface/klp_page_background_painter.dart:6 |

重要依賴：`klp_page_background.dart:40–44` 建構 `CustomPaint`／`KlpPageBackgroundPainter` 並傳入 recipe 與 viewport；:45–50 將 theme 值組成 `KlpPageBackgroundVisuals`。這是實際畫面組合與值傳遞，與單純 import 關係不同。
