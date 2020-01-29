class Merchant < ApplicationRecord
  validates_presence_of :name

  def self.most_revenue(quantity)
    require "pry"; binding.pry
  end
end
