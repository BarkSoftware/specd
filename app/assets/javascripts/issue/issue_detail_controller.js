specd.app.controller('IssueDetailController', [
  '$scope',
  'specd.services',
  '$stateParams',
  '$state',
  '$modal',
function($scope, services, $stateParams, $state, $modal) {
  var modalInstance = $modal.open({
    templateUrl: 't-card.html',
    controller: 'CardController',
    resolve: {
      project: function() {
        return services.project.get($stateParams.project_id);
      },
      issue_number: function() {
        return $stateParams.issue_number;
      }
    }
  }).result.then(function() {}, function() {
    $state.transitionTo('index.project_detail', { project_id: $stateParams.project_id });
  });;
}]);
