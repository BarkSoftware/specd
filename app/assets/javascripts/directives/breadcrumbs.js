specd.app.directive("breadcrumb", function() {
  return {
    templateProvider: templateProvider("breadcrumbs.html"),
    scope: { stateParams: "=" },
    link: function(scope, element, attrs) {
      scope.$watch('stateParams', function(params) {
        if (params) {
          scope.breadcrumbs = [];
          scope.breadcrumbs.push({ sref: "index.dashboard", text: 'Home' });
          scope.breadcrumbs.push({ sref: "index.project_detail({ project_id: " + params.project_id + " })", text: 'Project' });
        } else {
          scope.breadcrumbs = [];
        }
      });
    }
  }
});
