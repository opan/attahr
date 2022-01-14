RSpec.describe Main::Controllers::ProductCategories::Edit, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:product_category_repo) { instance_double('ProductCategoryRepository') }
  let(:action) { described_class.new(product_category_repo: product_category_repo, org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }
  let(:category) { Factory.structs[:product_category] }

  context 'with basic user' do
    context 'with valid ID' do
      before(:each) do
        params[:id] = category.id
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(category.id).and_return(category)

        @response = action.call(params)
      end

      it 'return 200' do
        expect(@response[0]).to eq(200)
      end

      it 'expose #product_category' do
        expect(action.product_category).to eq category
      end
    end

    context 'with invalid ID' do
      before(:each) do
        params[:id] = category.id
        expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)
        expect(product_category_repo).to receive(:find).with(category.id).and_return(nil)

        @response = action.call(params)
      end

      it 'return 422' do
        expect(@response[0]).to eq(422)
      end

      it 'expose #product_category' do
        expect(action.product_category).to eq nil
      end
    end
  end
end
