# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Status
   include ActiveModel::Model
  
  Fields = [:id_status, :name, :text, :date_add]
  
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
      SELECT id_status, name, text
      FROM status
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
  
  def self.find(db, id)
    sql = "SELECT id_status, name, text FROM status WHERE id_status = '#{change(id)}'"
    v = []
    db.query(sql).each{ |row| v << row}
    v
  end
  
  def self.save(db, name, text, id_status)
    if find(db,id_status).count == 0
      sql = "INSERT INTO status(id_status, name, text, date_add)
              VALUES( ?, ?, ?, ?)"
      
      stm = db.prepare(sql)
      stm.execute(id_status, name, text, DateTime.now)
      stm.close
    else
      sql = "UPDATE status SET
            name = ?,
            text = ?
            WHERE id_status = ? "
      stm = db.prepare(sql)
      stm.execute(name, text, id_status)
      stm. close
    end
  end
  
  def self.delete(db, id_status)
    sql = "DELETE FROM status WHERE id_status = '#{id_status}'"
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
