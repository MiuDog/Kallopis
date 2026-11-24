# 第一部分：Primitive token表格（名稱→實際值）

Primitive只定義值，不決定使用位置。269個primitive名稱；原有KlpScale／KlpPalette名稱全部保留；補充length-*等名稱只是替原實作數值建立文件原料ID，不是新增設計。字型保留Flutter package ownership；其他技術棧註冊對應Noto Sans TC／IBM Plex Mono，再移除packages/kallopis/前綴。fallback清單在後面的semantic表以primitive陣列表示。


## 顏色

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `parchment50` | `#FFF8F6F1` | 現有公開primitive |
| `parchment75` | `#FFF0EDE6` | 現有公開primitive |
| `parchment100` | `#FFEFEDE7` | 現有公開primitive |
| `parchment150` | `#FFE7E4DD` | 現有公開primitive |
| `parchment200` | `#FFE1DDD2` | 現有公開primitive |
| `parchment250` | `#FFD3CFC4` | 現有公開primitive |
| `parchment350` | `#FFBAB5AA` | 現有公開primitive |
| `parchment550` | `#FF6A655B` | 現有公開primitive |
| `parchment700` | `#FF514B40` | 現有公開primitive |
| `parchment750` | `#FF484339` | 現有公開primitive |
| `parchment800` | `#FF35322D` | 現有公開primitive |
| `parchment825` | `#FF33322C` | 現有公開primitive |
| `parchment900` | `#FF292724` | 現有公開primitive |
| `parchment925` | `#FF21201B` | 現有公開primitive |
| `parchment950` | `#FF201F1C` | 現有公開primitive |
| `ink1000` | `#FF000000` | 現有公開primitive |
| `transparent` | `#00000000` | 現有公開primitive |
| `ink50` | `#FFFFFFFF` | 現有公開primitive |
| `ink100` | `#FFF2F0EB` | 現有公開primitive |
| `ink150` | `#FFEAE7E1` | 現有公開primitive |
| `ink200` | `#FFE6E3DC` | 現有公開primitive |
| `ink250` | `#FFBCB8B0` | 現有公開primitive |
| `ink300` | `#FFADA89E` | 現有公開primitive |
| `ink350` | `#FF9E998F` | 現有公開primitive |
| `ink400` | `#FF8E8982` | 現有公開primitive |
| `ink450` | `#FF7F7A75` | 現有公開primitive |
| `ink500` | `#FF6F6C67` | 現有公開primitive |
| `ink550` | `#FF6B6459` | 現有公開primitive |
| `ink600` | `#FF4F5151` | 現有公開primitive |
| `ink650` | `#FF414344` | 現有公開primitive |
| `ink700` | `#FF343637` | 現有公開primitive |
| `ink750` | `#FF303030` | 現有公開primitive |
| `ink800` | `#FF292929` | 現有公開primitive |
| `ink850` | `#FF232323` | 現有公開primitive |
| `ink900` | `#FF1D1D1D` | 現有公開primitive |
| `ink950` | `#FF101010` | 現有公開primitive |
| `warmNeutral25` | `#FFF5F2EC` | 現有公開primitive |
| `warmNeutral50` | `#FFE4E1DA` | 現有公開primitive |
| `warmNeutral100` | `#FFD6D0C6` | 現有公開primitive |
| `warmNeutral200` | `#FFC8C0B4` | 現有公開primitive |
| `warmNeutral300` | `#FFB8B2A4` | 現有公開primitive |
| `warmNeutral400` | `#FF918A7B` | 現有公開primitive |
| `warmNeutral450` | `#FF8C8477` | 現有公開primitive |
| `warmNeutral500` | `#FF7A7566` | 現有公開primitive |
| `warmNeutral600` | `#FF6A6256` | 現有公開primitive |
| `warmNeutral700` | `#FF585249` | 現有公開primitive |
| `warmNeutral750` | `#FF45413A` | 現有公開primitive |
| `warmNeutral800` | `#FF433F3A` | 現有公開primitive |
| `warmNeutral900` | `#FF34302B` | 現有公開primitive |
| `sand50` | `#FFF8F1E2` | 現有公開primitive |
| `sand300` | `#FFF0D79A` | 現有公開primitive |
| `sand500` | `#FFE0BE73` | 現有公開primitive |
| `sand800` | `#FF453D2B` | 現有公開primitive |
| `sand900` | `#FF302B20` | 現有公開primitive |
| `gold50` | `#FFF6EBD7` | 現有公開primitive |
| `gold300` | `#FFE8BD70` | 現有公開primitive |
| `gold500` | `#FFD3A152` | 現有公開primitive |
| `gold800` | `#FF443725` | 現有公開primitive |
| `gold900` | `#FF30271B` | 現有公開primitive |
| `ochre50` | `#FFF3E4CF` | 現有公開primitive |
| `ochre300` | `#FFDFA04E` | 現有公開primitive |
| `ochre500` | `#FFC6823D` | 現有公開primitive |
| `ochre800` | `#FF413222` | 現有公開primitive |
| `ochre900` | `#FF2E241A` | 現有公開primitive |
| `terracotta50` | `#FFEEDDD0` | 現有公開primitive |
| `terracotta300` | `#FFC88745` | 現有公開primitive |
| `terracotta500` | `#FFA96836` | 現有公開primitive |
| `terracotta800` | `#FF3D2D22` | 現有公開primitive |
| `terracotta900` | `#FF2C211B` | 現有公開primitive |
| `clay50` | `#FFE9D8D1` | 現有公開primitive |
| `clay300` | `#FFA86D43` | 現有公開primitive |
| `clay500` | `#FF895137` | 現有公開primitive |
| `clay800` | `#FF382A23` | 現有公開primitive |
| `clay900` | `#FF291F1C` | 現有公開primitive |
| `umber50` | `#FFE4D5D1` | 現有公開primitive |
| `umber300` | `#FF89573E` | 現有公開primitive |
| `umber500` | `#FF683E33` | 現有公開primitive |
| `umber800` | `#FF332724` | 現有公開primitive |
| `umber900` | `#FF261D1C` | 現有公開primitive |
| `green100` | `#FFDFF0E5` | 現有公開primitive |
| `green400` | `#FF67AE86` | 現有公開primitive |
| `green500` | `#FF51B77B` | 現有公開primitive |
| `green600` | `#FF2D8057` | 現有公開primitive |
| `green800` | `#FF243B2D` | 現有公開primitive |
| `green900` | `#FF1D3025` | 現有公開primitive |
| `red100` | `#FFFAE3E2` | 現有公開primitive |
| `red300` | `#FFFA6C73` | 現有公開primitive |
| `red400` | `#FFD27B74` | 現有公開primitive |
| `red600` | `#FFA7443F` | 現有公開primitive |
| `red800` | `#FF472925` | 現有公開primitive |
| `red900` | `#FF3B2320` | 現有公開primitive |
| `amber500` | `#FFF6B52E` | 現有公開primitive |
| `blue500` | `#FF5499DF` | 現有公開primitive |
| `scrim` | `#99010202` | 現有公開primitive |
| `line` | `#00000000` | 現有公開primitive |
| `transparentSurface` | `#9426292D` | 現有公開primitive |
| `transparentSurfaceInset` | `#A8404449` | 現有公開primitive |
| `pureWhite` | `#FFFFFFFF` | 現有公開primitive |
| `pureBlack` | `#FF000000` | 現有公開primitive |
| `accent-ink-light` | `#FF1D1D1D` | 現有accent配對原料 |
| `accent-ink-dark` | `#FFFFFFFF` | 現有accent配對原料 |
| `accent-terracotta-light` | `#FF92563C` | 現有accent配對原料 |
| `accent-terracotta-dark` | `#FFCB8E72` | 現有accent配對原料 |
| `accent-ochre-light` | `#FF7D612F` | 現有accent配對原料 |
| `accent-ochre-dark` | `#FFB99860` | 現有accent配對原料 |
| `accent-olive-light` | `#FF5E6A39` | 現有accent配對原料 |
| `accent-olive-dark` | `#FF94A366` | 現有accent配對原料 |
| `accent-slate-light` | `#FF4E678A` | 現有accent配對原料 |
| `accent-slate-dark` | `#FF879EBD` | 現有accent配對原料 |
| `accent-crimson-light` | `#FF9F4B59` | 現有accent配對原料 |
| `accent-crimson-dark` | `#FFCE8A95` | 現有accent配對原料 |
| `color-b8292724` | `#B8292724` | 原實作值的文件名稱；未新增設計 |
| `color-b835322d` | `#B835322D` | 原實作值的文件名稱；未新增設計 |

