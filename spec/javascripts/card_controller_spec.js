describe('CardController', function() {
  beforeEach(module('specd'));

  var $controller;
  var _injector;

  beforeEach(inject(function($injector) {
    $controller = $injector.get('$controller');
    _injector = $injector;

    createController = function(inject) {
      return $controller('CardController', $.extend({
          //if there's a way to reduce the need for so many injections, that would be nice
          $modalInstance: {},
          'project': { github: { url: '' }},
          'issue_number': 1,
          '$state': {},
          '$timeout': {},
          '$scope': {},
          'specd.services': $injector.get('specd.services'),
          '$state': {},
          '$modal': {},
          'specd.board': {}
        }, inject)
      );
    };
  }));

  describe('$scope.moveTo', function() {
    it('moves a card from one column to another', function() {
      var issue = { id: 1 };
      var board = {
        columns: [
          { id: 1, issues: [issue]},
          { id: 2, issues: []}
        ]
      };
      var scope = {};
      var inject = {
        $scope: scope,
        'specd.board': board,
      }
      var controller = createController(inject);
      scope.move(board.columns[0], board.columns[1], issue);
      expect(board.columns[0].issues.length).toEqual(0);
      expect(board.columns[1].issues.length).toEqual(1);
    });
  });
});
