module ApplicationHelper
  def money_format(money)
    number_to_currency(money, :delimiter => '.', :unit => '', :precision => 0)
  end

  def iconed_text(icon, text)
    "<span class='#{icon}'></span>#{text}".html_safe
  end
end
