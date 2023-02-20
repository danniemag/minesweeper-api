# Class destined to set tiles parameters,
# including bomb counting and adjacent info
class GameTile
  attr_accessor :adjacent, :adjacent_bombs, :adjacent_zeroes

  #
  # @param board [BoardGenerator]
  # @return [BoardGenerator]
  #
  def initialize(board, is_bomb)
    @adjacent = {
      "up_left" => nil,
      "up" => nil,
      "up_right" => nil,
      "left" => nil,
      "right" => nil,
      "down_left" => nil,
      "down" => nil,
      "down_right" => nil
    }
    @board = board
    @is_bomb = is_bomb
    @adjacent_bombs = 0
    @adjacent_zeroes = []
  end

  def find_adjacent_bombs
    @adjacent.each do |key, value|
      begin
        if value.is_bomb?
          @adjacent_bombs += 1
        end
      rescue
      end
    end
  end

  def is_bomb?
    @is_bomb
  end
end
