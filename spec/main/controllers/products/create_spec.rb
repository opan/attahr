RSpec.describe Main::Controllers::Products::Create, type: :action do
  let(:product_repo) { instance_double('ProductRepository') }
  let(:product_org_repo) { instance_double('ProductOrgRepository') }
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }

  let(:current_user) { @warden.user }
  let(:product_params) {
    Factory.structs[:product].to_h.reject! { |k, _| %i[created_at updated_at id].include? k }
  }
  let(:root_org) { Factory[:org, is_root: true] }
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
    context 'create product' do
      before do
        params[:product] = product_params
        product_entity = Product.new(product_params)
        product_org_entity = ProductOrg.new(product_id: product_entity.id, org_id: root_org.id)

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:find_by_sku_and_org).with(product_params[:sku], root_org.id).and_return nil
        expect(product_repo).to receive(:create).with(product_entity).and_return(product_entity)
        expect(product_org_repo).to receive(:create).with(product_org_entity).and_return(product_org_entity)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq ["Product #{product_params[:name]} has been successfully created"]
      end
    end

    context 'create product without sku specified' do
      before do
        params[:product] = product_params.reject! { |k, _| %i[sku].include? k }
        product_entity = Product.new(product_params)
        product_org_entity = ProductOrg.new(product_id: product_entity.id, org_id: root_org.id)

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:find_by_sku_and_org).with(any_args, root_org.id).and_return nil
        expect(product_repo).to receive(:create).with(product_entity).and_return(product_entity)
        expect(product_org_repo).to receive(:create).with(product_org_entity).and_return(product_org_entity)

        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got success messages' do
        expect(action.exposures[:flash][:info]).to eq ["Product #{product_params[:name]} has been successfully created"]
      end
    end

    context 'create product with duplicate SKU' do
      before do
        params[:product] = product_params
        product_entity = Product.new(product_params)

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        allow(product_repo).to receive(:transaction).and_yield
        expect(product_repo).to receive(:find_by_sku_and_org).with(product_params[:sku], root_org.id).and_return product_entity
        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq 422
      end

      it 'got errors message' do
        product_entity = Product.new(product_params)
        expect(action.exposures[:flash][:errors]).to eq ["Found duplicate SKU: #{product_entity.sku}"]
      end
    end

    context 'create product without root organization' do
      before do
        params[:product] = product_params

        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(nil)
        @response = action.call(params)
      end

      it 'return 302' do
        expect(@response[0]).to eq 302
      end

      it 'got errors message' do
        expect(action.exposures[:flash][:errors]).to eq ["Can't find root organization for current user"]
      end
    end
  end
end
