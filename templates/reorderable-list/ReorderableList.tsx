import { useRef, useState, type ReactNode } from 'react';
import './reorderable-list.css';

export interface ReorderableListProps {
	/* ids：consumer 提供的穩定顯示順序；label：輔助技術辨識清單；children：各項呈現插槽。
	 * onMove：僅回報來源與目標，不保存、不決定業務身分；disabled：宿主忙碌或項目不能移動時停用。 */
	ids: readonly string[];
	label: string;
	children: (id: string) => ReactNode;
	onMove: (source: string, target: string) => void;
	disabled?: boolean;
}

export function ReorderableList({ ids, label, children, onMove, disabled = false }: ReorderableListProps) {

	// 只持有本次手勢身分，不讀取外部拖曳資料，避免其他清單誤觸。
	const source = useRef<string | null>(null);
	const [target, setTarget] = useState<string | null>(null);
	function clear() { source.current = null; setTarget(null); }
	return <div role="list" aria-label={label} className="klp-reorderable-list">{ids.map((id, index) => <div key={id} role="listitem" aria-posinset={index + 1} aria-setsize={ids.length} className="klp-reorderable-item" data-drop-target={target === id || undefined} draggable={!disabled && ids.length > 1} onDragStart={event => {
		if (disabled) { event.preventDefault(); return; }
		source.current = id;
		// Firefox 等宿主需要 drag payload；真正身分仍只信任此元件內的 ref。
		event.dataTransfer.setData('text/plain', id); event.dataTransfer.effectAllowed = 'move';
	}} onDragOver={event => { if (!disabled && source.current && source.current !== id) { event.preventDefault(); event.dataTransfer.dropEffect = 'move'; setTarget(id); } }} onDragLeave={() => setTarget(null)} onDragEnd={clear} onDrop={event => {
		event.preventDefault(); event.stopPropagation();
		if (!disabled && source.current && source.current !== id) onMove(source.current, id);
		clear();
	}} onKeyDownCapture={event => {
		if (disabled || !event.altKey || !['ArrowUp', 'ArrowDown'].includes(event.key)) return;
		const next = ids[index + (event.key === 'ArrowUp' ? -1 : 1)];
		if (!next) return;
		event.preventDefault(); event.stopPropagation(); onMove(id, next);
	}}>{children(id)}</div>)}</div>;
}
