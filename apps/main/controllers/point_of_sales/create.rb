# frozen_string_literal: true

module Main
  module Controllers
    module PointOfSales
      class Create
        include Main::Action
        include Main::Authentication

        before :authenticate!

        expose :pos_session
        expose :root_org

        params do
          required(:point_of_sale).schema do
            required(:password).filled(:str?)
            required(:session_id).filled(:str?)
            required(:cashier_id).filled(:int?)
            required(:org_id).filled(:int?)
          end
        end

        def initialize(pos_repo: PointOfSaleRepository.new, org_repo: OrgRepository.new)
          @pos_repo = pos_repo
          @org_repo = org_repo
        end

        def call(params)
          @pos_session = PointOfSale.new(pos_params)

          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          user_profile = current_user.profile

          @root_org = @org_repo.find_root_org_by_member(user_profile.id)
          if @root_org.nil?
            flash[:errors] = ["Can't find root organization for current user"]
            redirect_to Main.routes.point_of_sales_path
          end

          if BCrypt::Password.new(current_user.password_hash) != pos_params[:password]
            flash[:errors] = ['Invalid password']
            self.status = 422
            return
          end

          @pos_repo.transaction do
            @pos_repo.create(@pos_session)
          end

          flash[:info] = ['POS session has been successfully created']
          redirect_to Main.routes.point_of_sales_path
        end

        private

        def pos_params
          params.get(:point_of_sale).merge(
            {
              state: PointOfSale::STATES[:open],
              created_by_id: current_user.profile.id,
              updated_by_id: current_user.profile.id
            }
          )
        end
      end
    end
  end
end
