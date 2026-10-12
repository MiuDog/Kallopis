import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kallopis/kallopis_foundation.dart' as stable;
import 'package:kallopis/src/styling/legacy_metrics/klp_metrics.dart' as owner;

const _owner = 'lib/src/styling/legacy_metrics/klp_metrics.dart';

// 凍結於遷移前 e44813e627eff9d62f851bd0432b5a3731a72eae；執行時不從產品推導期望值。
const _parts = <String, String>{
	'klp_code_metrics.dart': 'KlpCodeMetrics',
	'klp_control_metrics.dart': 'KlpControlMetrics',
	'klp_elevation.dart': 'KlpElevation',
	'klp_form_metrics.dart': 'KlpFormMetrics',
	'klp_layout_gap.dart': 'KlpLayoutGap',
	'klp_line.dart': 'KlpLine',
	'klp_motion.dart': 'KlpMotion',
	'klp_placeholder_metrics.dart': 'KlpPlaceholderMetrics',
	'klp_radius.dart': 'KlpRadius',
	'klp_size.dart': 'KlpSize',
	'klp_space.dart': 'KlpSpace',
	'klp_transparency.dart': 'KlpTransparency',
	'klp_typography.dart': 'KlpTypography',
};

const _frozenDeclarations = <String, String>{
	"KlpCodeMetrics": "abstractfinalclassKlpCodeMetrics{staticconstdoubleactionButtonSize=26;staticconstdoubleactionIconSize=14;staticconstdoubleheaderHeight=32;staticconstdoubleterminalDot=4;staticconstdoubleterminalDotGap=3;staticconstdoubleterminalGroupGap=8;staticconstdoubleheaderPaddingHorizontal=10;staticconstdoublebodyPaddingHorizontal=10;staticconstdoublebodyPaddingVertical=8;staticconstdoublelineNumberWidth=32;staticconstdoublewrappedLineWidth=520;staticconstdoubledefaultMaximumHeight=320;}",
	"KlpControlMetrics": "abstractfinalclassKlpControlMetrics{staticconstdoublesegmentedDenseInset=3;staticconstdoublesegmentedDenseContentInset=0;staticconstdoubleslidingSelectionHeight=36;staticconstdoubleslidingSelectionSegmentWidth=41.4;staticconstdoubleslidingSelectionPadding=2;staticconstdoubleslidingSelectionIndicatorHeight=30;staticconstdoublescrollbarThickness=5;staticconstdoublescrollbarEndControlExtent=14;staticconstdoublescrollbarEndControlRightInset=(scrollbarThickness-scrollbarEndControlExtent)/2;staticconstdoublescrollbarPageIncrement=0.8;}",
	"KlpElevation": "abstractfinalclassKlpElevation{staticconstdoublemenuBlurRadius=18;staticconstdoublemenuSpreadRadius=1;staticconstdoublemenuOffsetY=8;staticconstdoublemenuShadowOpacity=0.22;}",
	"KlpFormMetrics": "abstractfinalclassKlpFormMetrics{staticconstdoublefieldHeight=30;staticconstdoubleselectionControl=18;staticconstdoubleselectionIndicatorInset=3.5;staticconstdoubleselectionIndicator=selectionControl-selectionIndicatorInset*2;staticconstdoubleselectionIcon=12;staticconstdoubletoggleWidth=30;staticconstdoubletoggleHeight=16;staticconstdoubletoggleThumb=12;staticconstdoubletoggleInset=2;}",
	"KlpLayoutGap": "abstractfinalclassKlpLayoutGap{staticconstdoublelg=10;}",
	"KlpLine": "abstractfinalclassKlpLine{staticconstdoublehairline=1;staticconstdoublewidth=2;staticconstdoubledashedLength=3;staticconstdoubledashedGap=2;staticconstdoubledashedOpacity=0.78;}",
	"KlpMotion": "abstractfinalclassKlpMotion{staticconstDurationthemeTransition=Duration.zero;staticconstDurationstyleTransition=Duration.zero;}",
	"KlpPlaceholderMetrics": "abstractfinalclassKlpPlaceholderMetrics{staticconstdoubleminimumHeight=120;staticconstdoublemarkerSize=6;staticconstdoublecontentPaddingHorizontal=16;staticconstdoublecontentPaddingVertical=12;staticconstdoublecontentGap=4;staticconstdoubleactionLeadingGap=4;staticconstdoubleactionPaddingHorizontal=12;staticconstdoubleactionPaddingVertical=5;staticconstdoublehatchBand=10.5;staticconstdoublehatchGap=10.5;staticconstdoublehatchStrokeWidth=hatchBand;staticconstdoubledarkHatchColorMix=0.18;staticconstdoublelatentStrokeOpacity=0.32;staticconstdoublelabelLetterSpacing=1.32;staticconstdoubledetailMaximumWidth=336;}",
	"KlpRadius": "abstractfinalclassKlpRadius{staticconstdoublenone=0;staticconstdoublesm=2;staticconstdoublemd=8;staticconstdoublelg=16;staticconstdoublefull=9999;staticconstdoublecontrol=md;staticconstdoublecard=md;staticconstdoublepanel=lg;staticconstdoublepill=full;}",
	"KlpSize": "abstractfinalclassKlpSize{staticconstdoublecontrolSmall=32;staticconstdoublecontrol=40;staticconstdoublecontrolLarge=48;staticconstdoublecontrolXLarge=56;staticconstdoublesegmentedDense=30;staticconstdoublesegmentedDenseItem=24;staticconstdoubleiconButton=32;staticconstdoubletab=32;staticconstdoubleiconSmall=14;staticconstdoubleiconBase=16;staticconstdoubledisclosure=9;staticconstdoubleicon=20;staticconstdoubleiconMedium=24;staticconstdoubleiconLarge=32;staticconstdoublerail=56;staticconstdoubleheader=60;staticconstdoublestatusBar=30;staticconstdoublelistTileTrailingMax=112;staticconstdoubleprimaryPaneBreakpoint=400;staticconstdoubleprimaryPaneContentBreakpoint=800;staticconstdoublesecondaryPaneBreakpoint=1120;staticconstdoublesidebar=300;staticconstdoubleinspector=350;staticconstdoublemenu=200;staticconstdoublecommandMenu=300;staticconstdoublemenuHeader=28;staticconstdoublemenuItem=28;}",
	"KlpSpace": "abstractfinalclassKlpSpace{staticconstdoublexxs=2;staticconstdoublexs=4;staticconstdoublesm=8;staticconstdoublemd=12;staticconstdoublelg=16;staticconstdoublexl=24;staticconstdoublexxl=32;staticconstdoublesectionLarge=48;staticconstdoublepage=64;staticconstdoublepageLarge=96;}",
	"KlpTransparency": "abstractfinalclassKlpTransparency{staticconstdoublelightPaneOpacity=0.88;staticconstdoubledarkPaneOpacity=0.72;}",
	"KlpTypography": "abstractfinalclassKlpTypography{staticconstStringsansFamily='packages/kallopis/NotoSansTC';staticconstList<String>sansFallback=['NotoSansTC','MicrosoftJhengHeiUI','MicrosoftJhengHei','PingFangTC','sans-serif'];staticconstStringmonoFamily='packages/kallopis/IBMPlexMono';staticconstList<String>monoFallback=[sansFamily,'IBMPlexMono','Consolas','CourierNew','monospace'];staticconstStringuiFamily=sansFamily;staticconstList<String>uiFallback=sansFallback;staticconstStringbodyFamily=sansFamily;staticconstList<String>bodyFallback=sansFallback;staticconstdoublemicro=10;staticconstdoublecaption=12;staticconstdoublesmall=12;staticconstdoublesub=14;staticconstdoublebody=16;staticconstdoublelead=18;staticconstdoubleh4=22;staticconstdoubleh3=28;staticconstdoublesection=28;staticconstdoubleheadingSmall=22;staticconstdoubleh2=36;staticconstdoubleheading=36;staticconstdoubleeditorHeading=36;staticconstdoubleh1=48;staticconstdoubletitle=48;staticconstdoubleheadline=48;staticconstdoubledisplay=64;staticconstdoublehero=64;staticconstdoublemicroLineHeight=1.200;staticconstdoublecaptionLineHeight=1.333;staticconstdoublesubLineHeight=1.428;staticconstdoublebodyLineHeight=1.500;staticconstdoubleleadLineHeight=1.555;staticconstdoubleh4LineHeight=1.272;staticconstdoubleh3LineHeight=1.285;staticconstdoubleh2LineHeight=1.222;staticconstdoubleh1LineHeight=1.166;staticconstdoubledisplayLineHeight=1.125;staticconstdoubledisplayLetterSpacing=-0.5;staticconstdoublelabelLetterSpacing=1.2;staticconstdoubleuiBaselineOffset=0;staticconstFontWeightregular=FontWeight.w400;staticconstFontWeightmedium=FontWeight.w400;staticconstFontWeightsemibold=FontWeight.w600;staticconstFontWeightbold=FontWeight.w700;staticconstFontWeightextraBold=FontWeight.w700;}",
};

