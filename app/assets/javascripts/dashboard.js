specd.app.controller('DashboardController', [
    '$scope',
    'specd.project',
    '$rootScope',
    '$state',
    function($scope, project, root, $state) {
      $scope.archivedProjectsExpanded = false;
      $scope.setArchivedProjectsExpanded = function(value) {
        $scope.archivedProjectsExpanded = value;
      }

      root.$watch('projects', function(projects) {
        $scope.projects = _.filter(projects, function(p) { return !p.archived });
        $scope.archivedProjects = _.filter(projects, function(p) { return p.archived });
      });
      project.list();

      $scope.openProject = function(p) {
        $state.transitionTo('index.project_detail', { project_id: p.id });
      };

      $scope.unarchive = function(p) {
        project.unarchive(p);
        p.archived = false;
      };
    }
]);
