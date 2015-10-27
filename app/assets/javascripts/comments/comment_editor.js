specd.app.directive("commentEditor", ['specd.services', function(services) {
  return {
    templateUrl: "t-comment-editor.html",
    scope: {
      comment: "=comment",
      blurFn: "&"
    },
    link: function($scope, element, attrs) {
      $scope.editor = $scope.comment;
      $scope.showFileTypeError = false;
      $scope.rejectedFiles = [];
      $scope.$watch('rejectedFiles', function() {
        if ($scope.rejectedFiles && $scope.rejectedFiles.length) {
          $scope.showFileTypeError = true;
        }
      });

      var onProgress = function(evt) {
        $scope.uploadProgress = parseInt(100.0 * evt.loaded / evt.total);
      };

      var onSuccess = function(data, status, headers, config) {
        var url = $(data).find('Location').text();
        var link = "\n ![" + config.file.name + "](" + url + ")";
        if ($scope.comment) {
          $scope.comment.body += link;
        }
        else if ($scope.issue) {
          $scope.issue.body += link;
        }
        $scope.uploading = false;
      };

      var onError = function(xml, status) {
        if (status === 400) {
          var doc = $($.parseXML(xml));
          var error = doc.find('Error');
          var msg = error.find('Code').text() + ": " + error.find('Message').text();
          $scope.fileUploadErrorMessage = msg;
        }
      };

      $scope.files = [];
      $scope.uploading = false;
      $scope.uploadProgress = 0;
      $scope.$watch('files', function() {
        if ($scope.files && $scope.files.length) {
          $scope.showFileTypeError = false;
          $scope.uploading = true;
          services.upload($scope.files[0], onProgress, onSuccess, onError);
        }
      });
    }
  }
}]);
