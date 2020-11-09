class ApplicationController < ActionController::Base
  private

  def set_total_score
    session[:total_score] = 0
  end
end
