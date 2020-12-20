Hanami::Model.migration do
  change do
    create_table :orgs do
      primary_key :id, type: :Bignum

      column :name, String, null: false, unique: true
      column :address, String
      column :phone_numbers, String

      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
