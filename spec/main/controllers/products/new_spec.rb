RSpec.describe Main::Controllers::Products::New, type: :action do
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:action) { described_class.new(product_category_repo: product_category_repo, org_member_repo: org_member_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:org_members) { Array.new(1) { OrgMember.new(org_id: 1) }}
  let(:product_categories) { Array.new(2) { Factory.structs[:product_category] }}

  context 'with basic user' do
    before do
      expect(org_member_repo).to receive(:find_by_emails).with([current_user.email]).and_return(org_members)
      expect(product_category_repo).to receive(:find_by_orgs).with(org_members.map(&:org_id)).and_return(product_categories)
      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of product categories' do
      expect(action.product_categories.to_a).to eq product_categories
    end
  end
end
