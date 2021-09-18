Hanami::Model.migration do
  up do
    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp"'

    create_table :org_invitations do
      primary_key :id, type: :Bignum
      foreign_key :org_id, :orgs, on_delete: :cascade, null: false

      column :invite_id, 'uuid', unique: true
      column :inviter, String, null: false
      column :invitees, String, null: false
      column :timeout, DateTime, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end

  down do
    drop_table :org_invitations
    execute 'DROP EXTENSION IF EXISTS "uuid-ossp"'
  end
end
