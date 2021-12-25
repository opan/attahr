RSpec.describe Main::Controllers::Products::Destroy, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:product_org_repo) { instance_double('ProductOrgRepository') }

  let(:product) { Factory.structs[:product] }
  let(:action) { described_class.new(product_repo: product_repo, product_org_repo: product_org_repo) }
  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'delete product with valid ID' do
      before do
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(product)
        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:delete).with(product.id)
        expect(product_org_repo).to receive(:delete_by_product).with(product.id)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get success messages' do
        expect(action.exposures[:flash][:info]).to eq ['Product has been successfully deleted']
      end
    end

    context 'delete product with invalid ID' do
      before do
        params[:id] = product.id

        expect(product_repo).to receive(:find).with(product.id).and_return(nil)
        # allow(product_repo).to receive(:transaction).and_yield
        # expect(product_repo).to receive(:delete).with(product.id)
        # expect(product_org_repo).to receive(:delete_by_product).with(product.id)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'get errors messages' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find product with ID #{params[:id]}"]
      end
    end
    
  end
end
