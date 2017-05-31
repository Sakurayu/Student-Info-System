require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] ||"sqlite3://#{Dir.pwd}/student.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :firstname, String
  property :lastname, String
  property :studentid, String
  property :birthday, Date
  property :address, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

configure do
  enable :sessions
  set :username, "u"
  set :password, "p"    #username is u, password is p
end

post '/login' do
  if params[:username] == settings.username
     params[:password] == settings.password
     session[:admin] = true
     redirect to ('/home')
  else
    erb :login
  end
end

get '/logout' do
 session.clear
 redirect to ('/login')
end

get '/students' do
  @students = Student.all
  @isin = session[:admin]
  erb :students
end

get '/students/new' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin  #If is not logged in, direct to to login page
  @student = Student.new
  erb :new_student
end

get '/students/:id' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin  #If is not logged in, direct to to login page
  @student = Student.get(params[:id])
  if (Student.get(params[:id]) == nil) #If the student id doesn't exist, direct to not_found page
    @title = "not found page"
    erb :not_found
  else                                 #Otherwise, show the student
    erb :show_student
  end
end

get '/students/:id/edit' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin
  @student = Student.get(params[:id])
  if (Student.get(params[:id]) == nil) #If the student id doesn't exist, direct to not_found page
    @title = "not found page"
    erb :not_found
  else                                 #Otherwise, edit the student
    erb :edit_student
  end
end

post '/students' do
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")
end

put '/students/:id' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin  #If is not logged in, direct to to login page
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  @isin = session[:admin]
  redirect to ('/login') unless @isin  #If is not logged in, direct to to login page
  Student.get(params[:id]).destroy
  redirect to('/students')             #Once delete one student, direct to students page
end
