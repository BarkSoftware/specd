'use strict'
var apiUrl = '/api';
var githubUrl = "https://api.github.com";
var specd = {};
var templatesRoot = '/t-';
var templateProvider = function(template) {
  return ['$templateCache', function($templateCache) {
    return $templateCache.get('t-' + template);
  }]
}

specd.app = angular.module('specd', [
    'templates',
    'ui.router',
    'ui.sortable',
    'specd.admin',
    'ngTagsInput',
    'ui.bootstrap',
    'angularMoment',
    'angularFileUpload',
    'btford.markdown',
    'perfect_scrollbar'
  ])
  .run(['$templateCache', function($templateCache) {
    $templateCache.put('templates/template1.html'
      , '<div><h4>dashboard</h4></div>');
  }])
  .config([
      '$stateProvider',
      '$urlRouterProvider',
      '$locationProvider',
      '$httpProvider',
      function(
        $stateProvider,
        $urlRouterProvider,
        $locationProvider,
        $httpProvider
        ) {
    $httpProvider.defaults.withCredentials = true;
    $httpProvider.defaults.headers.common = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    $locationProvider.html5Mode(true);
    $stateProvider
    .state('index', {
      url: '',
      templateProvider: templateProvider('admin.html'),
      controller: 'AdminController'
    })
    .state('index.dashboard', {
      url: '/',
      templateProvider: templateProvider('dashboard.html'),
      controller: 'DashboardController'
    })
    .state('index.project_detail', {
      url: '/p/:project_id/details',
      templateProvider: templateProvider('project-detail.html'),
      controller: 'ProjectDetailsController'
    })
    .state('index.project_settings', {
      url: '/p/:project_id/settings',
      templateProvider: templateProvider('project-settings.html'),
      controller: 'ProjectSettingsController'
    })
    .state('index.new_project', {
      url: '/new-project',
      templateProvider: templateProvider('new-project.html'),
      controller: 'NewProjectController'
    })
    .state('index.project_detail.issue_detail', {
      url: '/issues/:issue_number',
      templateProvider: templateProvider('issue-detail.html'),
      controller: 'IssueDetailController'
    })
    .state('index.activity_feed', {
      url: '/p/:project_id/activity',
      templateProvider: templateProvider('activity-feed-full.html'),
      controller: 'ActivityFeedFullController'
    })
    .state('index.new_issue', {
      url: '/p/:project_id/new-issue/:issue_type',
      templateProvider: templateProvider('new-issue.html'),
      controller: 'NewIssueController'
    })
    .state('index.add_github_issue', {
      url: '/p/:project_id/add-github-issue',
      templateProvider: templateProvider('add-github-issue.html'),
      controller: 'AddGithubIssueController'
    })
    .state('index.confirm_collaborator', {
      url: '/collaborators/confirm/:token',
      templateProvider: templateProvider('confirm-collaborator.html'),
      controller: 'ConfirmCollaboratorController'
    });
  }]);
