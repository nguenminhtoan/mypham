# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class CategoriesController < ApplicationController
   before_action :getTitle
  
  def getTitle
    @page = "DANH MỤC"
    @icon = "fa fa-navicon"
  end
  
  def index
    @title = "Danh mục sản phẩm"
    @list = Categories.getlist(@db)
    render "index", :layout=>'layout_admin'
  end
  
  def edit
    @title = "Chỉnh sửa danh mục sản phẩm"
    categories = Categories.find(@db, params[:id])
    @new = Categories.new(categories)
    @list = Categories.getpresent(@db)
    render "edit", :layout=>'layout_admin'
  end
  
  def new
    @title = "Thêm mới danh mục sản phẩm"
    @new = Categories.new
    @list = Categories.getpresent(@db)
    render "new", :layout=>'layout_admin'
  end
  
  def save
    @title = "Thêm mới danh mục sản phẩm"
    @new = Categories.new(params[:categories])
    if !@new.valid?
      @list = Categories.getpresent(@db)
      render "new", :layout=>'layout_admin'
    else
      Categories.save(@db, @new)
      redirect_to '/admin/categories', :layout=>'layout_admin'
    end
  end
  
  def update
    @title = "Chỉnh sửa danh mục sản phẩm"
    @new = Categories.new(params[:categories])
    if !@new.valid?
      @list = Categories.getpresent(@db)
      render "edit", :layout=>'layout_admin'
    else
      Categories.save(@db, @new, @new.id_categories)
      redirect_to '/admin/categories', :layout=>'layout_admin'
    end
  end
  
  def delete
    Categories.delete(@db,params[:id])
    redirect_to '/admin/categories', :layout => 'layout_admin'
  end
  
end
