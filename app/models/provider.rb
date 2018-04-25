# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Provider
  include ActiveModel::Model
  
  Fields = [:id_provider, :image, :logo, :name, :link, :title, :sort_order, :date_add]
  
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
      SELECT id_provider, image, name, logo, link, title, sort_order, date_add FROM provider ORDER BY sort_order ASC
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.find(db, id_provider)
    sql = <<-SQL
      SELECT id_provider, image, name, logo, link, title, sort_order, date_add FROM provider WHERE id_provider = '#{change(id_provider)}' ORDER BY sort_order ASC
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.save(db, provider, id = nil)
    if id.nil?
      
      uploaded_io = provider.image
      folder = 'public/images/provider'
      link = ''
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << '/images/provider/' << uploaded_io.original_filename
      end
      
      sql = <<-SQL
        INSERT INTO provider( id_provider, image, logo, name, link, title, sort_order, date_add)
        VALUES( null, ?, ?, ?, ?, ?, ?, ?)
      SQL
      stm = db.prepare(sql)
      stm.execute( link, provider.logo, provider.name, provider.link, provider.title, provider.sort_order.to_i,DateTime.now)
      stm.close
      
    else
      if provider.image.present?
        uploaded_io = provider.image
        folder = 'public/images/provider'
        link = ''
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << '/images/provider/' << uploaded_io.original_filename
        end

        sql = <<-SQL
          UPDATE provider SET
          image = ?,
          logo = ?,
          name = ?,
          link = ?,
          title = ?,
          sort_order = ?
          WHERE id_provider = ?
        SQL

        stm = db.prepare(sql)
        stm.execute( link , provider.logo, provider.name, provider.link, provider.title, provider.sort_order.to_i, provider.id_provider)
        stm.close
      else
        sql = <<-SQL
          UPDATE provider SET
          logo = ?,
          name = ?,
          link = ?,
          title = ?,
          sort_order = ?
          WHERE id_provider = ?
        SQL

        stm = db.prepare(sql)
        stm.execute( provider.logo, provider.name, provider.link, provider.title, provider.sort_order.to_i, provider.id_provider)
        stm.close
      end
    end
  end
  
  def self.delete(db, id_provider)
    sql = <<-SQL 
      DELETE FROM provider WHERE id_provider = '#{change(id_provider)}'
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
