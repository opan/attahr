RSpec.describe Main::Controllers::Products::Edit, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:product_category_repo) { instance_double('ProductCategoryReposirory') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }

  let(:current_user) { @warden.user }
  let(:product) { Factory.structs[:product, product_category_id: product_category.id] }
  let(:product_category) { Factory.structs[:product_category] }
  let(:org_members) { Array.new(2) { Factory.structs[:org_member] }}
  let(:params) { Hash['warden' => @warden] }
  let(:action) {
    described_class.new(
      product_repo: product_repo,
      product_category_repo: product_category_repo,
      org_member_repo: org_member_repo
    )
  }

  context 'with basic user' do
    context 'update product details' do
      before(:each) do
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return product
        expect(org_member_repo).to receive(:find_by_emails).with([current_user.email]).and_return org_members
        expect(product_category_repo).to receive(:find_by_orgs).with(org_members.map(&:org_id)).and_return [product_category]

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq 200
      end

      it 'expose #product' do
        expect(action.exposures[:product]).to eq product
      end

      it 'expose #product_categories' do
        expect(action.exposures[:product_categories]).to eq [product_category]
      end
    end

    context 'update product but product not found' do
      before(:each) do
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return nil

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find product with ID #{product.id}"]
      end
    end
  end
end
