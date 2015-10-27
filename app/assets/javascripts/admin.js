specd.admin = angular.module('specd.admin', [
    'ui.router'
  ])
  .controller('AdminController', [
    '$scope',
    'specd.user',
    'specd.github',
    'specd.project',
    '$rootScope',
    function($scope, user, github, projectService, root) {
      var navbarOpen = false;
      $scope.toggleNavbar = function() {
        if (!navbarOpen) {
          $("#page-wrapper").css("margin-left", "220px");
          $('#side-nav').show().addClass('animated bounceInLeft');
          navbarOpen = true;
        }
        else {
          $("#page-wrapper").css("margin-left", "0px");
          $('#side-nav').hide();
          navbarOpen = false;
        }
      }

      $scope.$on('$locationChangeStart', function(event) {
        //$scope.project = null;
        //$scope.breadcrumbState = null;
        var project = projectService.currentProject();
        if (project) {
          $scope.project = project;
          $scope.breadcrumbState = { project_id: project.id };
        }
        else {
          $scope.breadcrumbState = null;
          $scope.project = null;
        }
      });

      $scope.$watch(projectService.currentProject, function(project) {
        if (project) {
          $scope.project = project;
          $scope.breadcrumbState = { project_id: project.id };
        }
        else {
          $scope.breadcrumbState = null;
          $scope.project = null;
        }
      });

      $scope.$watch(user.currentUser, function(user) {
        $scope.user = user
        if (user.token) {
          $scope.authenticated = true;
          github.repos().then(function(repos) {
            $scope.repositories = repos;
          });
        }
        else {
          $scope.loginUrl      = user.loginUrl;
          $scope.repositories  = [];
          $scope.authenticated = false;
        }
      });
      $scope.user          = user.getCurrentUser();
      $scope.logout        = user.logout;
      $scope.repositories  = [];
      $scope.authenticated = false;
    }
  ]);
