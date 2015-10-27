specd.app.factory('specd.issue', ['$http', '$q', 'specd.github',
  function($http, $q, github) {
    //tries to find an appropriate font color (dark/light)
    function findForegroundColor(backgroundColor) {
        var c = backgroundColor.substring(1);      // strip #
        var rgb = parseInt(c, 16);   // convert rrggbb to decimal
        var r = (rgb >> 16) & 0xff;  // extract red
        var g = (rgb >>  8) & 0xff;  // extract green
        var b = (rgb >>  0) & 0xff;  // extract blue

        var luma = 0.2126 * r + 0.7152 * g + 0.0722 * b; // per ITU-R BT.709

        var textColor = '#000';
        if (luma < 40) {
          textColor = '#fff';
        }
        return textColor;
    }

    function mapIssue(issue) {
      issue.labels = _.map(issue.labels, function(label) {
        label.style = {
          'background-color': '#' + label.color,
          color: findForegroundColor(label.color),
          display: 'inline-block'
        };
        return label;
      });
      return issue;
    }

    function getByNumber(project, issue_number) {
      return $http.get(apiUrl + "/projects/" + project.id + "/issues/" + issue_number).then(function(response) {
        return mapIssue(response.data.issue);
      });
    }

    function create(issue_type, issue, column) {
      var data = {
        issue: issue,
        issue_type: issue_type
      };
      return $http.post(apiUrl + "/columns/" + column.id + "/issues", data).then(function(response) {
        return response.data.issue;
      });
    }

    function update(issue) {
      return github.post(issue.github.url, _.pick(issue.github, ['title', 'body', 'state'])).then(function(response) {
        return response.data;
      });
    }

    function updateSpecd(issue) {
      return $http.patch(apiUrl + /issues/ + issue.id, { issue: issue });
    }

    function listByColumn(column_id) {
      return $http.get(apiUrl + "/columns/" + column_id).then(function(response) {
        return response.data.column.issues;
      });
    }

    return {
      create: create,
      getByNumber: getByNumber,
      update: update,
      updateSpecd: updateSpecd,
      listByColumn: listByColumn,
    }
  }
]);
