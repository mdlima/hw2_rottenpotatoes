class Movie < ActiveRecord::Base
  
  def self.all_ratings
    Movie.select(:rating).map {|m| m.rating}.uniq
  end
end
