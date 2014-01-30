require 'bundler'
Bundler.require
require './models'

class MyApp < Sinatra::Base
	set :bind, '0.0.0.0'
	register Sinatra::Flash

	helpers do
		
		def authorize(username, password)
		  user = User.first(username)
		  if !user.nil? && user.authenticate(password)
				#user is authenticated, so let's create a session
				session = Session.new
				session.user = user
				session.save
				
				#set the session cookie
				response.set_cookie "session_token", {value: session.id, path: '/'}
				
				true
		  else
				false
		  end
		  
		end
		
		def current_user
		  session = Session.first(request.cookies["session_token"])
		  if !session.nil?
			session.user
		  else
				nil
		  end
		end
	end
	
	get '/' do
	  erb :welcome
	end

	get '/logintest' do
		user_name = current_user.username
		"The current user is #{user_name}"
	end

	get '/login' do
		erb :login
	end
	
	get '/users' do
		@users = User.all
		erb :users
	end
	
	get '/sessions' do
		@session_id = request.cookies["session_token"]	
		@sessions = Session.all
		erb :sessions
	end
	
	get '/setcookie' do
		response.set_cookie "test_cookie", {value: "my test value"}
		"I set the cookie"
	end
	
	get '/readcookie' do
		the_cookie = request.cookies["test_cookie"]	
	end
	
	get '/success' do
	  erb :success
	end
	
	get '/error' do
	  erb :error
	end

	get '/webapps' do
		@webapps = Webapp.all
		erb :webapps
	end

	get '/event' do
		erb :event
	end

	get '/events' do
		@events = Event.all
		erb :events
		#count = @events.count
		#{}"There are #{count} events."
	end

	post '/event/data' do
		puts "I AM HERE!!!"
		p params
		@webapp = Webapp.first
		@event = Event.new
		@event.event = params[:event]
		@event.save
	end
	
	post '/login/auth' do
		if authorize(params[:username], params[:password])
		  redirect to('/success')
		else
		  redirect to('/error')
		end
		
	end
end

MyApp.run!