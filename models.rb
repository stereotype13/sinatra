require 'data_mapper'
require 'dm-sqlite-adapter'
require 'bcrypt'
require 'securerandom'
DataMapper.setup(:default, "sqlite:db.sqlite")

class User
  include DataMapper::Resource
  include BCrypt

  property :id, Serial, :key => true
  property :username, String, :length => 3..50
  property :password, BCryptHash
  
  def authenticate(attempted_password)
    if self.password == attempted_password
      true
    else
      false
    end
  end
  
  has 1, :session
end

class Session
  include DataMapper::Resource
  
  belongs_to :user
  
  property :id, String, length: 344, key: true
  
  def initialize()
    self.id = SecureRandom.base64(4)
  end
  
end

DataMapper.finalize
DataMapper.auto_upgrade!

users = User.all

users.each do |user|
	user.destroy
end

sessions = Session.all

sessions.each do |sessions|
	sessions.destroy
end

admin_user = User.new(username: "admin", password: "admin")
admin_user.save