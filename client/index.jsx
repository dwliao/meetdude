import React from 'react';
import ReactDOM from 'react-dom';
import { Provider } from 'react-redux';
import { Router, Route, IndexRoute, Redirect, browserHistory } from 'react-router';
import { syncHistoryWithStore } from 'react-router-redux';
import MuiThemeProvider from 'material-ui/styles/MuiThemeProvider';
import injectTapEventPlugin from 'react-tap-event-plugin';
import store from './store';
import { setUserInfo } from './actions/user';
import { setNotifications } from './actions/notifications';
import {
  setPageUserInfo,
  setPagePosts,
} from './actions/page';
import {
  resetEditorState,
} from './actions/editor';
import UserService from './modules/UserService';
import PostService from './modules/PostService';
import AppBar from './components/AppBar';
import AppPage from './pages/AppPage';
import SignUpPage from './pages/SignUpPage';
import SignInPage from './pages/SignInPage';
import ProfilePage from './pages/ProfilePage';
import NotFoundPage from './pages/NotFoundPage';

function resetPageData() {
  store.dispatch(setPageUserInfo(null));
  store.dispatch(setPagePosts({
    posts: [],
    postsPageNumber: null,
    postsFinalPageNumber: null,
  }));
  store.dispatch(resetEditorState());
}

function run() {
  // Needed for onTouchTap
  // http://stackoverflow.com/a/34015469/988941
  injectTapEventPlugin();
  const history = syncHistoryWithStore(browserHistory, store);
  ReactDOM.render(
    <MuiThemeProvider>
      <Provider store={store}>
        <Router onUpdate={() => window.scrollTo(0, 0)} history={history}>
          <Route path="/" component={AppBar}>
            <Route path="/sign_up" component={SignUpPage} />
            <Route
              path="/sign_in"
              component={SignInPage}
              onEnter={(nextState, replace) => {
                if (UserService.isSignIn()) {
                  replace('/');
                }
              }}
            />
            <Route
              path="/sign_out"
              onEnter={(nextState, replace) => {
                UserService.signOut();
                store.dispatch(setUserInfo(null));
                store.dispatch(setNotifications({
                  notifications: [],
                  notificationsPageNumber: null,
                  notificationsFinalPageNumber: null,
                }));
                replace('/sign_in');
              }}
            />
            <Route
              path="/profile"
              component={ProfilePage}
              onEnter={(nextState, replace) => {
                if (!UserService.isSignIn()) {
                  replace('/sign_in');
                }
              }}
            />
            <Route path="/404" component={NotFoundPage} />
            <Route
              path=":userId"
              component={AppPage}
              onEnter={(nextState, replace, callback) => {
                resetPageData();
                if (!UserService.isSignIn()) {
                  replace('/sign_in');
                  callback();
                } else {
                  const user = store.getState().user;
                  const pageUserId = nextState.params.userId;
                  UserService.show(pageUserId).then((res) => {
                    store.dispatch(setPageUserInfo(res));
                    return PostService.getPost(user.auth_token, pageUserId, 0);
                  }).then((res) => {
                    store.dispatch(setPagePosts({
                      posts: res.data,
                      postsPageNumber: 0,
                      postsFinalPageNumber: res.final_page_number,
                    }));
                    callback();
                  }).catch(() => {
                    replace('/404');
                    callback();
                  });
                }
              }}
            />
            <IndexRoute
              component={AppPage}
              onEnter={(nextState, replace, callback) => {
                resetPageData();
                if (!UserService.isSignIn()) {
                  replace('/sign_in');
                  callback();
                } else {
                  // Do some stuff
                  callback();
                }
              }}
            />
          </Route>
          <Redirect from="*" to="/404" status={404} />
        </Router>
      </Provider>
    </MuiThemeProvider>,
    document.getElementById('root'),
  );
}

const loadedStates = ['complete', 'loaded', 'interactive'];
if (loadedStates.includes(document.readyState) && document.body) {
  run();
} else {
  window.addEventListener('DOMContentLoaded', run, false);
}
