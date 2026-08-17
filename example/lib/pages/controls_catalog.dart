import 'package:flutter/widgets.dart';

import 'package:kallopis/kallopis.dart';
import '../catalog_components.dart';

class ControlsCatalog extends StatefulWidget {
  const ControlsCatalog({super.key});

  @override
  State<ControlsCatalog> createState() => _ControlsCatalogState();
}

class _ControlsCatalogState extends State<ControlsCatalog> {
  bool _checked = true;
  bool _enabled = true;
  KlpTriState _triState = KlpTriState.mixed;
  int _segment = 0;
  String _radio = 'local';
  double _slider = 0.62;

  void _setChecked(bool value) => setState(() => _checked = value);

  void _setEnabled(bool value) => setState(() => _enabled = value);

  void _setTriState(KlpTriState value) => setState(() => _triState = value);

  void _setSegment(int value) => setState(() => _segment = value);

  void _setRadio(String value) => setState(() => _radio = value);

  void _setSlider(double value) => setState(() => _slider = value);

  @override
  Widget build(BuildContext context) {
    return CatalogCanvas(
      children: [
        KlpSection(
          title: '動作控制項',
          label: 'ACTIONS',
          child: CatalogGrid(
            children: [
              CatalogSample(
                label: 'Buttons',
                child: Wrap(
                  spacing: KlpSpace.sm,
                  runSpacing: KlpSpace.sm,
                  children: [
                    KlpButton(
                      label: '建立頁面',
                      onPressed: () {},
                      tone: KlpButtonTone.primary,
                    ),
                    KlpButton(
                      label: '次要動作',
                      onPressed: () {},
                      tone: KlpButtonTone.secondary,
                    ),
                    KlpButton(
                      label: '幽靈按鈕',
                      onPressed: () {},
                      tone: KlpButtonTone.ghost,
                    ),
                    KlpButton(
                      label: '移至垃圾桶',
                      onPressed: () {},
                      tone: KlpButtonTone.danger,
                    ),
                    const KlpButton(label: '不可使用', onPressed: null),
                  ],
                ),
              ),
              CatalogSample(
                label: 'Icon buttons',
                child: Wrap(
                  spacing: KlpSpace.sm,
                  children: [
                    KlpIconButton(
                      icon: KlpIcons.search,
                      label: '搜尋',
                      onPressed: () {},
                    ),
                    KlpIconButton(
                      icon: KlpIcons.grid,
                      label: '格狀檢視',
                      selected: true,
                      onPressed: () {},
                    ),
                    KlpIconButton(
                      icon: KlpIcons.settings,
                      label: '設定',
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        KlpSection(
          title: '輸入與驗證',
          label: 'FORM SYSTEM',
          child: CatalogGrid(
            children: [
              CatalogSample(
                label: 'Text fields',
                child: Column(
                  children: [
                    KlpTextField(
                      label: '頁面名稱',
                      placeholder: '輸入名稱',
                      leadingIcon: KlpIcons.edit,
                      helper: '名稱會顯示在專案頁面樹。',
                    ),
                    SizedBox(height: KlpSpace.md),
                    KlpTextField(
                      label: '模型 ID',
                      initialValue: 'model/prototype',
                      error: '此模型尚未連線。',
                    ),
                  ],
                ),
              ),
              CatalogSample(
                label: 'Textarea',
                child: KlpTextField(
                  label: 'Agent 職責',
                  placeholder: '描述此 Agent 的工作範圍…',
                  multiline: true,
                ),
              ),
              CatalogSample(
                label: 'Selection',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KlpCheckbox(
                      value: _checked,
                      label: '儲存為專案預設值',
                      onChanged: _setChecked,
                    ),
                    SizedBox(height: KlpSpace.sm),
                    KlpToggle(
                      value: _enabled,
                      label: '允許 Agent 提出修改',
                      onChanged: _setEnabled,
                    ),
                    SizedBox(height: KlpSpace.sm),
                    KlpTriStateToggle(
                      value: _triState,
                      label: '審核狀態',
                      onChanged: _setTriState,
                    ),
                    SizedBox(height: KlpSpace.md),
                    KlpRadioGroup<String>(
                      items: {'local': '本機', 'team': '團隊', 'public': '公開'},
                      value: _radio,
                      onChanged: _setRadio,
                    ),
                  ],
                ),
              ),
              CatalogSample(
                label: 'Structured controls',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    KlpSegmentedControl(
                      items: const ['畫布', '程式碼', '預覽'],
                      selected: _segment,
                      onSelected: _setSegment,
                    ),
                    SizedBox(height: KlpSpace.md),
                    KlpSelect(
                      label: '執行模型',
                      value: 'Sonnet / connected',
                      onPressed: () {},
                    ),
                    SizedBox(height: KlpSpace.md),
                    KlpSlider(
                      label: '介面密度',
                      value: _slider,
                      onChanged: _setSlider,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
