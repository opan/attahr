RSpec.describe Main::Controllers::ProductCategories::New, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:params) { Hash['warden' => @warden] }

  let(:current_user) { @warden.user }
  let(:root_org) { Factory.structs[:org, is_root: true] }

  context 'with basic user' do
    before(:each) do
      expect(org_repo).to receive(:find_root_org_by_member).with(current_user.profile.id).and_return(root_org)

      @response = action.call(params)
    end

    it 'return 200' do
      expect(@response[0]).to eq(200)
    end

    it 'expose #product_category' do
      expect(action.product_category).not_to be_nil
    end
  end
end
