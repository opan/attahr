RSpec.describe Main::Controllers::Products::Index, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:action) { described_class.new(product_repo: product_repo, org_member_repo: org_member_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:products) { Array.new(2) { Factory.structs[:product] }}
  let(:org_members) { Array.new(1) { OrgMember.new(org_id: 1) }}

  context 'with basic user' do
    before(:each) do
      expect(org_member_repo).to receive(:find_by_emails).with([current_user.email]).and_return(org_members)
      expect(product_repo).to receive(:find_by_orgs).with(org_members.map(&:org_id)).and_return(products)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq 200
    end

    it 'return list of products' do
      expect(action.products.to_a).to eq products
    end
  end
end
