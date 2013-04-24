class AddAddedPersonToOrigins < ActiveRecord::Migration
  def change
  	add_column :origins, :added_person, :string
  end
end
