Hanami::Model.migration do
  change do
    create_table :product_orgs do
      primary_key :id
      foreign_key :org_id, :orgs, on_delete: :cascade, null: false
      foreign_key :product_id, :products, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
