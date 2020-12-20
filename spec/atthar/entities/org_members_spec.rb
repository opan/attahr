RSpec.describe OrgMembers, type: :entity do
  it 'has attributes' do
    expect( subject.respond_to?(:id) ).to be true
    expect( subject.respond_to?(:org_id) ).to be true
    expect( subject.respond_to?(:org_member_role_id) ).to be true
    expect( subject.respond_to?(:created_at )).to be true
    expect( subject.respond_to?(:updated_at) ).to be true
  end
end
