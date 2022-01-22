RSpec.describe Main::Controllers::ProductCategories::Destroy, type: :action do
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:product_category_org_repo) { instance_double('ProductCategoryOrgRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) {
    described_class.new(
      product_category_repo: product_category_repo,
      product_category_org_repo: product_category_org_repo,
      org_repo: org_repo
    )
  }
  let(:params) { Hash['warden' => @warden] }
  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:product_category) { Factory.structs[:product_category] }

  context 'with basic user' do
    context 'delete product category with valid ID' do
      before do
        params[:id] = product_category.id

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(product_category.id).and_return(product_category)
        allow(product_category_repo).to receive(:transaction).and_yield
        expect(product_category_repo).to receive(:delete).with(product_category.id)
        expect(product_category_org_repo).to receive(:delete_by_category).with(product_category.id)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get success messages' do
        expect(action.exposures[:flash][:info]).to eq ['Product category has been successfully deleted']
      end
    end

    context 'delete product category with invalid ID' do
      before do
        params[:id] = product_category.id

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(product_category.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find product category with ID #{params[:id]}"]
      end
    end
  end
end
