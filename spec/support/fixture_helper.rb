module FixtureHelper

  RSpec.configure do |config|
    config.include self
  end

  def fixture *path
    path.unshift 'spec/fixtures'
    Rails.root.join(*path)
  end

end
