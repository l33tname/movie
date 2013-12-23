require "rest_client"
require "json"

class TheMovieDB
	attr_accessor :apiKey, :baseURL, :header, :sessionId, :userId
	def initialize(apiKey, sessionId, userId)
		self.apiKey = apiKey
		self.sessionId = sessionId
		self.userId = userId
		self.baseURL = "https://api.themoviedb.org"
		self.header = {:accept => "application/json"} 
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
end

class Movie
	attr_accessor :movieId, :title, :imgurl, :releaseYear

	def initialize(movieId, title, imgurl, releaseYear)
		self.movieId = movieId
		self.title = title
		self.imgurl = imgurl
		self.releaseYear = releaseYear
	end
end