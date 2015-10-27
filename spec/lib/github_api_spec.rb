require 'rails_helper'

RSpec.describe GithubApi do
  subject { described_class.new(junk) }
  include_context 'github fixtures'

  it 'does get requests' do
    subject.get 'https://api.github.com/user'
    expect(get_user_stub).to have_been_requested
  end
end
