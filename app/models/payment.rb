# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Payment
  include ActiveModel::Model
  
  Fields = [:id_payment, :name, :image, :card, :status, :date_add]
  
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
  
  def self.getlist(db, stt = nil)
    sql = "SELECT id_payment, image, name, card, status, date_add FROM payment"
    
    if stt.present?
      sql << " WHERE status = 1"
    end
    
    v = []
    db.query(sql).each{|row| v << row }
    v
  end
  
  def self.find(db, id_payment)
    sql = "SELECT id_payment, image, name, card, status, date_add FROM payment WHERE id_payment ='#{id_payment}'"
    
    v = []
    db.query(sql).each{|row| v << row }
    v
  end
  
  def self.save(db, payment, id)
    if id.nil?
      
      uploaded_io = payment.image
      folder = 'public/images/payment'
      link = ''
      if uploaded_io.present?
        File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
          file.write(uploaded_io.read)
        end
        link << '/images/payment/' << uploaded_io.original_filename
      end
      
      sql = " INSERT INTO payment(id_payment, image, name, card, status, date_add )
              VALUES ( null, ?, ?, ?, ?, ?)
      "
      stm = db.prepare(sql)
      stm.execute( link,  payment.name, payment.card, payment.status, DateTime.now)
      stm.close
      
      
      
    else
      if payment.image.present?
        uploaded_io = payment.image
        folder = 'public/images/payment'
        link = ''
        if uploaded_io.present?
          File.open(File.join(folder,uploaded_io.original_filename), 'wb') do |file|
            file.write(uploaded_io.read)
          end
          link << '/images/payment/' << uploaded_io.original_filename
        end
        sql = " UPDATE payment SET 
                image = ?,
                name = ?,
                card = ?,
                status = ?
                WHERE id_payment = ?
              "
        stm = db.prepare(sql)
        stm.execute( link , payment.name, payment.card, payment.status, payment.id_payment)
        stm.close
      else
        sql = " UPDATE payment SET 
                name = ?,
                card = ?,
                status = ?
                WHERE id_payment = ?
              "
        stm = db.prepare(sql)
        stm.execute(payment.name, payment.card, payment.status, payment.id_payment)
        stm.close
      end
      
    end
    
  end
  
  def self.delete(db, id_payment)
    sql = " DELETE FROM payment WHERE id_payment = '#{id_payment}'"
    db.query(sql)
  end
  
end
