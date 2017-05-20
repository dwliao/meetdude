import { SET_USER_INFO } from '../constants';
import UserService from '../modules/UserService';

export default function user(state = UserService.isSignIn() ? UserService.getUserInfo() : null, action) {
  switch (action.type) {
    case SET_USER_INFO:
      return action.payload;
    default:
      return state;
  }
}
