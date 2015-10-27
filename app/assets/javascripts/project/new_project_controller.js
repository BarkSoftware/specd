specd.app.controller('NewProjectController', [
    '$scope',
    '$q',
    'specd.user',
    '$state',
    'specd.project',
    function(
      $scope,
      $q,
      user,
      $state,
      projectService
      ) {

  $scope.project = {
    estimate_type: "Hours",
    cost_method: "Hourly Rate"
  };

  $scope.loading = false;
  $scope.create = function(project) {
    if (!$scope.loading) {
      $scope.loading = true;
      projectService.create(project).then(function(project) {
        $state.transitionTo('index.project_detail', { project_id: project.id });
      });
    }
  };

  $scope.getTags = function(query) {
    var languages = [
      'C#',
      'Ruby',
      'Python',
      'Javascript',
      'HTML',
      'CSS',
      'VB.Net',
      'C',
      'PHP',
      'Elixir',
      'NodeJS',
    ];
    return $q(function(resolve, reject) {
      var results = [];
      _.forEach(languages, function(language) {
        if (language.indexOf(query) > -1) {
          results.push(language);
        }
      });
      resolve(results);
    });
  };
}]);
