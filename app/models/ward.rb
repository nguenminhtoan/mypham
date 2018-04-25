# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Ward
  include ActiveModel::Model
  
  Fields = [
    :name,
    :id_ward
  ]
  
  attr_accessor *Fields
  
  def self.getlist(db, district=886)
    sql = <<-SQL
      SELECT id_ward, name
      FROM ward
      WHERE id_district = '#{district}'
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
end
