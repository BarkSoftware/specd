specd.app.controller('ProjectDetailsController', [
  '$scope',
  'specd.services',
  'specd.github',
  '$stateParams',
  '$state',
  '$modal',
  'specd.board',
function($scope, services, github, $stateParams, $state, $modal, board) {
  $scope.closeActivity = function() {
    $('#activity-popout').hide();
  }
  $scope.openActivity = function() {
    $('#activity-popout').show();
  }
  $scope.tabs = [
    { title: 'Open', active: true, content: 'Open Content' },
    { title: 'Closed', active: false, content: 'Closed Content' }
  ];

  services.project.get($stateParams.project_id).then(function(project) {
    board.columns = project.columns;
    $scope.project = project;
  });

  $scope.addCollaborators = function() {
    $modal.open({
      templateUrl: 'add-collaborators.html',
      controller: 'AddCollaboratorsController',
      resolve: {
        project_id: function() {
          return $stateParams.project_id;
        }
      }
    });
  };

  $scope.issueClass = function(issue) {
    switch (issue.issue_type.toLowerCase()) {
      case 'spec':
        return 'primary';
        break;
      case 'bug':
        return 'danger';
        break;
      case 'question':
        return 'info';
        break;
      default:
        return 'info';
    }
  };
}]);
