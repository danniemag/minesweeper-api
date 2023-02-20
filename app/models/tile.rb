class Tile < ApplicationRecord
  belongs_to :game, class_name: 'Game'

  validates :key_name, :near_bombs, presence: true

  enum flagged: %i[nope question red]
end
