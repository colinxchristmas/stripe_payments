class ChangeCardExpMonthInCards < ActiveRecord::Migration[5.0]
  def change
    change_column :cards, :card_exp_month, 'integer USING CAST(card_exp_month AS integer)'
  end
end
