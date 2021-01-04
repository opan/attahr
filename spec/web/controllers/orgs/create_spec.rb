RSpec.describe Web::Controllers::Orgs::Create, type: :action do
  let(:org_repo) { instance_double('OrgRepository') }
  let(:org_member_repo) { instance_double('OrgMemberRepository') }
  let(:org_member_role_repo) { instance_double('OrgMemberRoleRepository') }
  let(:action) { described_class.new(org_repo: org_repo, org_member_repo: org_member_repo, org_member_role_repo: org_member_role_repo) }
  let(:params) { Hash['warden' => @warden] }
  let(:org_hash) { { id: 888, name: 'pt. default indonesia, tbk', display_name: 'PT. Default Indonesia, Tbk', created_by_id: 999, updated_by_id: 999 } }
  let(:org) { Org.new(org_hash) }
  let(:admin_role) { OrgMemberRole.new(id: 1, name: 'admin') }

  context 'with valid params' do
    before(:each) do
      params[:org] = {
        name: 'pt. default indonesia, tbk',
        address: 'West Java',
      }

      arg_org = Org.new(org_hash.reject { |k, v| k == :id })
      expect(org_repo).to receive(:create).with(arg_org).and_return org
      expect(org_member_role_repo).to receive(:get).with('admin').and_return admin_role

      member = OrgMember.new(org_id: org.id, profile_id: 1000, org_member_role_id: admin_role.id)
      expect(org_member_repo).to receive(:create).with(member)
    end

    it 'return 302' do
      response = action.call(params)
      expect(response).to have_http_status 302
    end

    it 'got a success messages' do
      response = action.call(params)
      expect(action.exposures[:flash][:info]).to eq ["Organization #{org.display_name} has been successfully created"]
    end

    it 'redirects to /orgs' do
      response = action.call(params)
      expect(response).to redirect_to '/orgs'
    end
  end

  context 'with invalid params' do
    before(:each) do
      params[:org] = {
        name: '',
        address: 'West Java',
      }

      @response = action.call(params)
    end

    it 'return 422' do
      expect(@response[0]).to eq 422
    end

    it 'got an error messages' do
      expect(action.exposures[:flash][:errors]).to eq ['Name must be filled']
    end
  end
end
