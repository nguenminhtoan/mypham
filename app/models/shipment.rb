# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Shipment
  include ActiveModel::Model
  
  Fields = [:id_shipment, :name, :price, :messager, :date_add]
  
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
    sql = "SELECT id_shipment, name, price, messager, date_add FROM shipment"
    
    v = []
    db.query(sql).each{|row| v << row }
    v
  end
  
  def self.find(db, id_shipment)
    sql = "SELECT id_shipment, name, price, messager, date_add FROM shipment WHERE id_shipment ='#{id_shipment}'"
    
    v = []
    db.query(sql).each{|row| v << row }
    v
  end
  
  def self.save(db, shipment, id)
    if id.nil?
      
      
      sql = " INSERT INTO shipment(id_shipment, name, price, messager, date_add )
              VALUES ( null, ?, ?, ?, ?)
      "
      stm = db.prepare(sql)
      stm.execute( shipment.name, shipment.price, shipment.messager, DateTime.now)
      stm.close
      
      
      
    else
      
      sql = " UPDATE shipment SET 
              name = ?,
              price = ?,
              messager = ?
              WHERE id_shipment = ?
            "
      stm = db.prepare(sql)
      stm.execute(shipment.name, shipment.price, shipment.messager, shipment.id_shipment)
      stm.close
      
    end
    
  end
  
  def self.delete(db, id_shipment)
    sql = " DELETE FROM shipment WHERE id_shipment = '#{id_shipment}'"
    db.query(sql)
  end
end
