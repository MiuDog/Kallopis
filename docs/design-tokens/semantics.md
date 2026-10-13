# 第二部分：Semantic token表格（自然語言→設計組合）

## AI解析規則

| 步驟 | 執行方式 |
|---|---|
| 1 | 從對話識別元件用途、主題、size、tone、state，再查中文／英文別名取得canonical ID。單獨的primary不能直接當作任意藍色。 |
| 2 | 展開繼承；按鈕／欄位以base→variant→size→state合併。primary在尺寸套用後再次選captionStrong（xs/sm）、bodyStrong（md）、lead（lg/xl）。 |
| 3 | 將s(theme.*)依主題查成p(...)，再查實際值；公式在最後計算。 |
| 4 | button狀態：disabled>selected>hover/focus>rest；field：disabled>error>focus>hover>rest。outlined/multiline分別覆寫自己的參數。圖示按鈕disabled仍保留selected底色。 |
| 5 | 使用者明確覆寫優先，其餘遵照本表；需要的語意缺漏時不杜撰已定型公共配方。產品專用尺寸與流程由產品擁有。 |
| 6 | 實作說明列出使用的semantic ID與覆寫欄位。Flutter用公開theme／元件；其他技術棧集中維護同一份semantic map。 |

## 全域semantic值（theme.*）

完整350個公開主題欄位，陣列算一個欄位。components預設null，表中列出其**繼承解析**來源；null不是0。元件配方是後方的表格，不把每個theme欄位當作完整元件。


