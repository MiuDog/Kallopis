# 原生快捷鍵宿主

`KlpCommandShortcutHost<C>`必填keymap、getContext、getFocus(target)、onHandling、onResult及children。以中立display:contents包原生children；子元件defaultPrevented的按鍵不接管。getFocus投影非空focusId及scope鏈，宿主額外保護input／textarea／有效contenteditable與composition。結果handled才preventDefault／stopPropagation；onHandling可呈現錄製與prefix，onResult接同registry原結果。

## API 查表

- [KlpCommandShortcutHost](../../reference/react/components/actions/klp-command-shortcut-host.md)
