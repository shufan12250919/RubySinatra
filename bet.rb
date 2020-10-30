require "dm-core" 
require "dm-migrations"


configure :development do 
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

class Game
  include DataMapper::Resource

  property :id, Serial
  property :username, Text
  property :password, Text
  property :win, Integer
  property :lose, Integer
  property :profit, Integer
end

DataMapper.finalize