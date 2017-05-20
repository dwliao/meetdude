import React from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import MaterialUiAppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import IconMenu from 'material-ui/IconMenu';
import MenuItem from 'material-ui/MenuItem';
import FontIcon from 'material-ui/FontIcon';
import RaisedButton from 'material-ui/RaisedButton';
import { Toolbar, ToolbarGroup } from 'material-ui/Toolbar';
import NotificationService from '../modules/NotificationService';
import * as notificationActions from '../actions/notifications';
import style from './AppBar.scss';

class AppBar extends React.PureComponent {
  constructor(props) {
    super(props);
    this.createGotoPageFunc = this.createGotoPageFunc.bind(this);
    this.updateNotifications = this.updateNotifications.bind(this);
    this.createClickNotificationItemFunc = this.createClickNotificationItemFunc.bind(this);
  }

  componentDidMount() {
    const authToken = (this.props.user || {}).auth_token;
    if (authToken) {
      this.updateNotifications(authToken);
    }
  }

  createGotoPageFunc(page) {
    return () => {
      this.props.router.push(`/${page}`);
    };
  }

  updateNotifications(authToken) {
    const { setNotifications } = this.props;
    return new Promise((resolve, reject) => {
      NotificationService.getNotification(authToken, 0).then((res) => {
        setNotifications({
          notifications: res.notifications,
          notificationsPageNumber: 0,
          notificationsFinalPageNumber: res.final_page_number,
        });
        resolve();
      }).catch((error) => { reject(error); });
    });
  }

  createClickNotificationItemFunc(notification, cb) {
    const authToken = (this.props.user || {}).auth_token;
    if (authToken) {
      return () => {
        NotificationService.markIsRead(authToken, notification.id)
          .then(() => this.updateNotifications(authToken))
          .then(cb)
          .catch((error) => { console.error(error); });
      };
    }
    return () => {};
  }

  render() {
    const gotoAppPage = this.createGotoPageFunc('');
    const gotoSignUpPage = this.createGotoPageFunc('sign_up');
    const gotoSignInPage = this.createGotoPageFunc('sign_in');
    const gotoSignOutPage = this.createGotoPageFunc('sign_out');
    const CustomIconMenu = props => (
      <IconMenu
        iconButtonElement={
          <IconButton>
            <FontIcon className="material-icons" color="white">{props.iconName}</FontIcon>
          </IconButton>
        }
        anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
        targetOrigin={{ horizontal: 'right', vertical: 'top' }}
      >
        {props.children}
      </IconMenu>
    );
    const FriendshipMenu = (
      <CustomIconMenu iconName="people">
        <MenuItem primaryText="TEST" />
      </CustomIconMenu>
    );
    const NotificationItem = props => (
      <MenuItem
        style={props.isRead ? { color: 'grey' } : {}}
        primaryText={props.text}
        onClick={props.onClick}
      />
    );
    const notifications = this.props.notifications.notifications;
    const NotificationMenu = (
      <CustomIconMenu
        iconName={notifications.length ? 'notifications' : 'notifications_none'}
      >
        {notifications.map((notification) => {
          let text = '';
          let onClick = () => {};
          switch (notification.notice_type) {
            case 'receive_post': {
              text = `${notification.notified_by.name} is wrote something for you`;
              onClick = this.createClickNotificationItemFunc(notification, () => {
                // TODO: Goto post page
              });
              break;
            }
            default:
          }
          return (
            <NotificationItem
              key={notification.id}
              isRead={notification.is_read}
              text={text}
              onClick={onClick}
            />
          );
        })}
      </CustomIconMenu>
    );
    const FaceMenu = (
      <CustomIconMenu iconName="face">
        <MenuItem primaryText="Sign out" onClick={gotoSignOutPage} />
      </CustomIconMenu>
    );
    const ToolbarItems = this.props.user ? (
      <ToolbarGroup>
        {FriendshipMenu}
        {NotificationMenu}
        {FaceMenu}
      </ToolbarGroup>
    ) : (
      <ToolbarGroup>
        <RaisedButton label="Sign up" className={style.toolbarButton} primary onClick={gotoSignUpPage} />
        <RaisedButton label="Sign in" className={style.toolbarButton} primary onClick={gotoSignInPage} />
      </ToolbarGroup>
    );
    return (
      <div>
        <div className={style.materialUiAppBar}>
          <MaterialUiAppBar
            title={<span className={style.title}>Meetdude</span>}
            onTitleTouchTap={gotoAppPage}
          >
            <Toolbar className={style.toolbar}>
              {ToolbarItems}
            </Toolbar>
          </MaterialUiAppBar>
        </div>
        <div className={style.content}>
          {this.props.children}
        </div>
      </div>
    );
  }
}

AppBar.defaultProps = {
  children: '',
};

AppBar.propTypes = {
  children: PropTypes.node,
};

export default connect(state => state, notificationActions)(AppBar);
