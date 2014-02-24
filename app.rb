require "sinatra"
require "time"
require "yaml"

require_relative "movie.rb"

configure do
	set :erb, :layout => :'meta-layout/layout'
	set :erb, :locals => {:title => "Watchlist", :tagline => 'l33tname schaut schlechte Filme'}

	AppConfig = YAML.load_file(File.expand_path("config.yaml", File.dirname(__FILE__)))
	API = TheMovieDB.new(AppConfig["ApiKey"], AppConfig["SessionId"], AppConfig["UserName"])
	CONFIGURATION = API.config
	API.allMovie
end

get "/" do
	erb :index, :locals => {:filme => API.allMovie}
end
