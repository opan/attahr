class ProductCategoryOrgRepository < Hanami::Repository
  def delete_by_product(product_category_id)
    product_category_orgs
      .where(product_category_id: product_category_id)
      .delete
  end
end
