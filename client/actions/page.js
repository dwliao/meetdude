import {
  SET_PAGE_USER_INFO,
  SET_PAGE_POSTS,
  ADD_PAGE_POSTS,
} from '../constants';

export function setPageUserInfo(user) {
  return { type: SET_PAGE_USER_INFO, payload: user };
}

export function setPagePosts(payload) {
  return { type: SET_PAGE_POSTS, payload };
}

export function addPagePosts(payload) {
  return { type: ADD_PAGE_POSTS, payload };
}
