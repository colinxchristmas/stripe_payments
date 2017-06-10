class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address_line_one
      t.string :address_line_two
      t.string :address_city
      t.string :address_state
      t.string :address_country
      t.string :address_zip
      t.references :card, foreign_key: true

      t.timestamps
    end
  end
end
