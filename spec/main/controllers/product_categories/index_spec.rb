RSpec.describe Main::Controllers::ProductCategories::Index, type: :action do
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(product_category_repo: product_category_repo, org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:product_categories) { Array.new(2) { Factory.structs[:product_category] }}
  let(:root_org) { Factory.structs[:org, is_root: true] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
      expect(product_category_repo).to receive(:find_by_root_org).with(root_org.id).and_return(product_categories)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq(200)
    end

    it 'return list of product categories' do
      expect(action.product_categories.to_a).to eq(product_categories)
    end
  end
end
