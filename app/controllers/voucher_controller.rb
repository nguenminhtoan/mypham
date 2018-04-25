# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class VoucherController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "KHUYẾN MÃI"
    @icon = "fa fa-gift"
  end
  def index
    @title = "Danh sách khuyến mãi"
    @list = Voucher.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới khuyến mãi"
    @new = Voucher.new
    render "new", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa khuyến mãi"
    voucher = Voucher.find(@db, params[:id])
    @new = Voucher.new(voucher.first)
    render "edit", :layout => "layout_admin"
  end
  
  def save
    @title = "Thêm mới khuyến mãi"
    @new = Voucher.new(params[:voucher])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Voucher.save(@db, @new, nil)
      redirect_to "/admin/voucher", :layout => "layout_admin"
    end
  end
  
  def update
    @title = "Chỉnh sửa khuyến mãi"
    @new = Voucher.new(params[:voucher])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Voucher.save(@db, @new, @new.id_voucher)
      redirect_to "/admin/voucher", :layout => "layout_admin"
    end
  end
  
  
  def delete
    Voucher.delete(@db, params[:id])
    redirect_to "/admin/voucher", :layout => "layout_admin"
  end
end
