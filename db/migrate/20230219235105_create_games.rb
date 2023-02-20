class CreateGames < ActiveRecord::Migration[6.1]
  def change
    create_table :games do |t|
      t.integer    :matrix, null: false
      t.integer    :level, null: false, default: 0
      t.decimal    :starting_time, null: false, default: 0
      t.decimal    :elapsed_time, null: false, default: 0
      t.integer    :status, null: false, default: 0
      t.belongs_to :user, null: false, index: true

      t.timestamps
    end
  end
end
