require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times do
      @letters << ('A'..'Z').to_a.sample
    end
  end

  def score
    @letters = params[:letters]
    @words = params[:word]

    @words_array = @words.chars
    @letters_array = @letters.split(' ')

    results
  end

  private

  def results
    if @words_array.all? { |word| @words_array.count(word) <= @letters.count(word) }
      if hash_api['found']
        @results = "Congratulations! #{@words.capitalize} is a valid English word!"
        raise
      elsif hash_api['found'] == 'false'
        @results = "Sorry but #{@words.capitalize} does not seem to be a valid English word..."
      end
    else
      @results = "Sorry but #{@words.capitalize} cant't be built out of #{@letters.capitalize}"
    end
  end

  def hash_api
    wordsz = URI.open("https://wagon-dictionary.herokuapp.com/#{@words}").read
    JSON.parse(wordsz)
  end
end
