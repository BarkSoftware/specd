specd.app.directive('projectList', ['$state', 'specd.project', function($state, project) {
  return {
    templateUrl: "t-project-list.html",
    scope: { projects: "=" },
    link: function(scope, element, attrs) {
      scope.openProject = function(p) {
        $state.transitionTo('index.project_detail', { project_id: p.id });
      };

      scope.unarchive = function(p) {
        project.unarchive(p);
        p.archived = false;
      };
    }
  }
}]);
