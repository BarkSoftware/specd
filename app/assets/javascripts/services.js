specd.app.factory('specd.services', [
  'specd.project',
  'specd.issue',
  'specd.comment',
  'specd.user',
  'specd.collaborator',
  'specd.github',
  'specd.upload',
function(project, issue, comment, user, collaborator, github, upload) {
  return {
    project: project,
    issue: issue,
    comment: comment,
    user: user,
    collaborator: collaborator,
    github: github,
    upload: upload.upload
  };
}]);
