class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  
  before_action  :getPageInfo
  after_action  :afterDBClose
  
  
  DB_ADDRESS = MyPhamOnline::Application.config.db_host
  DB_ACCOUNT = MyPhamOnline::Application.config.db_user
  DB_PASS = MyPhamOnline::Application.config.db_pass
  DB_SCHEMA = MyPhamOnline::Application.config.db_schema
  def getPageInfo
    
    if self.controller_name == 'login' || self.controller_name == 'home'
    elsif session[:id_user].blank?
      redirect_to '/admin/login', :layout=>'layout1'
    end
    
    if self.controller_name == 'home' && ((self.action_name == "login" && session[:id_login].present?) || ( !session[:id_login].present? &&( self.action_name == "cart" || self.action_name == "pay" )))
      redirect_to '/'
    end
    
    begin
      @db = Mysql2::Client.new(:host => DB_ADDRESS, :username => DB_ACCOUNT, :password=>DB_PASS, :database=>DB_SCHEMA, :port=> 3307)
      #@db.select_db('shop_online_admin')
    rescue
      @db.close
    end
    
    
    
    @login = []
    @login = session[:id_login] if session[:id_login].present?
    
    if @login.present?
    
        sql = " SELECT COUNT(*) as quantily FROM orders_product do
                JOIN orders o ON o.id_order = do.id_order
                WHERE o.id_customer = #{@login} AND o.id_status = '1' "
        v = []
        @db.query(sql).each { |row| v << row}
        @numbercart = v.first['quantily']
    end
    
    
    if @login.present?
      user = Customer.find(@db, @login)
      @profile = Customer.new(user.first)
    end
    
    
    if session[:id_user].present?
      @info = Customer.find(@db,session[:id_user])
    end
    
  end
  
  
  
  
  
  def afterDBClose
   @db.close
  end
  
  
  
  
end
