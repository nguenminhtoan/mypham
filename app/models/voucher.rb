# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Voucher
  include ActiveModel::Model
  
  Fields = [
    :id_voucher,
    :percent,
    :amount,
    :status,
    :code,
    :messager,
    :name,
    :image,
    :date_add
  ]
  
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
  
  validates :name,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg}
  
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT id_voucher, name, code, status, percent, amount, image, date_add
      FROM voucher
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
  
  def self.find(db, id_voucher)
    sql = <<-SQL
      SELECT id_voucher, name, code, status, percent, amount, image, date_add
      FROM voucher
      WHERE id_voucher = #{id_voucher}
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v 
  end
  
  
  def self.save(db, voucher, id = nil)
    if id.nil?
      
      uploaded_io = voucher.image
      folder = 'public/images/voucher'
      link = ''
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << '/images/voucher/' << uploaded_io.original_filename
      end
      code = ""
      (0..voucher.amount.to_i).each { |v|
        if v == 0
          code << [*('0'..'9')].sample(8).join
        else
          code << ", " << [*('0'..'9')].sample(8).join
        end
      }
      
      sql = <<-SQL
        INSERT INTO voucher( id_voucher, image, name, percent, amount, code, messager, status, date_add)
        VALUES( null, ?, ?, ?, ?, ?, ?, ? , ?)
      SQL
      stm = db.prepare(sql)
      stm.execute(link, voucher.name, voucher.percent, voucher.amount, code, voucher.messager, voucher.status , DateTime.now)
      stm.close
      
    else
      if voucher.image.present?
        uploaded_io = voucher.image
        folder = 'public/images/voucher'
        link = ''
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << '/images/voucher/' << uploaded_io.original_filename
        end

        sql = <<-SQL
          UPDATE voucher SET
          image = ?,
          name = ?,
          percent = ?,
          amount = ?,
          code = ?,
          messager = ?,
          status = ?
          WHERE id_voucher = ?
        SQL
        
        code = ""
        (0..voucher.amount.to_i).each { |v|
          if v == 0
            code << [*('0'..'9')].sample(8).join
          else
            code << ", " << [*('0'..'9')].sample(8).join
          end
        }
        stm = db.prepare(sql)
        stm.execute(link, voucher.name, voucher.percent, voucher.amount, code, voucher.messager, voucher.status , voucher.id_voucher)
        stm.close
      else
        sql = <<-SQL
          UPDATE voucher SET
          name = ?,
          percent = ?,
          amount = ?,
          code = ?,
          messager = ?,
          status = ?
          WHERE id_voucher = ?
        SQL
        
        code = ""
        (0..voucher.amount.to_i).each { |v|
          if v == 0
            code << [*('0'..'9')].sample(8).join
          else
            code << ", " << [*('0'..'9')].sample(8).join
          end
        }
        stm = db.prepare(sql)
        stm.execute( voucher.name, voucher.percent, voucher.amount, code, voucher.messager, voucher.status , voucher.id_voucher)
        stm.close
      end
    end
  end
  
  def self.delete(db, id_voucher)
    sql = <<-SQL 
      DELETE FROM voucher WHERE id_voucher = '#{change(id_voucher)}'
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
