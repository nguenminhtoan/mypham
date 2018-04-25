module ApplicationHelper
  
  def ErrFieldClass(name, add)
    if name
      return add << " has-error"
    else
      return add << " ok"
    end
  end
  
  def option_array(list)
    array = []
    list.each do |val|
      if val['id_parent_categories'].nil? 
          array << [val['title'],val['id_categories']]
          list.each do |row|
            if row['id_parent_categories'].present? && row['id_parent_categories'].to_s == val['id_categories'].to_s 
              array << ["--- " << row['title'],row['id_categories']]
            end 
          end
      end
    end
    array
  end
  
  
  def get_attribute(id_product)
      sql = " SELECT a.id_attribute, a.attribute, value
              FROM attribute_product ap
              JOIN attribute a ON a.id_attribute = ap.id_attribute
              WHERE ap.id_product = #{id_product}
            "
      v = []
      @db.query(sql).each {|row| v << row }
      v
  end
  
  def get_voucher(id_product)
    sql = " SELECT v.id_voucher, v.name, v.title, v.link, v.image 
              FROM product_voucher pv 
              JOIN voucher v ON v.id_voucher = pv.id_voucher
              WHERE pv.id_product = #{id_product}
            "
      v = []
      @db.query(sql).each {|row| v << row }
      v
  end
  
  
  def get_value_attribute(id_attribute)
    sql = " SELECT ap.value
              FROM attribute a
              JOIN attribute_product ap ON ap.id_attribute = a.id_attribute
              WHERE a.id_attribute = '#{id_attribute}'
              GROUP BY ap.value
            "
      v = []
      @db.query(sql).each {|row| v << row }
      v
  end
  
  
  def date_now(time)
    now = DateTime.now
    bew = now.to_i - time.to_i
    if bew.to_i < 60
      v = "vài giây trước"
    elsif bew >= 60 && bew < 120
      v = "1 phút trước"
    elsif bew >= 120 && bew < 300
      v = "vài phút trước"
    elsif  bew >= 300 && bew < 3600
      v = (bew/60).to_s << " phút trước"
    elsif  bew >= 3600 && bew < 216000
      v = (bew/1440).to_s << " giờ trước"
    else 
      v = time.strftime("%Y-%m-%d")
    end 
    v.to_s
  end
  
  def countrank(id_product)
    sql = "
          SELECT COUNT(*) as count FROM product_rank WHERE id_product = #{id_product}
        "
    v = []
    @db.query(sql).each {|row| v << row }
    v = v.first['count']
  end
  
  def rank(id_product)
    sql = "
          SELECT AVG(rank) as rank FROM product_rank WHERE id_product = #{id_product}
        "
    v = []
    @db.query(sql).each {|row| v << row }
    v = v.first['rank'].present? ? v.first['rank'] : 0
    count = (v*10)%10
    tong = (v*10/10).to_i
    if count > 3 && count <= 7
      tong = tong.to_f + 0.5
    elsif count > 7 
      tong = tong + 1
    end
    return (tong*10).to_i
  end
  
  
end
