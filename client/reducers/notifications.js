import { SET_NOTIFICATIONS, ADD_NOTIFICATIONS } from '../constants';

export default function notifications(state = {
  notifications: [],
  notificationsPageNumber: null,
  notificationsFinalPageNumber: null,
}, action) {
  switch (action.type) {
    case SET_NOTIFICATIONS:
      return Object.assign({}, state, {
        notifications: action.payload.notifications,
        notificationsPageNumber: action.payload.notificationsPageNumber,
        notificationsFinalPageNumber: action.payload.notificationsFinalPageNumber,
      });
    case ADD_NOTIFICATIONS:
      return Object.assign({}, state, {
        notifications: state.notifications.concat(action.payload.notifications),
        notificationsPageNumber: action.payload.notificationsPageNumber,
        notificationsFinalPageNumber: action.payload.notificationsFinalPageNumber,
      });
    default:
      return state;
  }
}
