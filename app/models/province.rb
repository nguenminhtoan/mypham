# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Province
  include ActiveModel::Model
  
  Fields = [
    :name,
    :id_province
  ]
  
  attr_accessor *Fields
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT id_province, name
      FROM province
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
end