## 間距、尺寸、圓角、線寬與字距

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `space0` | `0` | 現有公開primitive |
| `space50` | `2` | 現有公開primitive |
| `space100` | `4` | 現有公開primitive |
| `space200` | `8` | 現有公開primitive |
| `space250` | `10` | 現有公開primitive |
| `space300` | `12` | 現有公開primitive |
| `space400` | `16` | 現有公開primitive |
| `space600` | `24` | 現有公開primitive |
| `space800` | `32` | 現有公開primitive |
| `space1000` | `40` | 現有公開primitive |
| `space1200` | `48` | 現有公開primitive |
| `space1600` | `64` | 現有公開primitive |
| `space2400` | `96` | 現有公開primitive |
| `radius0` | `0` | 現有公開primitive |
| `radius50` | `2` | 現有公開primitive |
| `radius100` | `4` | 現有公開primitive |
| `radius150` | `6` | 現有公開primitive |
| `radius200` | `8` | 現有公開primitive |
| `radius250` | `10` | 現有公開primitive |
| `radius300` | `12` | 現有公開primitive |
| `radius400` | `16` | 現有公開primitive |
| `radiusFull` | `9999` | 現有公開primitive |
| `stroke0` | `0` | 現有公開primitive |
| `stroke100` | `1` | 現有公開primitive |
| `stroke200` | `2` | 現有公開primitive |
| `font100` | `10` | 現有公開primitive |
| `font200` | `12` | 現有公開primitive |
| `font300` | `14` | 現有公開primitive |
| `font400` | `16` | 現有公開primitive |
| `font500` | `18` | 現有公開primitive |
| `font600` | `22` | 現有公開primitive |
| `font700` | `28` | 現有公開primitive |
| `font800` | `36` | 現有公開primitive |
| `font900` | `48` | 現有公開primitive |
| `font1000` | `64` | 現有公開primitive |
| `tracking0` | `0` | 現有公開primitive |
| `trackingTight` | `-0.5` | 現有公開primitive |
| `trackingWide` | `1.2` | 現有公開primitive |
| `trackingWider` | `1.32` | 現有公開primitive |
| `length-30` | `30` | 原實作值的文件名稱；未新增設計 |
| `length-56` | `56` | 原實作值的文件名稱；未新增設計 |
| `length-20` | `20` | 原實作值的文件名稱；未新增設計 |
| `length-60` | `60` | 原實作值的文件名稱；未新增設計 |
| `length-74` | `74` | 原實作值的文件名稱；未新增設計 |
| `length-170` | `170` | 原實作值的文件名稱；未新增設計 |
| `length-11` | `11` | 原實作值的文件名稱；未新增設計 |
| `length-3` | `3` | 原實作值的文件名稱；未新增設計 |
| `length-5` | `5` | 原實作值的文件名稱；未新增設計 |
| `length-7` | `7` | 原實作值的文件名稱；未新增設計 |
| `length-3_5` | `3.5` | 原實作值的文件名稱；未新增設計 |
| `length-41_4` | `41.4` | 原實作值的文件名稱；未新增設計 |
| `length-168` | `168` | 原實作值的文件名稱；未新增設計 |
| `length-26` | `26` | 原實作值的文件名稱；未新增設計 |
| `length-520` | `520` | 原實作值的文件名稱；未新增設計 |
| `length-320` | `320` | 原實作值的文件名稱；未新增設計 |
| `length-120` | `120` | 原實作值的文件名稱；未新增設計 |
| `length-9` | `9` | 原實作值的文件名稱；未新增設計 |
| `length-220` | `220` | 原實作值的文件名稱；未新增設計 |
| `length-192` | `192` | 原實作值的文件名稱；未新增設計 |
| `length-128` | `128` | 原實作值的文件名稱；未新增設計 |
| `length-112` | `112` | 原實作值的文件名稱；未新增設計 |
| `length-10_5` | `10.5` | 原實作值的文件名稱；未新增設計 |
| `length-336` | `336` | 原實作值的文件名稱；未新增設計 |
| `length-300` | `300` | 原實作值的文件名稱；未新增設計 |
| `length-350` | `350` | 原實作值的文件名稱；未新增設計 |
| `length-400` | `400` | 原實作值的文件名稱；未新增設計 |
| `length-800` | `800` | 原實作值的文件名稱；未新增設計 |
| `length-960` | `960` | 原實作值的文件名稱；未新增設計 |
| `length-1120` | `1120` | 原實作值的文件名稱；未新增設計 |
| `length-200` | `200` | 原實作值的文件名稱；未新增設計 |
| `length-360` | `360` | 原實作值的文件名稱；未新增設計 |
| `length-480` | `480` | 原實作值的文件名稱；未新增設計 |
| `length-1380` | `1380` | 原實作值的文件名稱；未新增設計 |
| `length-880` | `880` | 原實作值的文件名稱；未新增設計 |
| `length-260` | `260` | 原實作值的文件名稱；未新增設計 |
| `length-820` | `820` | 原實作值的文件名稱；未新增設計 |
| `length-minus-1` | `-1` | 原實作值的文件名稱；未新增設計 |

