class AddCascadeToCard < ActiveRecord::Migration[5.0]
  def change
    remove_foreign_key :addresses, :cards
    add_foreign_key :addresses, :cards, on_delete: :cascade
  end
end
