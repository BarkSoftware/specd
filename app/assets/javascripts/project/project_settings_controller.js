specd.app.controller('ProjectSettingsController', [
  '$scope',
  'specd.services',
  'specd.github',
  '$stateParams',
  '$state',
  '$modal',
function($scope, services, github, $stateParams, $state, $modal) {
  $scope.confirming = false;
  services.project.get($stateParams.project_id).then(function(project) {
    $scope.project = project;
    $scope.collaborators = project.collaborators;
    $scope.owner = project.owner;
    $scope.newCollaborator = { email: '', type: 'Sponsor' };
    $scope.loading = false;

    $scope.delete = function($index, collaborator) {
      var id = collaborator.id;
      services.collaborator.delete(id).then(function(deleteResponse) {
        $scope.collaborators.splice($index, 1);
      });
    }

    $scope.invite = function() {
      $scope.loading = true;
      services.collaborator.invite($scope.project.id, $scope.newCollaborator).then(function(inviteResponse) {
        $scope.collaborators.push(inviteResponse.data);
        $scope.newCollaborator = { email: '', type: 'Sponsor' };
        $scope.loading = false;
      });
    };
  });

  $scope.archive = function() {
    $scope.confirming = true;
  };

  $scope.confirmedArchive = function() {
    services.project.archive($scope.project).then(function(project) {
      $scope.confirming = false;
      $state.transitionTo('index.dashboard');
    });
  }
}]);
