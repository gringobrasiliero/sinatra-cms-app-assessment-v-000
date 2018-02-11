class User < ActiveRecord::Base

  validates_presence_of :username, :email, :password
has_secure_password
<<<<<<< HEAD
has_many :attributes
=======
>>>>>>> 32f5c8fba581bff55ef0c5aaf9a918b2e690425d
end
