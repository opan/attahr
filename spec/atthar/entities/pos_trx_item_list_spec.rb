# frozen_string_literal: true

RSpec.describe PosTrxItemList, type: :entity do
  it 'has attributes' do
    expect(subject.respond_to?(:id)).to be_truthy
    expect(subject.respond_to?(:product_id)).to be_truthy
    expect(subject.respond_to?(:name)).to be_truthy
    expect(subject.respond_to?(:sku)).to be_truthy
    expect(subject.respond_to?(:barcode)).to be_truthy
    expect(subject.respond_to?(:qty)).to be_truthy
    expect(subject.respond_to?(:price)).to be_truthy
  end
end