### colors

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.colors.app`<br>app background／應用背景色 | `p(parchment150)` | `p(parchment950)` | `p(ink950)` | `p(transparent)` |
| `theme.colors.surface`<br>base surface／輔助表面色 | `p(parchment100)` | `p(parchment900)` | `p(ink850)` | `p(color-b8292724)` |
| `theme.colors.surfaceInset`<br>inset surface／內嵌表面色 | `p(parchment100)` | `p(parchment900)` | `p(ink850)` | `p(parchment900)` |
| `theme.colors.surfaceMuted`<br>muted surface／弱化表面色 | `p(parchment200)` | `p(parchment750)` | `p(ink850)` | `p(parchment750)` |
| `theme.colors.component`<br>control surface／控制表面色 | `p(parchment50)` | `p(parchment800)` | `p(ink900)` | `p(parchment800)` |
| `theme.colors.stageSurface`<br>stage background／主內容表面色 | `p(parchment50)` | `p(parchment800)` | `p(ink900)` | `p(color-b835322d)` |
| `theme.colors.overlay`<br>overlay background／浮層色 | `p(parchment50)` | `p(parchment800)` | `p(ink850)` | `p(parchment800)` |
| `theme.colors.surfaceRaised`<br>raised surface／較亮表面 | `p(parchment50)` | `p(parchment800)` | `p(ink850)` | `p(parchment800)` |
| `theme.colors.modalScrim`<br>遮罩色 | `p(scrim)` | `p(scrim)` | `p(scrim)` | `p(scrim)` |
| `theme.colors.guide`<br>colors / guide | `p(parchment250)` | `p(parchment700)` | `p(ink450)` | `p(parchment700)` |
| `theme.colors.divider`<br>分隔線色 | `p(parchment250)` | `p(parchment700)` | `p(ink800)` | `p(parchment700)` |
| `theme.colors.pagePattern`<br>colors / page Pattern | `p(parchment250)` | `p(parchment700)` | `p(ink650)` | `p(parchment700)` |
| `theme.colors.text`<br>primary text／主文字 | `p(parchment925)` | `p(parchment75)` | `p(ink100)` | `p(parchment75)` |
| `theme.colors.textMuted`<br>muted text／次要文字 | `p(parchment550)` | `p(parchment350)` | `p(ink350)` | `p(parchment350)` |
| `theme.colors.textFaint`<br>faint text／弱化文字 | `p(parchment550)` | `p(parchment350)` | `p(ink400)` | `p(parchment350)` |
| `theme.colors.border`<br>邊框色 | `p(parchment250)` | `p(parchment700)` | `p(transparent)` | `p(parchment700)` |
| `theme.colors.borderStrong`<br>colors / border Strong | `p(parchment250)` | `p(parchment700)` | `p(transparent)` | `p(parchment700)` |
| `theme.colors.brand`<br>brand／品牌色／主動作底色 | `p(ink900)` | `p(ink50)` | `p(ink100)` | `p(ink50)` |
| `theme.colors.accent`<br>colors / accent | `p(ink900)` | `p(ink50)` | `p(ink100)` | `p(ink50)` |
| `theme.colors.accentSoft`<br>colors / accent Soft | `p(ink200)` | `p(ink750)` | `p(ink850)` | `p(ink750)` |
| `theme.colors.interaction`<br>interaction／操作色 | `p(ink900)` | `p(ink50)` | `p(ink100)` | `p(ink50)` |
| `theme.colors.interactionSoft`<br>selection background／柔和操作色 | `p(ink200)` | `p(ink750)` | `p(ink850)` | `p(ink750)` |
| `theme.colors.success`<br>colors / success | `p(green500)` | `p(green500)` | `p(green500)` | `p(green500)` |
| `theme.colors.warning`<br>colors / warning | `p(amber500)` | `p(amber500)` | `p(amber500)` | `p(amber500)` |
| `theme.colors.danger`<br>colors / danger | `p(red300)` | `p(red300)` | `p(red300)` | `p(red300)` |
| `theme.colors.info`<br>colors / info | `p(blue500)` | `p(blue500)` | `p(blue500)` | `p(blue500)` |
| `theme.colors.onStatus`<br>colors / on Status | `p(ink50)` | `p(ink50)` | `p(ink50)` | `p(ink50)` |
| `theme.colors.onLightBackground`<br>colors / on Light Background | `p(parchment925)` | `p(parchment925)` | `p(ink900)` | `p(parchment925)` |
| `theme.colors.onDarkBackground`<br>colors / on Dark Background | `p(parchment75)` | `p(parchment75)` | `p(ink50)` | `p(parchment75)` |
| `theme.colors.mutedOnLightBackground`<br>colors / muted On Light Background | `p(parchment550)` | `p(parchment550)` | `p(ink550)` | `p(parchment550)` |
| `theme.colors.mutedOnDarkBackground`<br>colors / muted On Dark Background | `p(parchment350)` | `p(parchment350)` | `p(ink300)` | `p(parchment350)` |
| `theme.colors.faintOnBackground`<br>colors / faint On Background | `p(parchment550)` | `p(parchment350)` | `p(ink400)` | `p(parchment350)` |
| `theme.colors.transparent`<br>透明 | `p(transparent)` | `p(transparent)` | `p(transparent)` | `p(transparent)` |

### typography

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.typography.sansFamily`<br>typography / sans Family | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` |
| `theme.typography.sansFallback`<br>typography / sans Fallback | `[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]` | `[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]` | `[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]` | `[p(family-noto-sans-tc), p(family-microsoft-jhenghei-ui), p(family-microsoft-jhenghei), p(family-pingfang-tc), p(family-sans-serif)]` |
| `theme.typography.monoFamily`<br>typography / mono Family | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` |
| `theme.typography.monoFallback`<br>typography / mono Fallback | `[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]` | `[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]` | `[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]` | `[p(family-packages-kallopis-noto-sans-tc), p(family-ibm-plex-mono), p(family-consolas), p(family-courier-new), p(family-monospace)]` |
| `theme.typography.uiFamily`<br>typography / ui Family | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` |
| `theme.typography.bodyFamily`<br>typography / body Family | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` | `p(family-packages-kallopis-noto-sans-tc)` |
| `theme.typography.codeFamily`<br>typography / code Family | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` | `p(family-packages-kallopis-ibm-plex-mono)` |
| `theme.typography.micro`<br>typography / micro | `p(space250)` | `p(space250)` | `p(space250)` | `p(space250)` |
| `theme.typography.caption`<br>typography / caption | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.typography.sub`<br>typography / sub | `p(font300)` | `p(font300)` | `p(font300)` | `p(font300)` |
| `theme.typography.body`<br>typography / body | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.typography.lead`<br>typography / lead | `p(font500)` | `p(font500)` | `p(font500)` | `p(font500)` |
| `theme.typography.h4`<br>typography / h4 | `p(font600)` | `p(font600)` | `p(font600)` | `p(font600)` |
| `theme.typography.h3`<br>typography / h3 | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.typography.h2`<br>typography / h2 | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.typography.h1`<br>typography / h1 | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.typography.display`<br>typography / display | `p(space1600)` | `p(space1600)` | `p(space1600)` | `p(space1600)` |
| `theme.typography.label`<br>typography / label | `p(font300)` | `p(font300)` | `p(font300)` | `p(font300)` |
| `theme.typography.section`<br>typography / section | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.typography.headingSmall`<br>typography / heading Small | `p(font600)` | `p(font600)` | `p(font600)` | `p(font600)` |
| `theme.typography.heading`<br>typography / heading | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.typography.title`<br>typography / title | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.typography.microLeading`<br>typography / micro Leading | `p(leading120)` | `p(leading120)` | `p(leading120)` | `p(leading120)` |
| `theme.typography.captionLeading`<br>typography / caption Leading | `p(leading133)` | `p(leading133)` | `p(leading133)` | `p(leading133)` |
| `theme.typography.subLeading`<br>typography / sub Leading | `p(leading142)` | `p(leading142)` | `p(leading142)` | `p(leading142)` |
| `theme.typography.bodyLeading`<br>typography / body Leading | `p(leading150)` | `p(leading150)` | `p(leading150)` | `p(leading150)` |
| `theme.typography.leadLeading`<br>typography / lead Leading | `p(leading155)` | `p(leading155)` | `p(leading155)` | `p(leading155)` |
| `theme.typography.h4Leading`<br>typography / h4Leading | `p(leading127)` | `p(leading127)` | `p(leading127)` | `p(leading127)` |
| `theme.typography.h3Leading`<br>typography / h3Leading | `p(leading128)` | `p(leading128)` | `p(leading128)` | `p(leading128)` |
| `theme.typography.h2Leading`<br>typography / h2Leading | `p(leading122)` | `p(leading122)` | `p(leading122)` | `p(leading122)` |
| `theme.typography.h1Leading`<br>typography / h1Leading | `p(leading116)` | `p(leading116)` | `p(leading116)` | `p(leading116)` |
| `theme.typography.displayLeading`<br>typography / display Leading | `p(leading100)` | `p(leading100)` | `p(leading100)` | `p(leading100)` |
| `theme.typography.headingLeading`<br>typography / heading Leading | `p(leading122)` | `p(leading122)` | `p(leading122)` | `p(leading122)` |
| `theme.typography.codeLeading`<br>typography / code Leading | `p(leading142)` | `p(leading142)` | `p(leading142)` | `p(leading142)` |
| `theme.typography.readingLeading`<br>typography / reading Leading | `p(leading155)` | `p(leading155)` | `p(leading155)` | `p(leading155)` |
| `theme.typography.labelLeading`<br>typography / label Leading | `p(leading133)` | `p(leading133)` | `p(leading133)` | `p(leading133)` |
| `theme.typography.labelTracking`<br>typography / label Tracking | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |
| `theme.typography.displayTracking`<br>typography / display Tracking | `p(trackingTight)` | `p(trackingTight)` | `p(trackingTight)` | `p(trackingTight)` |
| `theme.typography.regular`<br>typography / regular | `p(weight400)` | `p(weight400)` | `p(weight400)` | `p(weight400)` |
| `theme.typography.medium`<br>typography / medium | `p(weight400)` | `p(weight400)` | `p(weight400)` | `p(weight400)` |
| `theme.typography.semiBold`<br>typography / semi Bold | `p(weight600)` | `p(weight600)` | `p(weight600)` | `p(weight600)` |
| `theme.typography.bold`<br>typography / bold | `p(weight700)` | `p(weight700)` | `p(weight700)` | `p(weight700)` |
| `theme.typography.extraBold`<br>typography / extra Bold | `p(weight700)` | `p(weight700)` | `p(weight700)` | `p(weight700)` |
| `theme.typography.strong`<br>typography / strong | `p(weight600)` | `p(weight600)` | `p(weight600)` | `p(weight600)` |

### spacing

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.spacing.space0_5`<br>spacing / space0_5 | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.spacing.space1`<br>spacing / space1 | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.spacing.space2`<br>spacing / space2 | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.space3`<br>spacing / space3 | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.spacing.space4`<br>spacing / space4 | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.space6`<br>spacing / space6 | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.space8`<br>spacing / space8 | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.space12`<br>spacing / space12 | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.spacing.space16`<br>spacing / space16 | `p(space1600)` | `p(space1600)` | `p(space1600)` | `p(space1600)` |
| `theme.spacing.space24`<br>spacing / space24 | `p(space2400)` | `p(space2400)` | `p(space2400)` | `p(space2400)` |
| `theme.spacing.hairline`<br>spacing / hairline | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.spacing.tight`<br>spacing / tight | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.spacing.contentInlineGap`<br>spacing / content Inline Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.contentStackGap`<br>spacing / content Stack Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.contentInset`<br>spacing / content Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.controlContentGap`<br>spacing / control Content Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.controlInset`<br>spacing / control Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.actionGap`<br>spacing / action Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.chromeGap`<br>spacing / chrome Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.chromePanelInset`<br>spacing / chrome Panel Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.chromeToolbarGap`<br>spacing / chrome Toolbar Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.navigationItemInset`<br>spacing / navigation Item Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.navigationRailInset`<br>spacing / navigation Rail Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.navigationRailItemGap`<br>spacing / navigation Rail Item Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.overlayContentInset`<br>spacing / overlay Content Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.overlayHeadingGap`<br>spacing / overlay Heading Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.overlayItemGap`<br>spacing / overlay Item Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.navigationSectionGap`<br>spacing / navigation Section Gap | `p(radius150)` | `p(radius150)` | `p(radius150)` | `p(radius150)` |
| `theme.spacing.appFrameInset`<br>spacing / app Frame Inset | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.spacing.windowHeaderMargin`<br>spacing / window Header Margin | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.spacing.dockMargin`<br>spacing / dock Margin | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.spacing.base`<br>spacing / base | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.comfortable`<br>spacing / comfortable | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.loose`<br>spacing / loose | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.section`<br>spacing / section | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.sectionLarge`<br>spacing / section Large | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.spacing.page`<br>spacing / page | `p(space1600)` | `p(space1600)` | `p(space1600)` | `p(space1600)` |
| `theme.spacing.pageLarge`<br>spacing / page Large | `p(space2400)` | `p(space2400)` | `p(space2400)` | `p(space2400)` |
| `theme.spacing.controlPaddingXSmall`<br>spacing / control Padding XSmall | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.spacing.controlPaddingX`<br>spacing / control Padding X | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.controlPaddingXLarge`<br>spacing / control Padding XLarge | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.controlPaddingXXLarge`<br>spacing / control Padding XXLarge | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.controlPaddingY`<br>spacing / control Padding Y | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.containerPadding`<br>spacing / container Padding | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.itemGap`<br>spacing / item Gap | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.spacing.groupGap`<br>spacing / group Gap | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.controlHeightXSmall`<br>spacing / control Height XSmall | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.spacing.controlHeightSmall`<br>spacing / control Height Small | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.spacing.controlHeight`<br>spacing / control Height | `p(space1000)` | `p(space1000)` | `p(space1000)` | `p(space1000)` |
| `theme.spacing.controlHeightLarge`<br>spacing / control Height Large | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.spacing.controlHeightXLarge`<br>spacing / control Height XLarge | `p(length-56)` | `p(length-56)` | `p(length-56)` | `p(length-56)` |
| `theme.spacing.iconSmall`<br>spacing / icon Small | `p(font300)` | `p(font300)` | `p(font300)` | `p(font300)` |
| `theme.spacing.iconBase`<br>spacing / icon Base | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.spacing.iconGlyph`<br>spacing / icon Glyph | `p(font500)` | `p(font500)` | `p(font500)` | `p(font500)` |
| `theme.spacing.icon`<br>spacing / icon | `p(length-20)` | `p(length-20)` | `p(length-20)` | `p(length-20)` |
| `theme.spacing.iconMedium`<br>spacing / icon Medium | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.iconLarge`<br>spacing / icon Large | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.chromeHeader`<br>spacing / chrome Header | `p(length-60)` | `p(length-60)` | `p(length-60)` | `p(length-60)` |
| `theme.spacing.chromeStatusBar`<br>spacing / chrome Status Bar | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.spacing.chromeRail`<br>spacing / chrome Rail | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.spacing.chromeTab`<br>spacing / chrome Tab | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.iconButton`<br>spacing / icon Button | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.spacing.iconTiny`<br>spacing / icon Tiny | `p(space250)` | `p(space250)` | `p(space250)` | `p(space250)` |
| `theme.spacing.indicatorDot`<br>spacing / indicator Dot | `p(radius150)` | `p(radius150)` | `p(radius150)` | `p(radius150)` |
| `theme.spacing.indicatorDotLarge`<br>spacing / indicator Dot Large | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.spacing.noticeIconSlot`<br>spacing / notice Icon Slot | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.spacing.toastIconSlot`<br>spacing / toast Icon Slot | `p(font600)` | `p(font600)` | `p(font600)` | `p(font600)` |
| `theme.spacing.gutterNumber`<br>spacing / gutter Number | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.gutterMarker`<br>spacing / gutter Marker | `p(font300)` | `p(font300)` | `p(font300)` | `p(font300)` |
| `theme.spacing.micro`<br>spacing / micro | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` |
| `theme.spacing.calendarContentCell`<br>spacing / calendar Content Cell | `p(length-74)` | `p(length-74)` | `p(length-74)` | `p(length-74)` |
| `theme.spacing.gridTileWidth`<br>spacing / grid Tile Width | `p(length-170)` | `p(length-170)` | `p(length-170)` | `p(length-170)` |
| `theme.spacing.iconMicro`<br>spacing / icon Micro | `p(length-11)` | `p(length-11)` | `p(length-11)` | `p(length-11)` |
| `theme.spacing.avatarSmall`<br>spacing / avatar Small | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.spacing.progressTrack`<br>spacing / progress Track | `p(length-3)` | `p(length-3)` | `p(length-3)` | `p(length-3)` |
| `theme.spacing.skeletonLine`<br>spacing / skeleton Line | `p(space250)` | `p(space250)` | `p(space250)` | `p(space250)` |
| `theme.spacing.railItem`<br>spacing / rail Item | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |

