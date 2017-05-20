import { EditorState } from 'draft-js';
import { SET_EDITOR_STATE, RESET_EDITOR_STATE } from '../constants';

export default function editor(state = EditorState.createEmpty(), action) {
  switch (action.type) {
    case SET_EDITOR_STATE:
      return action.payload;
    case RESET_EDITOR_STATE:
      return EditorState.createEmpty();
    default:
      return state;
  }
}
