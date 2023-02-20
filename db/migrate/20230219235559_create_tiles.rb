class CreateTiles < ActiveRecord::Migration[6.1]
  def change
    create_table :tiles do |t|
      t.string      :key_name, null: false
      t.integer     :near_bombs, null: false
      t.integer     :flagged, default: 0
      t.boolean     :played, default: false
      t.boolean     :bomb, default: false
      t.belongs_to  :game, null: false, index: true

      t.timestamps
    end
  end
end
