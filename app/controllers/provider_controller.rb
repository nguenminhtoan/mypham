# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class ProviderController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "NHÀ CUNG CẤP"
    @icon = "fa fa-gears"
  end
  
  
  def index
    @title = "Danh sách nhà cung cấp"
    @list = Provider.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới nhà cung cấp"
    @new = Provider.new
    render "new", :layout => 'layout_admin'
  end
  
  def edit
    @title = "Chỉnh sửa nhà cung cấp"
    provider = Provider.find(@db, params[:id])
    @new = Provider.new(provider.first)
    render "edit", :layout => 'layout_admin'
  end
  
  def update
    @title = "Chỉnh sửa nhà cung cấp"
    @new = Provider.new(params[:provider])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Provider.save(@db, @new, @new.id_provider)
      redirect_to "/admin/provider", :layout => "layout_admin"
    end
  end
  
  def save
    @title = "Thêm mới nhà cung cấp"
    @new = Provider.new(params[:provider])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Provider.save(@db, @new, nil)
      redirect_to "/admin/provider", :layout => "layout_admin"
    end
    
  end
  
  def delete
    Provider.delete(@db, params[:id])
    redirect_to "/admin/provider", :layout => "layout_admin"
  end
end
