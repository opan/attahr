RSpec.describe Mailers::InviteMembersOrg, type: :mailer do
  it 'delivers email' do
    mail = Mailers::InviteMembersOrg.deliver
  end
end
