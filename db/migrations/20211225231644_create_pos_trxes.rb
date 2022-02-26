Hanami::Model.migration do
  change do
    create_table :pos_trxes do
      primary_key :id
      foreign_key :pos_id, :point_of_sales, on_delete: :cascade

      column :trx_id, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer
    end
  end
end
