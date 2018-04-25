# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class ProductImage
  def self.save(db, id_product ,list = [])
    
    sql = "DELETE FROM product_img WHERE id_product = #{change(id_product)}"
    db.query(sql)
    
    sql = <<-SQL
        INSERT INTO product_img(id_image, id_product, link, date_add) VALUES
    SQL
    if list.present?
      list.each do |val|
        uploaded_io = val
        folder = 'public/images/product'
        link = '/images/product/'
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << uploaded_io.original_filename
        end
        if val == list.last
          sql << "( null, #{change(id_product)}, '#{change(link)}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M")}')"
        else
          sql << "( null, #{change(id_product)}, '#{change(link)}', '#{DateTime.now.strftime("%Y-%m-%d %H:%M")}'),"
        end
      end

      db.query(sql)
    end
  end
  

  def self.find(db, id_product)
    sql = <<-SQL
      SELECT link 
      FROM product_img
      WHERE id_product = #{change(id_product)}
    SQL
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.delete(db, id_product)
    sql = <<-SQL
        DELETE FROM product_img WHERE id_product = #{change(id_product)}
    SQL
    
    db.query(sql)
  end
  
  def self.change(char)
    char = char.to_s
    char.gsub!(/ insert /,'I S E R T')
    char.gsub!(/ INSERT /,'I S E R T')
    char.gsub!(/ or /, 'O R')
    char.gsub!(/ OR /, 'O R')
    char.gsub!(/ update /,'U P D A T E')
    char.gsub!(/ UPDATE /,'U P D A T E')
    char
  end
end
