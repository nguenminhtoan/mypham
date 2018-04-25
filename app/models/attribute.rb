# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Attribute
  include ActiveModel::Model
  
  Fields = [:id_attribute, :attribute, :sort_order, :date_add]
  
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
  
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT id_attribute, attribute, sort_order
      FROM attribute
      ORDER BY sort_order ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
  
  def self.find(db, id)
    sql = "SELECT id_attribute, attribute, sort_order FROM attribute WHERE id_attribute = '#{change(id)}'"
    v = []
    db.query(sql).each{ |row| v << row}
    v
  end
  
  
  def self.save(db, attribute, sort_order, id)
    if find(db,id).count == 0
      sql = "INSERT INTO attribute(id_attribute, attribute, sort_order, date_add)
              VALUES( ?, ?, ?, ?)"
      
      stm = db.prepare(sql)
      stm.execute(id, attribute, sort_order, DateTime.now)
      stm.close
    else
      sql = "UPDATE attribute SET
            attribute = ?,
            sort_order = ?
            WHERE id_attribute = ? "
      stm = db.prepare(sql)
      stm.execute(attribute, sort_order, id)
      stm. close
    end
  end
  
  def self.delete(db, id_attribute)
    sql = "DELETE FROM attribute WHERE id_attribute = '#{change(id_attribute)}'"
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
