specd.app.controller('AddGithubIssueController', [
  '$scope',
  'specd.services',
  '$stateParams',
  '$state',
function($scope, services, $stateParams, $state) {
  services.project.get($stateParams.project_id).then(function(project) {
    $scope.project = project;
    services.issue.listDisconnected(project).then(function(issues) {
      $scope.issues = _.sortBy(issues, function(i) {
        return parseInt(i.number);
      });
    });
  });

  var addIssue = function(issue, issueType) {
    services.issue.createSpecd($scope.project, issueType, issue.number).then(function(res) {
      var transitionParams = {
        project_id: $stateParams.project_id,
        issue_number: issue.number
      }
      $state.transitionTo('index.project_detail.issue_detail', transitionParams);
    });
  }

  $scope.addSpec     = function(issue) { addIssue(issue, 'Spec'); };
  $scope.addBug      = function(issue) { addIssue(issue, 'Bug'); };
  $scope.addQuestion = function(issue) { addIssue(issue, 'Question'); };
}]);
