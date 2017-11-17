#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'
require 'date'

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

def get_db
  @db = SQLite3::Database.new (Dir.pwd + '/db/leprozorium.db')
  @db.results_as_hash = true
end

before do
  get_db
end

configure do
  get_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
  (
  "Id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
  "date_create" DATE,
  "theme" TEXT,
  "content" TEXT
  )'
  @db.execute 'CREATE TABLE IF NOT EXISTS Comments
  (
  "Id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
  "username" TEXT,
  "useremail" TEXT,
  "content" TEXT,
  "postid" INTEGER
  )'
end


get '/new' do
  erb :new
end

post '/new' do
  @text_new_post = params[:text_new_post]
  @theme_new_post = params[:theme_new_post]
  @date_new_post = Date.today
  if @text_new_post.length <= 0
    @error = 'Введите текст'
    return erb :new
  end
    @db.execute 'INSERT INTO
  "Posts"
  (
      "date_create",
      "theme",
      "content"
  )
  VALUES
  (
  ?, ?, ?
  )', [@date_new_post.to_s, @theme_new_post, @text_new_post]
    redirect '/'
  end


  get '/' do
    @results = @db.execute 'select * from Posts order by id desc'
    erb :index
  end


get '/posts' do
  @results = @db.execute 'select * from Posts'
  erb :posts
end




get '/details/:post_id' do
  @post_id = params[:post_id]
  selected = @db.execute 'select * from Posts where Id=?',[@post_id]
  @row = selected[0]
  @comment = @db.execute 'select * from Comments where postid=?',[@post_id]

  erb :details
end

post '/details/:post_id' do
  post_id = params[:post_id]
  user_name = params[:user_name]
  user_email = params[:user_email]
  user_comment = params[:user_comment]

  @db.execute 'INSERT INTO
  "Comments"
  (
  "postid",
  "username",
  "useremail",
  "content"
  )
  VALUES
  (
  ?, ?, ?, ?
  )', [post_id, user_name, user_email, user_comment]
  redirect "/details/#{post_id}"
end