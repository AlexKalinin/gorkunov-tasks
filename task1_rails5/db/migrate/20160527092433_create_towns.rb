# Storing towns' timezones in database
class CreateTowns < ActiveRecord::Migration[5.0]
  def change
    create_table :towns do |t|
      t.string :name
      t.string :time_zone
      #t.timestamps
    end
  end
end
