Hanami::Model.migration do
  change do
    create_table :pos_trxes do
      primary_key :id
      foreign_key :pos_id, :pos, on_delete: :cascade

      column :trx_id, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Bignum
      column :updated_by_id, Bignum
    end
  end
end
