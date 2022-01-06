RSpec.describe Main::Controllers::ProductCategories::Create, type: :action do
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
  let(:category_params) { { name: product_category.name } }
  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:product_category) { Factory.structs[:product_category] }

  context 'with basic user' do
    context 'create new product category' do
      before(:each) do
        params[:product_category] = category_params
        category_entity = ProductCategory.new(category_params)
        category_org_entity = ProductCategoryOrg.new(
          product_category_id: product_category.id,
          org_id: root_org.id
        )

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find_by_name_and_root_org).with(category_entity.name, root_org.id).and_return nil
        allow(product_category_repo).to receive(:transaction).and_yield
        expect(product_category_repo).to receive(:create).with(category_entity).and_return(product_category)
        expect(product_category_org_repo).to receive(:create).with(category_org_entity)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq ['Product category has been successfully created']
      end
    end
  end
end
