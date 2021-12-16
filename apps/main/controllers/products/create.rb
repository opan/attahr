module Main
  module Controllers
    module Products
      class Create
        include Main::Action
        include Main::Authentication

        before :authenticate!

        params do
          required(:product).schema do
            required(:name).filled(:str?)
            optional(:sku).maybe(:str?)
            required(:price).filled(:int?)
            required(:product_category_id).filled
          end
        end

        def initialize(product_repo: ProductRepository.new, product_org_repo: ProductOrgRepository.new, org_member_repo: OrgMemberRepository.new)
          @product_repo = product_repo
          @product_org_repo = product_org_repo
          @org_member_repo = org_member_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          @org_members = @org_member_repo.find_by_emails([current_user.email])

          @product_repo.transaction do
            @sku = product_params[:sku]
            if total_sku > 0
              flash[:errors] = ["Found duplicate SKU: #{@sku}"]
              self.status = 422
              return
            end

            if sku_empty?
              @sku = "SKU-#{random_sku}"
              # generate sku
              # set sku
            end

            product = @product_repo.create(Product.new(product_params))

            @org_members.map(&:org_id).each do |org_id|
              @product_org_repo.create(ProductOrg.new(product_id: product.id, org_id: org_id))
            end

            if total_sku > 1
              raise ROM::SQL::Rollback
            end
          end
        end

        private

        def product_params
          params.get(:product)
        end

        def sku_empty?
          @sku.empty? || @sku.nil?         
        end

        def total_sku
          @product_repo.find_by_sku_and_orgs(@sku, @org_members.map(&:org_id)).length
        end

        def random_sku
          [*('a'..'z'),*('0'..'9')].shuffle[0,8].join.upcase
        end
      end
    end
  end
end
