specd.app.directive("repositorySearch", function() {
  return {
    templateUrl: "t-repository-search.html",
    link: function(scope, element, attrs) {
      scope.$parent.$watch('repositories', function(repositories) {
        if (repositories.length) {
          $(element).find(".repo-search").typeahead({
            hint: true,
            highlight: true,
            minLength: 1
          },
          {
            name: 'repositories',
            displayKey: 'name',
            source: substringMatcher(repositories),
            templates: {
              suggestion: function(repo) {
                return "<p>" + repo.name +"</p>";
              }
            }
          })
          .on("typeahead:selected typeahead:autocompleted", function(e, repo, name) {
            scope.project.repository_id = repo.id;
            scope.project.repository_name = repo.name;
            scope.project.github_repository = repo.url;
          });
        }
      });
    }
  }

  function substringMatcher(repositories) {
    return function findmatches(q, cb) {
      var matches, substrRegex;

      // an array that will be populated with substring matches
      matches = [];

      // regex used to determine if a string contains the substring `q`
      substrRegex = new RegExp(q, 'i');

      // iterate through the pool of strings and for any string that
      // contains the substring `q`, add it to the `matches` array
      $.each(repositories, function(i, repo) {
        if (substrRegex.test(repo.name)) {
          // the typeahead jQuery plugin expects suggestions to a
          // JavaScript object, refer to typeahead docs for more info
          matches.push(repo);
        }
      });

      cb(matches);
    };
  };
});
