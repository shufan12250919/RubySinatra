require "sinatra"
require "sinatra/reloader" if development?
require_relative "dataValidate"
require_relative "bet"

enable :sessions

configure :development do 
	DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/bet.db")
end

configure :production do 
	DataMapper.setup(:default, ENV['DATABASE_URL']) 
end


get "/" do 
	erb :form
end

post "/login" do
	@dice = ""
	@result = ""
	@defalutMoney = 100
	@defalutPlace = 1
	session[:win] = 0
	session[:lose]= 0
	session[:profit] = 0
	@info = Game.first(username: params[:usr], password: params[:pwd])
	if @info == nil
		@info = Game.new(username: params[:usr],
						 password: params[:pwd],
						 win: 0,
						 lose: 0,
						 profit: 0)
		@info.save
	end
	session[:player] = @info
	erb :game
end

post "/bet" do
	check = valiate(params[:place], 6) && valiate(params[:money])
	amount = params[:money].to_i
	if check
		target = rand(1..6)
		@dice = "You bet on #{params[:place]}, and you roll the dice to #{target}"

		if params[:place].to_i == target 
			@result = "You win #{params[:money]} dollars!!"
			session[:win] += amount
			session[:profit] += amount
		else
			@result = "You lose #{params[:money]} dollars!"
			session[:lose] += amount
			session[:profit] -= amount
		end
		@defalutMoney = params[:money]
		@defalutPlace = params[:place]
	else
		@dice = "Please enter valid amount of money"
		@result = "and place between 1-6!"
		@defalutMoney = 100
		@defalutPlace = 1
	end
	erb :game
end

post "/logout" do
	session[:player].win += session[:win]
	session[:player].lose += session[:lose]
	session[:player].profit += session[:profit]
	session[:player].save
	session.clear
	erb :form
end