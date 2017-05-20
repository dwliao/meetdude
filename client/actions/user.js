import { SET_USER_INFO } from '../constants';

export function setUserInfo(user) {
  return { type: SET_USER_INFO, payload: user };
}
