module Main
  module Controllers
    module Products
      class Destroy
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:id).filled
        end

        def initialize(product_repo: ProductRepository.new, product_org_repo: ProductOrgRepository.new)
          @product_repo = product_repo
          @product_org_repo = product_org_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.errors_messages
            redirect_to Main.routes.products_path
          end

          product = @product_repo.find(params[:id])

          if product.nil?
            flash[:errors] = ["Can't find product with ID #{params[:id]}"]
            redirect_to Main.routes.products_path
          end

          @product_repo.transaction do
            @product_repo.delete(product.id)
            @product_org_repo.delete_by_product(product.id)
          end

          flash[:info] = ['Product has been successfully deleted']
          redirect_to Main.routes.products_path
        end
      end
    end
  end
end
