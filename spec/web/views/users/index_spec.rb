RSpec.describe Web::Views::Users::Index, type: :view do
  let(:users) {
    [double('user', username: 'user-1', email: 'user-1@mail.com')]
  }
  let(:exposures) { Hash[format: :html, users: users] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/users/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #users' do
    expect(view.users).to eq users
  end

  it 'shows list of users' do
    expect(rendered).to match %(Listing users)
    users.each do |u|
      expect(rendered).to match %(user-1)
    end
  end
end
