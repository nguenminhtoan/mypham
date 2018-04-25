Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'
  
  
  
  
  
  get 'admin/:controller(/:action(/:id(.format)))'
  post 'admin/:controller(/:action(/:id(.format)))' 
  post '/update_account' => 'home#update_account'
  post '/news_save' => 'home#news_save'
  get '/check/code' => 'home#check_code'
  get '/sale/order' => 'home#sale_order'
  post '/rank' => 'home#rank'
  post '/comment/news' => 'home#comment_new'
  post '/comment/product' => 'home#comment_pro'
  post '/update_cart' => 'home#update_cart'
  post '/addcart' => 'home#addcart'
  get '/complete' => 'home#complete'
  get '/account' => 'home#account'
  get '/news' => 'home#news'
  get '/news/:title' => 'home#news', as: :title
  get '/news/:title/:parent' => 'home#news', as: :title, as: :par
  post '/news/:title/:parent' => 'home#news', as: :name, as: :cm
  get '/news/:title/:parent/:id' => 'home#news', as: :title, as: :par, as: :new
  get '/district/:id' => 'home#district', as: :district
  get '/ward/:id' => 'home#ward', as: :ward
  post '/add_order' => 'home#add_order'
  get '/pay' => 'home#pay'
  get '/cart' => 'home#cart'
  get '/logout' => 'home#logout'
  post '/auth' => 'home#auth'
  get '/login' => 'home#login'
  get '/search' =>'home#product'
  get '/:title' => 'home#product', as: :categories
  get '/:title/:parent' => 'home#product', as: :categories, as: :parent
  get '/:title/:parent/:id' => 'home#product', as: :categories,as: :parent, as: :id
  
end
