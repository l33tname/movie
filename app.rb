require "sinatra"
require "time"
require "yaml"

require_relative "movie.rb"

configure do
	set :erb, :layout => :'meta-layout/layout'
	set :erb, :locals => {:title => "Watchlist", :tagline => 'l33tname schaut schlechte Filme'}

	AppConfig = YAML.load_file(File.expand_path("config.yaml", File.dirname(__FILE__)))
	$api = TheMovieDB.new(AppConfig["ApiKey"], AppConfig["SessionId"], AppConfig["UserName"])
	CONFIGURATION = $api.config

	$filme = nil
	$zeit = Time.now
end

get "/" do
	if Time.now-$zeit > 3600 || $filme.nil?
		filmeArray = Array.new

		for	page in 1..$api.totalPages do
			for film in $api.moviesPage(page)
				filmeArray << Movie.new(film["id"], film["title"], CONFIGURATION["images"]["base_url"] + CONFIGURATION["images"]["poster_sizes"][3] + film["poster_path"], film["release_date"].slice(0..3))
			end
		end

		$filme = filmeArray.reverse!
		$zeit = Time.now
	end

	erb :index, :locals => {:filme => $filme}
end
