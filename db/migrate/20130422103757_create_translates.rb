class CreateTranslates < ActiveRecord::Migration
  def change
    create_table :translates do |t|
      t.string :title
      t.string :url
      t.integer :page_rank
      t.integer :origin_id
      t.string :added_person

      t.timestamps
    end
  end
end
