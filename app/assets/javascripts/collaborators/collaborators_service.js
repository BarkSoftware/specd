specd.app.factory('specd.collaborator', ['$http',
function($http) {
  return {
    invite: function(project_id, collaborator) {
      var data = _.extend({ project_id: project_id }, collaborator);
      return $http.post(apiUrl + "/collaborators", data);
    },
    get: function(token) {
      return $http.get(apiUrl + "/confirm-collaborator-token?invite_token=" + token);
    },
    confirm: function(token) {
      var data = { invite_token: token };
      return $http.post(apiUrl + "/confirm-collaborator", data);
    },
    delete: function(id) {
      return $http.delete(apiUrl + "/collaborators/" + id.toString());
    }
  };
}]);
