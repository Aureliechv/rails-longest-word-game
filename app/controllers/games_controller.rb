require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = Array.new(10) { alphabet.sample }
  end

  def attempt_word_exist?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized, { symbolize_name: true })
    word.value?(true)
  end

  def score?(answer)
    answer.length**2
  end

  def score
    @score = 0
    answer = params[:answer].upcase
    letters_array = params[:letters].split
    @result = if answer.each_char.map { |letter| letters_array.include?(letter) } .include? false
                "Sorry but #{answer} can't be built out of #{letters_array.join(', ')}"
              elsif attempt_word_exist?(answer) == false
                "Sorry but #{answer} doesn't seem to be a valid english word..."
              else
                @score = score?(answer)
                "Congratulation! #{answer} is a valid english word"
              end
  end
end
