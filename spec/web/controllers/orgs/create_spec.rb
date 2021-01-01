RSpec.describe Web::Controllers::Orgs::Create, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:action) { described_class.new(org_repo: org_repo) }
  let(:params) { Hash[user_id: @warden.user.id, 'warden' => @warden] }
  let(:org_hash) { { id: 888, name: 'pt. default indonesia, tbk', display_name: 'PT. Default Indonesia, Tbk', created_by_id: 999, updated_by_id: 999 } }
  let(:org) { Org.new(org_hash) }

  context 'with valid params' do
    before(:each) do
      params[:org] = {
        name: 'pt. default indonesia, tbk',
        display_name: 'PT. Default Indonesia, Tbk',
        address: 'West Java',
      }

      arg_org = Org.new(org_hash.reject { |k, v| k == :id })
      expect(org_repo).to receive(:create).with(arg_org).and_return org
    end

    it 'return 302' do
      response = action.call(params)
      expect(response[0]).to eq 302
    end

    it 'got a success messages' do
      response = action.call(params)
      expect(action.exposures[:flash][:info]).to eq ["Organization #{org.display_name} has been successfully created"]
    end


    # The user_id is the same with @warden.user.id
    it "redirects to /orgs/999" do
      response = action.call(params)
      expect(response[1]['Location']).to eq '/orgs/999'
    end
  end

  context 'with empty display_name' do
    before(:each) do
      params[:org] = {
        name: 'pt. default indonesia, tbk',
        address: 'West Java',
      }

      arg_org = Org.new(org_hash.merge({display_name: org_hash[:name]}).reject { |k, v| k == :id })
      expect(org_repo).to receive(:create).with(arg_org).and_return org
    end

    it 'display_name is set to name if empty' do
      response = action.call(params)
    end
  end
end
