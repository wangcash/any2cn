class CreateTranslates < ActiveRecord::Migration
  def change
    create_table :translates do |t|
      t.string :title
      t.string :url
      t.integer :page_rank
      t.integer :origin_id
      t.integer :heat
      t.integer :favorite
      t.string :sharer

      t.timestamps
    end
  end
end
