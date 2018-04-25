# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class ProductController < ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "SẢN PHẨM"
    @icon = "fa fa-product-hunt"
  end
  
  def index
    @title = "Danh sách sản phẩm"
    @list = Product.getlist(@db)
    render "index", :layout=>'layout_admin'
  end
  
  def new
    @title = "Thêm mới sản phẩm"
    @new = Product.new
    @categories = Categories.getlist(@db)
    @attribute = Attribute.getlist(@db)
    @provider = Provider.getlist(@db)
    render 'new', :layout=>'layout_admin'
  end
  
  def edit
    @title = "Chỉnh sửa sản phẩm"
    product = Product.find(@db, params[:id])
    @new = @new = Product.new(product.first) 
    @categories = Categories.getlist(@db)
    @attribute = Attribute.getlist(@db)
    @att = ProductAttribute.find(@db, params[:id])
    @link = ProductImage.find(@db, params[:id]).map { |u| u['link'] }
    @provider = Provider.getlist(@db)
    render 'edit', :layout=>'layout_admin'
  end
  
  def save
    @title ="Thêm mới sản phẩm"
    @new = Product.new(params[:product])
    image = params[:image]
    @new.image = image.first if image.present?
    @att = params[:attributes]
    @vou = params[:vouchers]
    if !@new.valid?
      @link = params[:link][:image] if params[:link].present?
      @categories = Categories.getlist(@db)
      @attribute = Attribute.getlist(@db)
      @provider = Provider.getlist(@db)
      render 'new', :layout=>'layout_admin'
    else
      begin
        Product.getlast(@db)
        Product.save(@db, @new, nil)
        ProductImage.save(@db,Product.getlast(@db)['id_product'], image)
        ProductAttribute.save(@db, Product.getlast(@db)['id_product'], @att)
        redirect_to '/admin/product', :layout => 'layout_admin'
      rescue => ex
        raise ex
      end
    end
    
  end
  
  
  
  def update
    @new = Product.new(params[:product])
    image = params[:image] 
    @new.image = image.first if image.present?
    @att = params[:attributes]
    @vou = params[:vouchers]
    if !@new.valid?
      @link = params[:link].map{ |u| u['image']} if params[:link].present?
      @categories = Categories.getlist(@db)
      @attribute = Attribute.getlist(@db)
      @provider = Provider.getlist(@db)
      render 'edit', :layout=>'layout_admin'
    else
      begin
        Product.save(@db, @new, @new.id_product)
        ProductImage.save(@db,  @new.id_product, image) if image.present?
        ProductAttribute.save(@db,  @new.id_product, @att)
        redirect_to '/admin/product', :layout => 'layout_admin'
      rescue => ex
        raise ex
      end
    end
  end
  
  
  def delete
    ProductAttribute.delete(@db, params[:id])
    ProductImage.delete(@db,  params[:id])
    Product.delete(@db, params[:id])
    redirect_to '/admin/product', :layout => 'layout_admin'
  end
end
