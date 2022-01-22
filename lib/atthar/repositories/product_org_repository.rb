class ProductOrgRepository < Hanami::Repository
  def delete_by_product(product_id)
    product_orgs
      .where(product_id: product_id)
      .delete
  end
end
