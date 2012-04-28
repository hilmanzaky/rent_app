class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

  has_and_belongs_to_many :roles
end
