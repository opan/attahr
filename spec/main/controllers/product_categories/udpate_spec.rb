RSpec.describe Main::Controllers::ProductCategories::Update, type: :action do
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) {
    described_class.new(
      product_category_repo: product_category_repo,
      org_repo: org_repo
    )
  }
  let(:params) { Hash['warden' => @warden] }
  let(:category_params) { { name: product_category.name } }
  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:product_category) { Factory.structs[:product_category] }

  context 'with basic user' do
    context 'update existing product category' do
      before(:each) do
        params[:product_category] = { name: 'updated category' }
        params[:id] = product_category.id
        category_entity = ProductCategory.new(params[:product_category])

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(product_category.id).and_return product_category
        allow(product_category_repo).to receive(:transaction).and_yield
        expect(product_category_repo).to receive(:update).with(product_category.id, category_entity).and_return(category_entity)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'expose #product_category' do
        expect(action.exposures[:product_category]).not_to be_nil 
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq ['Product category has been successfully updated']
      end
    end

    context 'when missing ID' do
      before(:each) do
        params[:product_category] = { name: 'updated category' }

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq(422)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ['Id is missing']
      end
    end

    context 'when using invalid ID' do
      before(:each) do
        params[:product_category] = category_params
        params[:id] = 101

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(params[:id]).and_return nil

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq(302)
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find product category with ID #{params[:id]}"]
      end
    end
  end
end