// 遷移前唯一同名非 legacy 型別；保留精確路徑、正文與 library 指向。
const _frozenHomonyms = <String, String>{
	'lib/src/styling/primitives/klp_radius.dart': "part of 'klp_style_value.dart';\nfinal class KlpRadius extends KlpStyleValue {\n  final double value;\n\n  KlpRadius(this.value) {\n    if (!value.isFinite || value < 0) {\n      throw KlpContractError(\n        'invalid_primitive_value',\n        'radius.value: expected a finite non-negative number.',\n      );\n    }\n  }\n}",
};

void main() {
	test('old baseline public values stay frozen', () {

		// KlpCodeMetrics 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpCodeMetrics.actionButtonSize, const <double>[26].single, 'KlpCodeMetrics.actionButtonSize');
		_expectValue<double>(stable.KlpCodeMetrics.actionIconSize, const <double>[14].single, 'KlpCodeMetrics.actionIconSize');
		_expectValue<double>(stable.KlpCodeMetrics.headerHeight, const <double>[32].single, 'KlpCodeMetrics.headerHeight');
		_expectValue<double>(stable.KlpCodeMetrics.terminalDot, const <double>[4].single, 'KlpCodeMetrics.terminalDot');
		_expectValue<double>(stable.KlpCodeMetrics.terminalDotGap, const <double>[3].single, 'KlpCodeMetrics.terminalDotGap');
		_expectValue<double>(stable.KlpCodeMetrics.terminalGroupGap, const <double>[8].single, 'KlpCodeMetrics.terminalGroupGap');
		_expectValue<double>(stable.KlpCodeMetrics.headerPaddingHorizontal, const <double>[10].single, 'KlpCodeMetrics.headerPaddingHorizontal');
		_expectValue<double>(stable.KlpCodeMetrics.bodyPaddingHorizontal, const <double>[10].single, 'KlpCodeMetrics.bodyPaddingHorizontal');
		_expectValue<double>(stable.KlpCodeMetrics.bodyPaddingVertical, const <double>[8].single, 'KlpCodeMetrics.bodyPaddingVertical');
		_expectValue<double>(stable.KlpCodeMetrics.lineNumberWidth, const <double>[32].single, 'KlpCodeMetrics.lineNumberWidth');
		_expectValue<double>(stable.KlpCodeMetrics.wrappedLineWidth, const <double>[520].single, 'KlpCodeMetrics.wrappedLineWidth');
		_expectValue<double>(stable.KlpCodeMetrics.defaultMaximumHeight, const <double>[320].single, 'KlpCodeMetrics.defaultMaximumHeight');

		// KlpControlMetrics 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpControlMetrics.segmentedDenseInset, const <double>[3].single, 'KlpControlMetrics.segmentedDenseInset');
		_expectValue<double>(stable.KlpControlMetrics.segmentedDenseContentInset, const <double>[0].single, 'KlpControlMetrics.segmentedDenseContentInset');
		_expectValue<double>(stable.KlpControlMetrics.slidingSelectionHeight, const <double>[36].single, 'KlpControlMetrics.slidingSelectionHeight');
		_expectValue<double>(stable.KlpControlMetrics.slidingSelectionSegmentWidth, const <double>[41.4].single, 'KlpControlMetrics.slidingSelectionSegmentWidth');
		_expectValue<double>(stable.KlpControlMetrics.slidingSelectionPadding, const <double>[2].single, 'KlpControlMetrics.slidingSelectionPadding');
		_expectValue<double>(stable.KlpControlMetrics.slidingSelectionIndicatorHeight, const <double>[30].single, 'KlpControlMetrics.slidingSelectionIndicatorHeight');
		_expectValue<double>(stable.KlpControlMetrics.scrollbarThickness, const <double>[5].single, 'KlpControlMetrics.scrollbarThickness');
		_expectValue<double>(stable.KlpControlMetrics.scrollbarEndControlExtent, const <double>[14].single, 'KlpControlMetrics.scrollbarEndControlExtent');
		_expectValue<double>(stable.KlpControlMetrics.scrollbarEndControlRightInset, const <double>[(5 - 14) / 2].single, 'KlpControlMetrics.scrollbarEndControlRightInset');
		_expectValue<double>(stable.KlpControlMetrics.scrollbarPageIncrement, const <double>[0.8].single, 'KlpControlMetrics.scrollbarPageIncrement');

		// KlpElevation 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpElevation.menuBlurRadius, const <double>[18].single, 'KlpElevation.menuBlurRadius');
		_expectValue<double>(stable.KlpElevation.menuSpreadRadius, const <double>[1].single, 'KlpElevation.menuSpreadRadius');
		_expectValue<double>(stable.KlpElevation.menuOffsetY, const <double>[8].single, 'KlpElevation.menuOffsetY');
		_expectValue<double>(stable.KlpElevation.menuShadowOpacity, const <double>[0.22].single, 'KlpElevation.menuShadowOpacity');

		// KlpFormMetrics 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpFormMetrics.fieldHeight, const <double>[30].single, 'KlpFormMetrics.fieldHeight');
		_expectValue<double>(stable.KlpFormMetrics.selectionControl, const <double>[18].single, 'KlpFormMetrics.selectionControl');
		_expectValue<double>(stable.KlpFormMetrics.selectionIndicatorInset, const <double>[3.5].single, 'KlpFormMetrics.selectionIndicatorInset');
		_expectValue<double>(stable.KlpFormMetrics.selectionIndicator, const <double>[18 - 3.5 * 2].single, 'KlpFormMetrics.selectionIndicator');
		_expectValue<double>(stable.KlpFormMetrics.selectionIcon, const <double>[12].single, 'KlpFormMetrics.selectionIcon');
		_expectValue<double>(stable.KlpFormMetrics.toggleWidth, const <double>[30].single, 'KlpFormMetrics.toggleWidth');
		_expectValue<double>(stable.KlpFormMetrics.toggleHeight, const <double>[16].single, 'KlpFormMetrics.toggleHeight');
		_expectValue<double>(stable.KlpFormMetrics.toggleThumb, const <double>[12].single, 'KlpFormMetrics.toggleThumb');
		_expectValue<double>(stable.KlpFormMetrics.toggleInset, const <double>[2].single, 'KlpFormMetrics.toggleInset');

		// KlpLayoutGap 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpLayoutGap.lg, const <double>[10].single, 'KlpLayoutGap.lg');

		// KlpLine 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpLine.hairline, const <double>[1].single, 'KlpLine.hairline');
		_expectValue<double>(stable.KlpLine.width, const <double>[2].single, 'KlpLine.width');
		_expectValue<double>(stable.KlpLine.dashedLength, const <double>[3].single, 'KlpLine.dashedLength');
		_expectValue<double>(stable.KlpLine.dashedGap, const <double>[2].single, 'KlpLine.dashedGap');
		_expectValue<double>(stable.KlpLine.dashedOpacity, const <double>[0.78].single, 'KlpLine.dashedOpacity');

		// KlpMotion 的公開值、型別與順序保留原契約。
		_expectValue<Duration>(stable.KlpMotion.themeTransition, const <Duration>[Duration.zero].single, 'KlpMotion.themeTransition');
		_expectValue<Duration>(stable.KlpMotion.styleTransition, const <Duration>[Duration.zero].single, 'KlpMotion.styleTransition');

		// KlpPlaceholderMetrics 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpPlaceholderMetrics.minimumHeight, const <double>[120].single, 'KlpPlaceholderMetrics.minimumHeight');
		_expectValue<double>(stable.KlpPlaceholderMetrics.markerSize, const <double>[6].single, 'KlpPlaceholderMetrics.markerSize');
		_expectValue<double>(stable.KlpPlaceholderMetrics.contentPaddingHorizontal, const <double>[16].single, 'KlpPlaceholderMetrics.contentPaddingHorizontal');
		_expectValue<double>(stable.KlpPlaceholderMetrics.contentPaddingVertical, const <double>[12].single, 'KlpPlaceholderMetrics.contentPaddingVertical');
		_expectValue<double>(stable.KlpPlaceholderMetrics.contentGap, const <double>[4].single, 'KlpPlaceholderMetrics.contentGap');
		_expectValue<double>(stable.KlpPlaceholderMetrics.actionLeadingGap, const <double>[4].single, 'KlpPlaceholderMetrics.actionLeadingGap');
		_expectValue<double>(stable.KlpPlaceholderMetrics.actionPaddingHorizontal, const <double>[12].single, 'KlpPlaceholderMetrics.actionPaddingHorizontal');
		_expectValue<double>(stable.KlpPlaceholderMetrics.actionPaddingVertical, const <double>[5].single, 'KlpPlaceholderMetrics.actionPaddingVertical');
		_expectValue<double>(stable.KlpPlaceholderMetrics.hatchBand, const <double>[10.5].single, 'KlpPlaceholderMetrics.hatchBand');
		_expectValue<double>(stable.KlpPlaceholderMetrics.hatchGap, const <double>[10.5].single, 'KlpPlaceholderMetrics.hatchGap');
		_expectValue<double>(stable.KlpPlaceholderMetrics.hatchStrokeWidth, const <double>[10.5].single, 'KlpPlaceholderMetrics.hatchStrokeWidth');
		_expectValue<double>(stable.KlpPlaceholderMetrics.darkHatchColorMix, const <double>[0.18].single, 'KlpPlaceholderMetrics.darkHatchColorMix');
		_expectValue<double>(stable.KlpPlaceholderMetrics.latentStrokeOpacity, const <double>[0.32].single, 'KlpPlaceholderMetrics.latentStrokeOpacity');
		_expectValue<double>(stable.KlpPlaceholderMetrics.labelLetterSpacing, const <double>[1.32].single, 'KlpPlaceholderMetrics.labelLetterSpacing');
		_expectValue<double>(stable.KlpPlaceholderMetrics.detailMaximumWidth, const <double>[336].single, 'KlpPlaceholderMetrics.detailMaximumWidth');

		// KlpRadius 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpRadius.none, const <double>[0].single, 'KlpRadius.none');
		_expectValue<double>(stable.KlpRadius.sm, const <double>[2].single, 'KlpRadius.sm');
		_expectValue<double>(stable.KlpRadius.md, const <double>[8].single, 'KlpRadius.md');
		_expectValue<double>(stable.KlpRadius.lg, const <double>[16].single, 'KlpRadius.lg');
		_expectValue<double>(stable.KlpRadius.full, const <double>[9999].single, 'KlpRadius.full');
		_expectValue<double>(stable.KlpRadius.control, const <double>[8].single, 'KlpRadius.control');
		_expectValue<double>(stable.KlpRadius.card, const <double>[8].single, 'KlpRadius.card');
		_expectValue<double>(stable.KlpRadius.panel, const <double>[16].single, 'KlpRadius.panel');
		_expectValue<double>(stable.KlpRadius.pill, const <double>[9999].single, 'KlpRadius.pill');

		// KlpSize 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpSize.controlSmall, const <double>[32].single, 'KlpSize.controlSmall');
		_expectValue<double>(stable.KlpSize.control, const <double>[40].single, 'KlpSize.control');
		_expectValue<double>(stable.KlpSize.controlLarge, const <double>[48].single, 'KlpSize.controlLarge');
		_expectValue<double>(stable.KlpSize.controlXLarge, const <double>[56].single, 'KlpSize.controlXLarge');
		_expectValue<double>(stable.KlpSize.segmentedDense, const <double>[30].single, 'KlpSize.segmentedDense');
		_expectValue<double>(stable.KlpSize.segmentedDenseItem, const <double>[24].single, 'KlpSize.segmentedDenseItem');
		_expectValue<double>(stable.KlpSize.iconButton, const <double>[32].single, 'KlpSize.iconButton');
		_expectValue<double>(stable.KlpSize.tab, const <double>[32].single, 'KlpSize.tab');
		_expectValue<double>(stable.KlpSize.iconSmall, const <double>[14].single, 'KlpSize.iconSmall');
		_expectValue<double>(stable.KlpSize.iconBase, const <double>[16].single, 'KlpSize.iconBase');
		_expectValue<double>(stable.KlpSize.disclosure, const <double>[9].single, 'KlpSize.disclosure');
		_expectValue<double>(stable.KlpSize.icon, const <double>[20].single, 'KlpSize.icon');
		_expectValue<double>(stable.KlpSize.iconMedium, const <double>[24].single, 'KlpSize.iconMedium');
		_expectValue<double>(stable.KlpSize.iconLarge, const <double>[32].single, 'KlpSize.iconLarge');
		_expectValue<double>(stable.KlpSize.rail, const <double>[56].single, 'KlpSize.rail');
		_expectValue<double>(stable.KlpSize.header, const <double>[60].single, 'KlpSize.header');
		_expectValue<double>(stable.KlpSize.statusBar, const <double>[30].single, 'KlpSize.statusBar');
		_expectValue<double>(stable.KlpSize.listTileTrailingMax, const <double>[112].single, 'KlpSize.listTileTrailingMax');
		_expectValue<double>(stable.KlpSize.primaryPaneBreakpoint, const <double>[400].single, 'KlpSize.primaryPaneBreakpoint');
		_expectValue<double>(stable.KlpSize.primaryPaneContentBreakpoint, const <double>[800].single, 'KlpSize.primaryPaneContentBreakpoint');
		_expectValue<double>(stable.KlpSize.secondaryPaneBreakpoint, const <double>[1120].single, 'KlpSize.secondaryPaneBreakpoint');
		_expectValue<double>(stable.KlpSize.sidebar, const <double>[300].single, 'KlpSize.sidebar');
		_expectValue<double>(stable.KlpSize.inspector, const <double>[350].single, 'KlpSize.inspector');
		_expectValue<double>(stable.KlpSize.menu, const <double>[200].single, 'KlpSize.menu');
		_expectValue<double>(stable.KlpSize.commandMenu, const <double>[300].single, 'KlpSize.commandMenu');
		_expectValue<double>(stable.KlpSize.menuHeader, const <double>[28].single, 'KlpSize.menuHeader');
		_expectValue<double>(stable.KlpSize.menuItem, const <double>[28].single, 'KlpSize.menuItem');

		// KlpSpace 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpSpace.xxs, const <double>[2].single, 'KlpSpace.xxs');
		_expectValue<double>(stable.KlpSpace.xs, const <double>[4].single, 'KlpSpace.xs');
		_expectValue<double>(stable.KlpSpace.sm, const <double>[8].single, 'KlpSpace.sm');
		_expectValue<double>(stable.KlpSpace.md, const <double>[12].single, 'KlpSpace.md');
		_expectValue<double>(stable.KlpSpace.lg, const <double>[16].single, 'KlpSpace.lg');
		_expectValue<double>(stable.KlpSpace.xl, const <double>[24].single, 'KlpSpace.xl');
		_expectValue<double>(stable.KlpSpace.xxl, const <double>[32].single, 'KlpSpace.xxl');
		_expectValue<double>(stable.KlpSpace.sectionLarge, const <double>[48].single, 'KlpSpace.sectionLarge');
		_expectValue<double>(stable.KlpSpace.page, const <double>[64].single, 'KlpSpace.page');
		_expectValue<double>(stable.KlpSpace.pageLarge, const <double>[96].single, 'KlpSpace.pageLarge');

		// KlpTransparency 的公開值、型別與順序保留原契約。
		_expectValue<double>(stable.KlpTransparency.lightPaneOpacity, const <double>[0.88].single, 'KlpTransparency.lightPaneOpacity');
		_expectValue<double>(stable.KlpTransparency.darkPaneOpacity, const <double>[0.72].single, 'KlpTransparency.darkPaneOpacity');

		// KlpTypography 的公開值、型別與順序保留原契約。
		_expectValue<String>(stable.KlpTypography.sansFamily, const <String>['packages/kallopis/Noto Sans TC'].single, 'KlpTypography.sansFamily');
		_expectValue<List<String>>(stable.KlpTypography.sansFallback, const <List<String>>[[ 'Noto Sans TC', 'Microsoft JhengHei UI', 'Microsoft JhengHei', 'PingFang TC', 'sans-serif', ]].single, 'KlpTypography.sansFallback');
		_expectValue<String>(stable.KlpTypography.monoFamily, const <String>['packages/kallopis/IBM Plex Mono'].single, 'KlpTypography.monoFamily');
		_expectValue<List<String>>(stable.KlpTypography.monoFallback, const <List<String>>[[ 'packages/kallopis/Noto Sans TC', 'IBM Plex Mono', 'Consolas', 'Courier New', 'monospace', ]].single, 'KlpTypography.monoFallback');
		_expectValue<String>(stable.KlpTypography.uiFamily, const <String>['packages/kallopis/Noto Sans TC'].single, 'KlpTypography.uiFamily');
		_expectValue<List<String>>(stable.KlpTypography.uiFallback, const <List<String>>[[ 'Noto Sans TC', 'Microsoft JhengHei UI', 'Microsoft JhengHei', 'PingFang TC', 'sans-serif', ]].single, 'KlpTypography.uiFallback');
		_expectValue<String>(stable.KlpTypography.bodyFamily, const <String>['packages/kallopis/Noto Sans TC'].single, 'KlpTypography.bodyFamily');
		_expectValue<List<String>>(stable.KlpTypography.bodyFallback, const <List<String>>[[ 'Noto Sans TC', 'Microsoft JhengHei UI', 'Microsoft JhengHei', 'PingFang TC', 'sans-serif', ]].single, 'KlpTypography.bodyFallback');
		_expectValue<double>(stable.KlpTypography.micro, const <double>[10].single, 'KlpTypography.micro');
		_expectValue<double>(stable.KlpTypography.caption, const <double>[12].single, 'KlpTypography.caption');
		_expectValue<double>(stable.KlpTypography.small, const <double>[12].single, 'KlpTypography.small');
		_expectValue<double>(stable.KlpTypography.sub, const <double>[14].single, 'KlpTypography.sub');
		_expectValue<double>(stable.KlpTypography.body, const <double>[16].single, 'KlpTypography.body');
		_expectValue<double>(stable.KlpTypography.lead, const <double>[18].single, 'KlpTypography.lead');
		_expectValue<double>(stable.KlpTypography.h4, const <double>[22].single, 'KlpTypography.h4');
		_expectValue<double>(stable.KlpTypography.h3, const <double>[28].single, 'KlpTypography.h3');
		_expectValue<double>(stable.KlpTypography.section, const <double>[28].single, 'KlpTypography.section');
		_expectValue<double>(stable.KlpTypography.headingSmall, const <double>[22].single, 'KlpTypography.headingSmall');
		_expectValue<double>(stable.KlpTypography.h2, const <double>[36].single, 'KlpTypography.h2');
		_expectValue<double>(stable.KlpTypography.heading, const <double>[36].single, 'KlpTypography.heading');
		_expectValue<double>(stable.KlpTypography.editorHeading, const <double>[36].single, 'KlpTypography.editorHeading');
		_expectValue<double>(stable.KlpTypography.h1, const <double>[48].single, 'KlpTypography.h1');
		_expectValue<double>(stable.KlpTypography.title, const <double>[48].single, 'KlpTypography.title');
		_expectValue<double>(stable.KlpTypography.headline, const <double>[48].single, 'KlpTypography.headline');
		_expectValue<double>(stable.KlpTypography.display, const <double>[64].single, 'KlpTypography.display');
		_expectValue<double>(stable.KlpTypography.hero, const <double>[64].single, 'KlpTypography.hero');
		_expectValue<double>(stable.KlpTypography.microLineHeight, const <double>[1.200].single, 'KlpTypography.microLineHeight');
		_expectValue<double>(stable.KlpTypography.captionLineHeight, const <double>[1.333].single, 'KlpTypography.captionLineHeight');
		_expectValue<double>(stable.KlpTypography.subLineHeight, const <double>[1.428].single, 'KlpTypography.subLineHeight');
		_expectValue<double>(stable.KlpTypography.bodyLineHeight, const <double>[1.500].single, 'KlpTypography.bodyLineHeight');
		_expectValue<double>(stable.KlpTypography.leadLineHeight, const <double>[1.555].single, 'KlpTypography.leadLineHeight');
		_expectValue<double>(stable.KlpTypography.h4LineHeight, const <double>[1.272].single, 'KlpTypography.h4LineHeight');
		_expectValue<double>(stable.KlpTypography.h3LineHeight, const <double>[1.285].single, 'KlpTypography.h3LineHeight');
		_expectValue<double>(stable.KlpTypography.h2LineHeight, const <double>[1.222].single, 'KlpTypography.h2LineHeight');
		_expectValue<double>(stable.KlpTypography.h1LineHeight, const <double>[1.166].single, 'KlpTypography.h1LineHeight');
		_expectValue<double>(stable.KlpTypography.displayLineHeight, const <double>[1.125].single, 'KlpTypography.displayLineHeight');
		_expectValue<double>(stable.KlpTypography.displayLetterSpacing, const <double>[-0.5].single, 'KlpTypography.displayLetterSpacing');
		_expectValue<double>(stable.KlpTypography.labelLetterSpacing, const <double>[1.2].single, 'KlpTypography.labelLetterSpacing');
		_expectValue<double>(stable.KlpTypography.uiBaselineOffset, const <double>[0].single, 'KlpTypography.uiBaselineOffset');
		_expectValue<FontWeight>(stable.KlpTypography.regular, const <FontWeight>[FontWeight.w400].single, 'KlpTypography.regular');
		_expectValue<FontWeight>(stable.KlpTypography.medium, const <FontWeight>[FontWeight.w400].single, 'KlpTypography.medium');
		_expectValue<FontWeight>(stable.KlpTypography.semibold, const <FontWeight>[FontWeight.w600].single, 'KlpTypography.semibold');
		_expectValue<FontWeight>(stable.KlpTypography.bold, const <FontWeight>[FontWeight.w700].single, 'KlpTypography.bold');
		_expectValue<FontWeight>(stable.KlpTypography.extraBold, const <FontWeight>[FontWeight.w700].single, 'KlpTypography.extraBold');
	});

	test('frozen declaration snapshot matches public baseline', () {
		for (final entry in _parts.entries) {
			final moved = File('lib/src/styling/legacy_metrics/${entry.key}');

			// 舊版探針與搬移後驗證共用固定快照；存在性另由唯一來源檢查保護。
			final source = moved.existsSync() ? moved : File('lib/src/foundation/metrics/${entry.key}');
			final declarations = _unit(source.readAsStringSync()).declarations.map((node) => node.toSource()).join();
			expect(_compact(declarations), _frozenDeclarations[entry.value], reason: '${entry.value} 原始公開宣告快照必須吻合。');
		}
		for (final entry in _frozenHomonyms.entries) {
			// 對真實舊版來源驗證同名型別快照，避免只靠合成資料自我比對。
			final original = File(entry.key).readAsStringSync();
			expect(_tokenSignature(_unit(original)), _tokenSignature(_unit(entry.value)), reason: '${entry.key} 的原始非 legacy 宣告必須吻合。');
		}
	});

	test('13 public types have one identity across all entrances', () {
		expect(identical(stable.KlpCodeMetrics, owner.KlpCodeMetrics), isTrue, reason: 'KlpCodeMetrics Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpControlMetrics, owner.KlpControlMetrics), isTrue, reason: 'KlpControlMetrics Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpElevation, owner.KlpElevation), isTrue, reason: 'KlpElevation Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpFormMetrics, owner.KlpFormMetrics), isTrue, reason: 'KlpFormMetrics Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpLayoutGap, owner.KlpLayoutGap), isTrue, reason: 'KlpLayoutGap Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpLine, owner.KlpLine), isTrue, reason: 'KlpLine Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpMotion, owner.KlpMotion), isTrue, reason: 'KlpMotion Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpPlaceholderMetrics, owner.KlpPlaceholderMetrics), isTrue, reason: 'KlpPlaceholderMetrics Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpRadius, owner.KlpRadius), isTrue, reason: 'KlpRadius Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpSize, owner.KlpSize), isTrue, reason: 'KlpSize Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpSpace, owner.KlpSpace), isTrue, reason: 'KlpSpace Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpTransparency, owner.KlpTransparency), isTrue, reason: 'KlpTransparency Stable 與 styling 唯一來源必須同身分。');
		expect(identical(stable.KlpTypography, owner.KlpTypography), isTrue, reason: 'KlpTypography Stable 與 styling 唯一來源必須同身分。');
	});

	test('styling boundary rejects every foundation dependency', () {
		final sources = _sources();
		final violations = _foundationPaths(sources);
		expect(violations, isEmpty, reason: '完整 styling 必須只朝下相依：\n${violations.join('\n')}');
	});

	test('boundary synthetics detect direct conditional part and barrel routes', () {
		const origin = 'lib/src/styling/probe.dart';
		const foundation = 'lib/src/foundation/blocked.dart';
		const lower = 'lib/src/kernel/helper.dart';
		const cases = <String, String>{
			'package import': "import 'package:kallopis/src/foundation/blocked.dart';",
			'relative import': "import '../foundation/blocked.dart';",
			'normalized relative': "import './internal/../../foundation/blocked.dart';",
			'conditional import': "import '../kernel/helper.dart' if (dart.library.io) '../foundation/blocked.dart';",
			'conditional package export': "export '../kernel/helper.dart' if (dart.library.html) 'package:kallopis/src/foundation/blocked.dart';",
			'export': "export '../foundation/blocked.dart';",
			'part': "part '../foundation/blocked.dart';",
			'part of URI': "part of '../foundation/blocked.dart';",
			'named part of': 'part of upper.authority;',
			'barrel': "import 'package:kallopis/bridge.dart';",
		};
		for (final entry in cases.entries) {
			final sources = <String, String>{
				origin: entry.value,
				foundation: "library upper.authority; part '../styling/probe.dart';",
				lower: '',
				'lib/bridge.dart': "export 'bridge_second.dart';",
				'lib/bridge_second.dart': "export 'src/foundation/blocked.dart';",
			};
			expect(_foundationPaths(sources), isNotEmpty, reason: '${entry.key} 旁路必須攔截。');
		}
	});

	test('boundary synthetics permit own helpers lower libraries and text', () {
		const sources = <String, String>{
			'lib/src/styling/probe.dart': "library own.authority; import 'internal/helper.dart'; export '../kernel/helper.dart'; part 'piece.dart';",
			'lib/src/styling/internal/helper.dart': "// import '../../foundation/blocked.dart';\nconst text = \"export '../../foundation/blocked.dart';\";",
			'lib/src/styling/piece.dart': 'part of own.authority;',
			'lib/src/kernel/helper.dart': "export 'foundation_helper.dart';",
			'lib/src/kernel/foundation_helper.dart': '',
			'lib/src/foundation/blocked.dart': '',
		};
		expect(_foundationPaths(sources), isEmpty, reason: '正常同模組私有 helper、下層檔案及文字不得誤報。');
	});

	test('legacy uniqueness keeps frozen homonyms and rejects duplicate authorities', () {
		const ownerPath = 'lib/src/styling/legacy_metrics/klp_radius.dart';
		const legacy = "part of 'klp_metrics.dart'; abstract final class KlpRadius { static const double md = 8; }";
		final legitimate = <String, String>{..._frozenHomonyms, ownerPath: legacy};
		expect(_legacyLocations(legitimate)['KlpRadius'], [ownerPath], reason: '原有 primitive 同名型別合法且不算第二份 legacy 權威。');
		for (final extraPath in ['lib/src/styling/legacy_metrics/copy.dart', 'lib/src/styling/primitives/copy.dart', 'lib/src/foundation/metrics/copy.dart']) {
			final duplicate = {...legitimate, extraPath: legacy};
			expect(_legacyLocations(duplicate)['KlpRadius'], hasLength(2), reason: '$extraPath 的第二份 legacy 宣告必須被偵測。');
		}
		final replacedHomonym = {...legitimate, _frozenHomonyms.keys.single: legacy};
		expect(_legacyLocations(replacedHomonym)['KlpRadius'], hasLength(2), reason: '原合法同名路徑不能拿來藏第二份 legacy 實作。');
		final duplicateInsidePart = {...legitimate, ownerPath: '$legacy abstract final class KlpRadius {}'};
		expect(_legacyLocations(duplicateInsidePart)['KlpRadius'], hasLength(2), reason: '同一 part 內兩個宣告也必須拒絕。');
	});

	test('metrics use one complete reciprocal library and public export', () {
		final sources = _sources();
		expect(sources.containsKey(_owner), isTrue, reason: 'styling 必須擁有唯一 metrics library。');
		if (!sources.containsKey(_owner)) return;

		final stableExports = _unit(sources['lib/kallopis_foundation.dart']!).directives.whereType<ExportDirective>().map((directive) => directive.uri.stringValue);
		expect(stableExports, contains('src/styling/legacy_metrics/klp_metrics.dart'), reason: 'Stable 必須直接匯出唯一 metrics owner。');
		final rootUnit = _unit(sources[_owner]!);
		final rootParts = rootUnit.directives.whereType<PartDirective>().map((part) => _resolve(_owner, part.uri.stringValue!)).toList();
		final expectedPaths = _parts.keys.map((name) => 'lib/src/styling/legacy_metrics/$name').toSet();
		expect(rootParts, hasLength(13));
		expect(rootParts.toSet(), expectedPaths);
		expect(rootUnit.declarations, isEmpty, reason: '唯一根 library 不可另造 metrics 宣告。');
		for (final entry in _parts.entries) {
			final path = 'lib/src/styling/legacy_metrics/${entry.key}';
			expect(sources.containsKey('lib/src/foundation/metrics/${entry.key}'), isFalse, reason: '舊 part 必須退役。');
			expect(sources.containsKey(path), isTrue, reason: '$path 必須存在。');
			final partUnit = _unit(sources[path]!);
			expect(partUnit.directives, hasLength(1));
			final partOf = partUnit.directives.single;
			expect(partOf, isA<PartOfDirective>());
			if (partOf is! PartOfDirective) continue;

			expect(partOf.uri, isNotNull, reason: '各 part 必須明確回指唯一 library。');
			expect(_resolve(path, partOf.uri!.stringValue!), _owner);
			final declarations = partUnit.declarations.map((node) => node.toSource()).join();
			expect(_compact(declarations), _frozenDeclarations[entry.value], reason: '${entry.value} 的全部 const 宣告、型別、順序與值保持原樣。');
		}

		// 同名不等於同 library；只有精確凍結的既有非 legacy 宣告可保留。
		for (final entry in _frozenHomonyms.entries) {
			expect(sources.containsKey(entry.key), isTrue, reason: '既有獨立 library 的同名型別不得消失。');
			expect(_tokenSignature(_unit(sources[entry.key]!)), _tokenSignature(_unit(entry.value)), reason: '${entry.key} 的既有同名宣告與 part 權威不得變更。');
		}
		final locationsByType = _legacyLocations(sources);
		for (final entry in _parts.entries) {
			expect(locationsByType[entry.value], ['lib/src/styling/legacy_metrics/${entry.key}'], reason: '${entry.value} legacy metrics 必須只有一份實體宣告。');
		}
	});
}

