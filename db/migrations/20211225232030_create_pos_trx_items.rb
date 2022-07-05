Hanami::Model.migration do
  change do
    create_table :pos_trx_items do
      primary_key :id
      foreign_key :pos_trx_id, :pos_trxes, on_delete: :set_null

      column :product_category_id, Integer, null: false
      column :product_id, Integer, null: false
      column :name, String, null: false
      column :sku, String, null: false, size: 20
      column :barcode, String, size: 30
      column :price, BigDecimal, null: false, default: 0, size: [15, 2]
      column :qty, Integer, null: false, default: 0
      column :state, Integer, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Integer
      column :updated_by_id, Integer
    end
  end
end
