# frozen_string_literal: true

RSpec.describe PointOfSale, type: :entity do
  it 'has attributes' do
    expect(subject.respond_to?(:id)).to be_truthy
    expect(subject.respond_to?(:org_id)).to be_truthy
    expect(subject.respond_to?(:session_id)).to be_truthy
    expect(subject.respond_to?(:cashier_id)).to be_truthy
    expect(subject.respond_to?(:created_at)).to be_truthy
    expect(subject.respond_to?(:updated_at)).to be_truthy
    expect(subject.respond_to?(:created_by_id)).to be_truthy
    expect(subject.respond_to?(:updated_by_id)).to be_truthy
  end
end
