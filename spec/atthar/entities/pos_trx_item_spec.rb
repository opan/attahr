RSpec.describe PosTrxItem, type: :entity do
  it 'has attributes' do
    expect(subject.respond_to?(:id)).to be_truthy
    expect(subject.respond_to?(:pos_trxes_id)).to be_truthy
    expect(subject.respond_to?(:product_id)).to be_truthy
    expect(subject.respond_to?(:name)).to be_truthy
    expect(subject.respond_to?(:sku)).to be_truthy
    expect(subject.respond_to?(:price)).to be_truthy
    expect(subject.respond_to?(:product_category_id)).to be_truthy
    expect(subject.respond_to?(:category_name)).to be_truthy
    expect(subject.respond_to?(:created_at)).to be_truthy
    expect(subject.respond_to?(:updated_at)).to be_truthy
    expect(subject.respond_to?(:created_by_id)).to be_truthy
    expect(subject.respond_to?(:updated_by_id)).to be_truthy
  end
end
