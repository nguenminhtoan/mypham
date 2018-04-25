# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class ProductAttribute
  def self.save(db, id_product, list = [])
    
    sql = <<-SQL
      DELETE FROM product_attribute
      WHERE id_product = #{change(id_product)}
    SQL
    
    db.query(sql)
    
    sql = <<-SQL
      INSERT INTO product_attribute(id_product, id_attribute, value) values
    SQL
    if list.present?
      list.each{ |val|
        if val == list.last
          sql << "( #{id_product}, '#{change(val['id_attribute'])}', '#{change(val['value'])}')"
        else
          sql << "( #{id_product}, '#{change(val['id_attribute'])}','#{change(val['value'])}'),"
        end
      }

      db.query(sql);
    end
  end
  
  def self.find(db, id_product)
    sql = <<-SQL
      SELECT a.id_attribute, attribute, value
      FROM product_attribute ap
      JOIN attribute a ON ap.id_attribute = a.id_attribute
      WHERE ap.id_product = #{change(id_product)}
    SQL
    v = []
    db.query(sql).each {|row| v << row}
    v
    
  end
  
  def self.delete(db,id_product)
    sql = <<-SQL
      DELETE FROM product_attribute
      WHERE id_product = #{change(id_product)}
    SQL
    
    db.query(sql)
    
  end
  
  
  def self.deleteAttr(db,id_attribute)
    sql = <<-SQL
      DELETE FROM product_attribute
      WHERE id_attribute = '#{change(id_attribute)}'
    SQL
    
    db.query(sql)
    
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
