class ItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :id, :name, :description, :merchant_id

  attribute :unit_price do |invoice_item|
    "#{(invoice_item.unit_price.to_f / 100)}"
  end
end
