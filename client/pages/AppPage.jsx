import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import {
  Card,
  CardHeader,
  CardText,
  CardActions,
} from 'material-ui/Card';
import RaisedButton from 'material-ui/RaisedButton';
import FontIcon from 'material-ui/FontIcon';
import InfiniteScroll from 'react-infinite-scroller';
import moment from 'moment';
import { Editor } from 'draft-js';
import { stateToHTML } from 'draft-js-export-html';
import PostService from '../modules/PostService';
import style from './AppPage.scss';
import * as pageActions from '../actions/page';
import * as editorActions from '../actions/editor';

class AppPage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.handleClickRemoveButton = this.handleClickRemoveButton.bind(this);
    this.handleClickAddButton = this.handleClickAddButton.bind(this);
    this.handleLoadMore = this.handleLoadMore.bind(this);
    this.hasMorePosts = this.hasMorePosts.bind(this);
  }

  handleClickRemoveButton(postId) {
    return () => {
      const { user } = this.props;
      PostService.deletePost(user.auth_token, postId).then(() => {
        location.reload();
      });
    };
  }

  handleClickAddButton() {
    const { user, page, editor, editorActions } = this.props;
    const targetId = page.user ? page.user.id : user.id;
    const description = stateToHTML(editor.getCurrentContent());
    PostService.addPost(user.auth_token, targetId, description).then(() => {
      location.reload();
    });
    editorActions.resetEditorState();
  }

  handleLoadMore() {
    const { user, page, pageActions } = this.props;
    if (this.hasMorePosts()) {
      const nextPageNumber = page.postsPageNumber + 1;
      PostService.getPost(user.auth_token, page.user.id, nextPageNumber).then((res) => {
        pageActions.addPagePosts({
          posts: res.data,
          postsPageNumber: nextPageNumber,
          postsFinalPageNumber: res.final_page_number,
        });
      });
    }
  }

  hasMorePosts() {
    const { page } = this.props;
    return page.user && page.postsPageNumber < page.postsFinalPageNumber;
  }

  renderPostHeaderTitle(post) {
    const { user } = this.props;
    const content = post.user_id === post.target_id ? (
      <div className={style.headerTitleContent}>
        <Link to={`/${post.user_id}`}>{post.user.name}</Link>
      </div>
    ) : (
      <div className={style.headerTitleContent}>
        <Link to={`/${post.user_id}`}>{post.user.name}</Link>
        <span className={`material-icons ${style.forwardIcon}`}>forward</span>
        <Link to={`/${post.target_id}`}>{post.target.name}</Link>
      </div>
    );
    const removeButton = user.id === post.user_id || user.id === post.target_id ? (
      <span
        className={`material-icons ${style.deleteIcon}`}
        onClick={this.handleClickRemoveButton(post.id)}
      >clear</span>
    ) : null;
    return (
      <div className={style.headerTitle}>
        {content}
        {removeButton}
      </div>
    );
  }

  renderPost(post) {
    const headerAvatar = 'https://react.parts/react-logo.svg'; // Temporary use static url here
    const headerSubtitle = <span>{moment(post.updated_at).format('YYYY/M/D, h:mm:ss A')}</span>;
    const dangerouslySetInnerHTML = { __html: post.description };
    return (
      <Card key={post.id}>
        <CardHeader
          avatar={headerAvatar}
          textStyle={{ width: 'calc(100% - 56px)', padding: '0' }}
          title={this.renderPostHeaderTitle(post)}
          subtitle={headerSubtitle}
        />
        <CardText>
          <div dangerouslySetInnerHTML={dangerouslySetInnerHTML} />
        </CardText>
      </Card>
    );
  }

  renderLoder() {
    return <div>Loading ...</div>;
  }

  renderPostCreator() {
    const { user, page, editor, editorActions } = this.props;
    const headerAvatar = 'https://react.parts/react-logo.svg'; // Temporary use static url here
    const headerTitle = page.user && page.user.id !== user.id
      ? <span>Hello {user.name}, say something to {page.user.name}?</span>
      : <span>Hello {user.name}, say something?</span>;
    return (
      <Card>
        <CardHeader
          avatar={headerAvatar}
          title={headerTitle}
        />
        <CardText
          style={{ backgroundColor: 'rgba(0, 0, 0, 0.05)' }}
        >
          <Editor
            editorState={editor}
            onChange={editorActions.setEditorState}
          />
        </CardText>
        <CardActions>
          <RaisedButton
            label="SEND"
            primary
            icon={<FontIcon className="material-icons">send</FontIcon>}
            onClick={this.handleClickAddButton}
          />
        </CardActions>
      </Card>
    );
  }

  render() {
    const { user, page } = this.props;
    return (
      <div className={style.appPage}>
        {this.renderPostCreator()}
        <InfiniteScroll
          loadMore={this.handleLoadMore}
          hasMore={this.hasMorePosts()}
          loader={this.renderLoder()}
          threshold={50}
        >
          {page.posts.map(post => this.renderPost(post))}
        </InfiniteScroll>
      </div>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return {
    pageActions: bindActionCreators(pageActions, dispatch),
    editorActions: bindActionCreators(editorActions, dispatch),
  };
}

export default connect(state => state, mapDispatchToProps)(AppPage);
