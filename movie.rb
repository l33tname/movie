require "rest_client"
require "json"

class TheMovieDB
	attr_accessor :apiKey, :baseURL, :header, :sessionId, :userId, :zeit, :filme
	def initialize(apiKey, sessionId, userId)
		puts "init"
		self.apiKey = apiKey
		self.sessionId = sessionId
		self.userId = userId
		self.baseURL = "https://api.themoviedb.org"
		self.header = {:accept => "application/json"} 
		self.zeit = Time.now
	end

	def config
		JSON.parse RestClient.get "#{baseURL}/3/configuration?api_key=#{apiKey}", header
	end

	def totalPages
		response = JSON.parse RestClient.get "#{baseURL}/3/account/#{userId}/movie_watchlist?api_key=#{apiKey}&session_id=#{sessionId}", header
		response["total_pages"].to_i
	end

	def moviesPage(page)
		response = JSON.parse RestClient.get "#{baseURL}/3/account/#{userId}/movie_watchlist?api_key=#{apiKey}&session_id=#{sessionId}&page=#{page}", header
		response["results"]
	end

	def getMovie
		filmeArray = Array.new

		(1..totalPages).each do |page|
			moviesPage(page).each do |film|
				img = "#{CONFIGURATION["images"]["secure_base_url"]}#{CONFIGURATION["images"]["poster_sizes"][3]}#{film["poster_path"]}"
				filmeArray << Movie.new(film["id"], film["title"], img, film["release_date"].slice(0..3))
			end
		end

		filmeArray.reverse!
	end

	def allMovie
		@filme ||= getMovie 

		if Time.now-@zeit > 60*60
			puts "update cache"
			@filme = getMovie
			@zeit = Time.now
		end

		@filme
	end
end

class Movie
	attr_accessor :movieId, :title, :imgurl, :releaseYear

	def initialize(movieId, title, imgurl, releaseYear)
		self.movieId = movieId
		self.title = title
		self.imgurl = imgurl
		self.releaseYear = releaseYear
	end

	def title_short
		short = title[0..25]
		short += "..." if title.length > 25
		short
	end

end