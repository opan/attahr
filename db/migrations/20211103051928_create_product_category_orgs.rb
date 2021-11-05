Hanami::Model.migration do
  change do
    create_table :product_category_orgs do
      primary_key :id
      foreign_key :org_id, :orgs, on_delete: :cascade, null: false
      foreign_key :product_category_id, :product_categories, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
