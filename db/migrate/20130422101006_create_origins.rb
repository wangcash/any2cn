class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string :title
      t.string :url
      t.integer :page_rank
      t.integer :origin_id

      t.timestamps
    end
  end
end
