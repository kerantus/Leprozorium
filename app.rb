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


configure do
  get_db
  @db.execute 'CREATE TABLE IF NOT EXISTS Posts
  (
  "Id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
  "date_create" DATE,
  "content" TEXT
  )'
end


get '/new' do
  erb :new
end

post '/new' do
  @text_new_post = params[:text_new_post]
  @date_new_post = Date.today
  if @text_new_post.length <= 0
    @error = 'Введите текст'
    return erb :new
  end
    get_db
    @db.execute 'INSERT INTO
  "Posts"
  (
      "date_create",
      "content"
  )
  VALUES
  (
  datetime(), ?
  )', [@text_new_post]
    erb "Запись добавлена"
  end


  get '/' do
    get_db
    @results = @db.execute 'select * from Posts order by id desc'
    erb :index
  end