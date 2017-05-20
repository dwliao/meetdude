import { createStore, combineReducers, applyMiddleware } from 'redux';
import { reducer as formReducer } from 'redux-form';
import { routerReducer } from 'react-router-redux';
import { composeWithDevTools } from 'redux-devtools-extension';
import user from './reducers/user';
import notifications from './reducers/notifications';
import page from './reducers/page';
import editor from './reducers/editor';

const composeEnhancers = composeWithDevTools({
  // Specify here name, actionsBlacklist, actionsCreators and other options if needed
});
export default createStore(
  combineReducers({
    form: formReducer,
    routing: routerReducer,
    user,
    notifications,
    page,
    editor,
  }),
  // preloadedState,
  composeEnhancers(
    applyMiddleware(),
    // other store enhancers if any
  ),
);
