# frozen_string_literal: true

class CreateRatings < ActiveRecord::Migration[5.2]
  def change
    create_table :ratings do |t|
      t.belongs_to :news_item, index: true, null: false, references: :news_items
      t.belongs_to :user, index: true, null: false, references: :users
      t.integer :score
      t.timestamps null: false
    end
  end
end
