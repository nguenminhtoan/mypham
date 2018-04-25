# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class News
  include ActiveModel::Model
  
  Fields = [:id_news, :id_customer, :id_categories, :search, :image, :title, :link, :body, :status, :sort_order, :status]
  
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
  
  
  validates :id_customer,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}, on: :new
  validates :id_categories,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  validates :title,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  validates :link,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  
  
  def self.getlist(db)
    sql = "SELECT n.id_news, n.id_customer, n.id_categories, n.image, n.link, n.title, n.body, n.status, n.sort_order, n.date_add, c.name as customer, cs.link as link_cate,  cs.name as categories
          FROM news n
          LEFT JOIN customer c ON c.id_customer = n.id_customer
          LEFT JOIN categories cs ON cs.id_categories = n.id_categories
          ORDER BY sort_order ASC
      "
    v = []
    db.query(sql).each { |row| v << row}
    v
  end
  
  def self.find(db,id)
    sql = <<-SQL
      SELECT id_news, id_customer, id_categories, image, search, link, title, body, status, sort_order, date_add
      FROM news
      WHERE id_news = #{change(id)}
    SQL
    v=[]
    db.query(sql).each{|row| v << row}
    v.present? ? v.first : nil
  end
  
  def self.save(db, news, id = nil)
    if id.nil?
      
      uploaded_io = news.image
      folder = 'public/images/news'
      link = ''
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << '/images/news/' << uploaded_io.original_filename
      end
      
      sql = " INSERT INTO news(id_news, id_customer, id_categories, search, image, link, title, body, status, sort_order, date_add )
              VALUES (null, ?, ?, ?, ?, ?, ?, ?, ?, ? , ?)
      "
      stm = db.prepare(sql)
      stm.execute(news.id_customer, news.id_categories, news.search, link, news.link, news.title, news.body, news.status, news.sort_order, DateTime.now)
      stm.close
      
      
      
    else
      if news.image.present?
        uploaded_io = news.image
        folder = 'public/images/news'
        link = ''
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << '/images/news/' << uploaded_io.original_filename
        end
        sql = " UPDATE news SET 
                image = ?,
                id_categories = ?,
                search = ?,
                link = ?,
                title = ?,
                body = ?,
                status = ?,
                sort_order = ?
                WHERE id_news = ?
              "
        stm = db.prepare(sql)
        stm.execute(link, news.id_categories, news.search, news.link, news.title, news.body, news.status, news.sort_order, news.id_news)
        stm.close
      else
        sql = " UPDATE news SET 
                id_categories = ?,
                search = ?,
                link = ?,
                title = ?,
                body = ?,
                status = ?,
                sort_order = ?
                WHERE id_news = ?
              "
        stm = db.prepare(sql)
        stm.execute( news.id_categories, news.search, news.link, news.title, news.body, news.status, news.sort_order, news.id_news)
        stm.close
      end
      
    end
    
  end
  
  def self.delete(db, id_news)
    sql = " DELETE FROM news WHERE id_news = #{change(id_news)}"
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