void _expectValue<T>(T actual, T expected, String name) {
	expect(actual, expected, reason: '$name 不得變更遷移前公開值。');
}

Map<String, List<String>> _legacyLocations(Map<String, String> sources) {
	final locations = {for (final type in _parts.values) type: <String>[]};
	for (final entry in sources.entries) {
		final unit = _unit(entry.value);
		final frozen = _frozenHomonyms[entry.key];
		if (frozen != null && _tokenSignature(unit) == _tokenSignature(_unit(frozen))) continue;

		for (final declaration in unit.declarations.whereType<ClassDeclaration>()) {
			locations[declaration.namePart.typeName.lexeme]?.add(entry.key);
		}
	}
	return locations;
}

String _tokenSignature(AstNode node) {
	// token 保留字串內容與所有運算子，只忽略註解和排版空白。
	final tokens = <String>[];
	var token = node.beginToken;
	while (true) {
		tokens.add(token.lexeme);
		if (identical(token, node.endToken)) break;

		token = token.next!;
	}
	return tokens.join('\u0000');
}

String _compact(String source) => source.replaceAll(RegExp(r'\s+'), '');

CompilationUnit _unit(String source) {
	// 使用 Dart 解析器只辨認真實語法；註解、普通字串不會成為相依。
	return parseString(content: source, throwIfDiagnostics: false).unit;
}

