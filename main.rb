require 'sinatra'
require 'sinatra/reloader' if development?
require 'sass'
require './student'
require './comment'
require 'dm-timestamps'

get('/style.css'){scss :style}

get '/' do
  @title = "home page"
  erb :home
end

get '/home' do
  @title = "home page"
  erb :home
end

get '/about' do
  @title = "about page"
  erb :about
end

get '/contact' do
  @title = "contact page"
  erb :contact
end

get '/video' do
  @title = "video page"
  erb :video
end

get '/login' do
  @title = "login page"
  erb :login
end

not_found do
  @title = "not found page"
  erb :not_found
end

configure :development do
DataMapper.setup(:default,
"sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
DataMapper.setup(:default,
ENV['DATABASE_URL'])
end
