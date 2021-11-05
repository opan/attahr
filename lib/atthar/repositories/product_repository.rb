class ProductRepository < Hanami::Repository
  associations do
    has_many :product_orgs
    belongs_to :product_category
  end

  def find_by_orgs(org_ids = [])
    aggregate(:product_category)
      .qualified
      .join(product_orgs)
      .where(product_orgs[:org_id].qualified.in(org_ids))
      .map_to(Product)
      .to_a
  end

  def find_by_product_category(product_category_id)
    products
      .where(product_category_id: product_category_id)
      .map_to(Product)
      .to_a
  end
end
