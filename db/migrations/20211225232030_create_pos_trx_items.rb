Hanami::Model.migration do
  change do
    create_table :pos_trx_items do
      primary_key :id
      foreign_key :pos_trxes_id, :pos_trxes, on_delete: :set_null

      column :product_id, Bignum, null: false
      column :name, String, null: false
      column :sku, String, null: false
      column :price, BigDecimal, null: false, default: 0, size: [15, 2]
      column :product_category_id, Bignum, null: false
      column :category_name, String, null: false
      column :created_at, DateTime, null: false
      column :updated_at, DateTime, null: false
      column :created_by_id, Bignum
      column :updated_by_id, Bignum
    end
  end
end
