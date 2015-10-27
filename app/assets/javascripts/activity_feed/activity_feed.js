specd.app.controller('ActivityFeedFullController', [
    '$scope',
    '$stateParams',
    'specd.services',
function($scope, $stateParams, services) {
  $scope.breadcrumbState = $stateParams;
  services.project.get($stateParams.project_id).then(function(project) {
    $scope.project = project;
  });
}]);

specd.app.controller('ActivityFeedController', [
  '$scope',
  'specd.github',
  '$state',
function($scope, github, $state) {
  $scope.allEvents = [];

  var getActivityPath = "/events?page=1";
  function hasLabel(issue, label) {
    return _.any(issue.labels, function(l) { return l.name.toLowerCase() === label.toLowerCase(); });
  }

  function issueNumber(e) {
    if (e.payload.issue) {
      return e.payload.issue.number;
    }
    return null;
  }

  function getActivityGithub(project, memo, next) {
    if (!memo) { memo = []; }
    var url = project.url + getActivityPath;
    if (next) { url = next; }
    return github.get(url).then(function(response) {
      memo = memo.concat(response.data);
      var links = github.parseLinkHeader(response.headers('Link'));
      if (links.next) {
        return getActivityGithub(project, memo, links.next);
      }
      else {
        return memo;
      }
    });
  }

  function setFeedSettings(e) {
    e.feed_settings = { time: moment(e.created_at).format('h:mm a')};
    if (e.type === 'IssuesEvent') {
      var issue = e.payload.issue;
      _.extend(e.feed_settings, {
        title: e.payload.action + " issue",
        body: e.payload.issue.title,
      });
      if (hasLabel(issue, 'Spec')) {
        _.extend(e.feed_settings, { icon: 'fa fa-bullseye' });
      }
      else if (hasLabel(issue, 'Bug')) {
        _.extend(e.feed_settings, { icon: 'fa fa-bug' });
      }
      else if (hasLabel(issue, 'Question')) {
        _.extend(e.feed_settings, { icon: 'fa fa-question' });
      }
      else {
        _.extend(e.feed_settings, { icon: 'fa fa-exclamation-circle' });
      }
    }
    else if (e.type === "IssueCommentEvent") {
      _.extend(e.feed_settings, {
        icon: 'fa fa-comment',
        title: "new comment",
        body: e.payload.comment.body
      });
    }
  }

  function filterAndPrepareEvents() {
    _.each($scope.allEvents, setFeedSettings);
    if ($scope.condensed) {
      $scope.events = $scope.allEvents.slice(0, 10);
    }
    else {
      $scope.events = $scope.allEvents;
    }
  }

  $scope.navigateTo = function(e) {
    $state.transitionTo('index.project_detail.issue_detail', {
      project_id: $scope.project.id,
      issue_number: e.payload.issue.number
    });
  }

  $scope.filterComments = function() {
    $(".activity-filter button").removeClass("active");
    $(".comment-filter-button").addClass("active");
    $scope.events = _.filter($scope.allEvents, function(e) {
      return e.type === "IssueCommentEvent";
    });
  }

  $scope.filterSpecs = function() {
    $(".activity-filter button").removeClass("active");
    $(".spec-filter-button").addClass("active");
    $scope.events = _.filter($scope.allEvents, function(e) {
      return e.type === 'IssuesEvent' && hasLabel(e.payload.issue, 'Spec');
    });
  }

  $scope.filterQuestions = function() {
    $(".activity-filter button").removeClass("active");
    $(".question-filter-button").addClass("active");
    $scope.events = _.filter($scope.allEvents, function(e) {
      return e.type === 'IssuesEvent' && hasLabel(e.payload.issue, 'Question');
    });
  }

  $scope.filterBugs = function() {
    $(".activity-filter button").removeClass("active");
    $(".bug-filter-button").addClass("active");
    $scope.events = _.filter($scope.allEvents, function(e) {
      return e.type === 'IssuesEvent' && hasLabel(e.payload.issue, 'Bug');
    });
  }

  $scope.removeFilter = function() {
    $(".activity-filter button").removeClass("active");
    $scope.events = $scope.allEvents;
  }

  $scope.$watch('project', function(project) {
    if (project) {
      if ($scope.allEvents.length === 0) {
        getActivityGithub(project).then(function(events) {
          $scope.allEvents = events;
          filterAndPrepareEvents();
        });
      }
      else {
        filterAndPrepareEvents();
      }
    }
  });
}]);

specd.app.directive('activityFeed', function() {
  return {
    scope: {
      project: "=",
      condensed: "="
    },
    templateUrl: "t-activity-feed.html",
    controller: 'ActivityFeedController'
  }
});
