# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class New
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_session
        expose :root_org

        def initialize(pos_repo: PointOfSaleRepository.new, org_repo: OrgRepository.new)
          @pos_repo = pos_repo
          @org_repo = org_repo
        end

        def call(_)
          user_profile = current_user.profile

          @root_org = @org_repo.find_root_org_by_member(user_profile.id)
          if @root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.point_of_sales_path
          end

          opened_pos = @pos_repo.find_open_pos_by_user(user_profile.id)
          unless opened_pos.nil?
            flash[:errors] = ['There is still active POS session created by you.
              Please close it first before create a new session']
            redirect_to Main.routes.point_of_sales_path
          end

          @pos_session = PointOfSale.new(cashier_id: user_profile.id, session_id: generate_session)
        end

        private

        # Generate session ID for POS
        # It is constructed from:
        # POS-YY/MM/DD/{cashier-name}-{sequence}
        # Example:
        # POS-2022/02/28/username-01
        def generate_session
          # rand_an = [*('a'..'z'), *('0'..'9')].sample(4).join.upcase
          max_session_id = @pos_repo.get_max_session_id_by_user(current_user.profile.id)
          return "POS-#{Time.now.strftime('%Y/%m/%d')}/#{current_user.profile.name}-01" if max_session_id.nil?

          latest_seq = max_session_id.split('-').last
          "POS-#{Time.now.strftime('%Y/%m/%d')}/#{current_user.profile.name}-#{latest_seq.next}"
        end
      end
    end
  end
end
