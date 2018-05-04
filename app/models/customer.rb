# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Customer
  
  require 'digest/md5'
  
  include ActiveModel::Model
  
  Fields = [:id_customer, :image, :name, :sex, :phone, :email, :id_group, :id_ward, :score,
    :address, :password, :selt, :date_add]
  
  
  attr_accessor *Fields
  
  attr_accessor :link,:id_province, :id_district
  
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
  
  validates :email,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :format=>{:with => /\w+@\w+.{1}[a-zA-Z]{2,}/,:message => "phải là một email", :allow_blank => true}
  
  validates :password, 
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :length=>{:allow_blank => true, :minimum => 5, :message=>"phải có ít nhất 5 ký tự"} ,
    :confirmation => {:messager => "không đúng"}, on: :new
  validates :password_confirmation, :presence => {:message =>MyPhamOnline::Application.config.blank_msg}, on: :new
  
  validates :name,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  validates :phone,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :format=>{:with=>/0\d{8,9}/, :message => MyPhamOnline::Application.config.format_msg}
  
  validates :id_ward,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  validates :id_district,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  validates :id_province,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  validate  :confirm_pass
  
  def confirm_pass
    unless self.password.to_s == self.password_confirmation
      errors[:password_confirmation] << 'Không đúng'
    end
  end
  
  
  def self.getlist(db)
    sql = <<-SQL 
      SELECT #{Fields.map{|c| 'c.'+c.to_s}.join(', ')}, w.name as ward, d.name as district, p.name as province, g.name as groups
      FROM customer c JOIN Ward w ON c.id_ward = w.id_ward 
      LEFT JOIN district d ON d.id_district = w.id_district
      LEFT JOIN province p ON p.id_province = d.id_province
      LEFT JOIN groups g ON g.id_group = c.id_group
      GROUP BY c.id_customer
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.find(db, id_customer)
    sql = <<-SQL 
      SELECT #{Fields.map{|c| 'c.'+c.to_s}.join(', ')} , c.image as link, d.id_province as id_province, d.id_district as id_district, g.name as groups
      FROM customer c
      LEFT JOIN Ward w ON c.id_ward = w.id_ward 
      LEFT JOIN district d ON d.id_district = w.id_district
      LEFT JOIN groups g ON g.id_group = c.id_group
      WHERE id_customer = #{change(id_customer)}
      GROUP BY c.id_customer
    SQL
    
    v = []
    db.query(sql).each {|row| v << row}
    v
  end
  
  def self.getscore(db, id_customer)
    sql = <<-SQL 
      SELECT c.score FROM customer c
      WHERE id_customer = #{change(id_customer)}
      LIMIT 1
    SQL
    
    db.query(sql).first['score']
  end
  
  def self.authentication(db, email, password, selt)
    sql = <<-SQL 
      SELECT #{Fields.map{|c| c.to_s}.join(', ')}
      FROM customer
      WHERE email = '#{change(email)}'
    SQL
    
    str = password << selt
    str = Digest::MD5.hexdigest(str)
    sql << " AND password = '#{str}'"
    v = []
    db.query(sql).each {|row| v << row }
    v.present? ? v.first : nil
  end
  
  
  def self.autemail(db, email)
    sql = <<-SQL
      SELECT id_customer, selt, id_group
      FROM customer
      WHERE email = '#{change(email)}'
    SQL
    v = []
    db.query(sql).each {|row| v << row }
    v.present? ? v.first : []
  end
  
  def self.testemail(db, email, id)
    sql = <<-SQL
      SELECT id_customer, selt
      FROM customer
      WHERE email = '#{change(email)}'
      AND id_customer !='#{change(id)}'
    SQL
    v = []
    db.query(sql).each {|row| v << row }
    v.present? ? v.first : nil
  end
  
  
  def self.save(db, customer, id= nil)
    if id.nil?
      uploaded_io = customer.image
      folder = 'public/images/customer'
      link = '/images/customer/'
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << uploaded_io.original_filename
      else
        link << 'user.png'
      end
      
      sql = "INSERT INTO customer(id_customer, id_group, id_ward, name, image, sex, phone, email, password, selt, address, date_add )
             VALUES ( null, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
      str = (0...14).map { rand(25).chr }.join
      password = customer.password << str
      password = Digest::MD5.hexdigest(password)
      stm = db.prepare(sql)
      stm.execute(customer.id_group, customer.id_ward, customer.name, link.to_s, customer.sex, customer.phone, customer.email, password, str, customer.address, DateTime.now)
      stm.close
    else
      uploaded_io = customer.image
      folder = 'public/images/customer'
      link = '/images/customer/'
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << uploaded_io.original_filename
      end
      sql = "UPDATE customer SET 
             id_group = ?,
             id_ward = ?,
             name = ?,
             sex = ?,
             phone = ?,
             email = ?,
             address = ? "
      if uploaded_io.present?
        sql << ", image = '#{change(link)}'"
      end
      if customer.password.present?
        sql << ", password = ? "
        sql << ", selt = ?"
      end
      sql << " WHERE id_customer = ? "
      
      if customer.password.present?
        str = (0...14).map { rand(25).chr }.join
        password = customer.password << str
        password = Digest::MD5.hexdigest(password)
        stm = db.prepare(sql)
        stm.execute(customer.id_group, customer.id_ward, customer.name, customer.sex, customer.phone, customer.email, customer.address, password, str, id)
        stm.close
      else
        stm = db.prepare(sql)
        stm.execute(customer.id_group, customer.id_ward, customer.name, customer.sex, customer.phone, customer.email, customer.address, id)
        stm.close
      end
    end
  end
  
  def self.delete(db,id)
    sql ="DELETE FROM customer WHERE id_customer =#{change(id)}"
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
