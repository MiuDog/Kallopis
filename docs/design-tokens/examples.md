## 查表例子

| 使用者描述 | 查表路徑 | 最終設計（範例明確選md；其他採light/rest） |
|---|---|---|
| 「做主要按鈕，尺寸用預設」 | button-base→button-primary→button-size-sm | 背景brand；padding-x12、padding-y0；height32；radius6；字體captionStrong=12/600/行高1.333；其餘繼承。 |
| 「套用專案背景」 | app-background→theme.colors.app→parchment150 | background=#E7E4DD；padding0；border none；radius0；size產品決定。 |
| 「做md主要按鈕」 | button-base→button-primary→button-size-md | 背景brand=ink900=#1D1D1D；前景parchment75=#F0EDE6；padding-x16、padding-y0；height36；width內容決定；radius6；border none；Noto Sans TC/16/600/行高1.5；gap8；shadow none。 |
| 「深色md主按鈕hover」 | 上述路徑，dark＋button-hover | resting背景白色；onPrimary=#21201B；以onPrimary alpha0.10疊在白底；前景依新背景重新算；幾何繼承。 |
| 「做輸入框」 | field-base→field-size-md | 背景#EFEDE7；文字#21201B；height40；padding-x8；padding-y=(40−16×1.3)/2=9.6；radius6；border none；Noto Sans TC/16/行高1.333。 |
| 「正文繼承容器」 | text-body＋使用者color=繼承父層 | font=Noto Sans TC/16/400/行高1.5；文字色由容器提供，不自行改成黑色。 |
| 「側欄微立體」 | frame-sidebar→frame-raised | 背景surfaceInset；width300；radius12；padding0；effect-frame-relief；框間距8由workspace-layout提供。 |
| 「選取Explorer檔案」 | explorer-row→explorer-row-selected | hover/selected同為text alpha0.10疊層；icon改主文字；label用text-code；不增加互動虛線框。 |

