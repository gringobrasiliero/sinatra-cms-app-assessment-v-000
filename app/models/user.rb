require 'active_model'

require 'active_support/core_ext/hash'

class User < ActiveRecord::Base
  include Slugified::InstanceMethods
  extend Slugified::ClassMethods

  validates_presence_of :username, :email, :password
  validates :username, :email, length: { in: 1..20 }
  #validates :password, length: {in: 8..20 }
  #validates :email, uniqueness: { message: "We already have this email address linked to an Account."}

  validates :username, uniqueness: true


has_secure_password
has_many :projects


end
