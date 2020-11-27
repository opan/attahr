RSpec.describe Web::Views::Users::Index, type: :view do
  let(:double_user) { double('user', id: 1, username: 'user-1', email: 'user-1@mail.com') }
  let(:users) {
    [double_user]
  }
  let(:exposures) { Hash[format: :html, users: users, params: {}, flash: {}, current_user: 'current_user'] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/users/index.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }
  
  before(:each) do
    allow(double_user).to receive_message_chain(:profiles, :name) { 'user-1' }
    allow(double_user).to receive_message_chain(:profiles, :dob) { Time.now }
  end

  it 'exposes #users' do
    expect(view.users).to eq users
  end

  it 'shows link to create new user' do
    expect(rendered).to match %(Add User)
  end

  it 'shows list of users' do
    expect(rendered).to match %(Listing users)
    users.each do |u|
      expect(rendered).to match %(user-1)
    end
  end
end
