require 'game_tile'

# Class destined to set a full board containing tiles
# and all of their associated information
class BoardGenerator
  attr_accessor :matrix, :bomb_chance, :board

  #
  # @param matrix [Integer]
  # @param bomb_chance [Float]
  # @return [BoardGenerator]
  #
  def initialize(matrix, bomb_chance)
    @matrix = matrix
    @bomb_chance = bomb_chance
    @board = {}
  end

  def call
    matrix.times do |row|
      matrix.times do |column|
        if rand < bomb_chance
          board["#{row},#{column}"] = GameTile.new(self, true)
        else
          board["#{row},#{column}"] = GameTile.new(self, false)
        end
      end
    end

    # Set bomb counter to tile
    board.each do |key, value|
      value.find_adjacent_bombs
    end
  end
end
