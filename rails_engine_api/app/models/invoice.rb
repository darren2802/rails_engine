class Invoice < ApplicationRecord
  validates_presence_of :status

  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions

  belongs_to :customer
  belongs_to :merchant

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['customer_id']
      where("(customer_id = ?)", params[:customer_id].to_i)
    elsif params['merchant_id']
      where("(merchant_id = ?)", params[:merchant_id].to_i)
    elsif params['status']
      where('LOWER(status) = ?', params[:status].downcase)
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}").order(:id)
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}").order(:id)
    end
  end

  def self.find_all(params)
    if params['id']
      where("id = ?", params[:id].to_i)
    elsif params['customer_id']
      where("customer_id = ?", params[:customer_id].to_i)
    elsif params['merchant_id']
      where("merchant_id = ?", params[:merchant_id].to_i)
    elsif params['status']
      where('LOWER(status) LIKE ?', "%#{params[:status].downcase}%")
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end

  def self.revenue_by_date(date)
    select('sum(quantity * unit_price)::float/100 as total_revenue')
    .joins(:invoice_items, :transactions)
    .merge(Transaction.successful)
    .where("invoices.created_at::date::text = ?", date)[0]['total_revenue']
  end

  def self.favorite_customer(merchant_id)
    Invoice.joins(:customer, :transactions)
            .select('customers.*, COUNT(*)')
            .where('invoices.merchant_id = ?', merchant_id)
            .group('customers.id')
            .merge(Transaction.successful)
            .order('count DESC').limit(1)[0]
  end
end
