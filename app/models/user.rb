class User < ActiveRecord::Base
  include Slugified::InstanceMethods
  extend Slugified::ClassMethods
  validates_presence_of :username, :email, :password
  validates :email, uniqueness: { message: "We already have this email address linked to an Account."}
  validates :username, uniqueness: true
has_secure_password
has_many :projects


end
