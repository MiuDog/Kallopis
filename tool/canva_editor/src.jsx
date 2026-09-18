import React, {useCallback, useRef, useState} from 'react';
import {createRoot} from 'react-dom/client';
import {Excalidraw, MainMenu, convertToExcalidrawElements, newElementWith} from '@excalidraw/excalidraw';
import '@excalidraw/excalidraw/index.css';

window.EXCALIDRAW_ASSET_PATH = './';

function App() {
  const [initialData, setInitialData] = useState(null);
  const [transferTargets, setTransferTargets] = useState([]);
  const identity = useRef(null);
  const revision = useRef(0);
  const messageId = useRef(1000);
  const editor = useRef(null);
  const scene = useRef({elements: [], appState: {}, files: {}});
  const fingerprint = useRef('');
  const pendingReady = useRef(null);

  const send = useCallback((type, requestId, document, extra = {}) => {
    if (!identity.current) return;
    window.flutter_inappwebview.callHandler('KallopisCanva', {
      protocolVersion: 1,
      type,
      sessionId: identity.current.sessionId,
      requestId,
      revision: revision.current,
      ...(document ? {document} : {}),
      ...extra,
    });
  }, []);

  const onChange = useCallback((elements, appState, files) => {
    const nextScene = {
      elements: Array.from(elements),
      appState: {viewBackgroundColor: appState.viewBackgroundColor, gridSize: appState.gridSize, name: appState.name},
      files,
    };
    scene.current = nextScene;
    const nextFingerprint = JSON.stringify(nextScene);
    if (fingerprint.current === nextFingerprint) return;
    fingerprint.current = nextFingerprint;
    revision.current += 1;
    send('changed', messageId.current++);
  }, [send]);

  const onExcalidrawAPI = useCallback(() => {
    requestAnimationFrame(() => requestAnimationFrame(() => {
      const surface = document.querySelector('.excalidraw') || document.querySelector('canvas');
      if (surface) {
        surface.setAttribute('tabindex', '0');
        surface.focus();
      }
      if (pendingReady.current !== null) {
        send('ready', pendingReady.current);
        pendingReady.current = null;
      }
    }));
  }, [send]);

  const createStickyNote = useCallback(() => {
    const api = editor.current;
    if (!api) return;
    const state = api.getAppState();
    const [rectangle, text] = convertToExcalidrawElements([{
      type: 'rectangle',
      x: (300 - state.scrollX) / state.zoom.value,
      y: (240 - state.scrollY) / state.zoom.value,
      width: 240,
      height: 160,
      backgroundColor: '#ffec99',
      fillStyle: 'solid',
      label: {text: '便利貼'},
    }]);
    api.updateScene({elements: [...api.getSceneElementsIncludingDeleted(), rectangle, text]});
  }, []);

  const hideSelection = useCallback(() => {
    const api = editor.current;
    if (!api) return;
    const selected = api.getAppState().selectedElementIds;
    const all = api.getSceneElementsIncludingDeleted();
    const included = new Set(Object.keys(selected).filter((id) => selected[id]));
    let changed = true;
    while (changed) {
      changed = false;
      for (const element of all) {
        if (included.has(element.id)) {
          for (const bound of element.boundElements || []) {
            if (!included.has(bound.id)) changed = included.add(bound.id).size > 0;
          }
          if (element.containerId && !included.has(element.containerId)) changed = included.add(element.containerId).size > 0;
        }
        if (element.containerId && included.has(element.containerId) && !included.has(element.id)) changed = included.add(element.id).size > 0;
      }
    }
    const elements = all.map((element) => included.has(element.id)
      ? newElementWith(element, {isDeleted: true, customData: {...element.customData, planistHidden: true}})
      : element);
    api.updateScene({elements});
  }, []);

  const showHidden = useCallback(() => {
    const api = editor.current;
    if (!api) return;
    const elements = api.getSceneElementsIncludingDeleted().map((element) => element.customData?.planistHidden
      ? newElementWith(element, {isDeleted: false, customData: {...element.customData, planistHidden: false}})
      : element);
    api.updateScene({elements});
  }, []);

  const requestTransfer = useCallback((mode, targetDocumentId) => {
    const api = editor.current;
    if (!api || !identity.current?.projectId) return;
    const selected = api.getAppState().selectedElementIds;
    const all = api.getSceneElementsIncludingDeleted();
    const included = new Set(Object.keys(selected).filter((id) => selected[id]));
    let changed = true;
    while (changed) {
      changed = false;
      for (const element of all) {
        if (included.has(element.id)) {
          for (const bound of element.boundElements || []) {
            if (!included.has(bound.id)) changed = included.add(bound.id).size > 0;
          }
          if (element.containerId && !included.has(element.containerId)) changed = included.add(element.containerId).size > 0;
        }
        if (element.containerId && included.has(element.containerId) && !included.has(element.id)) changed = included.add(element.id).size > 0;
      }
    }
    if (!included.size) return;
    const operationId = `${Date.now().toString(36)}_${messageId.current++}`;
    send('transfer.request', messageId.current++, null, {
      operationId,
      targetDocumentId,
      mode,
      sourceElementIds: Array.from(included),
    });
  }, [send]);

  window.kallopisCanva = {
    receive(command) {
      if (command.type === 'open') {
        identity.current = command;
        revision.current = command.revision;
        scene.current = command.document;
        fingerprint.current = JSON.stringify({elements: command.document.elements, appState: command.document.appState, files: command.document.files});
        pendingReady.current = command.requestId;
        setTransferTargets(command.transferTargets || []);
        setInitialData({elements: command.document.elements, appState: command.document.appState, files: command.document.files});
      }
      else if (command.type === 'snapshot.request') {
        send('snapshot.response', command.requestId, {format: 'krepis.canva.excalidraw', schemaVersion: 1, ...scene.current});
      }
      else if (command.type === 'close') {
        identity.current = null;
      }
      else if (command.type === 'transfer.committed' && command.mode === 'move') {
        const removed = new Set(command.sourceElementIds || []);
        const elements = editor.current.getSceneElementsIncludingDeleted().filter((element) => !removed.has(element.id));
        editor.current.updateScene({elements});
      }
      else if (command.type === 'transfer.targets') {
        setTransferTargets(command.transferTargets || []);
      }
      else if (command.type === 'element.focus' && command.elementId) {
        const element = editor.current.getSceneElements().find((candidate) => candidate.id === command.elementId);
        if (!element) return;
        editor.current.updateScene({appState: {selectedElementIds: {[element.id]: true}}});
        editor.current.scrollToContent([element], {fitToViewport: false, animate: true});
      }
    },
  };

  if (!initialData) return null;
  const captureApi = (api) => {
    editor.current = api;
    onExcalidrawAPI();
  };
  return <div style={{height: '100vh'}}><Excalidraw initialData={initialData} onChange={onChange} excalidrawAPI={captureApi}>
    <MainMenu>
      <MainMenu.Item onSelect={createStickyNote}>新增便利貼</MainMenu.Item>
      <MainMenu.Item onSelect={hideSelection}>隱藏選取物件</MainMenu.Item>
      <MainMenu.Item onSelect={showHidden}>顯示隱藏物件</MainMenu.Item>
      {transferTargets.flatMap((target) => [
        <MainMenu.Item key={`copy-${target.documentId}`} onSelect={() => requestTransfer('copy', target.documentId)}>複製到「{target.name}」</MainMenu.Item>,
        <MainMenu.Item key={`move-${target.documentId}`} onSelect={() => requestTransfer('move', target.documentId)}>移動到「{target.name}」</MainMenu.Item>,
      ])}
      <MainMenu.Separator />
      <MainMenu.DefaultItems.SearchMenu />
      <MainMenu.DefaultItems.ChangeCanvasBackground />
      <MainMenu.DefaultItems.ClearCanvas />
      <MainMenu.DefaultItems.Help />
    </MainMenu>
  </Excalidraw></div>;
}

createRoot(document.getElementById('root')).render(<App />);
