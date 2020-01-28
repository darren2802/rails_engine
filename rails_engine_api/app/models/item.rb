class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price, :created_at, :updated_at

  has_many :invoice_items
  has_many :invoices, through: :invoice_items

  belongs_to :merchant
end
