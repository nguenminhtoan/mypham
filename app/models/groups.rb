# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Groups
  include ActiveModel::Model
  
  Fields = [
    :name,
    :id_group
  ]
  
  attr_accessor *Fields
  
  def self.getlist(db)
    sql = <<-SQL
      SELECT id_group, name
      FROM groups
    SQL
    v=[]
    db.query(sql).each{ |row| v << row}
    v
  end
end
