Hanami::Model.migration do
  change do
    create_table :product_categories do
      primary_key :id
      foreign_key :org_id, :orgs, on_delete: :set_null

      column :name, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Bignum
      column :updated_by_id, Bignum
    end
  end
end
