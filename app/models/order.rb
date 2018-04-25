# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Order
  def self.getlist(db)
    sql = <<-SQL
        SELECT o.id_order, o.total, o.address, p.name as payment, s.name as shipment, c.name as customer, st.name as status, o.date_add, s.price as freeship
        FROM orders o
        JOIN customer c ON o.id_customer = c.id_customer
        JOIN payment p ON p.id_payment = o.id_payment
        JOIN shipment s ON s.id_shipment = o.id_shipment
        JOIN status st ON st.id_status = o.id_status
        WHERE o.id_status != 'GH'
        GROUP BY o.id_order
        ORDER BY date_add DESC
    SQL
    v = []
    db.query(sql).each{ |row| v << row}
    v
  end
  
  def self.find(db, id)
    sql = <<-SQL
        SELECT o.id_order, o.total, o.address, p.name as payment, s.name as shipment, c.name as customer, c.email, c.phone, st.name as status, o.id_status, s.price as freeship
        FROM orders o
        JOIN customer c ON o.id_customer = c.id_customer
        JOIN payment p ON p.id_payment = o.id_payment
        JOIN shipment s ON s.id_shipment = o.id_shipment
        JOIN status st ON st.id_status = o.id_status
        WHERE id_order = #{change(id)}
        GROUP BY o.id_order
    SQL
    v = []
    db.query(sql).each{ |row| v << row}
    v.present? ? v.first : nil
  end
  
  def self.save(db, order)
    
  end
  
  def self.upstatus(db, status, id)
    sql = <<-SQL
        UPDATE orders SET
            id_status = ?
            WHERE id_order = ?
    SQL
    stm = db.prepare(sql)
    stm.execute(status, id)
    stm.close
    
  end
  
  def self.update(db, order)
    
  end
  
  
  
  def self.change(char)
    char = char.to_s
    char.gsub!(/insert/,'I S E R T')
    char.gsub!(/INSERT/,'I S E R T')
    char.gsub!(/or/, 'O R')
    char.gsub!(/OR/, 'O R')
    char.gsub!(/update/,'U P D A T E')
    char.gsub!(/UPDATE/,'U P D A T E')
    char
  end
end
