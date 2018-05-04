# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class HomeController < ApplicationController
  def index
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @breadcrumb = []
    
    sql = "SELECT p.id_product, p.image, p.title, p.price, p.sale, p.link FROM product p 
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          GROUP BY p.id_product
          ORDER BY p.date_add DESC
          LIMIT 16
        "
    v = []
    @db.query(sql).each{|row| v << row}
    @new = v
    
    
    sql = "
          SELECT p.id_product, p.image, p.title, p.price, p.sale, p.link FROM product p 
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          GROUP BY p.id_product
          LIMIT 8
          "
          
    v = []
    @db.query(sql).each{|row| v << row}
    @hot = v
    
    
    sql = "
          SELECT p.id_product, p.image, p.title, p.price, p.sale, p.link FROM product p 
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          WHERE sale != 0
          GROUP BY p.id_product
          ORDER BY p.date_add DESC
          LIMIT 8
          "
          
    v = []
    @db.query(sql).each{|row| v << row}
    @sale = v
    
  end
  
  def product
    @categories = Categories.getlist(@db)
    @banner = Banner.getlist(@db)
    @search = params[:product]
    @title = params[:title]
    @parent = params[:parent]
    @id_product = params[:id]
    @min = params[:min]
    @max = params[:max]
    
    sql = "
          SELECT p.id_product, p.image, p.title, p.price, p.sale, p.link, c.link as categories, pc.link as parent_cat, SUM(do.id_product) as hot FROM product p 
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          LEFT JOIN orders_product do ON do.id_product = p.id_product
          GROUP BY p.id_product
          ORDER BY hot DESC
          LIMIT 5
          "
          
    v = []
    @db.query(sql).each{|row| v << row}
    @hot = v
    
    sql = "
        SELECT title, link FROM categories WHERE link = '#{change(@title)}'
      "
    v = []
    @db.query(sql).each() { |row| v << row }
    sql = "
        SELECT title, link FROM categories WHERE link = '#{change(@parent)}'
      "
    @db.query(sql).each() { |row| v << row }
    sql = "
        SELECT title, link FROM product WHERE link = '#{change(@id_product)}'
      "
    @db.query(sql).each() { |row| v << row }
    @breadcrumb = v
    
    @breadcrumb = [{'title'=>"Tìm kiếm sản phẩm #{@search}",'link'=>'search'}] if @search.present?
    
    
    if @id_product.present?
      
      sql = "
          SELECT p.id_product, title, price, body, quantity
          FROM product p 
          WHERE p.link = '#{change(@id_product)}'
      "
      v = []
      @db.query(sql).each() { |row| v << row }
      @product = v.first
      
      sql = "
          SELECT link FROM product_img WHERE id_product = #{@product['id_product']}
      "
      v = []
      @db.query(sql).each {|row| v << row }
      @image = v
      
      
      sql = " SELECT a.id_attribute, a.attribute, value
              FROM product_attribute ap
              JOIN attribute a ON a.id_attribute = ap.id_attribute
              WHERE ap.id_product = #{@product['id_product']}
            "
      v = []
      @db.query(sql).each {|row| v << row }
      @attribute = v
      
      
      sql = " SELECT cp.id_comment, cp.id_parent_comment, cp.text, cp.date_add, c.name, c.image ,c.id_group
              FROM comment_product cp
              JOIN customer c ON c.id_customer = cp.id_customer
              WHERE cp.id_product = #{@product['id_product']}
              ORDER BY cp.date_add DESC
            "
      v = []
      @db.query(sql).each {|row| v << row }
      @comment = v
      
      
      sql = "
            SELECT rank, COUNT(rank) as count FROM product_rank WHERE id_product = #{@product['id_product']} GROUP BY rank
          "
      v = []
      @db.query(sql).each {|row| v << row }
      @rank = v
      
      if @login.present?
        @norank = true
        sql = "
              SELECT * FROM product_rank WHERE id_customer = #{@login} AND id_product=#{@product['id_product']}
          "
        v = []
        @db.query(sql).each {|row| v << row }

        if v.length > 0
          @norank = false
        end
        
        sql = "
              SELECT * FROM orders o
              JOIN orders_product do ON o.id_order = do.id_order
              WHERE o.id_customer = #{@login} AND do.id_product=#{@product['id_product']} AND o.id_status != '1'
          "
        v = []
        @db.query(sql).each {|row| v << row }
        if v.length == 0
          @norank = false
        end
      else
        @norank = false
      end
      
      
      sql = "
            SELECT n.link, n.title, n.image, n.body, c.link as categories FROM news n
            LEFT JOIN categories c ON c.id_categories = n.id_categories
            LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
            WHERE (n.title LIKE ? or n.body LIKE ? or n.search LIKE ? )  AND n.status = 1
          "
      stm = @db.prepare(sql)
      res = stm.execute("%#{@product['title']}%","%#{@product['title']}%","%#{@product['title']}%")
      v = []
      res.each {|row| v << row }
      @news = v
      stm.close
      
      
      sql = "
          SELECT p.id_product, p.image, p.title, p.price,p.sale, p.link, c.link as categories, pc.link as parent_cat  FROM product p
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          WHERE price >= #{@product['price'].to_i-50000} and price <= #{@product['price'].to_i+50000}
        "
      
      sql << " GROUP BY p.id_product "
      sql << " ORDER BY p.price ASC"
      sql << " LIMIT 5"
      v = []
      @db.query(sql).each{ |row| v << row }
      @lienquan = v
      
      render "detail", :layout => "application"
    else
      
      sql = "
          SELECT p.id_product, p.image, p.title, p.price,p.sale, p.link, c.link as categories, pc.link as parent_cat  FROM product p
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
        "
      if @search.present?
          sql << " WHERE p.title LIKE '%#{change(@search)}%'"
      end
      if @parent.present?
        sql << " WHERE c.link =  '#{change(@parent)}'"
      elsif @title.present?
        sql << " WHERE pc.link = '#{change(@title)}'"
      end
      
      if @min.present?
        sql << " AND p.price >= #{change(@min)} "
      end
      if @max.present?
        sql << " AND p.price <= #{change(@max)}"
      end
      
      
      sql << " GROUP BY p.id_product "
      sql << " ORDER BY p.price ASC"
      
      v = []
      @db.query(sql).each{ |row| v << row }
      @product = v
      sql = "SELECT n.id_news, n.id_customer, n.id_categories, n.image, n.link, n.title, n.body, n.status, n.sort_order, n.date_add, c.name as customer, cs.link as link_cate,  cs.name as categories
          FROM news n
          LEFT JOIN customer c ON c.id_customer = n.id_customer
          LEFT JOIN categories cs ON cs.id_categories = n.id_categories
          ORDER BY sort_order ASC LIMIT 5
        "
      @news = []
      @db.query(sql).each { |row| @news << row}
      
      render "product", :layout=>"application"
    end
    
    
  end
  
  
  
  def news
    @categories = Categories.getlist(@db)
    @banner = Banner.getlist(@db)
    @title = params[:title] if params[:title].present?
    @parent = params[:parent]
    @id_news = params[:id]
    
    sql = "
        SELECT title, link FROM categories WHERE link = '#{change('news/' << @title)}'
      "
    v = []
    @db.query(sql).each() { |row| v << row }
    sql = "
        SELECT title, link FROM categories WHERE link = '#{change(@parent)}'
      "
    @db.query(sql).each() { |row| v << row }
    sql = "
        SELECT title, link FROM news WHERE link = '#{change(@parent)}' AND status = 1
      "
    @db.query(sql).each() { |row| v << row }
    @breadcrumb = v
    
    sql = "
          SELECT p.id_product, p.image, p.title, p.price,p.sale, p.link, c.link as categories, pc.link as parent_cat  FROM product p
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
        "
      
      sql << " GROUP BY p.id_product "
      sql << " ORDER BY p.price ASC"
      sql << " LIMIT 5"
      v = []
      @db.query(sql).each{ |row| v << row }
      @product = v
    
    
    if @parent.present?
      sql = "
            SELECT n.body, n.title, n.date_add, cs.name, n.id_news, n.image, count(cn.id_news) as comment FROM news n
            JOIN customer cs ON cs.id_customer = n.id_customer
            LEFT JOIN comment_news cn ON cn.id_news = n.id_news
            WHERE n.link = '#{change(@parent)}'
          "
      v = []
      @db.query(sql).each {|row| v << row }
      @newsdetail = v.first
      
      sql = "
            SELECT n.id_comment_news, n.id_parenr_news, n.text, n.date_add, c.name, c.image ,c.id_group
            FROM comment_news n
            JOIN customer c ON c.id_customer = n.id_customer
            WHERE n.id_news = #{change(@newsdetail['id_news'])}
            ORDER BY n.date_add DESC
          "
      v = []
      @db.query(sql).each {|row| v << row }
      @comment = v
      render "news"
    else
      sql = "
            SELECT n.link, n.title, n.image, cs.name, n.date_add , c.link as categories, body, count(cn.id_news) as comment FROM news n
            JOIN customer cs ON cs.id_customer = n.id_customer
            LEFT JOIN categories c ON c.id_categories = n.id_categories
            LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
            LEFT JOIN comment_news cn ON cn.id_news = n.id_news
            WHERE status = 1
        "
        
      if @parent.present?
        sql << " AND c.link =  '#{change(@parent)}'"
      else
        sql << " AND c.link = '#{change("news/" << @title)}' OR pc.link = '#{change("news/" << @title)}'" if @title.present?
      end
      sql << " GROUP BY n.id_news"
      v = []
      @db.query(sql).each {|row| v << row }
      @listnews = v

      render "news"
    end
    
  end
  
  def comment_new
    @comment = params[:comment]
    if @comment.present?
      if @comment['parent_pro'].present?
          sql = "
                INSERT INTO comment_news( id_comment_news, id_news, id_customer, id_parenr_news, text, date_add)
                VALUES ( null, ?, ?, ?, ?, ?)
            "
          stm = @db.prepare(sql)
          stm.execute(@comment['id_pro'], @login, @comment['parent_pro'], @comment['text'], DateTime.now)
          stm.close
      else
          sql = "
                INSERT INTO comment_news( id_comment_news, id_news, id_customer, id_parenr_news, text, date_add)
                VALUES ( null, ?, ?, null, ?, ?)
            "
          stm = @db.prepare(sql)
          stm.execute(@comment['id_pro'], @login, @comment['text'], DateTime.now)
          stm.close
      end
    end
  end
  
  def news_save
    @new = News.new(params[:news])
    @new.id_customer = @login
    unless @new.valid?(:new)
      @show = true
      @breadcrumb = [{'title'=>'Tài khoản','link'=>'account'}]
      @banner = Banner.getlist(@db)
      @categories = Categories.getlist(@db)
      user = Customer.find(@db, @login).first
      @customer = Customer.new(user)
      @province = Province.getlist(@db)
      @district = District.getlist(@db, @customer.id_province)
      @ward = Ward.getlist(@db, @customer.id_district)
      render 'account'
    else
      News.save(@db, @new)
      score = Customer.getscore(@db, @login)
      score = score.to_i + 1
      sql = " UPDATE customer SET score = ? WHERE id_customer = ?"
      stm = @db.prepare(sql)
      stm.execute(score, @login)
      stm.close
      redirect_to '/account'
    end
    
  end
  
  def account
    @message = flash[:messager]
    redirect_to '/login' and return unless @login.present?
    @breadcrumb = [{'title'=>'Tài khoản','link'=>'account'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    user = Customer.find(@db, @login).first
    @customer = Customer.new(user)
    @province = Province.getlist(@db)
    @district = District.getlist(@db, @customer.id_province)
    @ward = Ward.getlist(@db, @customer.id_district)
    @new = News.new
  end
  
  def update_account
    @customer = Customer.new(params[:customer])
    @uppassword = params[:uppassword]
    @new = News.new
    if @uppassword.present?
      unless @customer.valid?(:new)
        @breadcrumb = [{'title'=>'Tài khoản','link'=>'account'}]
        @banner = Banner.getlist(@db)
        @categories = Categories.getlist(@db)
        @province = Province.getlist(@db)
        @district = District.getlist(@db, @customer.id_province)
        @ward = Ward.getlist(@db, @customer.id_district)
        
        render "account"
      else
        flash[:messager] = "Cập nhật thành công"
        Customer.save(@db, @customer, @customer.id_customer)
        redirect_to '/account'
      end
    else
      unless @customer.valid?
        @breadcrumb = [{'title'=>'Tài khoản','link'=>'account'}]
        @banner = Banner.getlist(@db)
        @categories = Categories.getlist(@db)
        @province = Province.getlist(@db)
        @district = District.getlist(@db, @customer.id_province)
        @ward = Ward.getlist(@db, @customer.id_district)
        render "account"
      else
        flash[:messager] = "Cập nhật thành công"
        Customer.save(@db, @customer, @customer.id_customer)
        redirect_to '/account'
      end
    end
  end
  
  def login
    @breadcrumb = [{'title'=>'Đăng Nhập','link'=>'login'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @customer = Customer.new
    @account = Account.new
    @province = Province.getlist(@db)
    @district = District.getlist(@db)
    @ward = Ward.getlist(@db)
  end
  
  def auth
    @account = Account.new(params[:account])
    @breadcrumb = [{'title'=>'Đăng Nhập','link'=>'login'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @customer = Customer.new
    @province = Province.getlist(@db)
    @district = District.getlist(@db)
    @ward = Ward.getlist(@db)
    unless @account.valid?
      render "login"
    else
      res = Customer.autemail(@db, @account.username)
      if (!res.present?)
        @account.errors[:username] << "không đúng"
        render "login"
      elsif(!Customer.authentication(@db, @account.username, @account.password, res['selt']).present?)
        @account.errors[:password] << "không đúng"
        render "login"
      else
        session[:id_login] = res['id_customer']
        redirect_to '/'
      end
    end
  end
  
  def sign
    @account = Account.new(params[:account])
    @breadcrumb = [{'title'=>'Đăng Nhập','link'=>'login'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @customer = Customer.new(params[:customer])
    @customer.id_group = 3
    if !@customer.valid?(:new)
      @province = Province.getlist(@db)
      @district = District.getlist(@db,@customer.id_province)
      @ward = Ward.getlist(@db, @customer.id_district)
      render "login"
    elsif(Customer.autemail(@db, @customer.email).present?)
      @province = Province.getlist(@db)
      @district = District.getlist(@db, @customer.id_province)
      @ward = Ward.getlist(@db, @customer.id_district)
      @customer.errors[:email] << "đã tồn tại"
      render "login"
    else
      Customer.save(@db,@customer)
      session[:id_login] = Customer.autemail(@db, @customer.email)['id_customer']
      redirect_to '/'
    end
    
  end
  
  
  def logout
    session.delete(:id_login)
    redirect_to '/login'
  end
  
  
  def cart
    @breadcrumb = [{'title'=>'giỏ hàng','link'=>'cart'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    sql = "
        SELECT do.quantity, p.image, p.title, p.price, p.id_product FROM orders_product do
        JOIN product p ON p.id_product = do.id_product
        JOIN orders o ON o.id_order = do.id_order
        WHERE o.id_customer = #{@login} AND o.id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @cart = v
    
    sql = "
        SELECT o.code, o.id_voucher, v.percent FROM orders o 
        JOIN voucher v ON o.id_voucher = v.id_voucher
        WHERE o.id_customer = #{@login} AND o.id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @order = v.present? ? v.first : []
    
    
    sql = "select  p.image, p.title, p.price, p.sale, p.link, c.link as categories, pc.link as parent_cat , COUNT(od.ID_PRODUCT) as count  FROM orders_product do
          JOIN orders_product od ON od.id_order = do.id_order AND od.ID_PRODUCT != do.ID_PRODUCT
          LEFT JOIN product p ON p.id_product = od.id_product
          LEFT JOIN categories c ON c.id_categories = p.id_categories
          LEFT JOIN categories pc ON pc.id_categories = c.id_parent_categories
          JOIN orders o ON o.id_order = od.id_order
          
      "
    if @cart.present?
        sql << " AND od.ID_PRODUCT NOT IN ( "
        @cart.each do |val|
          if val == @cart.last
            sql << "#{val['id_product']}"
          else
            sql << " #{val['id_product']}, "
          end
        end
        sql << " )"
    end
   
    if @cart.present?
        sql << " AND do.ID_PRODUCT IN ( "
        @cart.each do |val|
          if val == @cart.last
            sql << "#{val['id_product']}"
          else
            sql << " #{val['id_product']}, "
          end
        end
        sql << " )"
    end
    sql << " GROUP BY od.ID_PRODUCT	
          ORDER BY count DESC
          LIMIT 10
        "
    v = []
    @db.query(sql).each{|row| v << row} if @cart.present?
    @product = v
    
    render "cart"
  end
  
  def addcart
    @product = params[:id]
    @num = params[:num].to_i
    sql = "
        SELECT id_status, id_order FROM orders WHERE id_customer=#{@login} AND id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    
    
    sql = " SELECT price FROM product WHERE id_product =#{change(@product)}"
    res = []
    @db.query(sql).each { |row| res << row}
    res = res.first
    
    if v.count.to_i == 0
      sql = "
          INSERT INTO orders ( id_order, id_status, id_customer)
          VALUES (null, ?, ?)
        "
      stm = @db.prepare(sql)
      stm.execute("1",@login)
      stm.close
      
      sql = "
            SELECT id_order FROM orders WHERE id_customer =#{@login} AND id_status = '1'
          "
      v = []
      @db.query(sql).each { |row| v << row}
      v = v.first
      
      
      sql = " 
            INSERT INTO orders_product( id_product, id_order, quantity, total)
            VALUES ( ?, ?, ?, ?)
          "
      stm = @db.prepare(sql)
      stm.execute(@product, v['id_order'].to_i, @num, @num*res['price'])
      stm.close
      sql = " SELECT count(*) as quantity FROM orders_product WHERE id_order = #{change(v['id_order'].to_i)} "
        v = []
        @db.query(sql).each { |row| v << row}
        v = v.first
      render :html => v['quantity']
      
      
    else
      sql = " SELECT do.quantity, do.id_order 
              FROM orders_product do
              JOIN orders o ON o.id_order = do.id_order
              WHERE id_product = #{change(@product)} AND id_customer = #{@login}  AND id_status = '1' "
      v = []
      @db.query(sql).each { |row| v << row}
      v = v.present? ? v.first : []
      
      if v.count > 0
        sql = " 
              UPDATE orders_product SET
              quantity = ?,
              total = ?
              WHERE id_product = ? AND id_order = ? 
          "
        stm = @db.prepare(sql)
        stm.execute((v['quantity'].to_i + @num).to_i, (v['quantity'].to_i + @num)*res['price'].to_i, @product, v['id_order'].to_i)
        stm.close
        
        sql = " SELECT count(*) as quantity FROM orders_product WHERE id_order = #{change(v['id_order'].to_i)} "
        v = []
        @db.query(sql).each { |row| v << row}
        v = v.first
        
        render :html => v['quantity']
        
      else

        sql = "
              SELECT id_order FROM orders WHERE id_customer = #{@login} AND id_status = '1'
            "
        v = []
        @db.query(sql).each { |row| v << row}
        v = v.first
        sql = " 
            INSERT INTO orders_product( id_product, id_order, quantity, total)
            VALUES ( ?, ?, ?, ?)
          "
        stm = @db.prepare(sql)
        stm.execute(@product, v['id_order'].to_i, @num, @num*res['price'])
        stm.close
        
        sql = " SELECT count(*) as quantity FROM orders_product WHERE id_order = #{change(v['id_order'].to_i)} "
        v = []
        @db.query(sql).each { |row| v << row}
        v = v.first
        
        render :html => v['quantity']
      end
    end
  end
  
  def update_cart
    @pro = params[:product]
    sql = "
        SELECT id_status, id_order FROM orders WHERE id_customer=#{@login} AND id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    v = v.first
    
    sql = " DELETE FROM orders_product WHERE id_order = #{v['id_order']}"
    @db.query(sql)
    if @pro.present?
        sql = " INSERT INTO orders_product(id_order, id_product, quantity, total) VALUES "
        @pro.each do |row|
            que = " SELECT price FROM product WHERE id_product =#{change(row['id'])}"
            res = []
            @db.query(que).each { |u| res << u}
            res = res.first
            if row == @pro.first
              sql << " ( #{v['id_order']}, #{row['id']}, #{row['num']}, #{row['num'].to_i*res['price'].to_i}) "
            else
              sql << " ,( #{v['id_order']}, #{row['id']}, #{row['num']}, #{row['num'].to_i*res['price'].to_i})"
            end
        end
        @db.query(sql)
    end
    redirect_to '/cart'
  end
  
  
  def pay
    @breadcrumb = [{'title'=>'Thanh toán','link'=>'pay'}]
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @payment = Payment.getlist(@db, true)
    @shipment = Shipment.getlist(@db)
    sql = "SELECT c.name, c.phone, c.email, p.id_province,  p.name as province, d.id_district, d.name as district, w.id_ward, w.name as ward, address FROM customer c
           JOIN ward w ON w.id_ward = c.id_ward
           JOIN district d ON d.id_district = w.id_district
           JOIN province p ON p.id_province = d.id_province
           WHERE id_customer = #{@login}
        "
    v = []
    @db.query(sql).each { |row| v << row}
    @customer = v.first
    @province = Province.getlist(@db)
    @district = District.getlist(@db,@customer['id_province'])
    @ward = Ward.getlist(@db, @customer['id_district'])
    sql = "
        SELECT do.quantity, p.image, p.title, p.price, p.id_product FROM orders_product do
        JOIN product p ON p.id_product = do.id_product
        JOIN orders o ON o.id_order = do.id_order
        WHERE o.id_customer = #{@login} AND o.id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @cart = v
    
    
    sql = "
        SELECT o.code, o.id_voucher, v.percent FROM orders o 
        JOIN voucher v ON o.id_voucher = v.id_voucher
        WHERE o.id_customer = #{@login} AND o.id_status = '1'
      "
    v = []
    @db.query(sql).each { |row| v << row}
    @order = v.present? ? v.first : []
    
    unless @cart.present?
      redirect_to '/cart'
    end
    
  end

  def add_order
    @order = params['order']
    
    sql = " SELECT SUM(do.total) as total FROM orders_product do
            JOIN orders o ON o.id_order = do.id_order
            WHERE o.id_customer = #{@login} AND o.id_status = '1'
          "
    v = []      
    @db.query(sql).each{ |row| v << row}
    total = v.first['total']
    
    
    address = @order['address'] if @order['address'].present?
    address << ", " << @order['ward'] if @order['ward'].present?
    address << ", " << @order['district'] if @order['district'].present?
    address << ", " << @order['province'] if @order['province'].present?
    
    sql = "UPDATE orders SET
           id_status = '2',
           id_shipment = ?,
           id_payment = ?,
           total = ?,
           address = ?,
           date_add = ?
           WHERE id_customer= ? AND id_status = '1'
          "
          
    stm = @db.prepare(sql)
    stm.execute(@order['shipment'], @order['payment'], total, address, DateTime.now, @login)
    stm.close
    redirect_to '/complete'
  end
  
  
  def complete
    @categories = Categories.getlist(@db)
    @banner = Banner.getlist(@db)
    
  end
  
  def comment_pro
    @comment = params[:comment]
    if @comment.present?
      if @comment['parent_pro'].present?
          sql = "
                INSERT INTO comment_product( id_comment, id_product, id_customer, id_parent_comment, text, date_add)
                VALUES ( null, ?, ?, ?, ?, ?)
            "
          stm = @db.prepare(sql)
          stm.execute(@comment['id_pro'], @login, @comment['parent_pro'], @comment['text'], DateTime.now)
          stm.close
      else
          sql = "
                INSERT INTO comment_product( id_comment, id_product, id_customer, id_parent_comment, text, date_add)
                VALUES ( null, ?, ?, null, ?, ?)
            "
          stm = @db.prepare(sql)
          stm.execute(@comment['id_pro'], @login, @comment['text'], DateTime.now)
          stm.close
      end
    end
  end
  
  def rank
    sql = "
      INSERT INTO product_rank(id_product, id_customer, rank, date_add)
      VALUES( ?, ? , ?, ? )
    "
    stm = @db.prepare(sql)
    stm.execute(params[:id], @login, params[:star], DateTime.now)
    stm.close
  end
  
  def sale_order
    @banner = Banner.getlist(@db)
    @categories = Categories.getlist(@db)
    @id = params[:id_order]
    sql = " SELECT o.id_order, s.text, s.name, s.id_status FROM orders o
            JOIN status s ON s.id_status = o.id_status
            WHERE o.id_order = #{@id}
          "
    v = []      
    @db.query(sql).each{ |row| v << row}
    @status = v.first
    render "saleorder"
  end
  
  
  def check_code
    @code = params[:code].split('-')
    if @code.present?
        sql = " SELECT code FROM orders Where code = #{@code.last} AND id_status != 1"
        v = []  
        @db.query(sql).each{ |row| v << row}
        @check = v
        bool = 0
        if @check.count == 0
          sql = " SELECT code FROM voucher Where id_voucher = #{@code.first} AND status = 2"
          v = []  
          @db.query(sql).each{ |row| v << row}
          @list = v.present? ? v.first : []
          if @list.present?
            @list['code'].to_s.split(', ').each do |val|
              if val == @code.last
                bool = 1
                sql = "UPDATE orders SET
                  code = ?,
                  id_voucher = ?
                  WHERE id_customer = ? AND id_status = 1
                "
                stm = @db.prepare(sql)
                stm.execute(@code.last, @code.first, @login)
                stm.close
              end
            end
          end
        end
    else
      sql = " SELECT code FROM orders Where id_customer = #{@login} AND id_status = 1"
      v = []  
      @db.query(sql).each{ |row| v << row}
      @check = v.first
      if @check['code'].present? 
          sql = "UPDATE orders SET
            code = null,
            id_voucher = null
            WHERE id_customer = ? AND id_status = 1
          "
          stm = @db.prepare(sql)
          stm.execute(@login)
          stm.close
          bool = 2
      end
    end
    render :html => bool
  end
  
  def district
    @district = District.getlist(@db,params[:id])
    render "district", :layout => nil
  end
  
  def ward
    @ward = Ward.getlist(@db,params[:id])
    render "ward", :layout => nil
  end
  
  def change(char)
    char = char.to_s
    char.gsub!(/ insert /,' I S E R T')
    char.gsub!(/ INSERT /,' I S E R T')
    char.gsub!(/ or /, 'O R')
    char.gsub!(/ OR /, 'O R')
    char.gsub!(/ update /,'U P D A T E')
    char.gsub!(/ UPDATE /,'U P D A T E')
    char
  end
end
