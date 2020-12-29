module Web
  module Controllers
    module Orgs
      class Index
        include Web::Action
        include Web::Authentication

        before :authenticate!

        expose :orgs

        def initialize(org_repo: OrgRepository.new, user_repo: UserRepository.new)
          @org_repo = org_repo
          @user_repo = user_repo
        end

        def call(params)
          user = @user_repo.find_with_profile(params[:user_id])
          if user.nil?
            flash[:errors] = 'User not found'
            halt 404
          end

          @orgs = @org_repo.find_by_member(user.profile.id)
        end
      end
    end
  end
end
