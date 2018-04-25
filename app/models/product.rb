# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Product
  include ActiveModel::Model
  
  Fields = [:id_product, :id_categories, :id_provider,:image, :link, :title, :body, :price, :sale, :quantity, :sort_order, :date_add]
  
  attr_accessor *Fields
  
  def initialize(params={})
    set(params)
    
  end
  
  def set(params={})
    if params.present?
      params.keys.each do |k|
        send("#{k}=",params[k]) if respond_to?("#{k}=", true)
      end
    end
  end
  
  validates :link,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :format => {:with => /\A[a-z]/, :message =>MyPhamOnline::Application.config.format_msg}
  validates :title,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  validates :id_provider,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT #{Fields.map{|c| 'p.'+c.to_s}.join(', ')}, c.title as categories, pr.name provider
      FROM product p
      JOIN categories c ON c.id_categories = p.id_categories
      JOIN provider pr ON pr.id_provider = pr.id_provider
      GROUP BY p.id_product
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.find(db, id)
    sql = <<-SQL
      SELECT #{Fields.map{|c| 'p.'+c.to_s}.join(', ')} FROM product p
      WHERE id_product = #{change(id)}
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.save(db, product, id= nil)
    if id.nil?
      uploaded_io = product.image
      folder = 'public/images/product'
      link = '/images/product/'
      if uploaded_io.present?
        link << uploaded_io.original_filename
      end
      
      sql = "INSERT INTO product(id_product, id_categories, id_provider, link, title, body, image, price, sale, quantity, sort_order, date_add )
             VALUES ( null, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      stm = db.prepare(sql)
      stm.execute(product.id_categories, product.id_provider ,product.link, product.title, product.body, link , product.price.to_i, product.sale.to_i,  product.quantity.to_i, product.sort_order.to_i, DateTime.now)
      stm.close
    else
      uploaded_io = product.image
      link = '/images/product/'
      if uploaded_io.present?
        link << uploaded_io.original_filename
      end
      sql = "UPDATE product SET 
            id_categories = ?,
            id_provider = ?,
            link = ?,
            title = ?,
            body = ?,"
      if product.image.present?
        sql << "image = ?, "
      end
        sql << " price = ?,
              sale = ?,
              quantity = ?,
              sort_order = ?
              WHERE id_product = ? "
      
      if product.image.present?
        stm = db.prepare(sql)
        stm.execute(product.id_categories , product.id_provider, product.link, product.title, product.body, link, product.price, product.sale, product.quantity, product.sort_order, product.id_product)
        stm.close
      else
        stm = db.prepare(sql)
        stm.execute(product.id_categories , product.id_provider, product.link, product.title, product.body, product.price, product.sale, product.quantity, product.sort_order, product.id_product)
        stm.close
      end
      
    end
  end
  
  def self.delete(db,id)
    sql ="DELETE FROM product WHERE id_product =#{change(id)}"
    db.query(sql);
  end
  
  
  def self.getlast(db)
    sql = <<-SQL
          SELECT id_product
          FROM product
          ORDER BY id_product DESC
          LIMIT 1
    SQL
    v = []
    db.query(sql).each {|row| v << row}
    v.present? ? v.first : nil
  end
  
  def self.getfirst(db)
    sql = <<-SQL
          SELECT id_product
          FROM product
          ORDER BY id_product ASC
          LIMIT 1
    SQL
    v = []
    db.query(sql).each {|row| v << row}
    v.present? ? v.first : nil
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
