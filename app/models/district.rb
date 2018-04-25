# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class District
  include ActiveModel::Model
  
  Fields = [
    :name,
    :id_district
  ]
  
  attr_accessor *Fields
  
  def self.getlist(db, province=89)
    sql = <<-SQL
      SELECT id_district, name
      FROM district
      WHERE id_province = '#{province}'
      ORDER BY name ASC
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
end
