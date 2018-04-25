# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

class Account
  include ActiveModel::Model
  
  attr_accessor :username,
      :password
  
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
  
  validates :username,
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :format=>{:with => /\w+@\w+.{1}[a-zA-Z]{2,}/,:message => "phải là một email", :allow_blank => true}
  
  validates :password, 
    :presence => {:message =>MyPhamOnline::Application.config.blank_msg},
    :length=>{:allow_blank => true, :minimum => 5, :message=>"phải có ít nhất 5 ký tự"}
  
  
end
