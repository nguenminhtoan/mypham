# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class CustomerController <ApplicationController
  before_action :getTitle
  
  def getTitle
    @page = "NGƯỜI DÙNG"
    @icon = "glyphicon glyphicon-user"
  end
  def index
    @title = "Danh sách người dùng"
    @list = Customer.getlist(@db)
    render "index", :layout => 'layout_admin'
  end
  
  def edit
    @title = "Chỉnh sửa người dùng"
    user = Customer.find(@db,params[:id])
    @new = Customer.new(user.first)
    @province = Province.getlist(@db)
    @district = District.getlist(@db, @new.id_province)
    @ward = Ward.getlist(@db, @new.id_district)
    @groups = Groups.getlist(@db)
    render "edit", :layout => "layout_admin"
  end
  
  def delete
    Customer.delete(@db,params[:id])
    redirect_to '/admin/customer', :layout => 'layout_admin'
  end
  
  def new
    @title = "Thêm mới người dùng"
    @new = Customer.new
    
    @province = Province.getlist(@db)
    @district = District.getlist(@db)
    @ward = Ward.getlist(@db)
    @groups = Groups.getlist(@db)
    render "new", :layout => "layout_admin"
  end
  
  
  def save
    @title = "Thêm mới người dùng"
    @new = Customer.new(params[:customer])
    if !@new.valid?(:new)
      @province = Province.getlist(@db)
      @district = District.getlist(@db,@new.id_province)
      @ward = Ward.getlist(@db, @new.id_district)
      @groups = Groups.getlist(@db)
      render "new", :layout => "layout_admin"
    elsif(Customer.autemail(@db, @new.email).present?)
      @province = Province.getlist(@db)
      @district = District.getlist(@db, @new.id_province)
      @ward = Ward.getlist(@db, @new.id_district)
      @groups = Groups.getlist(@db)
      @new.errors[:email] << "đã tồn tại"
      render "new", :layout => "layout_admin"
    else
      Customer.save(@db,@new)
      redirect_to '/admin/customer', :layout => 'layout_admin'
    end
  end
  
  def update
    @title = "Chỉnh sửa người dùng"
    @new = Customer.new(params[:customer])
    
    if !@new.valid?
      @province = Province.getlist(@db)
      @district = District.getlist(@db,@new.id_province)
      @ward = Ward.getlist(@db, @new.id_district)
      @groups = Groups.getlist(@db)
      render "edit", :layout => "layout_admin"
    elsif(Customer.testemail(@db, @new.email, @new.id_customer).present?)
      @province = Province.getlist(@db)
      @district = District.getlist(@db,@new.id_province)
      @ward = Ward.getlist(@db, @new.id_district)
      @groups = Groups.getlist(@db)
      @new.errors[:email] << "đã tồn tại"
      render "edit", :layout => "layout_admin"
    else
      Customer.save(@db,@new, @new.id_customer)
      redirect_to '/admin/customer', :layout => 'layout_admin'
    end
  end
  
  
  def district
    @district = District.getlist(@db,params[:id])
    render "district", :layout => nil
  end
  
  def ward
    @ward = Ward.getlist(@db,params[:id])
    render "ward", :layout => nil
  end
end
