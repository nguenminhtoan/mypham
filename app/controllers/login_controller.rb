# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class LoginController < ApplicationController
  def index
    @account = Account.new
    render "index", layout: "layout1"
  end
  
  def auth
    @account = Account.new(params[:account])
    unless @account.valid?
      render "index", layout: "layout1"
    else
      res = Customer.autemail(@db, @account.username)
      if (res.nil?)
        @account.errors[:username] << "không đúng"
        render "index", :layout=>"layout1"
      elsif(Customer.authentication(@db, @account.username, @account.password, res['selt']).nil?)
        @account.errors[:password] << "không đúng"
        render "index", :layout=>"layout1"
      else
        if res['id_group'].to_i <= 2
          session[:id_user] = res['id_customer']
          session[:date_login] = DateTime.now.strftime('%Y/%m/%d %H:%M')
          redirect_to '/admin/dashboard', :layout=>'layout_admin'
        else
          @account.errors[:username] << "không có quyền đăng nhập"
          render "index", :layout=>"layout1"
        end
      end
    end
  end
  
  def logout
    session.delete(:id_user)
    redirect_to :controller => 'login', :action=> 'index'
  end
end
