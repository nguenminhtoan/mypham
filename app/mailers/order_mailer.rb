# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class OrderMailer < ApplicationMailer
  
  
  def welcome_email(user)
    @user = user
    @url  = 'http://example.com/login'
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
  
  def order(detail, user, sale = nill)
    @user = user
    @detail = detail
    @sale = 0
    @sale = sale['percent'] if sale.present?
    mail(to: @user['email'], subject: 'Xác Nhận Đơn Hàng')
  end
  
end
