describe('ProjectDetailsController', function() {
  beforeEach(module('specd'));

  var $controller;
  var _injector;

  beforeEach(inject(function($injector) {
    $controller = $injector.get('$controller');
    _injector = $injector;


    createController = function(inject) {
      return $controller('ProjectDetailsController', $.extend({
        $scope: {},
             'specd.services': $injector.get('specd.services'),
             github:{},
             $stateParams: {},
             $state: {},
             $modal: {},
             'specd.boardState': {}
      }, inject)
        );
    };
  }));

  describe('$scope.board', function() {
    it('is populated with project', function() {
      var $httpBackend;
      $httpBackend = _injector.get('$httpBackend');
      var boardState = { board: {}};
      var projectApiResponse = { project: {} };
      var scope = {};
      var inject = {
        $stateParams: { project_id: 1 },
        $scope: scope,
        'specd.boardState': boardState,
      }
      projectRequestHandler = $httpBackend.when('GET', /projects/)
        .respond(function(method, url, data, headers, params) {
          return [200, projectApiResponse];
      });
      var controller = createController(inject);
      $httpBackend.flush();
      expect(boardState.board).toEqual(projectApiResponse.project);
    });
  });
});
