specd.app.directive('title', ['$rootScope', '$timeout', 'specd.project',
  function($rootScope, $timeout, project) {
    return {
      link: function(scope) {
        $rootScope.title = "Spec'd";
        scope.$watch(project.currentProject, function(newVal, oldVal) {
          if (newVal) {
            $rootScope.title = newVal.title + " | Spec'd";
          }
          else {
            $rootScope.title = "Spec'd";
          }
        }, true);
      }
    };
  }
]);
