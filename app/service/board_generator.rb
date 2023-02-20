require 'game_tile'

# Class destined to set a full board containing tiles
# and all of their associated information
class BoardGenerator
  attr_accessor :matrix, :board, :bomb_chance

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
          @board["#{row},#{column}"] = GameTile.new(self, nil, nil, nil, nil, nil, nil, nil, nil, true)
        else
          @board["#{row},#{column}"] = GameTile.new(self, nil, nil, nil, nil, nil, nil, nil, nil, false)
        end

        if column > 0
          @board["#{row},#{column}"].adjacent["left"] = @board["#{row},#{column - 1}"]
        end

        if row > 0
          @board["#{row},#{column}"].adjacent["up"] = @board["#{row - 1},#{column}"]
          @board["#{row},#{column}"].adjacent["up_left"] = @board["#{row - 1},#{column - 1}"]
          @board["#{row},#{column}"].adjacent["up_right"] = @board["#{row - 1},#{column + 1}"]
        end
      end
    end

    matrix.times do |row|
      matrix.times do |column|
        if column < matrix - 1
          @board["#{row},#{column}"].adjacent["right"] = @board["#{row},#{column + 1}"]
        end

        if row < matrix - 1
          @board["#{row},#{column}"].adjacent["down_left"] = @board["#{row + 1},#{column - 1}"]
          @board["#{row},#{column}"].adjacent["down"] = @board["#{row + 1},#{column}"]
          @board["#{row},#{column}"].adjacent["down_right"] = @board["#{row + 1},#{column + 1}"]
        end
      end
    end

    @board.each do |key, value|
      value.find_adjacent_bombs
    end
  end
end
