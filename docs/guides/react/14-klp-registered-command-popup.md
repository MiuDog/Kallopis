# React 錨定與右鍵命令選單

`KlpRegisteredCommandPopup<C>`直接組合相同registry與公開menu。產品提供受控open、readonly anchor `{ x, y, width, height }`，其餘registry／getContext／items／label／emptyLabel／onResult沿menu；onDismiss接收escape／outside／executed並由產品更新open。沒有style覆寫定位入口。按鈕使用原生getBoundingClientRect，右鍵事件由產品preventDefault並提供clientX/Y的零尺寸point。

```tsx
<KlpRegisteredCommandPopup
	registry={commands}
	getContext={() => latestContext}
	items={[{ commandId: 'document.save' }]}
	open={popupOpen}
	anchor={popupAnchor}
	label="文件命令"
	emptyLabel="沒有可用命令"
	onResult={handleProductResult}
	onDismiss={reason => setPopupOpen(false)}
/>
```

## API 查表

- [KlpRegisteredCommandPopup](../../reference/react/components/actions/klp-registered-command-popup.md)
