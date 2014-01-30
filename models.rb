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
  has n, :webapps
end

class Session
  include DataMapper::Resource
  
  belongs_to :user
  
  property :id, String, length: 344, key: true
  
  def initialize()
    self.id = SecureRandom.base64(16)
    self.domain = nil
  end
  
end

class Webapp
  include DataMapper::Resource

  belongs_to :user, :required => false

  property :id, Serial, key: true
  property :webapp_key, String
  property :domain, String, length: 30

  def initialize()
    self.webapp_key = SecureRandom.base64(16)
    #self.domain = "asdf"
  end

  has n, :events
end

class Event
  include DataMapper::Resource

  belongs_to :webapp, :required => false

  property :id, Serial, key: true
  property :url, String
  property :event, String
  property :time_stamp, DateTime
  
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

webapps = Webapp.all

webapps.each do |webapp|
  webapp.destroy
end

admin_user = User.new(username: "admin", password: "admin")
admin_user.save

webapp = Webapp.new
webapp.user = admin_user
webapp.domain = "blocmetrics.com"
webapp.save