## 行高與倍率

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `leading100` | `1.125` | 現有公開primitive |
| `leading116` | `1.166` | 現有公開primitive |
| `leading120` | `1.2` | 現有公開primitive |
| `leading122` | `1.222` | 現有公開primitive |
| `leading127` | `1.272` | 現有公開primitive |
| `leading128` | `1.285` | 現有公開primitive |
| `leading133` | `1.333` | 現有公開primitive |
| `leading142` | `1.428` | 現有公開primitive |
| `leading150` | `1.5` | 現有公開primitive |
| `leading155` | `1.555` | 現有公開primitive |
| `leading150Legacy` | `1.2` | 現有公開primitive |
| `leading200` | `1.25` | 現有公開primitive |
| `leading300` | `1.3` | 現有公開primitive |
| `leading350` | `1.35` | 現有公開primitive |
| `leading400` | `1.4` | 現有公開primitive |
| `leading450` | `1.45` | 現有公開primitive |
| `leading500` | `1.5` | 現有公開primitive |
| `leading550` | `1.55` | 現有公開primitive |
| `leading650` | `1.65` | 現有公開primitive |
| `ratio-0_4` | `0.4` | 原實作值的文件名稱；未新增設計 |
| `ratio-0_35` | `0.35` | 原實作值的文件名稱；未新增設計 |
| `ratio-0_32` | `0.32` | 原實作值的文件名稱；未新增設計 |
| `ratio-0_22` | `0.22` | 原實作值的文件名稱；未新增設計 |
| `ratio-0_06` | `0.06` | 原實作值的文件名稱；未新增設計 |
| `ratio-8` | `8` | 原實作值的文件名稱；未新增設計 |
| `ratio-2` | `2` | 原實作值的文件名稱；未新增設計 |
| `ratio-3` | `3` | 原實作值的文件名稱；未新增設計 |
| `ratio-6` | `6` | 原實作值的文件名稱；未新增設計 |

