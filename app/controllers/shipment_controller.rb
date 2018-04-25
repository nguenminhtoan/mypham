# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class ShipmentController <ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "DANH MỤC"
    @icon = "fa fa-navicon"
  end
  def index
    @title = "Danh sách hình thức vận chuyển"
    @list = Shipment.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def new
    @title = "Thêm mới hình thức vận chuyển"
    @new = Shipment.new
    render "new", :layout => "layout_admin"
  end
  
  def edit
    @title = "Chỉnh sửa hình thức vận chuyển"
    shipment = Shipment.find(@db, params[:id])
    @new = Shipment.new(shipment.first)
    render "edit", :layout => "layout_admin"
  end
  
  def save
    @title = "Thêm mới hình thức vận chuyển"
    @new = Shipment.new(params[:shipment])
    if !@new.valid?
      render "new", :layout => "layout_admin"
    else
      Shipment.save(@db, @new, nil)
      redirect_to "/admin/shipment", :layout => "layout_admin"
    end
  end
  
  def update
    @title = "Chỉnh sửa hình thức vận chuyển"
    @new = Shipment.new(params[:shipment])
    if !@new.valid?
      render "edit", :layout => "layout_admin"
    else
      Shipment.save(@db, @new, @new.id_shipment)
      redirect_to "/admin/shipment", :layout => "layout_admin"
    end
  end
  
  def delete
    Shipment.delete(@db, params[:id])
    redirect_to "/admin/shipment", :layout => "layout_admin"
  end
end
