class User < ActiveRecord::Base
  validates :email, :password, :full_name, presence: true
  validates :email, uniqueness: true

  has_secure_password

end