### shape

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.shape.none`<br>shape / none | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |
| `theme.shape.sm`<br>shape / sm | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.shape.control`<br>shape / control | `p(radius150)` | `p(radius150)` | `p(radius150)` | `p(radius150)` |
| `theme.shape.controlInner`<br>shape / control Inner | `p(length-5)` | `p(length-5)` | `p(length-5)` | `p(length-5)` |
| `theme.shape.toggleTrack`<br>shape / toggle Track | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.shape.card`<br>shape / card | `p(length-7)` | `p(length-7)` | `p(length-7)` | `p(length-7)` |
| `theme.shape.panel`<br>shape / panel | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.shape.pill`<br>shape / pill | `p(radiusFull)` | `p(radiusFull)` | `p(radiusFull)` | `p(radiusFull)` |
| `theme.shape.hairline`<br>shape / hairline | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` |
| `theme.shape.stroke`<br>shape / stroke | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.shape.dashedLength`<br>shape / dashed Length | `p(length-3)` | `p(length-3)` | `p(length-3)` | `p(length-3)` |
| `theme.shape.dashedGap`<br>shape / dashed Gap | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.shape.dashedOpacity`<br>shape / dashed Opacity | `p(opacity780)` | `p(opacity780)` | `p(opacity780)` | `p(opacity780)` |

### motion

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.motion.themeTransition`<br>motion / theme Transition | `p(duration0)` | `p(duration0)` | `p(duration0)` | `p(duration0)` |
| `theme.motion.styleTransition`<br>motion / style Transition | `p(duration0)` | `p(duration0)` | `p(duration0)` | `p(duration0)` |
| `theme.motion.stateTransition`<br>motion / state Transition | `p(duration150)` | `p(duration150)` | `p(duration150)` | `p(duration150)` |
| `theme.motion.overlayEnter`<br>motion / overlay Enter | `p(duration150)` | `p(duration150)` | `p(duration150)` | `p(duration150)` |
| `theme.motion.overlayExit`<br>motion / overlay Exit | `p(duration100)` | `p(duration100)` | `p(duration100)` | `p(duration100)` |
| `theme.motion.toastDwell`<br>motion / toast Dwell | `p(duration500)` | `p(duration500)` | `p(duration500)` | `p(duration500)` |
| `theme.motion.tooltipDelay`<br>motion / tooltip Delay | `p(duration400)` | `p(duration400)` | `p(duration400)` | `p(duration400)` |
| `theme.motion.tooltipDwell`<br>motion / tooltip Dwell | `p(duration-4000)` | `p(duration-4000)` | `p(duration-4000)` | `p(duration-4000)` |
| `theme.motion.spinnerCycle`<br>motion / spinner Cycle | `p(duration-1000)` | `p(duration-1000)` | `p(duration-1000)` | `p(duration-1000)` |
| `theme.motion.longPressThreshold`<br>motion / long Press Threshold | `p(duration500)` | `p(duration500)` | `p(duration500)` | `p(duration500)` |
| `theme.motion.standard`<br>motion / standard | `p(easeStandard)` | `p(easeStandard)` | `p(easeStandard)` | `p(easeStandard)` |
| `theme.motion.emphasized`<br>motion / emphasized | `p(easeEmphasized)` | `p(easeEmphasized)` | `p(easeEmphasized)` | `p(easeEmphasized)` |

