class Transaction < ApplicationRecord
  validates_presence_of :credit_card_number, :result

  belongs_to :invoice

  scope :successful, -> { where(result: "success") }

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['invoice_id']
      where("(invoice_id = ?)", params[:invoice_id].to_i)
    elsif params['credit_card_number']
      where("(credit_card_number = ?)", params[:credit_card_number])
    elsif params['result']
      where('LOWER(result) = ?', params[:result].downcase)
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}").order(:id)
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}").order(:id)
    end
  end

  def self.find_all(params)
    if params['id']
      where("id = ?", params[:id].to_i)
    elsif params['invoice_id']
      where("invoice_id = ?", params[:invoice_id].to_i)
    elsif params['credit_card_number']
      where("credit_card_number = ?", params[:credit_card_number])
    elsif params['result']
      where('LOWER(result) LIKE ?', "%#{params[:result].downcase}%")
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end
end
