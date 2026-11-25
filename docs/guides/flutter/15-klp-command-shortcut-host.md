# 原生快捷鍵宿主

stable foundation的`KlpCommandShortcutHost<C>`必填keymap／getContext／getFocus／getIsComposing／onHandling／onResult／child；以非可聚焦的原生Focus包child，原focused descendant先處理。不註冊全域keyboard listener。getFocus投影產品identity與scope鏈；getIsComposing投影custom/upstream editor當前組字，宿主另與原生EditableText composing及editable做OR，硬體key事件不取代文字輸入。

## API 查表

- [KlpCommandShortcutHost](../../reference/flutter/components/actions/klp-command-shortcut-host.md)
