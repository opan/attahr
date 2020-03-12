Hanami::Model.migration do
  change do
    create_table :profiles do
      primary_key :id, type: :Bignum
      foreign_key :user_id, :users, on_delete: :cascade, null: false

      column :name, String
      column :dob, Date
      
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
    end
  end
end
