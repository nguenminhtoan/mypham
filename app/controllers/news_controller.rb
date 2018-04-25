# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class NewsController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "TIN TỨC"
    @icon = "fa fa-newspaper-o"
  end
  
  def index
    @title = "Danh sách tin tức"
    @list = News.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới tin tức"
    @new = News.new
    @categories = Categories.getlist(@db)
    render "new", :layout=>"layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa tin tức"
    news = News.find(@db, params[:id])
    @new = News.new(news)
    @categories = Categories.getlist(@db)
    render "edit", :layout=>"layout_admin"
  end
  
  def save
    @title = "Thêm mới tin tức"
    @new = News.new(params[:news])
    @new.id_customer = session[:id_user]
    if !@new.valid?(:new)
      @categories = Categories.getlist(@db)
      render "new", :layout => "layout_admin"
    else
      News.save(@db, @new, nil)
      redirect_to "/admin/news", :layout =>"layout_admin"
    end
  end
  
  def update
    @title = "Chỉnh sửa tin tức"
    @new = News.new(params[:news])
    if !@new.valid?
      @categories = Categories.getlist(@db)
      render "new", :layout => "layout_admin"
    else
      News.save(@db, @new, @new.id_news)
      redirect_to "/admin/news", :layout =>"layout_admin"
    end
  end
  
  def delete
    News.delete(@db,params[:id])
    redirect_to "/admin/news", :layout =>"layout_admin"
  end
end