### surface

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.surface.separation`<br>surface / separation | `p(string-shadow)` | `p(string-shadow)` | `p(string-shadow)` | `p(string-shadow)` |
| `theme.surface.overlayBlur`<br>surface / overlay Blur | `p(length-20)` | `p(length-20)` | `p(length-20)` | `p(length-20)` |
| `theme.surface.overlaySpread`<br>surface / overlay Spread | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |
| `theme.surface.overlayOffsetY`<br>surface / overlay Offset Y | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.surface.overlayShadowOpacity`<br>surface / overlay Shadow Opacity | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` |
| `theme.surface.scrimOpacity`<br>surface / scrim Opacity | `p(opacity-0_6)` | `p(opacity-0_6)` | `p(opacity-0_6)` | `p(opacity-0_6)` |
| `theme.surface.selectionWashOpacity`<br>surface / selection Wash Opacity | `p(opacity100)` | `p(opacity100)` | `p(opacity100)` | `p(opacity100)` |
| `theme.surface.focusWashOpacity`<br>surface / focus Wash Opacity | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` |
| `theme.surface.statusFillOpacity`<br>surface / status Fill Opacity | `p(opacity160)` | `p(opacity160)` | `p(opacity160)` | `p(opacity160)` |
| `theme.surface.pressProgressOpacity`<br>surface / press Progress Opacity | `p(opacity550)` | `p(opacity550)` | `p(opacity550)` | `p(opacity550)` |
| `theme.surface.diffFillOpacity`<br>surface / diff Fill Opacity | `p(opacity120)` | `p(opacity120)` | `p(opacity120)` | `p(opacity120)` |
| `theme.surface.gridLineOpacity`<br>surface / grid Line Opacity | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` |
| `theme.surface.veilOpacity`<br>surface / veil Opacity | `p(opacity820)` | `p(opacity820)` | `p(opacity820)` | `p(opacity820)` |
| `theme.surface.statusRowOpacity`<br>surface / status Row Opacity | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` |
| `theme.surface.statusRowSelectedOpacity`<br>surface / status Row Selected Opacity | `p(opacity320)` | `p(opacity320)` | `p(opacity320)` | `p(opacity320)` |
| `theme.surface.statusRowOpacityDark`<br>surface / status Row Opacity Dark | `p(opacity280)` | `p(opacity280)` | `p(opacity280)` | `p(opacity280)` |
| `theme.surface.statusRowSelectedOpacityDark`<br>surface / status Row Selected Opacity Dark | `p(opacity480)` | `p(opacity480)` | `p(opacity480)` | `p(opacity480)` |
| `theme.surface.frostedOpacity`<br>surface / frosted Opacity | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` |
| `theme.surface.frostedVeilOpacity`<br>surface / frosted Veil Opacity | `p(opacity120)` | `p(opacity120)` | `p(opacity120)` | `p(opacity120)` |
| `theme.surface.backdropBlurSigma`<br>surface / backdrop Blur Sigma | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.surface.dragOpacity`<br>surface / drag Opacity | `p(opacity820)` | `p(opacity820)` | `p(opacity820)` | `p(opacity820)` |
| `theme.surface.dragSourceOpacity`<br>surface / drag Source Opacity | `p(opacity350)` | `p(opacity350)` | `p(opacity350)` | `p(opacity350)` |
| `theme.surface.themePreviewDisabledOpacity`<br>surface / theme Preview Disabled Opacity | `p(opacity620)` | `p(opacity620)` | `p(opacity620)` | `p(opacity620)` |
| `theme.surface.listStatusOpacity`<br>surface / list Status Opacity | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` | `p(opacity140)` |
| `theme.surface.listStatusSelectedOpacity`<br>surface / list Status Selected Opacity | `p(opacity320)` | `p(opacity320)` | `p(opacity320)` | `p(opacity320)` |
| `theme.surface.accentSoftOpacityLight`<br>surface / accent Soft Opacity Light | `p(opacity160)` | `p(opacity160)` | `p(opacity160)` | `p(opacity160)` |
| `theme.surface.accentSoftOpacityDark`<br>surface / accent Soft Opacity Dark | `p(opacity220)` | `p(opacity220)` | `p(opacity220)` | `p(opacity220)` |
| `theme.surface.windowPaneOpacityLight`<br>surface / window Pane Opacity Light | `p(opacity-0_88)` | `p(opacity-0_88)` | `p(opacity-0_88)` | `p(opacity-0_88)` |
| `theme.surface.windowPaneOpacityDark`<br>surface / window Pane Opacity Dark | `p(opacity720)` | `p(opacity720)` | `p(opacity720)` | `p(opacity720)` |
| `theme.surface.invalidFillOpacity`<br>surface / invalid Fill Opacity | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` | `p(opacity180)` |
| `theme.surface.contactBlur`<br>surface / contact Blur | `p(length-3)` | `p(length-3)` | `p(length-3)` | `p(length-3)` |
| `theme.surface.contactOffsetY`<br>surface / contact Offset Y | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.surface.contactShadowOpacity`<br>surface / contact Shadow Opacity | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` | `p(opacity-0_13333333333333333)` |
| `theme.surface.overlayShadowColor`<br>surface / overlay Shadow Color | `p(ink1000)` | `p(ink1000)` | `p(ink1000)` | `p(ink1000)` |

