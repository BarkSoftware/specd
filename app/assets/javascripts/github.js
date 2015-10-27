specd.app.factory('specd.github', [
  '$http', 'specd.user', '$q', '$sce',
  function($http, user, $q, $sce) {
    function buildRequest(method, href, data) {
      method = method.toUpperCase();
      var currentUser = user.currentUser();
      var basicAuth = 'Basic ' + btoa(currentUser.token + ":x-oauth-basic");
      var req = {
        method: method,
        url: href,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/vnd.github.v3+json',
          'Authorization': basicAuth
        },
        withCredentials: false
      };
      if (data) {
        req.data = data;
      }
      return $http(req);
    }

    function getRepos() {
      var repos = [];
      var currentUser = user.currentUser();
      var username = currentUser.username;
      return getOrgs().then(function(response) {
        var orgs = response.data;
        return $q.all(_.map(orgs, function(org) {
          return buildRequest('get', org.repos_url).then(function(response) {
            _.each(response.data, function(r) { repos.push(r); });
          });
        })).then(function(response) {
          return buildRequest('get', githubUrl + '/users/' + username + '/repos').then(function(response) {
            _.each(response.data, function(r) { repos.push(r); });
            return repos;
          });
        });
      });
    }

    function getOrgs() {
      return buildRequest('get', githubUrl + "/user/orgs");
    }

    function parseLinkHeader(header) {
      if (!header || header.length == 0) {
        return {};
      }

      var parts = header.split(',');
      var links = {};
      _.each(parts, function(p) {
        var section = p.split(';');
        if (section.length != 2) {
          throw new Error("section could not be split on ';'");
        }
        var url = section[0].replace(/<(.*)>/, '$1').trim();
        var name = section[1].replace(/rel="(.*)"/, '$1').trim();
        links[name] = url;
      });

      return links;
    }

    return {
      markdown: function(body, context) {
        return buildRequest('post', 'https://api.github.com/markdown', {
          text: body,
          mode: 'gfm',
          context: context
        }).then(function(res) {
          return $sce.trustAsHtml(res.data);
        });
      },
      get: function(url) {
        return buildRequest('get', url);
      },
      post: function(url, data) {
        return buildRequest('post', url, data);
      },
      repos: getRepos,
      orgs: getOrgs,
      parseLinkHeader: parseLinkHeader
    };
  }
]);
