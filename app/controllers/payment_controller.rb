# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class PaymentController < ApplicationController
  
  before_action :getTitle
  
  def getTitle
    @page = "DANH MỤC"
    @icon = "fa fa-navicon"
  end
  
  def index
    @title = "Danh sách hình thức thanh toán"
    @list = Payment.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới hình thức thanh toán"
    @new = Payment.new
    render "new", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa hình thức thanh toán"
    payment = Payment.find(@db, params[:id])
    @new = Payment.new(payment.first)
    render "edit", :layout => "layout_admin"
  end
  
  def save
    @title = "Thêm mới hình thức thanh toán"
    @new = Payment.new(params[:payment])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Payment.save(@db, @new, nil)
      redirect_to "/admin/payment", :layout => "layout_admin"
    end
  end
  
  def update
    @title = "Chỉnh sửa hình thức thanh toán"
    @new = Payment.new(params[:payment])
    if !@new.valid?
      render "edit", :layout => "layout_admin"
    else
      Payment.save(@db, @new, @new.id_payment)
      redirect_to "/admin/payment", :layout => "layout_admin"
    end
  end
  
  def delete
    Payment.delete(@db, params[:id])
    redirect_to "/admin/payment", :layout => "layout_admin"
  end
  
end
