# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Categories
  include ActiveModel::Model
  
  Fields = [:id_categories, :id_parent_categories, :link, :title, :name, :image, :sort_order, :date_add]
  
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
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT #{Fields.map{|c| 'c.' << c.to_s}.join(', ')}
      FROM categories c
      LEFT JOIN categories cs ON cs.id_categories = c.id_parent_categories
      GROUP BY c.id_categories
      ORDER BY sort_order ASC
    SQL
    
    v = []
    res = db.exec_params(sql)
    res.each{|row| v << row } if res.count > 0
    v
    
  end
  
  def self.find(db,id)
    sql = <<-SQL
      SELECT #{Fields.map{|c| c.to_s}.join(', ')}
      FROM categories
      WHERE id_categories = #{change(id)}
    SQL
    v=[]
    db.query(sql).each{|row| v << row}
    v.present? ? v.first : nil
  end
  
  def self.getpresent(db)
    sql = <<-SQL
      SELECT #{Fields.map{|c| c.to_s}.join(', ')}
      FROM Categories
      WHERE id_parent_categories IS NULL
      ORDER BY sort_order ASC
    SQL
    v=[]
    db.query(sql).each{|row| v << row}
    v
  end
  
  def self.save(db, categories, id=nil)
        
    if id.nil?
      unless categories.id_parent_categories.present?
        sql = <<-SQL
          INSERT INTO categories (id_categories, title, link, image, name, sort_order, date_add)
          VALUES (null, ?, ?, ?, ?, ?, ?)
        SQL
        stm = db.prepare(sql)
        stm.execute(categories.title, categories.link, categories.image, categories.name, categories.sort_order.to_i,DateTime.now)
        stm.close
        
      else
        sql = <<-SQL
          INSERT INTO categories (id_categories, id_parent_categories, title, link, image, name, sort_order, date_add)
          VALUES (null, ? , ?, ?, ?, ?, ?, ?)
        SQL
        stm = db.prepare(sql)
        stm.execute(categories.id_parent_categories.to_i , categories.title, categories.link, categories.image, categories.name, categories.sort_order.to_i,DateTime.now)
        stm.close
      end

    else
      unless categories.id_parent_categories.present?
        sql = <<-SQL
          UPDATE categories SET
          title = ?,
          link = ?,
          image = ?,
          name = ?,
          id_parent_categories = null,
          sort_order = ?
          WHERE id_categories = ?
        SQL

        stm = db.prepare(sql)
        stm.execute(categories.title, categories.link, categories.image, categories.name, categories.sort_order, categories.id_categories)
        stm.close
      else
        sql = <<-SQL
          UPDATE categories SET
          id_parent_categories = ?,
          title = ?,
          link = ?,
          image = ?,
          name = ?,
          sort_order = ?
          WHERE id_categories = ?
        SQL

        stm = db.prepare(sql)
        stm.execute(categories.id_parent_categories, categories.title, categories.link, categories.image, categories.name, categories.sort_order, categories.id_categories)
        stm.close
      end
    end
  end
  
  def self.delete(db,id)
    sql ="DELETE FROM categories WHERE id_categories =#{change(id)}"
    db.query(sql);
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
