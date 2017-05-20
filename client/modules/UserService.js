export default {
  signUp(name, email, password, passwordConfirm) {
    return new Promise((resolve, reject) => {
      fetch('/users', {
        method: 'POST',
        headers: new Headers({
          'Content-Type': 'application/json',
        }),
        body: JSON.stringify({
          user: { name, email, password, password_confirmation: passwordConfirm },
        }),
      }).then((res) => {
        if (res.status >= 200 && res.status < 300) {
          return res.json();
        }
        const error = new Error(res.statusText);
        error.response = res;
        throw error;
      }).then((res) => {
        if (!res.errors) {
          localStorage.setItem('user', JSON.stringify(res));
        }
        resolve(res);
      }).catch((err) => {
        reject(err);
      });
    });
  },
  signIn(email, password) {
    return new Promise((resolve, reject) => {
      fetch('/users/sign_in', {
        method: 'POST',
        headers: new Headers({
          'Content-Type': 'application/json',
        }),
        body: JSON.stringify({
          session: { email, password },
        }),
      }).then((res) => {
        if (res.status >= 200 && res.status < 300) {
          return res.json();
        }
        const error = new Error(res.statusText);
        error.response = res;
        throw error;
      }).then((res) => {
        if (!res.errors) {
          localStorage.setItem('user', JSON.stringify(res));
        }
        resolve(res);
      }).catch((err) => {
        reject(err);
      });
    });
  },
  show(userId) {
    return new Promise((resolve, reject) => {
      fetch(`/users/${userId}`, {
        method: 'GET',
        headers: new Headers({
          'Content-Type': 'application/json',
        }),
      }).then((res) => {
        if (res.status >= 200 && res.status < 300) {
          return res.json();
        }
        const error = new Error(res.statusText);
        error.response = res;
        throw error;
      }).then((res) => {
        resolve(res);
      }).catch((err) => {
        reject(err);
      });
    });
  },
  isSignIn() {
    return localStorage.getItem('user') !== null;
  },
  getUserInfo() {
    return JSON.parse(localStorage.getItem('user'));
  },
  signOut() {
    localStorage.removeItem('user');
  },
};
