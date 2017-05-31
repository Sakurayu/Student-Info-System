require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||"sqlite3://#{Dir.pwd}/student.db")

class Comment
  include DataMapper::Resource
  property :id, Serial
  property :personname, String
  property :content, String
  property :created_at, DateTime
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/comments' do
  @comments = Comment.all
  erb :comments
end

get '/comments/new' do
  @comment = Comment.new
  erb :new_comment
end

get '/comments/:id' do
  @comment = Comment.get(params[:id])
  if (Comment.get(params[:id]) == nil) #If the comment id doesn't exist, direct to not_found page
    @title = "not found page"
    erb :not_found
  else                                 #Otherwise, show the comment
    erb :show_comment
  end
end

post '/comments' do
  comment = Comment.create(params[:comment])
  redirect to("/comments/#{comment.id}")
end

put '/comments/:id' do
  comment = Comment.get(params[:id])
  comment.update(params[:comment])
  redirect to("/comments/#{comment.id}")
end

delete '/comments/:id' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin  #If is not logged in, direct to to login page
  Comment.get(params[:id]).destroy
  redirect to('/comments')             #Once delete one comment, direct to comments page
end