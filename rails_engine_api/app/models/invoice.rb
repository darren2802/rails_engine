class Invoice < ApplicationRecord
  validates_presence_of :status, :created_at, :updated_at

  has_many :invoice_items
  has_many :items, through: :invoice_items

  belongs_to :customer
  belongs_to :merchant
end
