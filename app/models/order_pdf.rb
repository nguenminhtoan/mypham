# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class OrderPdf < Prawn::Document
	def initialize(order,user, sale = nil)
		super(top_margin: 70)
		font_families.update("Times" => {
			:normal => Rails.root.join("app/assets/fonts/times.ttf"),
			:italic => Rails.root.join("app/assets/fonts/timesi.ttf"),
			:bold => Rails.root.join("app/assets/fonts/timesbd.ttf"),
			:bold_italic => Rails.root.join("app/assets/fonts/timesbi.ttf")
		})
		font "Times"
    @user = user
    @order = order
    @sale = 0
    @sale = sale if sale.present?
    user_number
    line_items
    total
	end
	
	def user_number
		text "HÓA ĐƠN BÁN HÀNG", size: 20, style: :bold, align: :center
    text "Mã đơn hàng: #{@user['id_order']}"
    text "Khách hàng: #{@user['customer']}"
    text "Số điện thoại: #{@user['phone']}"
    text "Vận chuyển: #{@user['shipment']}"
    text "Thanh toán: #{@user['payment']}"
    text "Địa chỉ giao hàng: #{@user['address']}"
	end
	
	def line_items
	  move_down 20
	  table line_item_rows do
		@cells.border_width = 1
		row(0).font_style = :bold
		row(0).align = :center
		row(0).background_color = "DDDDDD"
		columns(0).width = 250
		columns(1).width = 130
    columns(1).align = :right
		columns(2).width = 50
    columns(2).align = :center
    columns(3).width =110
    columns(3).align = :right
		columns(0..3).size = 10
		self.row_colors = ['FFFFFF', 'EEEEEE']
		self.header = true
	  end
	end
	
	def line_item_rows
		[["Tên hàng", "Đơn giá", "Số lượng","Tổng"]] +
		@order.map do |val|
		  [val['title'], price(val['price']).to_s << " vnđ",val['quantity'],price(val['price']*val['quantity']).to_s << " vnđ"]
		end
	end
  
  def total
    total = @order.collect{ |v| v['price']*v['quantity']}.sum
    move_down 4
    
    table [['Tạm tính:',price(total).to_s << " VNĐ"],["Khuyến mãi", @sale.to_s + " %" ],["Vận chuyển:",price(@user['freeship']).to_s << " VNĐ"],["Tổng đơn hàng:", price((total-(total*@sale/100))+@user['freeship'].to_i).to_s << " VNĐ"]] do
			@cells.align = :center
			row(0..3).border_width = 0
			row(0..3).padding = 0
      row(0..3).padding_top = 4
      columns(1).align = :right
      columns(1).width = 100
      columns(0).align = :left
      row(0..3).size = 12
      row(0..3).font_style = :bold
			self.position = :right
		end
  end
  
  
  def price(n)
    n = n.to_s
    k = n.length - 1
    m = ''
    for i in 0..k
      if (i+1)%3 == 0 && i < k
        m << n[k-i].to_s + ','
      else
        m << n[k-i]
      end
    end
    n = ''
    k = m.to_s.length - 1
    for i in 0..k
      n << m[k-i] 
    end
    n
  end
end
