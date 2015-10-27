specd.app.directive("assigneeSearch", function() {
  return {
    templateUrl: "t-assignee-search.html",
    scope: { assignees: "=" },
    link: function(scope, element, attrs) {
      scope.$parent.$watch('assignees', function(assignees) {
        if (assignees) {
          $(element).find(".assignee-search").typeahead({
            hint: true,
            highlight: true,
            minLength: 1
          },
          {
            name: 'assignees',
            displayKey: 'login',
            source: substringMatcher(scope.assignees),
            templates: {
              suggestion: function(assignee) {
                return "<p><img class='img-circle user-img' src='" + assignee.avatar_url + "' />" + assignee.login +"</p>";
              }
            }
          })
          .on("typeahead:selected typeahead:autocompleted", function(e, assignee, name) {
            scope.$parent.issue.github.assignee = assignee;
          });
        }
      });
    }
  }

  function substringMatcher(assignees) {
    return function findmatches(q, cb) {
      var matches, substrRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(assignees, function(i, assignee) {
        if (substrRegex.test(assignee.login)) {
          // the typeahead jQuery plugin expects suggestions to a
          // JavaScript object, refer to typeahead docs for more info
          matches.push(assignee);
        }
      });

      cb(matches);
    };
  };
});
