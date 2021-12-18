RSpec.describe Main::Controllers::Products::Create, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:product_org_repo) { instance_double('ProductOrgRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }

  let(:current_user) { @warden.user }
  let(:product_params) {
    Factory.structs[:product].to_h.reject! { |k, v| [:created_at, :updated_at, :id].include? k  }
  }
  let(:action) {
    described_class.new(
      product_repo: product_repo,
      product_org_repo: product_org_repo,
      org_repo: org_repo,
      org_member_repo: org_member_repo
    )
  }

  let(:params) { Hash['warden' => @warden] }

  context 'with basic user' do
    context 'with valid params' do
      before do
        params[:product] = product_params
        params[:org_id] = 1
        product_entity = Product.new(product_params)
        product_org_entity = ProductOrg.new(product_id: product_entity.id, org_id: params[:org_id])

        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:find_by_sku_and_org).with(product_params[:sku], params[:org_id]).and_return nil
        expect(product_repo).to receive(:create).with(product_entity).and_return(product_entity)
        expect(product_org_repo).to receive(:create).with(product_org_entity).and_return(product_org_entity)

        @response = action.call(params)
      end
      
      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got success message' do
        expect(action.exposures[:flash][:info]).to eq ["Product #{product_params[:name]} has been successfully created"]
      end
    end

    context 'with duplicate SKU' do
      before do
        params[:product] = product_params
        params[:org_id] = 1
        product_entity = Product.new(product_params)
        product_org_entity = ProductOrg.new(product_id: product_entity.id, org_id: params[:org_id])

        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:find_by_sku_and_org).with(product_params[:sku], params[:org_id]).and_return product_entity

        @response = action.call(params)
      end
      
      it 'return 422' do
        expect(@response[0]).to eq 422
      end

      it 'got errors message' do
        expect(action.exposures[:flash][:errors]).to eq ["Found duplicate SKU: #{product_params[:sku]}"]
      end
    end

    context 'without organization' do
      before do
        params[:product] = product_params
        product_entity = Product.new(product_params)
        product_org_entity = ProductOrg.new(product_id: product_entity.id, org_id: params[:org_id])

        expect(org_member_repo).to receive(:find_root_org_by_email).with(current_user.email).and_return nil
        expect(org_member_repo).to receive(:find_by_emails).with([current_user.email]).and_return nil
        # allow(product_repo).to receive(:transaction).and_yield
        # expect(product_repo).to receive(:find_by_sku_and_org).with(product_params[:sku], params[:org_id]).and_return product_entity
        # expect(product_repo).to receive(:create).with(product_entity).and_return(product_entity)
        # expect(product_org_repo).to receive(:create).with(product_org_entity).and_return(product_org_entity)

        @response = action.call(params)
      end
      
      it 'return 422' do
        expect(@response[0]).to eq 422
      end

      it 'got errors message' do
        expect(action.exposures[:flash][:errors]).to eq ["You don't have relation to any Organization"]
      end
    end
  end
end
