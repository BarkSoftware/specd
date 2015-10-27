specd.app.factory('specd.comment',
  ['$http', '$q', 'specd.github',
  function($http, $q, github) {
    var noContextErrorMessage = "context required for markdown see: https://developer.github.com/v3/markdown/#render-an-arbitrary-markdown-document";

    var mapComment = function(comment, context) {
      if (!context) {
        throw new Error(noContextErrorMessage);
      }
      return github.markdown(comment.body, context).then(function(html) {
        comment.html = html;
        return comment;
      });
    };

    return {
      list: function(issue, context) {
        return github.get(issue.github.comments_url).then(function(res) {
          return $q.all(_.map(res.data, function(comment) {
            return mapComment(comment, context);
          })).then(function() {
            return res.data;
          });
        });
      },
      create: function(issue, comment, context) {
        return github.post(issue.github.comments_url, comment).then(function(response) {
          return mapComment(response.data, context);
        });
      },
      update: function(comment, context) {
        return github.post(comment.url, { body: comment.body }).then(function(response) {
          return mapComment(response.data, context);
        });
      }
    }
  }
]);
