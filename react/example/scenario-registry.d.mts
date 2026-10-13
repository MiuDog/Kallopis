/* 公開metadata不承載布局或handler，產品內容留在實際consumer。 */
export const reactScenarioRegistry: Readonly<Record<'vscode' | 'blockbench' | 'blender', Readonly<{ title: string; reference: string }>>>;
