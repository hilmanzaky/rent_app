class Payment < ActiveRecord::Base
  attr_accessor :remains

  belongs_to :order

  after_save do |payment|
    check_and_change_payment_status(payment)
  end

  after_destroy do |payment|
    check_and_change_payment_status(payment)
  end

  private
  def check_and_change_payment_status(payment)
    order = payment.order
    sum = order.payments.sum(:amount)
    if sum >= order.total_price
      order.update_attribute(:payment_status, "Lunas")
    elsif sum < order.total_price && sum > 0
      order.update_attribute(:payment_status, "Down Payment") if order.payment_status != "Down Payment"
    else
      order.update_attribute(:payment_status, "Belum Bayar") if order.payment_status != "Belum Bayar"
    end
  end

end
