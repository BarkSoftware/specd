specd.app.controller('ConfirmCollaboratorController', [
  '$scope',
  'specd.services',
  '$stateParams',
  '$state',
function($scope, services, $stateParams, $state) {
  services.collaborator.get($stateParams.token).then(function(response) {
    $scope.title = response.data.project_title;
    $scope.owner_name = response.data.owner_name;
  });

  $scope.acceptInvite = function() {
    services.collaborator.confirm($stateParams.token).then(function(response) {
      var projectId = response.data.project_id;
      $state.transitionTo('index.project_detail', { project_id: projectId });
    });
  }
}]);
