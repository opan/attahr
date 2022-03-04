RSpec.describe PosTrx, type: :entity do
  it 'has attributes' do
    expect(subject.respond_to?(:id)).to be_truthy
    expect(subject.respond_to?(:point_of_sale_id)).to be_truthy
    expect(subject.respond_to?(:trx_id)).to be_truthy
    expect(subject.respond_to?(:state)).to be_truthy
    expect(subject.respond_to?(:created_at)).to be_truthy
    expect(subject.respond_to?(:updated_at)).to be_truthy
    expect(subject.respond_to?(:created_by_id)).to be_truthy
    expect(subject.respond_to?(:updated_by_id)).to be_truthy
  end
end
