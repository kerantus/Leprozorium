#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
	@db = SQLIte3::Database.new (Dir.pwd + '/db/leprozorium.db')
	@db.redults_as_hash
end

before do

end

configure do

end


get '/new' do
	erb :new
end

post '/new' do
  erb "Запись добавлена"
end



get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
end