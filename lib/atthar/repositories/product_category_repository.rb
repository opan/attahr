class ProductCategoryRepository < Hanami::Repository
  associations do
    has_many :products
    has_many :product_category_orgs
  end

  def find_by_orgs(org_ids = [])
    product_categories
      .qualified
      .join(product_category_orgs)
      .where(product_category_orgs[:org_id].qualified.in(org_ids))
      .map_to(ProductCategory)
      .to_a
  end
end
