import { SET_NOTIFICATIONS } from '../constants';

export function setNotifications(payload) {
  return { type: SET_NOTIFICATIONS, payload };
}
