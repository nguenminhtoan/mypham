# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class OrderController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :getTitle
  
  def getTitle
    @page = "ĐƠN ĐẶT HÀNG"
    @icon = "glyphicon glyphicon-usd"
  end
  
  def index
    @title = "Danh sách đơn hàng"
    @list = Order.getlist(@db)
    @status = Status.getlist(@db)
    render "index", :layout => "layout_admin"
  end
  
  def access
    order =params[:order]
    sql = " UPDATE orders SET id_status = ? WHERE id_order = ?"
    stm = @db.prepare(sql)
    stm.execute(order['status'],order['id_order'])
    stm.close
    redirect_to "/admin/order"
  end
  
  def edit
    @title = "Xác nhận đơn hàng"
    @order = Order.find(@db, params[:id])
    @orderdetail = Orderproduct.find(@db, params[:id])
    @status = Status.getlist(@db)
    sql = "
        SELECT o.code, o.id_voucher, v.percent FROM orders o 
        JOIN voucher v ON o.id_voucher = v.id_voucher
        WHERE o.id_order = #{params[:id]} AND o.id_status != '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @sale = v.present? ? v.first : []
    
    render "edit", :layout => "layout_admin"
  end
  
  def save
    @title = "Xác nhận đơn hàng"
    @order = Order.find(@db, params[:id_order])
    @orderdetail = Orderproduct.find(@db, params[:id_order])
    @status = Status.getlist(@db)
    
    sql = "
        SELECT o.code, o.id_voucher, v.percent FROM orders o 
        JOIN voucher v ON o.id_voucher = v.id_voucher
        WHERE o.id_order = #{params[:id_order]} AND o.id_status != '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @sale = v.present? ? v.first : []
    Order.upstatus(@db, '3', params[:id_order])
    if @order.present?
      # Tell the UserMailer to send a welcome email after save
      OrderMailer.order(@orderdetail, @order, @sale).deliver_later
    end
    redirect_to "/admin/order/edit/#{params[:id_order]}"
  end
  
  def order_pdf
    @order = Order.find(@db, params[:id_order])
    @orderdetail = Orderproduct.find(@db, params[:id_order])
    
    sql = "
        SELECT o.code, o.id_voucher, v.percent FROM orders o 
        JOIN voucher v ON o.id_voucher = v.id_voucher
        WHERE o.id_order = #{params[:id_order]} AND o.id_status != '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @sale = v.present? ? v.first : []
    respond_to do |format|
      format.html
      format.pdf do

        pdf = OrderPdf.new(@orderdetail,@order, @sale)

        send_data pdf.render,
            filename: "order_hang",
            type: 'application/pdf',
            disposition: 'inline'       
      end
    end
  end
  
  def update
    Orders.upstatus(@db, params[:status], params[:id_order])
    redirect_to "/admin/order", :layout => "layout_admin"
  end
end
