RSpec.describe Org, type: :entity do
  it 'has attributes' do
    expect( subject.respond_to?(:id) ).to be true
    expect( subject.respond_to?(:name) ).to be true
    expect( subject.respond_to?(:display_name) ).to be true
    expect( subject.respond_to?(:address) ).to be true
    expect( subject.respond_to?(:phone_numbers) ).to be true
    expect( subject.respond_to?(:is_root) ).to be true
    expect( subject.respond_to?(:created_at )).to be true
    expect( subject.respond_to?(:updated_at) ).to be true
    expect( subject.respond_to?(:created_by_id )).to be true
    expect( subject.respond_to?(:updated_by_id) ).to be true
  end
end
