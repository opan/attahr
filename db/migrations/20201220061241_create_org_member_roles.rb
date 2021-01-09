Hanami::Model.migration do
  change do
    create_table :org_member_roles do
      primary_key :id, type: :Bignum

      column :name, String, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false

      index :name
    end
  end
end
