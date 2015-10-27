specd.app.factory('specd.user', [
  '$http',
  function($http) {
    var currentUser = {
      authenticated: false,
      logoutUrl: null,
      loginUrl: null,
      fullName: null
    };

    return {
      currentUser: function() { return currentUser; },
      getCurrentUser: getCurrentUser,
      logout: logout
    };

    function logout() {
      $http.delete(currentUser.logoutUrl, {
        data: {},
      })
      .success(function(data, status) {
        currentUser = {
          authenticated: false,
          loginUrl: data.login_url,
          profileImage: null,
          username: null,
          fullName: null
        }
      });
    }

    function getCurrentUser() {
      return $http.get(apiUrl)
        .success(function(data, status) {
          currentUser = {
            authenticated: true,
            token: data.github.token,
            image: data.profile_image,
            logoutUrl: data.logout_url,
            username: data.github.username,
            fullName: data.github.full_name
          }
      })
      .error(function(data, status) {
        currentUser = {
          authenticated: false,
          token: null,
          username: null,
          image: null,
          full_name: null
        }
        if (data && data.login_url) {
          currentUser.loginUrl = data.login_url;
        }
      });
    }
  }
]);
