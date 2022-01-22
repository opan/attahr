RSpec.describe Main::Controllers::Products::Update, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:org_repo) { instance_double('OrgRepository') }

  let(:current_user) { @warden.user }
  let(:product) { Factory.structs[:product] }
  let(:category) { ProductCategory.new(id: product.product_category_id) }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:updated_params) {
    {
      name: 'Updated Product',
      price: 1212,
      product_category_id: product.product_category_id,
      sku: product.sku
    }
  }
  let(:params) { Hash['warden' => @warden] }
  let(:action) {
    described_class.new(
      product_repo: product_repo,
      product_category_repo: product_category_repo,
      org_repo: org_repo
    )
  }

  context 'with basic user' do
    context 'update existing product details' do
      before(:each) do
        params[:product] = updated_params
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(product)
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find_by_root_org).with(root_org.id).and_return([category])
        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:update).with(product.id, Product.new(updated_params))

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get success messages' do
        expect(action.exposures[:flash][:info]).to eq(['Product has been successfully updated'])
      end
    end

    context 'update product but with invalid ID' do
      before(:each) do
        params[:product] = updated_params
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(nil)
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find_by_root_org).with(root_org.id).and_return([category])

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(["Can't find product with ID #{product.id}"])
      end
    end

    context 'update product but sku set to nil' do
      before(:each) do
        params[:product] = updated_params
        params[:product][:sku] = nil
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(product)
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find_by_root_org).with(root_org.id).and_return([category])

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq 422
      end

      it 'expose #product' do
        expect(action.exposures[:product].name).to eq(product.name)
      end

      it 'expose #product_categories' do
        expect(action.exposures[:product_categories].length).to eq(1)
      end

      it 'get errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(["SKU can't be set to empty"])
      end
    end

    context 'update product but with invalid product category id' do
      before(:each) do
        params[:product] = updated_params
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(product)
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find_by_root_org).with(root_org.id).and_return([])

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get errors messages' do
        expect(action.exposures[:flash][:errors]).to eq(["Can't find product category with ID #{category.id}"])
      end
    end
  end
end
