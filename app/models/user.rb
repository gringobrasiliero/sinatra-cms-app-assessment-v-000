class User < ActiveRecord::Base
  include Slugified::InstanceMethods
  extend Slugified::ClassMethods
  validates_presence_of :username, :email, :password
has_secure_password
has_many :projects


end
