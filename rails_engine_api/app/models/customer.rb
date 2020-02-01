class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :transactions, through: :invoices

  def self.find_one(params)
    if params['id']
      where("(id = ?)", params[:id].to_i)
    elsif params['first_name']
      where('LOWER(first_name) = ?', params[:first_name].downcase)
    elsif params['last_name']
      where('LOWER(last_name) = ?', params[:last_name].downcase)
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end

  def self.find_all(params)
    if params['id']
      where("(id::text LIKE ?)", "%#{params[:id]}%")
    elsif params['first_name']
      where('LOWER(first_name) LIKE ?', "%#{params[:first_name].downcase}%")
    elsif params['last_name']
      where('LOWER(last_name) LIKE ?', "%#{params[:last_name].downcase}%")
    elsif params['created_at']
      where('created_at = ?', "#{params[:created_at]}")
    elsif params['updated_at']
      where('updated_at = ?', "#{params[:updated_at]}")
    end
  end

  def self.pending_invoices(merchant_id)
    customers = find_by_sql("
      SELECT    customers.*
      FROM      customers JOIN
                invoices ON customers.id = invoices.customer_id
      WHERE     invoices.merchant_id = 17
      GROUP BY  customers.id

      EXCEPT

      SELECT    customers.*
      FROM      customers JOIN
                invoices ON customers.id = invoices.customer_id JOIN
                transactions on transactions.invoice_id = invoices.id
      WHERE     transactions.result = 'success' AND
                invoices.merchant_id = #{merchant_id}
      GROUP BY  customers.id;"
    )
  end
end
