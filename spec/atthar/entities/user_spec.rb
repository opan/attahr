RSpec.describe User, type: :entity do
  it 'has attributes' do
    expect( subject.respond_to?(:id) ).to be true
    expect( subject.respond_to?(:username) ).to be true
    expect( subject.respond_to?(:email) ).to be true
    expect( subject.respond_to?(:password_hash) ).to be true
    expect( subject.respond_to?(:created_at )).to be true
    expect( subject.respond_to?(:updated_at) ).to be true

    expect( subject.respond_to?(:profile) ).to be true
  end
end
