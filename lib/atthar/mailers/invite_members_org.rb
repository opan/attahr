module Mailers
  class InviteMembersOrg
    include Hanami::Mailer

    from    'bot@posas.com'
    to      :recipient
    subject :subject

    private

    def recipient
      users
    end

    def subject
      "Invitation to join organization #{org.display_name}"
    end
  end
end
