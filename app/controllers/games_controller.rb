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
    score = answer.length**2
    session[:total_score] += score
    score
  end

  def score
    answer = params[:answer].upcase
    @score = 0
    letters_array = params[:letters].split
    @result = if answer.each_char.map { |letter| params[:letters].split.include?(letter) } .include? false
                "Sorry but #{answer} can't be built out of #{letters_array.join(', ')}"
              elsif attempt_word_exist?(answer) == false
                "Sorry but #{answer} doesn't seem to be a valid english word..."
              else
                @score = score?(answer)
                "Congratulation! #{answer} is a valid english word"
              end
  end
end
