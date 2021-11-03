RSpec.describe Product, type: :entity do
  it 'has attributes' do
    expect( subject.respond_to?(:id) ).to be true
    expect( subject.respond_to?(:product_category_id) ).to be true
    expect( subject.respond_to?(:name) ).to be true
    expect( subject.respond_to?(:sku) ).to be true
    expect( subject.respond_to?(:price) ).to be true
    expect( subject.respond_to?(:created_at )).to be true
    expect( subject.respond_to?(:updated_at) ).to be true
    expect( subject.respond_to?(:created_by_id) ).to be true
    expect( subject.respond_to?(:updated_by_id) ).to be true
  end
end
