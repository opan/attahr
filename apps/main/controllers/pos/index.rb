# frozen_string_literal: true

module Main
  module Controllers
    module Pos
      class Index
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_sessions

        def initialize(pos_repo: PosRepository.new, org_repo: OrgRepository.new)
          @pos_repo = pos_repo
          @org_repo = org_repo
        end

        def call(_)
          root_org = @org_repo.find_root_org_by_member(current_user.profile.id)
          @pos_sessions = @pos_repo.all_by_org(root_org.id)
        end
      end
    end
  end
end
