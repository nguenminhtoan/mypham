# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Banner
  include ActiveModel::Model
  
  Fields = [:id_banner, :image, :link, :title, :name, :sort_order, :date_add]
  
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
  
  validates :title,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  
  def self.getlist(db)
    sql = "SELECT id_banner, link, image, title, name, sort_order, date_add FROM banner ORDER BY sort_order"
    
    v = []
    res = db.exec_params(sql)
    res.each{|row| v << row } if res.count > 0
    v
  end
  
  def self.find(db, id_banner)
    sql = "SELECT id_banner, link, image, title, name, sort_order, date_add FROM banner WHERE id_banner ='#{change(id_banner)}' ORDER BY sort_order"
    
    v = []
    db.query(sql).each{|row| v << row }
    v
  end
  
  def self.save(db, banner, id)
    if id.nil?
      uploaded_io = banner.image
      folder = 'public/images/banner'
      link = ''
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << '/images/banner/' << uploaded_io.original_filename
      end
      
      
      sql = " INSERT INTO banner(id_banner, image, link, title, name, sort_order, date_add )
              VALUES (null, ?, ?, ?, ?, ?, ?)
      "
      stm = db.prepare(sql)
      stm.execute(link, banner.link, banner.title, banner.name, banner.sort_order, DateTime.now)
      stm.close
      
      
      
    else
      if banner.image.present?
        uploaded_io = banner.image
        folder = 'public/images/banner'
        link = ''
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << '/images/banner/' << uploaded_io.original_filename
        end
        sql = " UPDATE banner SET 
                image = ?,
                link = ?,
                title = ?,
                name = ?,
                sort_order = ?
                WHERE id_banner = ?
              "
        stm = db.prepare(sql)
        stm.execute(link, banner.link, banner.title, banner.name, banner.sort_order, banner.id_banner)
        stm.close
      else
        sql = " UPDATE banner SET 
                link = ?,
                title = ?,
                name = ?,
                sort_order = ?
                WHERE id_banner = ?
              "
        stm = db.prepare(sql)
        stm.execute(banner.link, banner.title, banner.name, banner.sort_order, banner.id_banner)
        stm.close
        
      end
      
    end
    
  end
  
  def self.delete(db, id_banner)
    sql = " DELETE FROM banner WHERE id_banner = '#{change(id_banner)}'"
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
