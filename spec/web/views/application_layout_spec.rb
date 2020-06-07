require "spec_helper"

RSpec.describe Web::Views::ApplicationLayout, type: :view do
  let(:layout)   { Web::Views::ApplicationLayout.new({ format: :html }, 'atthar web apps') }
  let(:rendered) { layout.render }

  it 'contains application name' do
    expect(rendered).to include('atthar web apps')
  end
end
