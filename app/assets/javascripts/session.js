specd.app.factory('specd.session', ['specd.user', function(userService) {
  var session = {
    user: userService.currentUser
  };
  return session;
}]);