### components

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.components.buttonRadius`<br>components / button Radius | `s(theme.shape.control)` | `s(theme.shape.control)` | `s(theme.shape.control)` | `s(theme.shape.control)` |
| `theme.components.buttonPaddingX`<br>components / button Padding X | `s(theme.spacing.controlPaddingX)` | `s(theme.spacing.controlPaddingX)` | `s(theme.spacing.controlPaddingX)` | `s(theme.spacing.controlPaddingX)` |
| `theme.components.buttonPaddingY`<br>components / button Padding Y | `s(theme.spacing.controlPaddingY)` | `s(theme.spacing.controlPaddingY)` | `s(theme.spacing.controlPaddingY)` | `s(theme.spacing.controlPaddingY)` |
| `theme.components.buttonHeight`<br>components / button Height | `s(theme.geometry.control.buttonHeight)` | `s(theme.geometry.control.buttonHeight)` | `s(theme.geometry.control.buttonHeight)` | `s(theme.geometry.control.buttonHeight)` |
| `theme.components.buttonBorderWidth`<br>components / button Border Width | `s(theme.shape.none)` | `s(theme.shape.none)` | `s(theme.shape.none)` | `s(theme.shape.none)` |
| `theme.components.fieldRadius`<br>components / field Radius | `s(theme.shape.control)` | `s(theme.shape.control)` | `s(theme.shape.control)` | `s(theme.shape.control)` |
| `theme.components.fieldPaddingX`<br>components / field Padding X | `s(theme.spacing.controlInset)` | `s(theme.spacing.controlInset)` | `s(theme.spacing.controlInset)` | `s(theme.spacing.controlInset)` |
| `theme.components.fieldHeight`<br>components / field Height | `s(theme.spacing.controlHeight)` | `s(theme.spacing.controlHeight)` | `s(theme.spacing.controlHeight)` | `s(theme.spacing.controlHeight)` |
| `theme.components.fieldBorderWidth`<br>components / field Border Width | `s(theme.shape.none)` | `s(theme.shape.none)` | `s(theme.shape.none)` | `s(theme.shape.none)` |
| `theme.components.menuRadius`<br>components / menu Radius | `s(theme.shape.card)` | `s(theme.shape.card)` | `s(theme.shape.card)` | `s(theme.shape.card)` |
| `theme.components.menuPadding`<br>components / menu Padding | `s(theme.spacing.overlayContentInset)` | `s(theme.spacing.overlayContentInset)` | `s(theme.spacing.overlayContentInset)` | `s(theme.spacing.overlayContentInset)` |
| `theme.components.menuItemHeight`<br>components / menu Item Height | `s(theme.geometry.layout.menuItemHeight)` | `s(theme.geometry.layout.menuItemHeight)` | `s(theme.geometry.layout.menuItemHeight)` | `s(theme.geometry.layout.menuItemHeight)` |
| `theme.components.cardRadius`<br>components / card Radius | `s(theme.shape.card)` | `s(theme.shape.card)` | `s(theme.shape.card)` | `s(theme.shape.card)` |
| `theme.components.cardPadding`<br>components / card Padding | `s(theme.spacing.containerPadding)` | `s(theme.spacing.containerPadding)` | `s(theme.spacing.containerPadding)` | `s(theme.spacing.containerPadding)` |
| `theme.components.badgeRadius`<br>components / badge Radius | `s(theme.shape.pill)` | `s(theme.shape.pill)` | `s(theme.shape.pill)` | `s(theme.shape.pill)` |
| `theme.components.badgePaddingX`<br>components / badge Padding X | `add(s(theme.spacing.tight), s(theme.spacing.space0_5))` | `add(s(theme.spacing.tight), s(theme.spacing.space0_5))` | `add(s(theme.spacing.tight), s(theme.spacing.space0_5))` | `add(s(theme.spacing.tight), s(theme.spacing.space0_5))` |

### geometry

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.geometry.control.switchTrackWidth`<br>geometry / control / switch Track Width | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.geometry.control.switchTrackHeight`<br>geometry / control / switch Track Height | `p(length-20)` | `p(length-20)` | `p(length-20)` | `p(length-20)` |
| `theme.geometry.control.switchThumb`<br>geometry / control / switch Thumb | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.geometry.control.buttonHeightXSmall`<br>geometry / control / button Height XSmall | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.geometry.control.buttonHeightSmall`<br>geometry / control / button Height Small | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.geometry.control.buttonHeight`<br>geometry / control / button Height | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.geometry.control.buttonHeightLarge`<br>geometry / control / button Height Large | `p(space1000)` | `p(space1000)` | `p(space1000)` | `p(space1000)` |
| `theme.geometry.control.buttonHeightXLarge`<br>geometry / control / button Height XLarge | `p(space1200)` | `p(space1200)` | `p(space1200)` | `p(space1200)` |
| `theme.geometry.control.pageBackgroundHitRadius`<br>geometry / control / page Background Hit Radius | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.control.presenceMarkerExtent`<br>geometry / control / presence Marker Extent | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.control.colorPickerCursorRadius`<br>geometry / control / color Picker Cursor Radius | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.control.swatchExtent`<br>geometry / control / swatch Extent | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.control.segmentedProgressHeight`<br>geometry / control / segmented Progress Height | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.control.fieldHeight`<br>geometry / control / field Height | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.geometry.control.selectionControl`<br>geometry / control / selection Control | `p(font500)` | `p(font500)` | `p(font500)` | `p(font500)` |
| `theme.geometry.control.selectionIndicatorInset`<br>geometry / control / selection Indicator Inset | `p(length-3_5)` | `p(length-3_5)` | `p(length-3_5)` | `p(length-3_5)` |
| `theme.geometry.control.selectionIcon`<br>geometry / control / selection Icon | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.geometry.control.toggleWidth`<br>geometry / control / toggle Width | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.geometry.control.toggleHeight`<br>geometry / control / toggle Height | `p(space400)` | `p(space400)` | `p(space400)` | `p(space400)` |
| `theme.geometry.control.toggleThumb`<br>geometry / control / toggle Thumb | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.geometry.control.toggleInset`<br>geometry / control / toggle Inset | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.geometry.control.segmentedDenseHeight`<br>geometry / control / segmented Dense Height | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.geometry.control.segmentedDenseInset`<br>geometry / control / segmented Dense Inset | `p(length-3)` | `p(length-3)` | `p(length-3)` | `p(length-3)` |
| `theme.geometry.control.segmentedDenseContentInset`<br>geometry / control / segmented Dense Content Inset | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |
| `theme.geometry.control.segmentedDenseItemHeight`<br>geometry / control / segmented Dense Item Height | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.geometry.control.slidingSelectionHeight`<br>geometry / control / sliding Selection Height | `p(font800)` | `p(font800)` | `p(font800)` | `p(font800)` |
| `theme.geometry.control.slidingSelectionSegmentWidth`<br>geometry / control / sliding Selection Segment Width | `p(length-41_4)` | `p(length-41_4)` | `p(length-41_4)` | `p(length-41_4)` |
| `theme.geometry.control.slidingSelectionPadding`<br>geometry / control / sliding Selection Padding | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.geometry.control.slidingSelectionIndicatorHeight`<br>geometry / control / sliding Selection Indicator Height | `p(length-30)` | `p(length-30)` | `p(length-30)` | `p(length-30)` |
| `theme.geometry.control.scrollbarThickness`<br>geometry / control / scrollbar Thickness | `p(length-5)` | `p(length-5)` | `p(length-5)` | `p(length-5)` |
| `theme.geometry.control.sliderTrackHeight`<br>geometry / control / slider Track Height | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.geometry.control.colorPlaneExtent`<br>geometry / control / color Plane Extent | `p(length-168)` | `p(length-168)` | `p(length-168)` | `p(length-168)` |
| `theme.geometry.control.textFieldIndicatorHeightFactor`<br>geometry / control / text Field Indicator Height Factor | `p(ratio-0_4)` | `p(ratio-0_4)` | `p(ratio-0_4)` | `p(ratio-0_4)` |
| `theme.geometry.control.textFieldLineHeightFactor`<br>geometry / control / text Field Line Height Factor | `p(leading300)` | `p(leading300)` | `p(leading300)` | `p(leading300)` |
| `theme.geometry.control.textFieldMinLines`<br>geometry / control / text Field Min Lines | `p(count-4)` | `p(count-4)` | `p(count-4)` | `p(count-4)` |
| `theme.geometry.control.textFieldMaxLines`<br>geometry / control / text Field Max Lines | `p(count-8)` | `p(count-8)` | `p(count-8)` | `p(count-8)` |
| `theme.geometry.control.fileExplorerRowHeightAdjustment`<br>geometry / control / file Explorer Row Height Adjustment | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |
| `theme.geometry.data.codeActionButtonSize`<br>geometry / data / code Action Button Size | `p(length-26)` | `p(length-26)` | `p(length-26)` | `p(length-26)` |
| `theme.geometry.data.codeHeaderHeight`<br>geometry / data / code Header Height | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.geometry.data.codeTerminalDot`<br>geometry / data / code Terminal Dot | `p(space100)` | `p(space100)` | `p(space100)` | `p(space100)` |
| `theme.geometry.data.codeTerminalDotGap`<br>geometry / data / code Terminal Dot Gap | `p(length-3)` | `p(length-3)` | `p(length-3)` | `p(length-3)` |
| `theme.geometry.data.codeHeaderPaddingX`<br>geometry / data / code Header Padding X | `p(space250)` | `p(space250)` | `p(space250)` | `p(space250)` |
| `theme.geometry.data.codeBodyPaddingX`<br>geometry / data / code Body Padding X | `p(space250)` | `p(space250)` | `p(space250)` | `p(space250)` |
| `theme.geometry.data.codeLineNumberWidth`<br>geometry / data / code Line Number Width | `p(space800)` | `p(space800)` | `p(space800)` | `p(space800)` |
| `theme.geometry.data.codeWrappedLineWidth`<br>geometry / data / code Wrapped Line Width | `p(length-520)` | `p(length-520)` | `p(length-520)` | `p(length-520)` |
| `theme.geometry.data.codeMaximumHeight`<br>geometry / data / code Maximum Height | `p(length-320)` | `p(length-320)` | `p(length-320)` | `p(length-320)` |
| `theme.geometry.data.codeCollapsedHeight`<br>geometry / data / code Collapsed Height | `p(length-120)` | `p(length-120)` | `p(length-120)` | `p(length-120)` |
| `theme.geometry.data.codeDisclosureSize`<br>geometry / data / code Disclosure Size | `p(length-9)` | `p(length-9)` | `p(length-9)` | `p(length-9)` |
| `theme.geometry.data.filePreviewHeight`<br>geometry / data / file Preview Height | `p(length-220)` | `p(length-220)` | `p(length-220)` | `p(length-220)` |
| `theme.geometry.data.previewCardCompactHeight`<br>geometry / data / preview Card Compact Height | `p(space1600)` | `p(space1600)` | `p(space1600)` | `p(space1600)` |
| `theme.geometry.data.previewCardStandardHeight`<br>geometry / data / preview Card Standard Height | `p(space2400)` | `p(space2400)` | `p(space2400)` | `p(space2400)` |
| `theme.geometry.data.previewCardLargeHeight`<br>geometry / data / preview Card Large Height | `p(length-192)` | `p(length-192)` | `p(length-192)` | `p(length-192)` |
| `theme.geometry.data.dateGridCellHeight`<br>geometry / data / date Grid Cell Height | `p(length-128)` | `p(length-128)` | `p(length-128)` | `p(length-128)` |
| `theme.geometry.data.keyValueLabelWidthCompact`<br>geometry / data / key Value Label Width Compact | `p(space2400)` | `p(space2400)` | `p(space2400)` | `p(space2400)` |
| `theme.geometry.data.keyValueLabelWidthStandard`<br>geometry / data / key Value Label Width Standard | `p(length-112)` | `p(length-112)` | `p(length-112)` | `p(length-112)` |
| `theme.geometry.data.stepperMarkerSize`<br>geometry / data / stepper Marker Size | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.geometry.data.stepperLabelWidth`<br>geometry / data / stepper Label Width | `p(length-60)` | `p(length-60)` | `p(length-60)` | `p(length-60)` |
| `theme.geometry.data.progressIndeterminateFraction`<br>geometry / data / progress Indeterminate Fraction | `p(ratio-0_35)` | `p(ratio-0_35)` | `p(ratio-0_35)` | `p(ratio-0_35)` |
| `theme.geometry.data.placeholderMinimumHeight`<br>geometry / data / placeholder Minimum Height | `p(length-120)` | `p(length-120)` | `p(length-120)` | `p(length-120)` |
| `theme.geometry.data.placeholderContentPaddingY`<br>geometry / data / placeholder Content Padding Y | `p(space300)` | `p(space300)` | `p(space300)` | `p(space300)` |
| `theme.geometry.data.placeholderActionPaddingY`<br>geometry / data / placeholder Action Padding Y | `p(length-5)` | `p(length-5)` | `p(length-5)` | `p(length-5)` |
| `theme.geometry.data.placeholderHatchBand`<br>geometry / data / placeholder Hatch Band | `p(length-10_5)` | `p(length-10_5)` | `p(length-10_5)` | `p(length-10_5)` |
| `theme.geometry.data.placeholderHatchGap`<br>geometry / data / placeholder Hatch Gap | `p(length-10_5)` | `p(length-10_5)` | `p(length-10_5)` | `p(length-10_5)` |
| `theme.geometry.data.placeholderLabelTracking`<br>geometry / data / placeholder Label Tracking | `p(trackingWider)` | `p(trackingWider)` | `p(trackingWider)` | `p(trackingWider)` |
| `theme.geometry.data.placeholderDetailMaximumWidth`<br>geometry / data / placeholder Detail Maximum Width | `p(length-336)` | `p(length-336)` | `p(length-336)` | `p(length-336)` |
| `theme.geometry.data.spinnerSquareFactor`<br>geometry / data / spinner Square Factor | `p(ratio-0_32)` | `p(ratio-0_32)` | `p(ratio-0_32)` | `p(ratio-0_32)` |
| `theme.geometry.data.spinnerOrbitFactor`<br>geometry / data / spinner Orbit Factor | `p(ratio-0_22)` | `p(ratio-0_22)` | `p(ratio-0_22)` | `p(ratio-0_22)` |
| `theme.geometry.data.spinnerCornerFactor`<br>geometry / data / spinner Corner Factor | `p(ratio-0_06)` | `p(ratio-0_06)` | `p(ratio-0_06)` | `p(ratio-0_06)` |
| `theme.geometry.layout.drawerWidth`<br>geometry / layout / drawer Width | `p(length-320)` | `p(length-320)` | `p(length-320)` | `p(length-320)` |
| `theme.geometry.layout.drawerHeight`<br>geometry / layout / drawer Height | `p(length-320)` | `p(length-320)` | `p(length-320)` | `p(length-320)` |
| `theme.geometry.layout.resizeHandleExtent`<br>geometry / layout / resize Handle Extent | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.overlayViewportInset`<br>geometry / layout / overlay Viewport Inset | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.railDropTargetExtent`<br>geometry / layout / rail Drop Target Extent | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.disclosureIconSize`<br>geometry / layout / disclosure Icon Size | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.treeLeadingGap`<br>geometry / layout / tree Leading Gap | `p(ratio-8)` | `p(ratio-8)` | `p(ratio-8)` | `p(ratio-8)` |
| `theme.geometry.layout.tooltipOffsetX`<br>geometry / layout / tooltip Offset X | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.primaryPaneWidth`<br>geometry / layout / primary Pane Width | `p(length-300)` | `p(length-300)` | `p(length-300)` | `p(length-300)` |
| `theme.geometry.layout.secondaryPaneWidth`<br>geometry / layout / secondary Pane Width | `p(length-350)` | `p(length-350)` | `p(length-350)` | `p(length-350)` |
| `theme.geometry.layout.primaryPaneBreakpoint`<br>geometry / layout / primary Pane Breakpoint | `p(length-400)` | `p(length-400)` | `p(length-400)` | `p(length-400)` |
| `theme.geometry.layout.primaryPaneContentBreakpoint`<br>geometry / layout / primary Pane Content Breakpoint | `p(length-800)` | `p(length-800)` | `p(length-800)` | `p(length-800)` |
| `theme.geometry.layout.responsivePaneBreakpoint`<br>geometry / layout / responsive Pane Breakpoint | `p(length-960)` | `p(length-960)` | `p(length-960)` | `p(length-960)` |
| `theme.geometry.layout.secondaryPaneBreakpoint`<br>geometry / layout / secondary Pane Breakpoint | `p(length-1120)` | `p(length-1120)` | `p(length-1120)` | `p(length-1120)` |
| `theme.geometry.layout.menuWidth`<br>geometry / layout / menu Width | `p(length-200)` | `p(length-200)` | `p(length-200)` | `p(length-200)` |
| `theme.geometry.layout.commandMenuWidth`<br>geometry / layout / command Menu Width | `p(length-300)` | `p(length-300)` | `p(length-300)` | `p(length-300)` |
| `theme.geometry.layout.menuHeaderHeight`<br>geometry / layout / menu Header Height | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.geometry.layout.menuItemHeight`<br>geometry / layout / menu Item Height | `p(font700)` | `p(font700)` | `p(font700)` | `p(font700)` |
| `theme.geometry.layout.dialogMaximumWidth`<br>geometry / layout / dialog Maximum Width | `p(length-520)` | `p(length-520)` | `p(length-520)` | `p(length-520)` |
| `theme.geometry.layout.toastMaximumWidth`<br>geometry / layout / toast Maximum Width | `p(length-360)` | `p(length-360)` | `p(length-360)` | `p(length-360)` |
| `theme.geometry.layout.inlineNoticeBreakpoint`<br>geometry / layout / inline Notice Breakpoint | `p(length-480)` | `p(length-480)` | `p(length-480)` | `p(length-480)` |
| `theme.geometry.layout.statusBarBreakpoint`<br>geometry / layout / status Bar Breakpoint | `p(length-400)` | `p(length-400)` | `p(length-400)` | `p(length-400)` |
| `theme.geometry.layout.settingsDialogMaximumWidth`<br>geometry / layout / settings Dialog Maximum Width | `p(length-1380)` | `p(length-1380)` | `p(length-1380)` | `p(length-1380)` |
| `theme.geometry.layout.settingsDialogMaximumHeight`<br>geometry / layout / settings Dialog Maximum Height | `p(length-880)` | `p(length-880)` | `p(length-880)` | `p(length-880)` |
| `theme.geometry.layout.settingsPaneGap`<br>geometry / layout / settings Pane Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.layout.settingsNavigationWidth`<br>geometry / layout / settings Navigation Width | `p(length-300)` | `p(length-300)` | `p(length-300)` | `p(length-300)` |
| `theme.geometry.layout.settingsNavigationMinimumWidth`<br>geometry / layout / settings Navigation Minimum Width | `p(length-260)` | `p(length-260)` | `p(length-260)` | `p(length-260)` |
| `theme.geometry.layout.settingsNavigationMaximumWidth`<br>geometry / layout / settings Navigation Maximum Width | `p(length-360)` | `p(length-360)` | `p(length-360)` | `p(length-360)` |
| `theme.geometry.layout.settingsContentMaximumWidth`<br>geometry / layout / settings Content Maximum Width | `p(length-820)` | `p(length-820)` | `p(length-820)` | `p(length-820)` |
| `theme.geometry.layout.themePreviewTileWidth`<br>geometry / layout / theme Preview Tile Width | `p(length-168)` | `p(length-168)` | `p(length-168)` | `p(length-168)` |
| `theme.geometry.layout.windowHeaderHeight`<br>geometry / layout / window Header Height | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.geometry.layout.windowHeaderControlSize`<br>geometry / layout / window Header Control Size | `p(space600)` | `p(space600)` | `p(space600)` | `p(space600)` |
| `theme.geometry.layout.windowAppIconSize`<br>geometry / layout / window App Icon Size | `p(length-20)` | `p(length-20)` | `p(length-20)` | `p(length-20)` |
| `theme.geometry.layout.windowIdentityGap`<br>geometry / layout / window Identity Gap | `p(space200)` | `p(space200)` | `p(space200)` | `p(space200)` |
| `theme.geometry.optical.menuIconOffsetY`<br>geometry / optical / menu Icon Offset Y | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` |
| `theme.geometry.optical.railBadgeInset`<br>geometry / optical / rail Badge Inset | `p(space50)` | `p(space50)` | `p(space50)` | `p(space50)` |
| `theme.geometry.optical.statusIconOffsetY`<br>geometry / optical / status Icon Offset Y | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` | `p(stroke100)` |
| `theme.geometry.optical.monoBaselineOffsetY`<br>geometry / optical / mono Baseline Offset Y | `p(length-minus-1)` | `p(length-minus-1)` | `p(length-minus-1)` | `p(length-minus-1)` |
| `theme.geometry.optical.uiBaselineOffsetY`<br>geometry / optical / ui Baseline Offset Y | `p(space0)` | `p(space0)` | `p(space0)` | `p(space0)` |

### dataVisualization

| Semantic ID／語意 | light | dark | ultraDark | transparent |
|---|---|---|---|---|
| `theme.dataVisualization.series`<br>data Visualization / series | `[p(sand500), p(gold500), p(ochre500), p(terracotta500), p(clay500), p(umber500)]` | `[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]` | `[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]` | `[p(sand300), p(gold300), p(ochre300), p(terracotta300), p(clay300), p(umber300)]` |
| `theme.dataVisualization.seriesWash`<br>data Visualization / series Wash | `[p(sand50), p(gold50), p(ochre50), p(terracotta50), p(clay50), p(umber50)]` | `[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]` | `[p(sand900), p(gold900), p(ochre900), p(terracotta900), p(clay900), p(umber900)]` | `[p(sand800), p(gold800), p(ochre800), p(terracotta800), p(clay800), p(umber800)]` |
| `theme.dataVisualization.axis`<br>data Visualization / axis | `p(warmNeutral100)` | `p(warmNeutral700)` | `p(warmNeutral750)` | `p(warmNeutral700)` |
| `theme.dataVisualization.grid`<br>data Visualization / grid | `p(warmNeutral50)` | `p(warmNeutral800)` | `p(warmNeutral900)` | `p(warmNeutral800)` |
| `theme.dataVisualization.gridStrong`<br>data Visualization / grid Strong | `p(warmNeutral200)` | `p(warmNeutral600)` | `p(warmNeutral700)` | `p(warmNeutral600)` |
| `theme.dataVisualization.label`<br>data Visualization / label | `p(ink550)` | `p(warmNeutral300)` | `p(warmNeutral300)` | `p(warmNeutral300)` |
| `theme.dataVisualization.value`<br>data Visualization / value | `p(ink900)` | `p(warmNeutral25)` | `p(warmNeutral25)` | `p(warmNeutral25)` |
| `theme.dataVisualization.plotBackground`<br>data Visualization / plot Background | `p(transparent)` | `p(transparent)` | `p(transparent)` | `p(transparent)` |
| `theme.dataVisualization.crosshair`<br>data Visualization / crosshair | `p(warmNeutral450)` | `p(warmNeutral400)` | `p(warmNeutral500)` | `p(warmNeutral400)` |
| `theme.dataVisualization.marketUp`<br>data Visualization / market Up | `p(green600)` | `p(green400)` | `p(green400)` | `p(green400)` |
| `theme.dataVisualization.marketUpWash`<br>data Visualization / market Up Wash | `p(green100)` | `p(green800)` | `p(green900)` | `p(green800)` |
| `theme.dataVisualization.marketDown`<br>data Visualization / market Down | `p(red600)` | `p(red400)` | `p(red400)` | `p(red400)` |
| `theme.dataVisualization.marketDownWash`<br>data Visualization / market Down Wash | `p(red100)` | `p(red800)` | `p(red900)` | `p(red800)` |
| `theme.dataVisualization.marketFlat`<br>data Visualization / market Flat | `p(warmNeutral450)` | `p(warmNeutral400)` | `p(warmNeutral500)` | `p(warmNeutral400)` |

