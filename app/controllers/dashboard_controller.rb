# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class DashboardController <ApplicationController
  def index
    
    @total = {}
    sql = " SELECT SUM(total) as thanhtien FROM orders"
    @total['thanhtien'] = @db.query(sql).first['thanhtien']
    sql = " SELECT count(*) as orders FROM orders"
    @total['order'] = @db.query(sql).first['orders']
    sql = " SELECT count(*) as product FROM product"
    @total['product'] = @db.query(sql).first['product']
    sql = " SELECT count(*) as user FROM customer"
    @total['user'] = @db.query(sql).first['user']
    sql = "SELECT SUM(quantity) as kho FROM product"
    @total['kho'] = @db.query(sql).first['kho']
    sql = "SELECT SUM(quantity) as ban FROM orders_product"
    @total['ban'] = @db.query(sql).first['ban']
    render "index", :layout => 'layout_admin'
  end
end