Map<String, String> _sources() {
	// 每次從目前套件讀取實際來源，涵蓋新檔案與所有公開轉匯出路線。
	return {for (final file in Directory('lib').listSync(recursive: true).whereType<File>().where((file) => file.path.endsWith('.dart'))) file.path.replaceAll(r'\', '/'): file.readAsStringSync()};
}

String? _resolve(String origin, String target) {
	if (target.startsWith('package:kallopis/')) return Uri.parse('lib/${Uri.parse(target).path.substring('kallopis/'.length)}').normalizePath().path;
	if (Uri.parse(target).hasScheme) return null;

	return Uri.parse(origin).resolve(target).normalizePath().path;
}

List<String> _foundationPaths(Map<String, String> sources) {
	// 步驟 1：建立整個套件的 directive 圖與 named library 對照。
	final units = {for (final entry in sources.entries) entry.key: _unit(entry.value)};
	final libraryNames = <String, List<String>>{};
	for (final entry in units.entries) {
		for (final directive in entry.value.directives.whereType<LibraryDirective>()) {
			final name = directive.name?.toSource();
			if (name != null) libraryNames.putIfAbsent(name, () => []).add(entry.key);
		}
	}
	final edges = <String, Set<String>>{};
	for (final entry in units.entries) {
		final targets = <String>{};
		for (final directive in entry.value.directives) {
			final uris = <String>[];
			if (directive is UriBasedDirective) {
				final uri = directive.uri.stringValue;
				if (uri != null) uris.add(uri);
			}
			if (directive is NamespaceDirective) {
				uris.addAll(directive.configurations.map((condition) => condition.uri.stringValue).whereType<String>());
			}
			if (directive is PartOfDirective) {
				final uri = directive.uri?.stringValue;
				if (uri != null) uris.add(uri);

				final name = directive.libraryName?.toSource();
				if (name != null) targets.addAll(libraryNames[name] ?? const []);
			}
			for (final uri in uris) {
				final target = _resolve(entry.key, uri);
				if (target != null) targets.add(target);
			}
		}
		edges[entry.key] = targets;
	}

	// 步驟 2：從每個 styling 檔案追蹤完整路線，包含多層 barrel 與 part。
	final violations = <String>[];
	for (final origin in sources.keys.where((path) => path.startsWith('lib/src/styling/'))) {
		final visited = <String>{};
		void visit(String path, List<String> route) {
			if (!visited.add(path)) return;
			if (path.startsWith('lib/src/foundation/')) {
				violations.add([...route, path].join(' -> '));
				return;
			}

			for (final target in edges[path] ?? const <String>{}) {
				visit(target, [...route, path]);
			}
		}
		visit(origin, const []);
	}
	return violations;
}
