var specdStubs = {};

function issueSpy() {
  return {
    create: sinon.spy(),
    getByNumber: sinon.spy(),
    update: sinon.spy(),
    updateSpecd: sinon.spy(),
    listByColumn: sinon.spy(),
  }
}
beforeEach(function() {
  specdStubs = {
    issue: issueSpy()
  };
      //project: project,
      //comment: comment,
      //user: user,
      //collaborator: collaborator,
      //github: github,
      //upload: upload.upload
});
