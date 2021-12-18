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
          optional(:org_id).maybe(:int?)
        end

        def initialize(
          product_repo: ProductRepository.new,
          product_org_repo: ProductOrgRepository.new,
          org_member_repo: OrgMemberRepository.new,
          org_repo: OrgRepository.new
        )
          @product_repo = product_repo
          @product_org_repo = product_org_repo
          @org_member_repo = org_member_repo
          @org_repo = org_repo
        end

        def call(params)
          unless params.valid?
            flash[:errors] = params.error_messages
            self.status = 422
            return
          end

          org_id = params[:org_id]

          if org_id.nil?
            org_member = @org_member_repo.find_root_org_by_email(current_user.email)
            
            if org_member.nil?
              org_members = @org_member_repo.find_by_emails([current_user.email])
              org_member = org_members.first unless org_members.nil?
            end

            if org_member.nil?
              flash[:errors] = ["You don't have relation to any Organization"]
              self.status = 422
              return
            end

            org_id = org_member.org_id
          end

          @product_repo.transaction do
            @sku = product_params[:sku]
            product_entity = Product.new(product_params)

            if sku_empty?
              @sku = "SKU-#{random_sku}"
              product_entity = Product.new(product_params.merge({sku: @sku}))
            end

            duplicate_sku = @product_repo.find_by_sku_and_org(@sku, org_id)

            if duplicate_sku
              flash[:errors] = ["Found duplicate SKU: #{@sku}"]
              self.status = 422
              return
            end

            product = @product_repo.create(product_entity)
            product_org = @product_org_repo.create(ProductOrg.new(product_id: product.id, org_id: org_id))

            if product.nil? || product_org.nil?
              raise ROM::SQL::Rollback
            end
          end

          flash[:info] = ["Product #{product_params[:name]} has been successfully created"]
          redirect_to Main.routes.products_path
        end

        private

        def product_params
          params.get(:product)
        end

        def sku_empty?
          @sku.empty? || @sku.nil?         
        end

        def random_sku
          [*('a'..'z'),*('0'..'9')].shuffle[0,8].join.upcase
        end
      end
    end
  end
end
