class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name

  has_many :invoices
  has_many :transactions, through: :invoices

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
