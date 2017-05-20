export default {
  getNotification(authToken, pageNumber) {
    return new Promise((resolve, reject) => {
      fetch(`/notifications?page=${pageNumber}`, {
        method: 'GET',
        headers: new Headers({
          'Content-Type': 'application/json',
          Authorization: authToken,
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
  markIsRead(authToken, id) {
    return new Promise((resolve, reject) => {
      fetch(`/notifications/${id}`, {
        method: 'GET',
        headers: new Headers({
          'Content-Type': 'application/json',
          Authorization: authToken,
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
};
