specd.app.factory('specd.project', ['$http', 'specd.github', '$rootScope', function($http, github, root) {
  root.projects = [];
  var currentProject = null;

  return {
    currentProject: function() {
      return currentProject;
    },
    sortKanban: function(column_id, issue_sort) {
      var body = {
        sort: issue_sort
      };
      return $http.post(apiUrl + "/columns/" + column_id + "/sort_kanban", body);
    },
    list: function() {
      currentProject = null;
      return $http.get(apiUrl + "/projects").then(function(res) {
          root.projects              = res.data.projects;
          root.collaborator_projects = res.data.collaborator_projects;
          return res.data.projects;
      });
    },
    get: function(id) {
      return $http.get(apiUrl + "/projects/" + id).then(function(res) {
        var project = res.data.project;
        return github.get(project.github_repository).then(function(res) {
          currentProject = $.extend(res.data, project);
          return currentProject;
        });
      });
    },
    create: function(project) {
      return $http.post(apiUrl + "/projects", project).then(function(res) {
        root.projects.push(res.data.project);
        return res.data.project;
      });
    },
    archive: function(project) {
      var url = apiUrl + "/projects/" + project.id + "?archive=1";
      return $http.patch(url, project).then(function(res) {
        var new_projects = _.reject(root.projects, function(p) { return p.id == project.id });
        root.projects = new_projects;
        return res.data;
      });
    },
    unarchive: function(project) {
      var url = apiUrl + "/projects/" + project.id + "?unarchive=1";
      return $http.patch(url, project).then(function(res) {
        return res.data;
      });
    }
  }
}]);
