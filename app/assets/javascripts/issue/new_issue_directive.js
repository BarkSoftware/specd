specd.app.directive("newIssue", function() {
  return {
    scope: { column: "=", project_id: "=" },
    templateUrl: 't-new-issue.html',
    controller: "NewIssueController",
  }
});

specd.app.controller(
    'NewIssueController', [
      '$scope',
      '$state',
      '$stateParams',
      'specd.services',
function($scope, $state, $stateParams, services) {
  $scope.issue = {
    title: ''
  };
  $scope.getButtonClass = function() {
    switch ($scope.issue_type) {
      case 'spec':
        return 'btn-primary';
        break;
      case 'bug':
        return 'btn-danger';
        break;
      case 'question':
        return 'btn-success';
        break;
      default:
        return 'btn-info';
    }
  };
  $scope.issue_type = 'spec';
  $scope.button_class = $scope.getButtonClass();
  $scope.create = function() {
    if ($scope.issue.title && !$scope.loading) {
      $scope.loading = true;
      services.issue.create($scope.issue_type, $scope.issue, $scope.column).then(function(issue) {
        $scope.column.issues.unshift(issue);
        $scope.issue.title = '';
        $scope.loading = false;
      });
    }
  }

  $scope.issueTypeSpec = function() {
    $scope.issue_type = 'spec';
    $scope.button_class = $scope.getButtonClass();
  }
  $scope.issueTypeBug = function() {
    $scope.issue_type = 'bug';
    $scope.button_class = $scope.getButtonClass();
  }
  $scope.issueTypeQuestion = function() {
    $scope.issue_type = 'question';
    $scope.button_class = $scope.getButtonClass();
  }

}]);
