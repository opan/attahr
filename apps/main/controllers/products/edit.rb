module Main
  module Controllers
    module Products
      class Edit
        include Main::Action
        include Main::Authentication

        expose :product
        expose :product_categories

        params do
          required(:id).filled(:int?)
        end

        def initialize(
          product_repo: ProductRepository.new,
          product_category_repo: ProductCategoryRepository.new,
          org_member_repo: OrgMemberRepository.new
        )
          @product_repo = product_repo
          @product_category_repo = product_category_repo
          @org_member_repo = org_member_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.errors_messages
            redirect_to Main.routes.products_path
          end

          @product = @product_repo.find(params[:id])
          if @product.nil?
            flash[:errors] = ["Can't find product with ID #{params[:id]}"]
            redirect_to Main.routes.products_path
          end

          org_members = @org_member_repo.find_by_emails([current_user.email])
          @product_categories = @product_category_repo.find_by_orgs(org_members.map(&:org_id))
        end
      end
    end
  end
end
