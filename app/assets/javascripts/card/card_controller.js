specd.app.controller('CardController', [
  '$scope',
  'specd.services',
  '$modalInstance',
  'project',
  'issue_number',
  '$state',
  '$timeout',
  'specd.board',
function($scope, services, $modalInstance, project, issue_number, $state, $timeout, board) {
  var github = services.github;

  $scope.done = function() {
    $modalInstance.close();
    $state.transitionTo('index.project_detail', { project_id: project.id });
  }

  $scope.project = board;
  $scope.board = board;
  $scope.clearAssignee = function() {
    $scope.issue.github.assignee = null;
  }

  $scope.moveToColumn = function() {
    $scope.move($scope.currentColumn, $scope.selectedColumn, $scope.issue);
  }

  $scope.move = function(fromColumn, toColumn, issue) {
    services.issue.updateSpecd({ id: issue.id, column_id: toColumn.id, kanban_sort: 0});
    _.remove(fromColumn.issues, function(i) { return i.id == issue.id });
    toColumn.issues.unshift(issue);
    $scope.currentColumn = toColumn;
  };

  services.issue.getByNumber(project, issue_number).then(function(issue) {
    $scope.currentColumn = _.find(board.columns, function(c) { return c.id == issue.column_id });
    $scope.selectedColumn = $scope.currentColumn
    $scope.issue = issue;
    $scope.$watch('issue.github.assignee', function(newValue, oldValue) {
      if (newValue !== oldValue) {
        var newAssignee  = null;
        if (newValue) {
          newAssignee = newValue.login;
        }
        services.github.post($scope.issue.github.url, { assignee: newAssignee });
      }
    });

    if ($scope.issue.github.body) {
      services.github.markdown($scope.issue.github.body, project.github.full_name).then(function(html) {
        $scope.issue.github.html = html;
      });
    }
    services.comment.list(issue, project.github.full_name).then(function(comments) {
      $scope.comments = comments;
    });
  });

  services.github.get(project.github.url + "/assignees").then(function(res) {
    $scope.assignees = res.data;
  });

  $scope.comment = {
    body: ""
  };

  $scope.createComment = function(comment) {
    services.comment.create($scope.issue, comment, $scope.project.github.full_name).then(function(newComment) {
      $scope.comments.push(newComment);
      $scope.comment.body = "";
    });
  }

  $scope.editComment = function(comment) {
    comment.editing = true;
  }

  $scope.updateComment = function(comment) {
    services.comment.update(comment, $scope.project.github.full_name).then(function(commentResponse) {
      comment.editing = false;
      $.extend(comment, commentResponse);
    });
  }

  $scope.editIssueDescription = function(issue) {
    issue.editingDescription = true;
    $timeout(function(){
      $(".card-description-editor textarea").focus();
    }, 5);
  }

  $scope.editIssueTitle = function(issue) {
    issue.editingTitle = true;
    // workaround for the time it take angular to render the input
    $timeout(function(){
      $(".card-title-input").focus();
    }, 5);
  }

  $scope.updateIssue = function(issue) {
    services.issue.update(issue).then(function(issueResponse) {
      issue.editingTitle = false;
      issue.editingDescription = false;
      $.extend(issue, issueResponse);
      services.github.markdown($scope.issue.github.body, $scope.project.github.full_name).then(function(html) {
        $scope.issue.github.html = html;
      });
    });
  }

  $scope.reopenIssue = function(issue, comment) {
    issue.github.state = "open";
    $scope.createComment(comment);
    services.issue.update(issue).then(function(issueResponse) {
      $.extend(issue, issueResponse);
      services.github.markdown($scope.issue.github.body, $scope.project.github.full_name).then(function(html) {
        $scope.issue.github.html = html;
      });
    });
  }

  $scope.updateSpecd = function(issue) {
    services.issue.updateSpecd(issue);
  }
}]);
