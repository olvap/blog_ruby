require 'bcrypt'

class User < ActiveRecord::Base

  has_many :posts
  
  validates :name, presence: true, length: {minimum: 3}
  validates :email, presence: true, uniqueness: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/ix }
  validates :password, presence: true, confirmation: true, on: :create
  validates :password_confirmation, presence:true, on: :create


  
  def hash_password(secret)
    self.salt = BCrypt::Engine.generate_salt
    BCrypt::Engine.hash_secret(secret, self.salt)
  end


  def self.authenticate(email, secret)
    user = User.find_by(email: email)
    if user && user.check_password(secret)
      user
    else
      nil
    end
  end

  def password=(secret)
    write_attribute(:password,hash_password(secret))
  end
  
  def check_password(secret)
    self.password == BCrypt::Engine.hash_secret(secret, self.salt)
  end
  
end
