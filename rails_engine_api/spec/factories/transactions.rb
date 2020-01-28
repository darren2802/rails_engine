FactoryBot.define do
  factory :transaction do
    credit_card_number { 1 }
    credit_card_expiration_date { "2020-01-27 18:01:05" }
    result { "MyString" }
    invoice { nil }
  end
end
