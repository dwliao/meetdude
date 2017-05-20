import React from 'react';
import { bindActionCreators } from 'redux';
import { connect } from 'react-redux';
import { Link } from 'react-router';
import { Card, CardText } from 'material-ui/Card';
import style from './SignInPage.scss';
import SignInForm from '../components/SignInForm';
import UserService from '../modules/UserService';
import NotificationService from '../modules/NotificationService';
import * as userActions from '../actions/user';
import * as notificationActions from '../actions/notifications';

class SignInPage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.handleSubmit = this.handleSubmit.bind(this);
    this.updateNotifications = this.updateNotifications.bind(this);
  }

  handleSubmit({ email, password }) {
    const { userActions, user, router } = this.props;
    UserService.signIn(email, password).then((res) => {
      if (!res.errors) {
        userActions.setUserInfo(res);
        const authToken = (user || {}).auth_token;
        this.updateNotifications(authToken).catch((error) => { console.error(error); });
        router.push('/');
      }
    });
  }

  updateNotifications(authToken) {
    const { notificationActions } = this.props;
    return new Promise((resolve, reject) => {
      NotificationService.getNotification(authToken, 0).then((res) => {
        notificationActions.setNotifications({
          notifications: res.data,
          notificationsPageNumber: 0,
          notificationsFinalPageNumber: res.final_page_number,
        });
        resolve();
      }).catch((error) => { reject(error); });
    });
  }

  render() {
    return (
      <Card className={style.container}>
        <h2 className={style.cardHeading}>Sign In</h2>
        <SignInForm onSubmit={this.handleSubmit} />
        <CardText>Do not have an account? <Link to={'/sign_up'}>Create one</Link>.</CardText>
      </Card>
    );
  }
}

function mapDispatchToProps(dispatch) {
  return {
    userActions: bindActionCreators(userActions, dispatch),
    notificationActions: bindActionCreators(notificationActions, dispatch),
  };
}

export default connect(state => state, mapDispatchToProps)(SignInPage);
