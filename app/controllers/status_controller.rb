# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class StatusController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "ĐƠN ĐẶT HÀNG"
    @icon = "glyphicon glyphicon-usd"
  end
  def index
    @title = "Danh sách trạng thái"
    @list = Status.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa trạng thái"
    @list = Status.getlist(@db)
    @new = Status.new
    render "edit", :layout => "layout_admin"
  end
  
  
  def save
    @title = "Chỉnh sửa trạng thái"
    @status = params[:statusArr]
    if @status.present?
      @status.each { |val|
        Status.save(@db, val["name"], val['text'], val["id_status"])
      }
      redirect_to "/admin/status", :layout => "layout_admin"
    else
      @list = params[:statusArr]
      @new = Status.new
      render "edit", :layout => "layout_admin"
    end
  end
  
  def delete
    Status.delete(@db, params[:id])
    redirect_to "/admin/status", :layout => "layout_admin"
  end
end
