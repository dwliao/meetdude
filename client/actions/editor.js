import { SET_EDITOR_STATE, RESET_EDITOR_STATE } from '../constants';

export function setEditorState(editorState) {
  return { type: SET_EDITOR_STATE, payload: editorState };
}

export function resetEditorState() {
  return { type: RESET_EDITOR_STATE };
}
