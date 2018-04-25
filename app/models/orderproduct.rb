# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Orderproduct
  def self.find(db, id)
    sql = "SELECT do.quantity, p.image, p.title, p.price
          FROM orders_product do
          JOIN product p ON p.id_product = do.id_product
          WHERE do.id_order = #{change(id)}
          ORDER BY p.id_product
        "
    v = []
    db.query(sql).each{|row| v << row}
    v
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