## 字重

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `weight400` | `400` | 現有公開primitive |
| `weight500` | `500` | 現有公開primitive |
| `weight600` | `600` | 現有公開primitive |
| `weight700` | `700` | 現有公開primitive |
| `weight800` | `800` | 現有公開primitive |

## 時間

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `duration0` | `0` | 現有公開primitive |
| `duration100` | `120` | 現有公開primitive |
| `duration150` | `140` | 現有公開primitive |
| `duration400` | `450` | 現有公開primitive |
| `duration500` | `500` | 現有公開primitive |
| `duration-4000` | `4000` | 原實作值的文件名稱；未新增設計 |
| `duration-1000` | `1000` | 原實作值的文件名稱；未新增設計 |

## 緩動

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `easeStandard` | `[0.215, 0.61, 0.355, 1.0]` | 現有公開primitive |
| `easeEmphasized` | `[0.645, 0.045, 0.355, 1.0]` | 現有公開primitive |

## 透明度

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `opacity100` | `0.1` | 現有公開primitive |
| `opacity120` | `0.12` | 現有公開primitive |
| `opacity140` | `0.14` | 現有公開primitive |
| `opacity160` | `0.16` | 現有公開primitive |
| `opacity180` | `0.18` | 現有公開primitive |
| `opacity220` | `0.22` | 現有公開primitive |
| `opacity280` | `0.28` | 現有公開primitive |
| `opacity320` | `0.32` | 現有公開primitive |
| `opacity350` | `0.35` | 現有公開primitive |
| `opacity440` | `0.44` | 現有公開primitive |
| `opacity480` | `0.48` | 現有公開primitive |
| `opacity550` | `0.55` | 現有公開primitive |
| `opacity620` | `0.62` | 現有公開primitive |
| `opacity720` | `0.72` | 現有公開primitive |
| `opacity780` | `0.78` | 現有公開primitive |
| `opacity820` | `0.82` | 現有公開primitive |
| `opacity-0_13333333333333333` | `0.13333333333333333` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_6` | `0.6` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_88` | `0.88` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_47843137254901963` | `0.47843137254901963` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_1803921568627451` | `0.1803921568627451` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_07058823529411765` | `0.07058823529411765` | 原實作值的文件名稱；未新增設計 |
| `opacity-0_8509803921568627` | `0.8509803921568627` | 原實作值的文件名稱；未新增設計 |

## 字型／fallback名稱

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `family-packages-kallopis-noto-sans-tc` | `packages/kallopis/Noto Sans TC` | 原實作值的文件名稱；未新增設計 |
| `family-noto-sans-tc` | `Noto Sans TC` | 原實作值的文件名稱；未新增設計 |
| `family-microsoft-jhenghei-ui` | `Microsoft JhengHei UI` | 原實作值的文件名稱；未新增設計 |
| `family-microsoft-jhenghei` | `Microsoft JhengHei` | 原實作值的文件名稱；未新增設計 |
| `family-pingfang-tc` | `PingFang TC` | 原實作值的文件名稱；未新增設計 |
| `family-sans-serif` | `sans-serif` | 原實作值的文件名稱；未新增設計 |
| `family-packages-kallopis-ibm-plex-mono` | `packages/kallopis/IBM Plex Mono` | 原實作值的文件名稱；未新增設計 |
| `family-ibm-plex-mono` | `IBM Plex Mono` | 原實作值的文件名稱；未新增設計 |
| `family-consolas` | `Consolas` | 原實作值的文件名稱；未新增設計 |
| `family-courier-new` | `Courier New` | 原實作值的文件名稱；未新增設計 |
| `family-monospace` | `monospace` | 原實作值的文件名稱；未新增設計 |

## 模式

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `string-shadow` | `shadow` | 原實作值的文件名稱；未新增設計 |

## 數量

| Primitive名稱 | 實際值 | 來源 |
|---|---|---|
| `count-4` | `4` | 原實作值的文件名稱；未新增設計 |
| `count-8` | `8` | 原實作值的文件名稱；未新增設計 |


## 桌面控制尺寸修訂

| Primitive | Value | 說明 |
| --- | --- | --- |
| `length-15` | `15` | checkbox 13px 增加 2px 的明確尺寸 |
