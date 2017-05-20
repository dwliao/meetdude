export default {
  getPost(authToken, userId, pageNumber) {
    return new Promise((resolve, reject) => {
      fetch(`/getPost?id=${userId}&page=${pageNumber}`, {
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
  deletePost(authToken, postId) {
    return new Promise((resolve, reject) => {
      fetch(`/deletePost?id=${postId}`, {
        method: 'DELETE',
        headers: new Headers({
          'Content-Type': 'application/json',
          Authorization: authToken,
        }),
      }).then((res) => {
        if (res.status >= 200 && res.status < 300) {
          resolve(res);
        }
        const error = new Error(res.statusText);
        error.response = res;
        throw error;
      }).catch((err) => {
        reject(err);
      });
    });
  },
  addPost(authToken, targetId, description) {
    return new Promise((resolve, reject) => {
      fetch('/createPost', {
        method: 'POST',
        headers: new Headers({
          'Content-Type': 'application/json',
          Authorization: authToken,
        }),
        body: JSON.stringify({
          target_id: targetId,
          description,
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
