# Dock 有限尺寸

`resolveKlpDockGeometry` 接受目前容器的有限 `width`／`height`、保存 `layout`、左右 `minExtent`／可選 `maxExtent`、可選 Bottom 限制，以及語意投影的 `handleExtent`／可選 `headerExtent`。回傳不可變的 Stage、各區、header、handle 矩形與 `maximumLeft`／`maximumRight`／`maximumBottom`；呈現及 pointer 使用相同座標。

空間不足會同比例壓縮 minimum；保存偏好保持原值。正 Infinity maximum 表示無邏輯上限，其他尺寸須有限非負；縮放提交需再把實際 maximum 與產品邏輯 min/max 求交集，不足 minimum 時不回寫縮放。省略 header 與零高 header 槽不同；省略 Bottom 限制只允許 Bottom 隱藏且無群組。非法輸入以 TypeError 拒絕，caller 不修改。這是純尺寸入口，React 可拖放 Dock 元件仍在接續實作。

## API 查表

- [resolveKlpDockGeometry](../../reference/react/utilities/resolve-klp-dock-geometry.md)
