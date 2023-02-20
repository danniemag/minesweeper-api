class Game < ApplicationRecord
  has_many :tiles, class_name: 'Tile', dependent: :destroy
  accepts_nested_attributes_for :tiles, reject_if: :all_blank

  belongs_to :user, class_name: 'User'

  validates :matrix, :level, :starting_time, :elapsed_time, :status, presence: true

  enum level: %i[easy medium hard]
  enum status: %i[stopped progress paused lost won]

  BOMB_CHANCE = { 0 => 0.3, 1 => 0.5, 2 => 0.7 }.freeze
end
