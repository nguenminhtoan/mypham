# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class AttributeController <ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "SẢN PHẨM"
    @icon = "fa fa-product-hunt"
  end
  
  def index
    @title ="Danh sách thuộc tính"
    @list = Attribute.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa thuộc tính"
    @list = Attribute.getlist(@db)
    @new = Attribute.new
    render "edit", :layout => "layout_admin"
  end
  
  
  def save
    @title = "Chỉnh sửa thuộc tính"
    @attribute = params[:attributes]
    if @attribute.present?
      @attribute.each { |val|
        Attribute.save(@db, val["attribute"], val['sort_order'], val["id_attribute"])
      }
      redirect_to "/admin/attribute", :layout => "layout_admin"
    end
  end
  
  def delete
    ProductAttribute.deleteAttr(@db,params[:id])
    Attribute.delete(@db, params[:id])
    redirect_to "/admin/attribute", :layout => "layout_admin"
  end
  
end
