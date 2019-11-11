require 'open-uri'
require 'json'

class GamesController < ApplicationController

  def new
    @letters = generate_grid(9)
    @start_time = Time.now
  end

  def score
    # elapsed_time = Time.now - start_time
    @letters = params[:grid].split
    @attempt = params[:attempt]
    @start_time = Time.parse(params[:start])
    elapsed_time = Time.now - @start_time
    url = "https://wagon-dictionary.herokuapp.com/#{@attempt}"
    user_serialized = open(url).read
    user = JSON.parse(user_serialized)
    @results = {}
    if user['found'] == false # pas ok
      @results[:message] = 'not an english word'
      @results[:score] = 0
    elsif !included_in_grid(@attempt, @letters) # exist but not in grid
      @results[:message] = 'the given word is not in the grid'
      @results[:score] = 0
    else
      @results[:message] = "Well done #{@attempt} is a #{@attempt.size} letter word"
      @results[:score] = @attempt.length * 10 - elapsed_time
    end
  end #score

  private

  def generate_grid(grid_size)
    grid = []
    until grid_size == grid.length
      grid << ('A'..'Z').to_a.sample(1)[0]
    end
    puts grid;
    return grid
  end

  def included_in_grid(attempt, grid)
    attempt_arr = attempt.upcase.chars
    attempt_arr.each do |letter|
      if grid.include?(letter)
        grid.delete_at(grid.index(letter))
      else
        return false
      end
    end
  end

end #class



# def run_game(attempt, grid, start_time, end_time)
#   # TODO: runs the game and return detailed hash of result
#   url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
#   user_serialized = open(url).read
#   user = JSON.parse(user_serialized)
#   elapsed_time = end_time - start_time
#   results = {}
#   if user["found"] == false # pas ok
#     results[:message] = "not an english word"
#     results[:score] = 0
#   elsif !included_in_grid(attempt, grid) # exist but not in grid
#     results[:message] = "the given word is not in the grid"
#     results[:score] = 0
#   else
#     results[:message] = "Well done #{attempt} is a #{attempt.size} letter word"
#     results[:score] = attempt.length * 10 - elapsed_time
#   end
#   results[:time] = elapsed_time
#   return results
# end
# #  ****************************

# # puts "******** Welcome to the longest word-game!********"
# # puts "Here is your grid:"
# # grid = generate_grid(9)
# # puts grid.join(" ")
# # puts "*****************************************************"

# puts "What's your best shot?"
# start_time = Time.now
# attempt = gets.chomp
# end_time = Time.now

# puts "******** Now your result ********"

# result = run_game(attempt, grid, start_time, end_time)

# puts "Your word: #{attempt}"
# puts "Time Taken to answer: #{result[:time]}"
# puts "Your score: #{result[:score]}"
# puts "Message: #{result[:message]}"

# puts "*****************************************************"
