class Api::V1::MerchantsController < ApplicationController
  def index
    render json: MerchantSerializer.new(Merchant.all)
  end

  def most_revenue
    merchants = Merchant.find_by_sql(["
      SELECT
      	items.merchant_id as id,
      	merchants.name,
        SUM(inv_items.quantity * inv_items.unit_price / 100) as revenue

      FROM
      	invoice_items inv_items JOIN
      	items ON inv_items.item_id = items.id JOIN
      	merchants on items.merchant_id = merchants.id

      GROUP BY
      	items.merchant_id, merchants.name

      ORDER BY
      	revenue DESC

      LIMIT ?", params[:quantity]])
    render json: MerchantSerializer.new(merchants)
  end
end
