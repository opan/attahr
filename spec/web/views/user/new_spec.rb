RSpec.describe Web::Views::User::New, type: :view do
  let(:exposures) { Hash[format: :html, user: User.new, params: {}] }
  let(:template)  { Hanami::View::Template.new('apps/web/templates/user/new.html.erb') }
  let(:view)      { described_class.new(template, exposures) }
  let(:rendered)  { view.render }

  it 'exposes #format' do
    expect(view.format).to eq exposures.fetch(:format)
  end

  it 'exposes #user' do
    expect(view.user).to eq exposures.fetch(:user)
  end

  context 'user form' do
    it 'show username input' do
      expect(rendered).to match(/name\="user\[username\]"/)
    end

    it 'show email input' do
      expect(rendered).to match(/name\="user\[email\]"/)
    end
  end
end
