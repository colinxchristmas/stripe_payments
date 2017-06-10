class CreateCards < ActiveRecord::Migration[5.0]
  def change
    create_table :cards do |t|
      t.string :stripe_id
      t.string :card_name
      t.integer :card_last_four
      t.string :card_type
      t.string :card_exp_month
      t.integer :card_exp_year
      t.boolean :default_card, default: false
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
