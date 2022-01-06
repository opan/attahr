class ProductCategoryRepository < Hanami::Repository
  associations do
    has_many :products
    has_many :product_category_orgs
    has_many :orgs, through: :product_category_orgs
  end

  def find_by_orgs(org_ids = [])
    product_categories
      .qualified
      .join(product_category_orgs)
      .where(product_category_orgs[:org_id].qualified => org_ids)
      .map_to(ProductCategory)
      .to_a
  end

  def find_by_id_and_root_org(id, org_id)
    product_categories
      .qualified
      .join(orgs, id: product_category_orgs[:org_id].qualified)
      .where(product_categories[:id].qualified.is(id))
      .where(orgs[:id].qualified.is(org_id))
      .where(orgs[:is_root].qualified.is(true))
      .map_to(ProductCategory)
      .one
  end

  def find_by_root_org(org_id)
    product_categories
      .join(orgs, id: product_category_orgs[:org_id].qualified)
      .where(orgs[:id].qualified.is(org_id))
      .where(orgs[:is_root].qualified.is(true))
      .map_to(ProductCategory)
      .to_a
  end

  def find_by_name_and_root_org(name, org_id)
    product_categories
      .join(orgs, id: product_category_orgs[:org_id].qualified)
      .where(orgs[:id].qualified.is(org_id))
      .where(orgs[:is_root].qualified.is(true))
      .where(product_categories[:name].qualified.is(name))
      .map_to(ProductCategory)
      .to_a
  end
end
