# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class BannerController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "BANNER"
    @icon = "glyphicon glyphicon-earphone"
  end
  def index
    @title = "Danh sách banner"
    @list = Banner.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới banner"
    @new = Banner.new
    render "new", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa banner"
    banner = Banner.find(@db, params[:id])
    @new = Banner.new(banner.first)
    render "edit", :layout => "layout_admin"
  end
  
  def save
    @title = "Thêm mới banner"
    @new = Banner.new(params[:banner])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Banner.save(@db, @new, nil)
      redirect_to "/admin/banner", :layout => "layout_admin"
    end
  end
  
  def update
    @title = "Chỉnh sửa banner"
    @new = Banner.new(params[:banner])
    if !@new.valid?
      render "edit", :layout => "layout_admin"
    else
      Banner.save(@db, @new, @new.id_banner)
      redirect_to "/admin/banner", :layout => "layout_admin"
    end
  end
  
  def delete
    Banner.delete(@db, params[:id])
    redirect_to "/admin/banner", :layout => "layout_admin"
  end
end
