import {
  SET_PAGE_USER_INFO,
  SET_PAGE_POSTS,
  ADD_PAGE_POSTS,
} from '../constants';

export default function page(state = {
  user: null,
  posts: [],
  postsPageNumber: null,
  postsFinalPageNumber: null,
}, action) {
  switch (action.type) {
    case SET_PAGE_USER_INFO:
      return Object.assign({}, state, {
        user: action.payload,
      });
    case SET_PAGE_POSTS:
      return Object.assign({}, state, {
        posts: action.payload.posts,
        postsPageNumber: action.payload.postsPageNumber,
        postsFinalPageNumber: action.payload.postsFinalPageNumber,
      });
    case ADD_PAGE_POSTS:
      return Object.assign({}, state, {
        posts: state.posts.concat(action.payload.posts),
        postsPageNumber: action.payload.postsPageNumber,
        postsFinalPageNumber: action.payload.postsFinalPageNumber,
      });
    default:
      return state;
  }
}
