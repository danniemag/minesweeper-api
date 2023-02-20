# Class destined to set tiles parameters,
# including bomb counting and adjacent info
class GameTile
  attr_accessor :adjacent, :adjacent_bombs, :adjacent_zeroes

  #
  # @param board [BoardGenerator]
  # @param up_left [Tile]
  # @param up [Tile]
  # @param up_right [Tile]
  # @param left [Tile]
  # @param right [Tile]
  # @param down_left [Tile]
  # @param down [Tile]
  # @param down_right [Tile]
  # @param is_bomb [Boolean]
  # @return [GameTile]
  #
  def initialize(board, up_left, up, up_right, left, right, down_left, down, down_right, is_bomb)
    @adjacent = {
      "up_left" => up_left,
      "up" => up,
      "up_right" => up_right,
      "left" => left,
      "right" => right,
      "down_left" => down_left,
      "down" => down,
      "down_right" => down_right
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
