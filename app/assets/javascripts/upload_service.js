specd.app.factory('specd.upload', ['$http', '$upload', function($http, $upload) {
  var presignedPost = function(file_type) {
    return $http.post(apiUrl + '/uploads', { file_type: file_type }).then(function(response) {
      return response.data;
    });
  };

  return {
    upload: function(file, progress, success, error) {
      return presignedPost(file.type).then(function(presigned_post) {
        $upload.upload({
          url: presigned_post.url,
          fields: presigned_post.fields,
          file: file
        }).progress(progress).success(success).error(error);
      });
    }
  }
}]);
