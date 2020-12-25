Hanami::Model.migration do
  change do
    create_table :org_members do
      primary_key :id, type: :Bignum
      foreign_key :org_id, :orgs, on_delete: :cascade, null: false
      foreign_key :org_member_role_id, :org_member_roles, on_delete: :cascade, null: false
      foreign_key :profile_id, :profiles, on_delete: :cascade, null: false

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
