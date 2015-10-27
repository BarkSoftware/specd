specd.app.directive("kanbanItem", function() {
  return {
    scope: { issue: "=" },
    templateUrl: "t-kanban-item.html"
  }
});

specd.app.directive("kanbanColumn", function() {
  return {
    scope: { column: "=" },
    templateUrl: "t-kanban-column.html",
    controller: "KanbanController",
  }
});

specd.app.controller("KanbanController", [
    '$scope',
    'specd.services',
    '$state',
    '$modal',
function(scope, services, $state, $modal) {
  function setColumnHeights() {
    $('.scroller').height(function(index, height) {
      var ul = $(this).find('ul.kanban-list');
      var newHeight = window.innerHeight - $(this).offset().top - 33;
      ul.height(newHeight);
      return newHeight;
    });
  }

  services.issue.listByColumn(scope.column.id).then(function(issues) {
    scope.column.issues = issues;
    setColumnHeights();
  });

  function updateKanban(sortable) {
    var index = sortable.dropindex;
    if (index >= 0) { //dropped outside of a column
      var issue_sort = [];
      issue_sort.push({ number: sortable.model.number, index: index });
      _.each(sortable.droptargetModel, function(m, i) {
        if (i >= index) {
          issue_sort.push({ number: m.number, index: i + 1 });
        }
        else {
          issue_sort.push({ number: m.number, index: i });
        }
      });
      services.project.sortKanban(scope.column.id, issue_sort);
    }
  }

  scope.viewIssue = function(issue) {
    if (!scope.dragging) {
      $state.transitionTo('index.project_detail.issue_detail', {
        project_id: issue.project_id,
        issue_number: issue.number
      });
    }
  }

  scope.clickIssue = function() {
    scope.dragging = false;
  }

  scope.sortableOptions = {
    connectWith: ".connectList",
    stop: function (e, ui) {
      if (!ui.item.sortable.received) {
        updateKanban(ui.item.sortable);
      }
      scope.dragging = false;
    },
    receive: function(e, ui) {
      updateKanban(ui.item.sortable);
    },
    start: function() {
      scope.dragging = true;
    },
    appendTo: 'body',
    helper: 'clone',
    containment: 'window',
    scroll: false,
    placeholder: 'card-placeholder',
  };
}]);
