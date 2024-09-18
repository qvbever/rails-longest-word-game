require 'open-uri'
require 'json'


class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }.join
  end

  def score
    @word = params[:word].upcase
    @letters = params[:letters].upcase
    if valid_word?(@word, @letters)
      if english_word?(@word)
        @answer = "Congratulation! #{@word} is a valid English word"
      else
        @answer = "Sorry but #{@word} does not seems an English word"
      end
    else
      @answer = "Sorry but #{@word} can't be built out of #{@letters.join(', ')}"
    end
  end

  private

  def valid_word?(word, letters)
    word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  def english_word?(word)
    url = URI.parse("https://wagon-dictionary.herokuapp.com/#{word}")
    response = JSON.parse(URI.open(url).read)
    response['found']
  end
end
